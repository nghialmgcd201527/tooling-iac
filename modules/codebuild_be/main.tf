# data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "log" {
  bucket = "${var.project_name}-${var.be_repo_name}-${var.stage}-build-log"
}

resource "aws_codebuild_project" "codebuild_project" {
  name          = "${var.be_repo_name}-main"
  description   = "Codebuild for ${var.be_repo_name}"
  build_timeout = "50"
  service_role  = var.codebuild_role

  source_version = "refs/heads/${var.build_branch}"

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = var.compute_type
    image                       = var.image
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
  }

  source {
    type     = "CODECOMMIT"
    location = var.codecommit_be_url
  }
  # VPC configuration will apply for all backend codebuild, even if it no need. 
  vpc_config {
    vpc_id = var.vpc_id

    subnets = flatten([
      var.private_subnet_ids
    ])

    security_group_ids = [
      var.private_security_group
    ]
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

