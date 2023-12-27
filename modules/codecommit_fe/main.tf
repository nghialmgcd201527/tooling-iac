resource "aws_codecommit_repository" "fe_repo" {
  repository_name = var.fe_repo_name
  description     = "CodeCommit of ${var.fe_repo_name}"
  default_branch  = var.fe_repo_branch
}

data "template_file" "policy_codecommit" {
  template = file("${path.module}/policies/codecommit-policy.json")

  vars = {
    RESOURCES = "${aws_codecommit_repository.fe_repo.arn}"
  }
}

resource "aws_iam_policy" "codecommit_policy_fe" {
  name   = "CodeCommit-Policies-Frontend-${var.fe_repo_name}"
  policy = data.template_file.policy_codecommit.rendered
}
