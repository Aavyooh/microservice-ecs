resource "aws_ecs_cluster" "this" {
  name = var.ecs_cluster_name

  tags = {
    Name = var.ecs_cluster_name
  }
}

variable "ecs_cluster_name" {
  type        = string
  description = "Name of the ECS Cluster"
  default     = "wp-cluster"
}

output "ecs_cluster_id" {
  value = aws_ecs_cluster.this.id
}
