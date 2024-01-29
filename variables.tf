variable "access_key" {
  type      = string
  sensitive = true
}
variable "secret_key" {
  type      = string
  sensitive = true
}
variable "region" {
  type = string
}

variable "cidr_blocks" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "availability_zone" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}
