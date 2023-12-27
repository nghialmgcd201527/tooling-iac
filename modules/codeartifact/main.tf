
data "aws_iam_policy_document" "repo_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::847042182429:root", "arn:aws:iam::748485313542:root"]
    }

    actions   = ["codeartifact:GetRepositoryEndpoint", "codeartifact:ReadFromRepository", "codeartifact:GetAuthorizationToken", "sts:GetServiceBearerToken", "codeartifact:DescribePackageVersion", "codeartifact:DescribeRepository", "codeartifact:GetPackageVersionReadme", "codeartifact:GetRepositoryEndpoint", "codeartifact:ListPackageVersionAssets", "codeartifact:ListPackageVersionDependencies", "codeartifact:ListPackageVersions", "codeartifact:ListPackages"]
    resources = ["arn:aws:codeartifact:*:847042182429:repository/puravida/*"]
  }
}

data "aws_iam_policy_document" "domain_policy" {
  statement {
    effect = "Allow"

    # principals {
    #   type = "*"
    #   # identifiers = ["arn:aws:iam::847042182429:root", "arn:aws:iam::748485313542:root"]
    # }

    principals {
      type        = "*"
      identifiers = ["*"]
    }
    condition {
      test     = "StringEquals"
      values   = ["o-kpzfn73s3a"]
      variable = "aws:PrincipalOrgID"
    }

    actions   = ["codeartifact:GetAuthorizationToken", "sts:GetServiceBearerToken", "codeartifact:ListRepositoriesInDomain", "codeartifact:GetDomainPermissionsPolicy", "codeartifact:DescribeDomain"]
    resources = ["*"]
  }
}

resource "aws_codeartifact_domain" "codeartifact_domain" {
  domain = var.project_name
}
resource "aws_codeartifact_domain_permissions_policy" "domain_policy" {
  domain          = aws_codeartifact_domain.codeartifact_domain.domain
  policy_document = data.aws_iam_policy_document.domain_policy.json
}

resource "aws_codeartifact_repository" "codeartifact_repo" {
  repository = var.project_name
  domain     = aws_codeartifact_domain.codeartifact_domain.domain
}
resource "aws_codeartifact_repository_permissions_policy" "repo_policy" {
  repository      = aws_codeartifact_repository.codeartifact_repo.repository
  domain          = aws_codeartifact_domain.codeartifact_domain.domain
  policy_document = data.aws_iam_policy_document.repo_policy.json
}
