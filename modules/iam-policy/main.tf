data "template_file" "s3_iam_role_policy_file" {
  template = file("${path.module}/policy/s3_iam_role_policy.json")
}

data "template_file" "codebuild_iam_role_policy_file" {
  template = file("${path.module}/policy/codebuild-role-policy.json")
}

data "template_file" "codebuild_iam_assume_role_policy_file" {
  template = file("${path.module}/policy/codebuild-assume-role-policy.json")
}

data "template_file" "codebuild_execution_policy_file" {
  template = file("${path.module}/policy/codebuild-execution-role.json")
}

data "template_file" "pipeline_iam_assume_role_policy_file" {
  template = file("${path.module}/policy/code-pipeline-assume-role.json")
}

data "template_file" "allow_to_assume_policy_file" {
  template = file("${path.module}/policy/allow-to-assume.json")
}

data "template_file" "pipeline_iam_policy_file" {
  template = file("${path.module}/policy/codepipeline-service-role-policy.json")
}

data "template_file" "codecommit_policy_dev_file" {
  template = file("${path.module}/policy/codecommit-dev.json")

  vars = {
    account_id = var.account_id
  }
}

data "template_file" "codecommit_policy_devops_file" {
  template = file("${path.module}/policy/codecommit-devops.json")

  vars = {
    account_id = var.account_id
  }
}

data "template_file" "codecommit_policy_maintainers_file" {
  template = file("${path.module}/policy/codecommit-maintainer.json")

  vars = {
    account_id = var.account_id
  }
}

data "template_file" "allow_to_assume_application_file" {
  template = file("${path.module}/policy/allow-to-assume-to-application.json")

  vars = {
    application_account_id    = var.application_account_id
    application_account_id_qa = var.application_account_id_qa
  }
}

data "template_file" "ssm_application_role_file" {
  template = file("${path.module}/policy/ssm-application-role.json")

  vars = {
    application_account_id    = var.application_account_id
    application_account_id_qa = var.application_account_id_qa
  }
}

/* role for Amazon CodeBuild */
resource "aws_iam_role" "codebuild_role" {
  name               = "Codebuild-role"
  assume_role_policy = data.template_file.codebuild_iam_assume_role_policy_file.rendered
}

resource "aws_iam_role" "codebuild_role_for_codeartifact" {
  name               = "Codebuild-role-for-codeartifact"
  assume_role_policy = data.template_file.codebuild_iam_assume_role_policy_file.rendered
}

resource "aws_iam_role" "codebuild_role_for_backend" {
  name               = "Codebuild-role-for-dev-env-backend"
  assume_role_policy = data.template_file.codebuild_iam_assume_role_policy_file.rendered
}

resource "aws_iam_role" "codebuild_role_for_frontend" {
  name               = "Codebuild-role-for-dev-env-frontend"
  assume_role_policy = data.template_file.codebuild_iam_assume_role_policy_file.rendered
}

/* role for Amazon CodePipeline */
resource "aws_iam_role" "codepipeline_role" {
  name               = "CodePipeline-role"
  assume_role_policy = data.template_file.pipeline_iam_assume_role_policy_file.rendered
}

/* AWS Policies */
resource "aws_iam_policy" "codecommit_devops_policy" {
  name        = "CodeCommit-Policies-DevOps"
  path        = "/"
  description = "Policy that attach to DevOps Group "
  policy      = data.template_file.codecommit_policy_devops_file.rendered
}

resource "aws_iam_policy" "codecommit_maintainer_policy" {
  name        = "CodeCommit-Policies-Maintainers"
  path        = "/"
  description = "Policy that attach to Maintainer Group "
  policy      = data.template_file.codecommit_policy_maintainers_file.rendered
}

resource "aws_iam_policy" "codecommit_dev_policy" {
  name        = "CodeCommit-Policies-Devs"
  path        = "/"
  description = "Policy that attach to Dev Group "
  policy      = data.template_file.codecommit_policy_dev_file.rendered
}


resource "aws_iam_policy" "codepipeline_policy" {
  name        = "Codepileline-policy"
  path        = "/"
  description = "Policy that attach to codepipeline "
  policy      = data.template_file.pipeline_iam_policy_file.rendered
}

resource "aws_iam_policy" "codebuildbase_policy" {
  name        = "CodeBuildbase-policy"
  path        = "/"
  description = "Policy that attach to codebuild to interact with codecommit, s3, logs"
  policy      = data.template_file.codebuild_iam_role_policy_file.rendered
}


resource "aws_iam_policy" "allow_to_assume_policy" {
  name        = "AllowToAssumeCodeArtifact"
  path        = "/"
  description = "Policy that attach to codebuild to assume role access to Puravida Artifact"
  policy      = data.template_file.allow_to_assume_policy_file.rendered
}
resource "aws_iam_policy" "allow_to_assume_application_policy" {
  name        = "AllowToAssumeApplication"
  path        = "/"
  description = "Policy that attach to codebuild to assume role in Application Env"
  policy      = data.template_file.allow_to_assume_application_file.rendered
}

resource "aws_iam_policy" "codebuild_execution_policy" {
  name        = "CodeBuild-execution-role-policy"
  path        = "/"
  description = "Policy that attach to codebuild to run the build"
  policy      = data.template_file.codebuild_execution_policy_file.rendered
}

