module "vpc" {
  source   = "./modules/vpc"
  env      = var.environment
  vpc_cidr = var.vpc_cidr
}


/*
# 3. Security Group for ECS Tasks (shared by both services)
resource "aws_security_group" "ecs_tasks" {
  name        = "${var.environment}-ecs-tasks-sg"
  vpc_id      = module.vpc.vpc_id
  description = "Allow ECS tasks to talk to RDS and outbound internet"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.environment}-ecs-tasks-sg" }
}


# 4. RDS MySQL (Private Subnets)

module "rds" {
  source            = "./modules/rds"
  env               = var.environment
  private_subnet_ids = module.vpc.private_subnets
  vpc_id            = module.vpc.vpc_id
  db_username       = var.db_user
  db_password       = var.db_pass
  ecs_tasks_sg_id   = aws_security_group.ecs_tasks.id
  depends_on        = [module.vpc]
}


# 5. Secrets Manager – Store DB credentials
module "secrets" {
  source       = "./modules/secrets"
  env          = var.environment
  db_username  = var.db_user
  db_password  = var.db_pass
  rds_endpoint = module.rds.rds_endpoint
  depends_on   = [module.rds]
}

# 6. ECS Cluster
module "ecs_cluster" {
  source = "./modules/ecs-cluster"
  env    = var.environment
}


# 7. IAM Roles + ECS Services + Auto Scaling + ALB Target Groups
module "ecs_services" {
  source = "./modules/ecs-services"

  env                     = var.environment
  cluster_id              = module.ecs_cluster.cluster_id
  vpc_id                  = module.vpc.vpc_id
  private_subnet_ids      = module.vpc.private_subnets
  alb_listener_https_arn  = module.alb.https_listener_arn
  alb_security_group_id   = module.alb.alb_security_group_id
  ecs_tasks_sg_id         = aws_security_group.ecs_tasks.id
  secret_arn              = module.secrets.secret_arn
  rds_endpoint            = module.rds.rds_endpoint
  microservice_ecr_url    = var.microservice_ecr_url  # you'll set this in tfvars

  depends_on = [
    module.ecs_cluster,
    module.alb,
    module.secrets,
    module.rds
  ]
}



resource "random_password" "db_password" {
  length  = 20
  special = true
  override_special = "_%@"
}


*/