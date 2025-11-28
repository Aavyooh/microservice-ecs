resource "aws_ecs_service" "wp_service" {
  name            = "dev-ecs-wp-sv"
  cluster         = aws_ecs_cluster.this.arn     # existing cluster
  task_definition = aws_ecs_task_definition.wp_task.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets         = module.vpc.private_subnets
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
    load_balancer {
    target_group_arn = aws_lb_target_group.wp_tg.arn
    container_name   = "wordpress"
    container_port   = 80
  }

  depends_on = [
    aws_lb_listener.http_listener
  ]

  lifecycle {
    ignore_changes = [task_definition]  # allows updating TD without recreating service
  }
}
