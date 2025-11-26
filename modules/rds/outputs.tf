output "rds_endpoint" { value = aws_db_instance.main.address }
output "rds_sg_id" { value = aws_security_group.rds.id }