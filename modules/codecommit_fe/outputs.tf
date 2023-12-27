output "codecommit_fe_repo" {
  value = aws_codecommit_repository.fe_repo.repository_name
}

output "codecommit_fe_arn" {
  value = aws_codecommit_repository.fe_repo.arn
}

output "codecommit_fe_url" {
  value = aws_codecommit_repository.fe_repo.clone_url_ssh
}

# output "codecommit_be_repo" {
#   value = "${aws_codecommit_repository.codecommit_be_repo.repository_name}"
# }
