# data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "log" {
  bucket = "${var.project_name}-${var.fe_repo_name}-${var.stage}-build-log"
}

resource "aws_codebuild_project" "codebuild_project" {
  name          = "${var.fe_repo_name}-main"
  description   = "Codebuild for ${var.fe_repo_name}"
  build_timeout = "50"
  service_role  = var.codebuild_role

  source_version = "refs/heads/${var.build_branch}"

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = var.compute_type
    image                       = "aws/codebuild/standard:7.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = false
  }

  source {
    type     = "CODECOMMIT"
    location = var.codecommit_fe_url
    git_submodules_config {
      fetch_submodules = true
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "log-group"
      stream_name = "log-stream"
    }
    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.log.id}/build-log"
    }
  }


}

