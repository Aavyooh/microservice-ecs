resource "aws_ecr_repository" "this" {
  name = var.ecr_repo_name

  image_tag_mutability = "MUTABLE"

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Name = var.ecr_repo_name
  }
}

variable "ecr_repo_name" {
  type        = string
  description = "Name of the ECR Repository"
  default     = "wp-ecr-repo"
}

output "ecr_repo_url" {
  value = aws_ecr_repository.this.repository_url
}

output "ecr_repo_arn" {
  value = aws_ecr_repository.this.arn
}
