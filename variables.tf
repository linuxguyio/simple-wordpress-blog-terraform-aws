variable "app_region" {
  description = "this is the region where our blog will be deployed"
  type        = string
  default     = "ap-southeast-2"

}

variable "vpc_cidr_block" {
  description = "this is the cidr block for your VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "az" {
  description = "this is the availability zone where the subnet will be created"
  type        = string
  default     = "ap-southeast-2b"
}

variable "webserver_instance_type" {
    description = "instance type for webserver"
    type = string
    default = "t2.micro"
  
}
