variable "region" {
    default = "us-east-1"
}
variable "environment" {
    default = "dev"
}

variable "vpc_cidr" {
    default = "10.0.0.0/16"
}

/*
variable "db_user" {
    default = "wpuser"  
}

variable "db_pass" {
    default = "wpuser"
    sensitive = true
}
variable "acm_certificate_arn" {
  description = "ACM cert ARN for *.nsc.viewdns.net (or leave empty to create one)"
  default     = ""
}

/*

variable "ecr_url" {
  default = 
  
}


variable "route53_zone_id" {
  description = "Hosted zone ID for nsc.viewdns.net"
}



*/

