resource "aws_ecs_cluster" "main" {
  name = "${var.env}-cluster"
}

