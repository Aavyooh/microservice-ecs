# WordPress Task Definition
resource "aws_ecs_task_definition" "wordpress" {
  family                   = "${var.env}-wordpress"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "1024"
  memory                   = "2048"
  execution_role_arn       = aws_iam_role.ecs_execution.arn
  task_role_arn            = aws_iam_role.ecs_task.arn

  container_definitions = jsonencode([
    {
      name  = "wordpress"
      image = "wordpress:latest"
      essential = true
      portMappings = [{ containerPort = 80, protocol = "tcp" }]
      environment = [
        { name = "WORDPRESS_DB_HOST", value = var.rds_endpoint },
        { name = "WORDPRESS_DB_USER", value = var.db_username },
        { name = "WORDPRESS_DB_NAME", value = "wordpress" }
      ]
      secrets = [
        { name = "WORDPRESS_DB_PASSWORD", valueFrom = "${var.secret_arn}:password::" }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs.name
          "awslogs-region"        = data.aws_region.current.name
          "awslogs-stream-prefix" = "wordpress"
        }
      }
    }
  ])
}

# Node.js Microservice
resource "aws_ecs_task_definition" "microservice" {
  family                   = "${var.env}-microservice"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_execution.arn

  container_definitions = jsonencode([
    {
      name      = "microservice"
      image     = "${var.ecr_repo_url}:latest"
      essential = true
      portMappings = [{ containerPort = 3000, protocol = "tcp" }]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs.name
          "awslogs-region"        = data.aws_region.current.name
          "awslogs-stream-prefix" = "microservice"
        }
      }
    }
  ])
}