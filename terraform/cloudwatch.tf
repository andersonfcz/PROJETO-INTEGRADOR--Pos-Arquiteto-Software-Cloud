resource "aws_cloudwatch_metric_alarm" "scale-up-alarm" {
  alarm_name                = "scale-up-ec2-alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 120
  statistic                 = "Average"
  threshold                 = 70
  alarm_description         = "This metric monitors ec2 cpu utilization, if it goes above 70% for 2 periods it will trigger an alarm."
  insufficient_data_actions = []

  alarm_actions = [
    aws_autoscaling_policy.up.arn
  ]
}

resource "aws_cloudwatch_metric_alarm" "scale-down-alarm" {
  alarm_name                = "scale-down-ec2-alarm"
  comparison_operator       = "LessThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 120
  statistic                 = "Average"
  threshold                 = 40
  alarm_description         = "This metric monitors ec2 cpu utilization, if it goes below 40% for 2 periods it will trigger an alarm."
  insufficient_data_actions = []

  alarm_actions = [
    aws_autoscaling_policy.down.arn
  ]
}