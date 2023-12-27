output "iam_maintainers_group" {
  value = aws_iam_group.maintainers.name
}
output "iam_devops_group" {
  value = aws_iam_group.devops.name
}
output "iam_devs_group" {
  value = aws_iam_group.devs.name
}
