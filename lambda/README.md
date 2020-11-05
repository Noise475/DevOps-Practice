# Python lambda example

This example describes how to use the aws-cli
to create a lambda function running python and processing a stream into DynamoDB.

**Note: python3, aws-sam-cli, and pip are assumed to be installed on your system.**

1. clone the repository

``` shell
git clone git@github.com:Noise475/DevOps-Practice.git
```

2. Go to the lambda directory

``` shell
cd lambda
```

3. Build the template

``` shell
sam build
```

## Local Testing

Invoke the lambda locally with docker

``` shell
sam local invoke -e testEvent.json
```

Which should yield:

``` shell
--- some output omitted ---
END RequestId: bde75c72-6cb0-123d-c681-a71c62d00a3d
REPORT RequestId: bde75c72-6cb0-123d-c681-a71c62d00a3d  Init Duration: 185.55 ms        Duration: 4.78 ms       Billed Duration: 100 ms Memory Size: 128 MB    Max Memory Used: 26 MB

"Successfully processed 3 records."
```

## Deploy lambda to AWS

To create & run the lambda as a cloudformation template run the following and respond to the prompts as needed:

``` shell
sam deploy --guided
```

You should see the CloudFormation stack changeset if you answered yes to this prompt

`Confirm changes before deploy [y/N]:`

``` shell
Initiating deployment
=====================

Waiting for changeset to be created..

CloudFormation stack changeset
-------------------------------------------------------------------------------------------------------------------------------------------------
Operation                            LogicalResourceId                    ResourceType                         Replacement
-------------------------------------------------------------------------------------------------------------------------------------------------
+ Add                                Table1                               AWS::DynamoDB::Table                 N/A
+ Add                                dynamodbprocessstreampython3DynamoDB1   AWS::Lambda::EventSourceMapping      N/A
+ Add                                dynamodbprocessstreampython3Role     AWS::IAM::Role                       N/A
+ Add                                dynamodbprocessstreampython3         AWS::Lambda::Function                N/A
-------------------------------------------------------------------------------------------------------------------------------------------------

Changeset created successfully.
```

## Clean Up

To delete your stack:

``` shell
aws cloudformation delete-stack --stack-name sam-app --region <instance-region>
```
