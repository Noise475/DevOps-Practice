# launch config for all terraform built servers

resource "aws_launch_configuration" "terraform-example" {
  image_id = data.aws_ami.amazon_linux_2.image_id
  instance_type = "t2.micro"

  security_groups = [
    aws_security_group.terraform.id]

  user_data = <<-EOF
                #!/bin/bash
                cd /var/www
                echo "Hello, World!" > index.html
                nohup busybox httpd -f -p ${var.server_port} &
              EOF

  lifecycle {
    create_before_destroy = true
  }

}

# set autoscaling group

resource "aws_autoscaling_group" "asg" {
  launch_configuration = aws_launch_configuration.terraform-example.id
  min_size = 2
  max_size = 5
  wait_for_elb_capacity = 1

  vpc_zone_identifier = [
    aws_subnet.public2.id,
    aws_subnet.public.id]

  target_group_arns = [
    aws_lb_target_group.target.arn]

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"]

  metrics_granularity = "1Minute"

  tag {
    key = "NAME"
    value = "terraform-asg-example"
    propagate_at_launch = true
  }

}

# set autoscaling rules

resource "aws_autoscaling_policy" "autopolicy" {
  name = "terraform-autopolicy"
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = aws_autoscaling_group.asg.name
}

# set cloudwatch alarm cpu usage high

resource "aws_cloudwatch_metric_alarm" "cpualarm" {
  alarm_name = "terraform-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = 2
  metric_name = "CPU_Utilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "60"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }

  alarm_description = "This metric monitors EC2 instance cpu usage"

  alarm_actions = [
    aws_autoscaling_policy.autopolicy.arn]
}

# Define security group rules

resource "aws_security_group" "terraform" {
  name = "terraform_sg"
  vpc_id = aws_vpc.terraform-vpc.id

  ingress {
    from_port = 8080
    to_port = var.server_port
    protocol = "tcp"
    cidr_blocks = [
      var.open_cider]
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = [
      var.open_cider]
  }

  tags = {
    Name = "terraform_sg"
  }
}

####################################
# Network Settings
####################################

# Internet Gateway

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.terraform-vpc.id

  tags = {
    Name = "terraform-gateway"
  }
}

# Create VPC

resource "aws_vpc" "terraform-vpc" {
  cidr_block = "172.2.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "terraform"
  }
}

# Create subnets

resource "aws_subnet" "public" {
  cidr_block = "172.2.32.0/24"
  vpc_id = aws_vpc.terraform-vpc.id
  availability_zone = data.aws_availability_zones.all.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "public"
  }
}

resource "aws_subnet" "public2" {
  cidr_block = "172.2.8.0/24"
  vpc_id = aws_vpc.terraform-vpc.id
  availability_zone = data.aws_availability_zones.all.names[1]

  tags = {
    Name = "public2"
  }
}

# List target group for lb

resource "aws_lb_target_group" "target" {
  name = "target"
  port = var.server_port
  protocol = "HTTP"
  target_type = "instance"
  vpc_id = aws_vpc.terraform-vpc.id

  # Note that for NLB `healthy_threshold` and `unhealthy_threshold` must be the same value
  health_check {
    healthy_threshold = "3"
    unhealthy_threshold = "2"
    interval = "10"
    port = var.server_port
    protocol = "HTTP"
  }

  stickiness {
    enabled = false
    type = "lb_cookie"
  }

  tags = {
    Name = "lb-target-group"
  }
}

################################
# nlb settings
################################
/*
resource "aws_lb" "nlb" {
  name = "nlb-example"
  internal = false
  load_balancer_type = "network"

  subnets = [
    aws_subnet.public.id,
    aws_subnet.public2.id]


  enable_deletion_protection = false

  tags = {
    Name = "terraform-nlb"
  }
}

resource "aws_lb_listener" "nlb-listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port = var.server_port
  protocol = "TCP"

  default_action {
    target_group_arn = aws_lb_target_group.target.arn
    type = "forward"
  }
}
*/

##############################
# alb settings
##############################

resource "aws_lb" "alb" {
  name = "alb-example"
  internal = false

  subnets = [
    aws_subnet.public.id,
    aws_subnet.public2.id]

  security_groups = [
    aws_security_group.terraform.id]

  enable_deletion_protection = false

  tags = {
    Name = "terraform-alb"
  }
}

# alb listener for port forwarding

resource "aws_lb_listener" "alb-listener" {
  load_balancer_arn = aws_lb.alb.arn
  port = var.server_port
  protocol = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.target.arn
    type = "forward"
  }

}
