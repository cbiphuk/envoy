resource "aws_ecs_service" "envoy" {
  name            = "${var.ecs_launch_configuration_name}"
  cluster         = "${var.ecs_cluster}"
  task_definition = "${var.ecs_task_definition}"
  desired_count   = "${var.ecs_task_count}"
  iam_role        = "${var.ecs_task_role}"
  depends_on      = "${var.aws_iam_role_policy}"


#TODO: write load balancer part
  load_balancer {
    target_group_arn = "${aws_lb_target_group.foo.arn}"
    container_name   = "mongo"
    container_port   = 8080
  }
}
