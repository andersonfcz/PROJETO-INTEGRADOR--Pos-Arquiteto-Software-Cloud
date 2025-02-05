resource "aws_lb" "inventory-lb" {
  name                             = "Inventory-LB"
  internal                         = false
  load_balancer_type               = "application"
  security_groups                  = [aws_security_group.lb.id]
  subnets                          = [aws_subnet.public-a.id, aws_subnet.public-b.id]
  enable_cross_zone_load_balancing = true
  enable_deletion_protection       = false
}

resource "aws_lb_target_group" "inventory-lb" {
  name     = "Inventory-Appp"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    healthy_threshold = 2
    interval          = 30
  }

  depends_on = []
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.inventory-lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.inventory-lb.arn
  }
}