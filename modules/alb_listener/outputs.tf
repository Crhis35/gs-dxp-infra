output "lb_listener_arn" {
  description = "The Listener of the Loadbalancer"
  value       = aws_lb_listener.this.*.arn
}
