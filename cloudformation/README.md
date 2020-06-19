# CloudFormation

This is a breakdown of how to create a blue/green deployment
template using CloudFormation in yaml following `ecs_blue_green_deploy.yml`.

This is a breakdown from the example here: 
https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/blue-green.html#blue-green-required

which may prove helpful to follow-up/along with as well. 

## Parameters
In the first section we see the following parameters:
```yaml
Parameters:
  Vpc:
    Type: 'AWS::EC2::VPC::Id'
  Subnet1:
    Type: 'AWS::EC2::Subnet::Id'
  Subnet2:
    Type: 'AWS::EC2::Subnet::Id'
```
This will allow `Vpc` and `Subnet1` & `Subnet2` to use a 
referential call like `!Ref Vpc`,   
`!Ref Subnet1`, `!Ref Subnet2` 
respectively with the types defined above.
  
## Transform
next we have: 
```yaml
Transform:
  - 'AWS::CodeDeployBlueGreen'
```

The `Transform` section allows the use of macros: 
Custom processes that can be inserted on the fly to cloudformation scripts

In this case the transform is calling for the CodeDeploy
AWS tool to use it's blue-green deployment template.  

for more on macros see:
https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-macros.html 


## Hooks
The full `Hooks` section looks like:
```yaml
Hooks:
  CodeDeployBlueGreenHook:
    Properties:
      TrafficRoutingConfig:
        Type: AllAtOnce
      Applications:
        - Target:
            Type: 'AWS::ECS::Service'
            LogicalID: ECSDemoService
          ECSAttributes:
            TaskDefinitions:
              - BlueTaskDefinition
              - GreenTaskDefinition
            TaskSets:
              - BlueTaskSet
              - GreenTaskSet
            TrafficRouting:
              ProdTrafficRoute:
                Type: 'AWS::ElasticLoadBalancingV2::Listener'
                LogicalID: ALBListenerProdTraffic
              TargetGroups:
                - ALBTargetGroupBlue
                - ALBTargetGroupGreen
    Type: 'AWS::CodeDeploy::BlueGreen'
```

`Hooks` are validation Lambda functions that are run 
before and after traffic shifting.
```yaml
Hooks:
  CodeDeployBlueGreenHook:
```

In the above section we specify the `CodeDeployBlueGreenHook` which:

- Generates all the necessary green application environment resources

- Shifts the traffic based on the specified traffic routing parameters

- Deletes the blue resources

The next section includes the properties required for the
setup, routing, and tear-down of the blue and green environments

```yaml
Properties:
      TrafficRoutingConfig:
        Type: AllAtOnce
      Applications:
        - Target:
            Type: 'AWS::ECS::Service'
            LogicalID: ECSDemoService
          ECSAttributes:
            TaskDefinitions:
              - BlueTaskDefinition
              - GreenTaskDefinition
            TaskSets:
              - BlueTaskSet
              - GreenTaskSet
            TrafficRouting:
              ProdTrafficRoute:
                Type: 'AWS::ElasticLoadBalancingV2::Listener'
                LogicalID: ALBListenerProdTraffic
              TargetGroups:
                - ALBTargetGroupBlue
                - ALBTargetGroupGreen
    Type: 'AWS::CodeDeploy::BlueGreen'
```


for more on hooks check:  

https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/sam-property-function-hooks.html


