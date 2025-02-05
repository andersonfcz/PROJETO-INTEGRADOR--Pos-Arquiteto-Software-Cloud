resource "aws_autoscaling_group" "app-asg" {
  vpc_zone_identifier       = [aws_subnet.private-a.id, aws_subnet.private-b.id]
  desired_capacity          = 2
  max_size                  = 4
  min_size                  = 2
  target_group_arns         = [aws_lb_target_group.inventory-lb.arn]
  health_check_grace_period = 300
  force_delete              = true

  launch_template {
    id = aws_launch_template.app-lt.id
  }

  availability_zone_distribution {
    capacity_distribution_strategy = "balanced-best-effort"
  }

  depends_on = [aws_db_instance.default]
}

resource "aws_launch_template" "app-lt" {
  name                   = "app-lt"
  image_id               = "ami-032ae1bccc5be78ca"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.app-key.id
  vpc_security_group_ids = [aws_security_group.app.id]

  monitoring {
    enabled = true
  }

  iam_instance_profile {
    arn = aws_iam_instance_profile.inventory-app.arn
  }

  user_data = base64encode(
    <<-EOT
    #!/bin/bash
    yum install -y httpd mysql
    amazon-linux-extras install -y php7.2
    wget https://aws-tc-largeobjects.s3-us-west-2.amazonaws.com/ILT-TF-200-ACACAD-20-EN/mod9-guided/scripts/inventory-app.zip
    unzip inventory-app.zip -d /var/www/html/
    wget https://github.com/aws/aws-sdk-php/releases/download/3.62.3/aws.zip
    unzip aws -d /var/www/html
    chkconfig httpd on
    service httpd start
    EOT
  )

}

resource "aws_autoscaling_policy" "up" {
  name                   = "scale-up-ec2"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.app-asg.name
  policy_type            = "SimpleScaling"

}

resource "aws_autoscaling_policy" "down" {
  name                   = "scale-down-ec2"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.app-asg.name
  policy_type            = "SimpleScaling"
}

resource "aws_autoscaling_attachment" "my_asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.app-asg.id
  lb_target_group_arn    = aws_lb_target_group.inventory-lb.arn
}

resource "aws_key_pair" "app-key" {
  key_name   = "inventory-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC9todtQOKniUC0XGL76eN24m+YMitdRMnNAnrVg6rBbwWV4K7Zz7TUlcwCdsIA2ETO462AY+zhUm+CzKCHfxxXTGmL4tPXuM3xTkOpltRqzTGe7io1iCY890PBrdPP7EEGPwSJXG+noU04mOga8rUI6kNBdyqSnUMSZNbznTFLk9FV5p+cU+2r+3rjqHAfrt6c0Q02WXuhRzIJQz4rFJ22lDgtyU5YzCVwVM16NuD+wm3ZyhPCgKlGBrVFgvbErmO29t7nyRJMTxZ6H4hd1/0YdFlXZ2WNDAmA4mO0g3WsiKmWYTre4KZsld3A6y3VEcalarTsc9vGP6IvkHUWS+UbVlb+5HJKB/uxYPVi7iKX/wSIMvGYQyQGzx8gL6eUUMilyz9d59KtGvseWYOYPz3Zcqm34zo685cSg5I5L4sp8jEN+V7xQ2I3qJ/HAOoyIlcdJVU3uPjAVeY5ywXH4tPxQrejcpC7qKBsLCsw/8UQLZpByb5twHp4p8XKVB/EsJk= ander@ANDERSON-HOME-DESKTOP"
}