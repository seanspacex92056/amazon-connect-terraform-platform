variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "recordings_bucket_arn" {
  type = string
}

variable "customer_lookup_lambda_arn" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
