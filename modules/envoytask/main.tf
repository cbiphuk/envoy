resource "aws_ecs_task_definition" "envoy_proxy" {
  family                = "envoy-proxy"
  container_definitions = "${file("task-definitions/service.json")}"
}
