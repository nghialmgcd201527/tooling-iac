output "secret_manager_arn" {
  description = "ARN of Secret Manager"
  value       = aws_secretsmanager_secret.secret-manager.arn
}
