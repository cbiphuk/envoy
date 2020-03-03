output "ecs_launch_config" {
  value = "${aws_launch_configuration.ecs_launch_configuration.name}"
}
