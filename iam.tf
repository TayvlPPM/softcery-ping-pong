
resource "aws_iam_role" "AdminRoleForECSTask" {
  assume_role_policy = <<POLICY
{
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Sid": ""
    }
  ],
  "Version": "2012-10-17"
}
POLICY

  description          = "Allows ECS tasks to call AWS services on your behalf."
  managed_policy_arns  = ["arn:aws:iam::aws:policy/AdministratorAccess"]
  max_session_duration = "3600"
  name                 = "AdminRoleForECSTask"
  path                 = "/"
}

resource "aws_iam_role" "aws-ec2-spot-fleet-autoscale-role" {
  assume_role_policy = <<POLICY
{
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "application-autoscaling.amazonaws.com"
      },
      "Sid": ""
    }
  ],
  "Version": "2012-10-17"
}
POLICY

  max_session_duration = "3600"
  name                 = "aws-ec2-spot-fleet-autoscale-role"
  path                 = "/"
}

resource "aws_iam_role" "ecsAutoscaleRole" {
  assume_role_policy = <<POLICY
{
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "application-autoscaling.amazonaws.com"
      }
    }
  ],
  "Version": "2012-10-17"
}
POLICY

  managed_policy_arns  = ["arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceAutoscaleRole"]
  max_session_duration = "3600"
  name                 = "ecsAutoscaleRole"
  path                 = "/"
}

resource "aws_iam_role" "ecsInstanceRole" {
  assume_role_policy = <<POLICY
{
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Sid": ""
    }
  ],
  "Version": "2008-10-17"
}
POLICY

  managed_policy_arns  = ["arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"]
  max_session_duration = "3600"
  name                 = "ecsInstanceRole"
  path                 = "/"
}

resource "aws_iam_role" "ecsServiceRole" {
  assume_role_policy = <<POLICY
{
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs.amazonaws.com"
      },
      "Sid": ""
    }
  ],
  "Version": "2008-10-17"
}
POLICY

  managed_policy_arns  = ["arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"]
  max_session_duration = "3600"
  name                 = "ecsServiceRole"
  path                 = "/"
}

resource "aws_iam_role" "ecsSpotFleetRole" {
  assume_role_policy = <<POLICY
{
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "spotfleet.amazonaws.com"
      },
      "Sid": ""
    }
  ],
  "Version": "2012-10-17"
}
POLICY

  managed_policy_arns  = ["arn:aws:iam::aws:policy/service-role/AmazonEC2SpotFleetTaggingRole"]
  max_session_duration = "3600"
  name                 = "ecsSpotFleetRole"
  path                 = "/"
}

resource "aws_iam_role_policy_attachment" "AdminRoleForECSTask" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role       = "AdminRoleForECSTask"

  depends_on = [aws_iam_role.AdminRoleForECSTask]
}

resource "aws_iam_role_policy_attachment" "ecsAutoscaleRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceAutoscaleRole"
  role       = "ecsAutoscaleRole"

  depends_on = [aws_iam_role.ecsAutoscaleRole]
}

resource "aws_iam_role_policy_attachment" "ecsInstanceRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
  role       = "ecsInstanceRole"

  depends_on = [aws_iam_role.ecsInstanceRole]
}

resource "aws_iam_role_policy_attachment" "ecsServiceRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
  role       = "ecsServiceRole"

  depends_on = [aws_iam_role.ecsServiceRole]
}

resource "aws_iam_role_policy_attachment" "ecsSpotFleetRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2SpotFleetTaggingRole"
  role       = "ecsSpotFleetRole"

  depends_on = [aws_iam_role.ecsSpotFleetRole]
}

resource "aws_iam_instance_profile" "ecsInstanceRole" {
  name = "ecsInstanceRole"
  path = "/"
  role = "ecsInstanceRole"
}