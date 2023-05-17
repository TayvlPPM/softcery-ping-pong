resource "aws_ecr_repository" "aws-ecr" {
  name = "${var.app_name}-${var.app_environment}-ecr"
  
  image_scanning_configuration {
    scan_on_push = true
  }

  image_tag_mutability = "MUTABLE"
  
  tags = {
    Name        = "${var.app_name}-ecr"
    Environment = var.app_environment
  }
}