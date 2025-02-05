resource "aws_security_group" "app" {
  name        = "Inventory-App"
  description = "Enable access to App"
  vpc_id      = aws_vpc.main.id
}

resource "aws_security_group" "db" {
  name        = "Inventory-Db"
  description = "Enable access to MySQL"
  vpc_id      = aws_vpc.main.id
}

resource "aws_security_group" "lb" {
  name        = "Inventory-LB"
  description = "Enable access to LB"
  vpc_id      = aws_vpc.main.id
}

resource "aws_vpc_security_group_ingress_rule" "app_allow_lb_ingress" {
  security_group_id            = aws_security_group.app.id
  referenced_security_group_id = aws_security_group.lb.id
  from_port                    = 80
  to_port                      = 80
  ip_protocol                  = "tcp"
}


resource "aws_vpc_security_group_ingress_rule" "db_allow_app_mysql_ingress" {
  security_group_id            = aws_security_group.db.id
  referenced_security_group_id = aws_security_group.app.id
  from_port                    = 3306
  to_port                      = 3306
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "lb_allow_http" {
  security_group_id = aws_security_group.lb.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "app_default_egress" {
  security_group_id = aws_security_group.app.id
  from_port         = 0
  to_port           = 0
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "db_default_egress" {
  security_group_id = aws_security_group.db.id
  from_port         = 0
  to_port           = 0
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "lb_default_egress" {
  security_group_id = aws_security_group.lb.id
  from_port         = 0
  to_port           = 0
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}