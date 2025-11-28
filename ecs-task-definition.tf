data "aws_ecr_repository" "wp_repo" {
  name = "wp-ecr-repo"
}

data "aws_ecr_image" "wp_image" {
  repository_name = data.aws_ecr_repository.wp_repo.name
  image_tag       = "latest"
}



resource "aws_ecs_task_definition" "wp_task" {
  family                   = "dev-ecs-wp-td"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "1024"
  memory                   = "2048"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "wordpress"
      image     = data.aws_ecr_image.wp_image.image_uri
      essential = true

      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
      
      secrets = [
        {
          name      = "WORDPRESS_DB_USER"
          valueFrom = "${aws_secretsmanager_secret.db_credentials.arn}:username::"
        },
        {
          name      = "WORDPRESS_DB_PASSWORD"
          valueFrom = "${aws_secretsmanager_secret.db_credentials.arn}:password::"
        }
      ]

      environment = [
        {
          name  = "WORDPRESS_DB_HOST"
          value = aws_db_instance.dev_wp_rds.address
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/wp"
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "wordpress"
          "awslogs-create-group"  = "true"
        }
      }
    }
  ])
}

resource "aws_cloudwatch_log_group" "wp" {
  name              = "/ecs/wp"
  retention_in_days = 30
}
