resource "aws_ecs_cluster" "aws-ecs-cluster" {
  name = "${var.app_name}-${var.app_environment}-cluster"

  tags = {
    Name        = "${var.app_name}-ecs"
    Environment = var.app_environment
  }
}

data "aws_ecs_task_definition" "main" {
  task_definition = aws_ecs_task_definition.aws-ecs-task.family
}

resource "aws_ecs_service" "aws-ecs-service" {
  name                 = "${var.app_name}-${var.app_environment}-ecs-service"
  cluster              = aws_ecs_cluster.aws-ecs-cluster.name
  #iam_role             = aws_iam_role.foo.arn
  launch_type          = "EC2"
  desired_count        = 4
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 50
  force_new_deployment = true
  scheduling_strategy = "REPLICA"
  task_definition     = "${aws_ecs_task_definition.aws-ecs-task.family}:${max(aws_ecs_task_definition.aws-ecs-task.revision, data.aws_ecs_task_definition.main.revision)}"
  
  deployment_circuit_breaker {
    enable   = "true"
    rollback = "true"
  }

  deployment_controller {
    type = "ECS"
  }

  ordered_placement_strategy {
    field = "attribute:ecs.availability-zone"
    type  = "spread"
  }

  ordered_placement_strategy {
    field = "instanceId"
    type  = "spread"
  }

  load_balancer {
    container_name   = "${var.app_name}-container"
    container_port   = 8080
    target_group_arn = aws_lb_target_group.target_group.arn
  }

  tags = {
    Name        = "${var.app_name}-ecs-service"
    Environment = var.app_environment
  }

  depends_on = [aws_lb_listener.listener]
}

resource "aws_ecs_task_definition" "aws-ecs-task" {
  family                   = "${var.app_name}-task"
  requires_compatibilities = ["EC2"]
  task_role_arn            = aws_iam_role.AdminRoleForECSTask.arn
  execution_role_arn       = aws_iam_role.AdminRoleForECSTask.arn
  cpu                      = "256"
  memory                   = "256"

  container_definitions = jsonencode([
    {
      "name": "${var.app_name}-container",
      "image": "${aws_ecr_repository.aws-ecr.repository_url}:latest",
      "cpu": 256,
      "memory": 256,
      "essential": true,
      "entryPoint": [],
      "command": [],
      "portMappings": [
        {
          "containerPort": 8080,
          "hostPort": 8080,
          "protocol": "tcp"
        }
      ],
      "environment": [],
      "mountPoints": [],
      "volumesFrom": []
    }
  ])
}