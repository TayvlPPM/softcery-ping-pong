resource "aws_cloudwatch_metric_alarm" "tfer--TargetTracking-002D-service-002F-ping-002D-pong-002D-service-002F-ping-002D-pong-002D-service-002D-AlarmHigh-002D-1d773d4c-002D-fce2-002D-4cd9-002D-a751-002D-cb1b7775ba20" {
  actions_enabled     = "true"
  alarm_actions       = ["arn:aws:autoscaling:${var.aws_region}:667332577260:scalingPolicy:c4079544-e137-43bc-bb91-dd4a9a3e51f4:resource/ecs/service/ping-pong-service/ping-pong-service:policyName/EC2SpotFleetAutoscale:createdBy/b6031bc3-dfd5-4c20-a727-b3613d874a01"]
  alarm_description   = "DO NOT EDIT OR DELETE. For TargetTrackingScaling policy arn:aws:autoscaling:${var.aws_region}:667332577260:scalingPolicy:c4079544-e137-43bc-bb91-dd4a9a3e51f4:resource/ecs/service/ping-pong-service/ping-pong-service:policyName/EC2SpotFleetAutoscale:createdBy/b6031bc3-dfd5-4c20-a727-b3613d874a01."
  alarm_name          = "TargetTracking-service/ping-pong-service/ping-pong-service-AlarmHigh-1d773d4c-fce2-4cd9-a751-cb1b7775ba20"
  comparison_operator = "GreaterThanThreshold"

  dimensions = {
    ClusterName = "${var.app_name}-${var.app_environment}-cluster"
    ServiceName = "${var.app_name}-${var.app_environment}-ecs-service"
  }

  evaluation_periods = "3"
  metric_name        = "CPUUtilization"
  namespace          = "AWS/ECS"
  period             = "60"
  statistic          = "Average"
  threshold          = "80"
  treat_missing_data = "missing"
  unit               = "Percent"
}
