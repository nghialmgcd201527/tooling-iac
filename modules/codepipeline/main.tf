data "template_file" "env_file" {
  template = file("${path.module}/env.json")
  vars = {
    secret_manager_arn = "${var.secret_manager_arn}"
    stage              = "${var.stage}"
  }
}

resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket        = "${var.project_name}-${var.repo_name}-${var.stage}-pp-log"
  force_destroy = var.is_force_destroy
}

# resource "aws_s3_bucket_acl" "codepipeline_s3_bucket" {
#   bucket = aws_s3_bucket.codepipeline_bucket.id
#   acl    = "private"
# }

resource "aws_s3_bucket_public_access_block" "codepipeline_bucket_access_block" {
  bucket = aws_s3_bucket.codepipeline_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_codepipeline" "codepipeline" {
  name     = "${var.repo_name}-${var.stage}"
  role_arn = var.codepipeline_role

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["sourceout"]

      configuration = {
        RepositoryName       = "${var.repo_name}"
        BranchName           = "${var.repo_branch}"
        OutputArtifactFormat = "CODEBUILD_CLONE_REF"
        PollForSourceChanges = "false"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = var.codebuild_project_name
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["sourceout"]
      output_artifacts = ["buildout1"]
      version          = "1"

      configuration = {
        ProjectName          = "${var.codebuild_project_name}"
        EnvironmentVariables = data.template_file.env_file.rendered
      }
    }
  }
}

resource "aws_cloudwatch_event_rule" "codepipeline" {
  name        = "cp-rule-${var.repo_name}-${var.stage}"
  description = "Amazon CloudWatch Events rule to automatically start your pipeline when a change occurs in the AWS CodeCommit source repository and branch. Deleting this may prevent changes from being detected in that pipeline. Read more: http://docs.aws.amazon.com/codepipeline/latest/userguide/pipelines-about-starting.html"

  event_pattern = jsonencode({
    source = ["aws.codecommit"]
    detail-type = [
      "CodeCommit Repository State Change"
    ]
    resources = ["${var.codecommit_arn}"]
    detail = {
      event = [
        "referenceCreated",
        "referenceUpdated"
      ]
      referenceType = ["branch"]
      referenceName = ["${var.repo_branch}"]
    }
  })
}

resource "aws_iam_role" "cwe_codepipeline" {
  name = "cwe-role-${var.repo_name}-${var.stage}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "events.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "cwe_codepipeline_policy" {
  name        = "start-pipeline-execution-policy-${var.repo_name}-${var.stage}"
  path        = "/"
  description = "Allows Amazon CloudWatch Events to automatically start a new execution in the ${var.repo_name}-${var.stage} pipeline when a change occurs"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "codepipeline:StartPipelineExecution",
        ]
        Effect   = "Allow"
        Resource = ["${aws_codepipeline.codepipeline.arn}"]
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cwe-codepipeline-policy-attachment" {
  role       = aws_iam_role.cwe_codepipeline.name
  policy_arn = aws_iam_policy.cwe_codepipeline_policy.arn
}

resource "aws_cloudwatch_event_target" "codepipeline" {
  rule      = aws_cloudwatch_event_rule.codepipeline.name
  target_id = "${var.repo_name}-${var.stage}"
  arn       = aws_codepipeline.codepipeline.arn
  role_arn  = aws_iam_role.cwe_codepipeline.arn
}