## Resources
This next section's length hides it's simplicity:
```yaml
Resources:
  ExampleSecurityGroup:
    Type: 'AWS::EC2::SecurityGroup'
    Properties:
      GroupDescription: Security group for ec2 access
      VpcId: !Ref Vpc
      SecurityGroupIngress:
        - IpProtocol: tcp
          FromPort: 80
          ToPort: 80
          CidrIp: 0.0.0.0/0
        - IpProtocol: tcp
          FromPort: 8080
          ToPort: 8080
          CidrIp: 0.0.0.0/0
        - IpProtocol: tcp
          FromPort: 22
          ToPort: 22
          CidrIp: 0.0.0.0/0
  ALBTargetGroupBlue:
    Type: 'AWS::ElasticLoadBalancingV2::TargetGroup'
    Properties:
      HealthCheckIntervalSeconds: 5
      HealthCheckPath: /
      HealthCheckPort: '80'
      HealthCheckProtocol: HTTP
      HealthCheckTimeoutSeconds: 2
      HealthyThresholdCount: 2
      Matcher:
        HttpCode: '200'
      Port: 80
      Protocol: HTTP
      Tags:
        - Key: Group
          Value: Example
      TargetType: ip
      UnhealthyThresholdCount: 4
      VpcId: !Ref Vpc
  ALBTargetGroupGreen:
    Type: 'AWS::ElasticLoadBalancingV2::TargetGroup'
    Properties:
      HealthCheckIntervalSeconds: 5
      HealthCheckPath: /
      HealthCheckPort: '80'
      HealthCheckProtocol: HTTP
      HealthCheckTimeoutSeconds: 2
      HealthyThresholdCount: 2
      Matcher:
        HttpCode: '200'
      Port: 80
      Protocol: HTTP
      Tags:
        - Key: Group
          Value: Example
      TargetType: ip
      UnhealthyThresholdCount: 4
      VpcId: !Ref Vpc
  ExampleALB:
    Type: 'AWS::ElasticLoadBalancingV2::LoadBalancer'
    Properties:
      Scheme: internet-facing
      SecurityGroups:
        - !Ref ExampleSecurityGroup
      Subnets:
        - !Ref Subnet1
        - !Ref Subnet2
      Tags:
        - Key: Group
          Value: Example
      Type: application
      IpAddressType: ipv4
  ALBListenerProdTraffic:
    Type: 'AWS::ElasticLoadBalancingV2::Listener'
    Properties:
      DefaultActions:
        - Type: forward
          ForwardConfig:
            TargetGroups:
              - TargetGroupArn: !Ref ALBTargetGroupBlue
                Weight: 1
      LoadBalancerArn: !Ref ExampleALB
      Port: 80
      Protocol: HTTP
  ALBListenerProdRule:
    Type: 'AWS::ElasticLoadBalancingV2::ListenerRule'
    Properties:
      Actions:
        - Type: forward
          ForwardConfig:
            TargetGroups:
              - TargetGroupArn: !Ref ALBTargetGroupBlue
                Weight: 1
      Conditions:
        - Field: http-header
          HttpHeaderConfig:
            HttpHeaderName: User-Agent
            Values:
              - Mozilla
      ListenerArn: !Ref ALBListenerProdTraffic
      Priority: 1
  ECSTaskExecutionRole:
    Type: 'AWS::IAM::Role'
    Properties:
      AssumeRolePolicyDocument:
        Version: 2012-10-17
        Statement:
          - Sid: ''
            Effect: Allow
            Principal:
              Service: ecs-tasks.amazonaws.com
            Action: 'sts:AssumeRole'
      ManagedPolicyArns:
        - 'arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy'
  BlueTaskDefinition:
    Type: 'AWS::ECS::TaskDefinition'
    Properties:
      ExecutionRoleArn: !Ref ECSTaskExecutionRole
      ContainerDefinitions:
        - Name: DemoApp
          Image: 'nginxdemos/hello:latest'
          Essential: true
          PortMappings:
            - HostPort: 80
              Protocol: tcp
              ContainerPort: 80
      RequiresCompatibilities:
        - FARGATE
      NetworkMode: awsvpc
      Cpu: '256'
      Memory: '512'
      Family: ecs-demo
  ECSDemoCluster:
    Type: 'AWS::ECS::Cluster'
    Properties: {}
  ECSDemoService:
    Type: 'AWS::ECS::Service'
    Properties:
      Cluster: !Ref ECSDemoCluster
      DesiredCount: 1
      DeploymentController:
        Type: EXTERNAL
  BlueTaskSet:
    Type: 'AWS::ECS::TaskSet'
    Properties:
      Cluster: !Ref ECSDemoCluster
      LaunchType: FARGATE
      NetworkConfiguration:
        AwsVpcConfiguration:
          AssignPublicIp: ENABLED
          SecurityGroups:
            - !Ref ExampleSecurityGroup
          Subnets:
            - !Ref Subnet1
            - !Ref Subnet2
      PlatformVersion: 1.3.0
      Scale:
        Unit: PERCENT
        Value: 1
      Service: !Ref ECSDemoService
      TaskDefinition: !Ref BlueTaskDefinition
      LoadBalancers:
        - ContainerName: DemoApp
          ContainerPort: 80
          TargetGroupArn: !Ref ALBTargetGroupBlue
  PrimaryTaskSet:
    Type: 'AWS::ECS::PrimaryTaskSet'
    Properties:
      Cluster: !Ref ECSDemoCluster
      Service: !Ref ECSDemoService
      TaskSetId: !GetAtt
        - BlueTaskSet
        - Id
```
The above section seems daunting, 
but inspecting it more closely you'll notice 
that there only a few truly new things here.

