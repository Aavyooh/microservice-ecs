variable "env" { type = string }
variable "vpc_id" { type = string }
variable "public_subnet_ids" { type = list(string) }
variable "route53_zone_id" { type = string }
variable "acm_certificate_arn" { 
    type = string 
    default = "" 
}