output "codecommit_be_repo" {
  value = aws_codecommit_repository.be_repo.repository_name
}

output "codecommit_be_arn" {
  value = aws_codecommit_repository.be_repo.arn
}

output "codecommit_be_url" {
  value = aws_codecommit_repository.be_repo.clone_url_ssh
}

