variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "connect_instance_id" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
