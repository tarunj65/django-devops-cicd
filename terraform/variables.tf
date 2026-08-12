variable "aws_region" {

  description = "AWS Region"

  type = string

}

variable "admin_ip" {

  description = "Public IPv4 address allowed to access Jenkins."
  type        = string

}
