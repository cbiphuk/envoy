variable "ecs_service_role" {
  default     = "ecs_envoy_role"
  description = "ecs role for envoy cluster"
}

variable "ecs_instance_role" {
  default     = "ecs_instance_role"
  description = "ecs instance role for envoy cluster"
}

variable "ecs_instance_profile" {
  default     = "ecs_instance_profile"
  description = "ecs instance profile for envoy cluster"
}

variable "vpc_id" {
  default     = "vpc-e2164b9b"
  description = "vpc id for ecs clsuter and security group"
}

#Launch configuration

variable "ecs_launch_configuration_name" {
  default     = "ecs_envoy_launch_configuration"
  description = "name of the ecs launch configuration"
}

variable "image_id" {
  default     = "ami-00afc256a955c31b5"
  description = "image id for the launch configuration"
}

variable "instance_type" {
  default     = "m5ad.large"
  description = "Instance type for the laucnh configuration"
}

variable "ecs_key_pair_name" {
  default     = "vitlir"
  description = "key pair for ecs launch configuration"
}

# Autoscaling group

variable "ecs_autoscaling_group_name" {
  default     = "ecs_envoy_autoscaling_group"
  description = "ecs autoscaling group name"
}

variable "max_instance_size" {
  default     = "1"
  description = "max value of hosts in autoscaling group"
}

variable "min_instance_size" {
  default     = "1"
  description = "max value of hosts in autoscaling group"
}

variable "desired_capacity" {
  default     = "1"
  description = "max value of hosts in autoscaling group"
}

variable "ecs_cluster" {
  default     = "envoy_ecs_cluster"
  description = "ecs envoy cluster name"
}

variable "nlb_name" {
  default     = "Envoy-NLB"
  description = "NLB for balancing envoy proxy instances"
}

variable "subnets" {
  default = ["subnet-3ff1545b"]
  description = "NLB subnets"
}
