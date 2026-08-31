output "instance_id" { value = aws_connect_instance.this.id }
output "instance_arn" { value = aws_connect_instance.this.arn }
output "inbound_contact_flow_id" { value = aws_connect_contact_flow.inbound.contact_flow_id }
output "enterprise_queue_id" { value = aws_connect_queue.enterprise.queue_id }
output "priority_queue_id" { value = aws_connect_queue.priority.queue_id }
