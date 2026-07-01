module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.0"

  domain_name = var.domain

  subject_alternative_names = [
    "*.${var.domain}",    # Covers all subdomains
  ]

  validation_method = "DNS"

  # Hostinger pe DNS hai — Route53 nahi
  create_route53_records = false

  wait_for_validation = false   # False rakho — pehle CNAME add karna padega Hostinger mein

  tags = {
    Name      = var.domain
    Env       = var.env
    ManagedBy = "terraform"
  }
}

output "acm_certificate_arn" {
  value = module.acm.acm_certificate_arn
}

# Yeh output se CNAME values milegi Hostinger ke liye
output "acm_validation_records" {
  value = module.acm.acm_certificate_domain_validation_options
}