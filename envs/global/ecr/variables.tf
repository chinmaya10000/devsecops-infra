variable "region" {
  description = "AWS region to provision infrastructure."
  type        = string
}

variable "bucket" {
  description = "S3 bucket for terraform state."
  type        = string
}

variable "github_repo" {
  description = "GitHub repository in format org/repo"
  type        = string
}

variable "services" {
  description = "List of services to provision."
  type        = list(string)
}
