data "aws_iam_role" "spot_fleet_role" {
  name = "AWSServiceRoleForEC2SpotFleet"
}

output "spot_fleet_role_arn" {
  value = data.aws_iam_role.spot_fleet_role.arn
}

resource "aws_spot_fleet_request" "example" {
  iam_fleet_role                      = data.aws_iam_role.spot_fleet_role.arn
  target_capacity                     = 4
  on_demand_target_capacity           = 0
  replace_unhealthy_instances         = true
  allocation_strategy                 = "diversified"
  #wait_for_fulfillment                = "true"
  terminate_instances_on_delete       = "true"
  spot_price                          = 0.05

  dynamic "launch_specification" {
    for_each = aws_subnet.public
    content {
      instance_type        = "t3.nano"
      ami                  = "ami-09abc3f61176ea1de"
      vpc_security_group_ids = [aws_security_group.ecs-containers-sg.id]
      subnet_id            = launch_specification.value.id
      iam_instance_profile = aws_iam_instance_profile.ecsInstanceRole.name

      # Configure the ECS task definition for the fleet instances
      user_data = <<-EOF
                #!/bin/bash
                echo 'ECS_CLUSTER=${var.app_name}-${var.app_environment}-cluster' >> /etc/ecs/ecs.config
                echo 'ECS_ENABLE_SPOT_INSTANCE_DRAINING=true' >> /etc/ecs/ecs.config
                echo 'ECS_ENABLE_TASK_IAM_ROLE=true' >> /etc/ecs/ecs.config
                echo 'ECS_ENABLE_TASK_IAM_ROLE_NETWORK_HOST=true' >> /etc/ecs/ecs.config
                echo 'ECS_TASK_DEFINITION=${aws_ecs_task_definition.aws-ecs-task.family}:latest' >> /etc/ecs/ecs.config
                echo 'ECS_CONTAINER_STOP_TIMEOUT=120s' >> /etc/ecs/ecs.config
                EOF

      tags = {
          Name        = "${var.app_name}-ec2-worker"
          tag_builder = "builder"
        }
    }
  }
  target_group_arns = [
    aws_lb_target_group.target_group.arn
  ]

}
