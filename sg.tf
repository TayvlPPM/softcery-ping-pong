resource "aws_security_group" "ecs-containers-sg" {
  description = "ECS Allowed Ports"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    from_port       = "8080"
    protocol        = "tcp"
    security_groups = [aws_security_group.lb-sg.id]
    self            = "false"
    to_port         = "8080"
  }

  name   = "${var.app_name}-containers-sg"
  vpc_id        = aws_vpc.aws-vpc.id
}

resource "aws_security_group" "vpc-default" {
  description = "default VPC security group"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    from_port = "0"
    protocol  = "-1"
    self      = "true"
    to_port   = "0"
  }

  name   = "default-vpc-sg"
  vpc_id      = aws_vpc.aws-vpc.id
}

data "http" "my_ip" {
  url = "https://api.ipify.org?format=text"
}

output "my_ip_address" {
  value = data.http.my_ip.body
}

resource "aws_security_group" "vpn-sg" {
  description = "ec2 vpn sg"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "1194"
    protocol    = "udp"
    self        = "false"
    to_port     = "1194"
  }

  ingress {
    cidr_blocks = ["${data.http.my_ip.body}/32"]
    from_port   = "22"
    protocol    = "tcp"
    self        = "false"
    to_port     = "22"
  }

  name   = "${var.app_name}-vpn-instance-sg"
  vpc_id        = aws_vpc.aws-vpc.id
}

resource "aws_security_group" "lb-sg" {
  description = "ping-pong-lb-sg"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    from_port       = "80"
    protocol        = "tcp"
    security_groups = [aws_security_group.vpn-sg.id]
    self            = "false"
    to_port         = "80"
  }

  name   = "${var.app_name}-lb-sg"
  vpc_id            = aws_vpc.aws-vpc.id
}