resource "aws_iam_policy" "ssm_application_policy" {
  name        = "Ssm-application-policy"
  path        = "/"
  description = "Policy that attach to developer group"
  policy      = data.template_file.ssm_application_role_file.rendered
}

/* Attach Policies to IAM role */

resource "aws_iam_role_policy_attachment" "codebuildbase-policy-attachment" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = aws_iam_policy.codebuildbase_policy.arn
}

resource "aws_iam_role_policy_attachment" "codebuildbase-policy-attachment-1" {
  role       = aws_iam_role.codebuild_role_for_codeartifact.name
  policy_arn = aws_iam_policy.codebuildbase_policy.arn
}

resource "aws_iam_role_policy_attachment" "codebuildbase-policy-attachment-2" {
  role       = aws_iam_role.codebuild_role_for_backend.name
  policy_arn = aws_iam_policy.codebuildbase_policy.arn
}

resource "aws_iam_role_policy_attachment" "codebuildbase-policy-attachment-3" {
  role       = aws_iam_role.codebuild_role_for_frontend.name
  policy_arn = aws_iam_policy.codebuildbase_policy.arn
}

#Allow to Assume CodeArtifact attachment
resource "aws_iam_role_policy_attachment" "allow-to-assume-policy-attachment-codebuild-role" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = aws_iam_policy.allow_to_assume_policy.arn
}

resource "aws_iam_role_policy_attachment" "allow-to-assume-policy-attachment-codebuild-backend" {
  role       = aws_iam_role.codebuild_role_for_backend.name
  policy_arn = aws_iam_policy.allow_to_assume_policy.arn
}

resource "aws_iam_role_policy_attachment" "allow-to-assume-policy-attachment-codebuild-frontend" {
  role       = aws_iam_role.codebuild_role_for_frontend.name
  policy_arn = aws_iam_policy.allow_to_assume_policy.arn
}

resource "aws_iam_role_policy_attachment" "allow-to-assume-policy-attachment-codebuild-artifact" {
  role       = aws_iam_role.codebuild_role_for_codeartifact.name
  policy_arn = aws_iam_policy.allow_to_assume_policy.arn
}
#Allow to Assume Application attachment
resource "aws_iam_role_policy_attachment" "allow-to-assume-application-policy-attachment-codebuild-role" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = aws_iam_policy.allow_to_assume_application_policy.arn
}

resource "aws_iam_role_policy_attachment" "allow-to-assume-application-policy-attachment-codebuild-backend" {
  role       = aws_iam_role.codebuild_role_for_backend.name
  policy_arn = aws_iam_policy.allow_to_assume_application_policy.arn
}

resource "aws_iam_role_policy_attachment" "allow-to-assume-policy-application-attachment-codebuild-frontend" {
  role       = aws_iam_role.codebuild_role_for_frontend.name
  policy_arn = aws_iam_policy.allow_to_assume_application_policy.arn
}

resource "aws_iam_role_policy_attachment" "allow-to-assume-policy-application-attachment-codebuild-artifact" {
  role       = aws_iam_role.codebuild_role_for_codeartifact.name
  policy_arn = aws_iam_policy.allow_to_assume_application_policy.arn
}

#Codebuild Execution attachment
resource "aws_iam_role_policy_attachment" "codebuild-execution-policy-attachment" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = aws_iam_policy.codebuild_execution_policy.arn
}

resource "aws_iam_role_policy_attachment" "codebuild-execution-policy-attachment-1" {
  role       = aws_iam_role.codebuild_role_for_codeartifact.name
  policy_arn = aws_iam_policy.codebuild_execution_policy.arn
}

resource "aws_iam_role_policy_attachment" "codebuild-execution-policy-attachment-2" {
  role       = aws_iam_role.codebuild_role_for_backend.name
  policy_arn = aws_iam_policy.codebuild_execution_policy.arn
}

resource "aws_iam_role_policy_attachment" "codebuild-execution-policy-attachment-3" {
  role       = aws_iam_role.codebuild_role_for_frontend.name
  policy_arn = aws_iam_policy.codebuild_execution_policy.arn
}

resource "aws_iam_role_policy_attachment" "codepipeline-policy-attachment" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = aws_iam_policy.codepipeline_policy.arn
}

/* Attach Policies to IAM Group */
resource "aws_iam_group_policy_attachment" "devops_policy_attachment" {
  group      = var.iam_devops_group
  policy_arn = aws_iam_policy.codecommit_devops_policy.arn
}


resource "aws_iam_group_policy_attachment" "dev_policy_attachment" {
  group      = var.iam_devs_group
  policy_arn = aws_iam_policy.codecommit_dev_policy.arn
}

resource "aws_iam_group_policy_attachment" "maintainer_policy_attachment" {
  group      = var.iam_maintainers_group
  policy_arn = aws_iam_policy.codecommit_maintainer_policy.arn
}

resource "aws_iam_group_policy_attachment" "ssm_application_policy_devs_attachment" {
  group      = var.iam_devs_group
  policy_arn = aws_iam_policy.ssm_application_policy.arn
}

resource "aws_iam_group_policy_attachment" "ssm_application_policy_maintainer_attachment" {
  group      = var.iam_maintainers_group
  policy_arn = aws_iam_policy.ssm_application_policy.arn
}
