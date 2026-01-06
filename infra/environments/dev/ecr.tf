resource "aws_ecr_repository" "app" {
  name = "eks-demo-app"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Name        = "eks-demo-app"
    Environment = "dev"
  }
}