For example:
```yaml
Resources:
  ExampleSecurityGroup:
    Type: 'AWS::EC2::SecurityGroup'
```

is simply a security group named `ExampleSecurityGroup`. 
The next section is simply defining the properties that security group should have:

```yaml
Properties:
      GroupDescription: Security group for ec2 access
      VpcId: !Ref Vpc
      SecurityGroupIngress:
        - IpProtocol: tcp
          FromPort: 80
          ToPort: 80
          CidrIp: 0.0.0.0/0
        - IpProtocol: tcp
          FromPort: 8080
          ToPort: 8080
          CidrIp: 0.0.0.0/0
        - IpProtocol: tcp
          FromPort: 22
          ToPort: 22
          CidrIp: 0.0.0.0/0
```
 
Notice how parameters we setup before are 
referenced as properties in the form: 
```yaml
VpcId: !Ref Vpc
```  

# Data Type Breakdown
This section describes what the base forms 
look like for common data types in
CloudFormation. 

Note that `# comment` is simply for 
illustrative purposes and does not actually 
provide a comment in CloudFormation templates.

**<ins>[Parameters][2]</ins>:**
```yaml
Parameters:
  ParameterLogicalID: # The name of the resource for reference (E.G: vpc, ec2, ecs...)
    Type: DataType # This can be primitive datatypes(string, int, boolean...) or AWS specific(AWS::EC2::AvailabilityZone::Name)
    ParameterProperty: value # Optional
```
Also see [AWS Parameters][3] for more specific usage

**<ins>[Resources][4]</ins>:**
```yaml
Resources:
  Logical ID: # logical name to reference the resource in other parts of the template
    Type: Resource type # The resource type identifies the type of resource that you are declaring. For example, AWS::EC2::Instance declares an EC2 instance
    Properties:
      Set of properties
```


# Best Practices

#### Planning and organizing

1. Organize Your Stacks By Lifecycle and Ownership

2. Use Cross-Stack References to Export Shared Resources

3. Use IAM to Control Access

4. Reuse Templates to Replicate Stacks in Multiple Environments

5. Verify Quotas for All Resource Types

6. Use Nested Stacks to Reuse Common Template Patterns

#### Creating templates

1. Do Not Embed Credentials in Your Templates

2. Use AWS-Specific Parameter Types

3. Use Parameter Constraints

4. Use `AWS::CloudFormation::Init` to Deploy Software Applications on Amazon EC2 Instances

5. Use the Latest Helper Scripts wherever possible

6. Validate templates before using them

#### Managing stacks

1. Manage All Stack Resources Through AWS CloudFormation

2. Create Change Sets Before Updating Your Stacks

3. Use Stack Policies

4. Use AWS CloudTrail to Log AWS CloudFormation Calls

5. Use Code Reviews and Revision Controls to Manage Your Templates

6. Update Your Amazon EC2 Linux Instances Regularly



# References

1. ECS Blue-Green Deploy: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/blue-green.html#blue-green-required 

2. Parameters: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/parameters-section-structure.html

3. Parameter Types: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/parameters-section-structure.html#aws-specific-parameter-types

4. Resources: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/resources-section-structure.html

5. Best Practices: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/best-practices.html

6. Macros: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-macros.html

7. Transform: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/transform-section-structure.html

[1]: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/blue-green.html#blue-green-required
[2]: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/parameters-section-structure.html
[3]: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/parameters-section-structure.html#aws-specific-parameter-types
[4]: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/resources-section-structure.html
[5]: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/best-practices.html
[6]: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-macros.html
[7]: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/transform-section-structure.html