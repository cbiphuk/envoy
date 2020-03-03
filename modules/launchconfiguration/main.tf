resource "aws_launch_configuration" "ecs_launch_configuration" {
  name                 = "${var.ecs_launch_configuration_name}"
  image_id             = "${var.image_id}"
  instance_type        = "${var.instance_type}"
  iam_instance_profile = "${var.ecs_instance_profile}"

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 50
    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
  }

  #  security_groups             = ["${aws_security_group.ecs_envoy_security_group.id}"]
  security_groups             = ["${var.ecs_security_group}"]
  associate_public_ip_address = "true"
  key_name                    = "${var.ecs_key_pair_name}"

  user_data = <<EOF
                                  #!/bin/bash
                                  echo ECS_CLUSTER=${var.ecs_cluster} >> /etc/ecs/ecs.config
                                  EOF
}
