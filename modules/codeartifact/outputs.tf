output "codeartifact_domain_arn" {
  value = "${aws_codeartifact_domain.codeartifact_domain.arn}"
}
output "codeartifact_domain_id" {
  value = "${aws_codeartifact_domain.codeartifact_domain.id}"
}

output "codeartifact_repo_arn" {
  value = "${aws_codeartifact_repository.codeartifact_repo.arn}"
}
output "codeartifact_repo_id" {
  value = "${aws_codeartifact_repository.codeartifact_repo.id}"
}