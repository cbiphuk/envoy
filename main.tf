# Configure the AWS Provider
provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
}

# Service Role
resource "aws_iam_role" "ecs_service_role" {
  name               = "${var.ecs_service_role}"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_service_policy.json}"
}

resource "aws_iam_role_policy_attachment" "ecs_service_role_attachment" {
  role       = "${aws_iam_role.ecs_service_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

data "aws_iam_policy_document" "ecs_service_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}

# Instance role

resource "aws_iam_role" "ecs_instance_role" {
  name               = "${var.ecs_instance_role}"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_instance_policy.json}"
}

data "aws_iam_policy_document" "ecs_instance_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecs_instance_role_attachement" {
  role       = "${aws_iam_role.ecs_instance_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "${var.ecs_instance_profile}"
  path = "/"
  role = "${aws_iam_role.ecs_instance_role.id}"

  provisioner "local-exec" {
    command = "sleep 10"
  }
}

#Security group

resource "aws_security_group" "ecs_envoy_security_group" {
  name        = "ecs_envoy_sg"
  description = "Configure access to envoy ecs cluster"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "launchconfiguration" "ecs_launch_configuration" {
  source                        = "./modules/launchconfiguration"
  ecs_launch_configuration_name = "${var.ecs_launch_configuration_name}"
  image_id                      = "${var.image_id}"
  instance_type                 = "${var.instance_type}"
  ecs_instance_profile          = "${aws_iam_instance_profile.ecs_instance_profile.id}"
  ecs_security_group            = "${aws_security_group.ecs_envoy_security_group.id}"
  ecs_key_pair_name             = "${var.ecs_key_pair_name}"
  ecs_cluster                   = "${var.ecs_cluster}"
}

resource "aws_autoscaling_group" "ecs_autoscaling_group" {
  name             = "${var.ecs_autoscaling_group_name}"
  max_size         = "${var.max_instance_size}"
  min_size         = "${var.min_instance_size}"
  desired_capacity = "${var.desired_capacity}"

  #TODO: Fix hardcoded subnet
  vpc_zone_identifier  = ["subnet-3ff1545b"]
  launch_configuration = "${module.launchconfiguration.ecs_launch_config}"
  health_check_type    = "ELB"

  tags = [
    {
      key                 = "noreap"
      value               = "true"
      propagate_at_launch = true
    },
  ]
}

resource "aws_ecs_cluster" "test-ecs-cluster" {
  name = "${var.ecs_cluster}"
}

module "envoytask" "envoy_proxy" {
  source = "./modules/envoytask"
}

module "envoynlb" "ecs_envoy_nlb" {
  source   = "./modules/envoynlb"
  nlb_name = "${var.nlb_name}"
  subnets  = ["${var.subnets}"]
}

#TODO: write module description for envoyservice

