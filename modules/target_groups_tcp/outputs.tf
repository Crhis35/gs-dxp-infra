output "target_group_name" {
  description = "Name of the target group"
  value       = concat(aws_lb_target_group.this.*.name, [""])[0]
}

output "target_group_arn" {
  description = "Name of the target group"
  value       = concat(aws_lb_target_group.this.*.arn, [""])[0]
}
