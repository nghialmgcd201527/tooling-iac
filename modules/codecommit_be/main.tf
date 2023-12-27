resource "aws_codecommit_repository" "be_repo" {
  repository_name = var.be_repo_name
  description     = "CodeCommit of ${var.be_repo_name}"
  default_branch  = var.be_repo_branch
}

data "template_file" "policy_codecommit" {
  template = file("${path.module}/policies/codecommit-policy.json")

  vars = {
    RESOURCES = "${aws_codecommit_repository.be_repo.arn}"
  }
}

resource "aws_iam_policy" "codecommit_policy_be" {
  name   = "CodeCommit-Policies-Backend-${var.be_repo_name}"
  policy = data.template_file.policy_codecommit.rendered
}
