resource "aws_secretsmanager_secret" "secret-manager" {
  name = "${var.environment}-secret"
}
variable "example" {
  default = {
    key1 = "value1"
  }

  type = map(string)
}
resource "aws_secretsmanager_secret_version" "example" {
  secret_id     = aws_secretsmanager_secret.secret-manager.id
  secret_string = jsonencode(var.example)
}
