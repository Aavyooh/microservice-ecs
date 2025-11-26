/*

output "wordpress_url" {
  value = "https://wordpress.nsc.viewdns.net"
}

output "microservice_url" {
  value = "https://microservice.nsc.viewdns.net"
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "rds_endpoint" {
  value     = module.rds.rds_endpoint
  sensitive = true
}

output "db_password" {
  value     = random_password.db_password.result
  sensitive = true
}  

*/