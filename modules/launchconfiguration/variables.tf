variable "ecs_launch_configuration_name" {
  description = "ecs launch configuration name"
}

variable "image_id" {
  description = "Image id for ecs launch configuration"
}

variable "instance_type" {
  description = "ecs envoy cluster instance type"
}

variable "ecs_key_pair_name" {
  description = "ssh key pair for ecs cluster"
}

variable "ecs_instance_profile" {
  description = "instance profile for ecs launch configuration"
}


variable "ecs_security_group" {
  description = "security group for ecs cluster"
}

variable "ecs_cluster" {}
