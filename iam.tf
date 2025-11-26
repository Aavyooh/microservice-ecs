################### ECS Task Role with Custom Assume Role Policy

resource "aws_iam_role" "ecs_task_role" {
  name = "ecs_task_role"

  assume_role_policy = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
})

  tags = {
    Name = "ecs-task-role"
  }
}

# Attach Amazon ECS Full Access
resource "aws_iam_role_policy_attachment" "ecs_full_access_attach" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}

########## ECS Task Execution Role with Standard Assume Role Policy
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs_task_execution_role"

  # --- Custom Trust Policy (clean version) ---
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "ecs-task-execution-role"
  }
}

# --- Attach Amazon ECS Task Execution Role Managed Policy ---
resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
