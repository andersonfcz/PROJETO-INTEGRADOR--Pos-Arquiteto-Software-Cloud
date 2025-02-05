resource "aws_iam_instance_profile" "inventory-app" {
  name = "Inventory-App-Role"
  role = aws_iam_role.app.name
}

resource "aws_iam_role" "app" {
  name = "Inventory-App-Role"
  path = "/"
  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "ec2.amazonaws.com"
          }
        },
      ]
    }
  )
}

resource "aws_iam_role_policy" "root" {
  name = "root"
  role = aws_iam_role.app.id

  policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["ssm:*"]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    }
  )
}