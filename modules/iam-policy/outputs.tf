
//CODEBUILD ROLE OUTPUT
output "codebuild_name" {
  value       = aws_iam_role.codebuild_role.name
  description = "The name of the IAM role created"
}

output "codebuild_id" {
  value       = aws_iam_role.codebuild_role.unique_id
  description = "The stable and unique string identifying the role"
}

output "codebuild_arn" {
  value       = aws_iam_role.codebuild_role.arn
  description = "The Amazon Resource Name (ARN) specifying the role"
}
output "codebuild_name_1" {
  value       = aws_iam_role.codebuild_role_for_codeartifact.name
  description = "The name of the IAM role created"
}

output "codebuild_id_1" {
  value       = aws_iam_role.codebuild_role_for_codeartifact.unique_id
  description = "The stable and unique string identifying the role"
}

output "codebuild_arn_1" {
  value       = aws_iam_role.codebuild_role_for_codeartifact.arn
  description = "The Amazon Resource Name (ARN) specifying the role"
}



//CODEPINELINE ROLE OUTPUT

output "codepipeline_name" {
  value       = aws_iam_role.codepipeline_role.name
  description = "The name of the IAM role created"
}

output "codepipeline_id" {
  value       = aws_iam_role.codepipeline_role.unique_id
  description = "The stable and unique string identifying the role"
}

output "codepipeline_arn" {
  value       = aws_iam_role.codepipeline_role.arn
  description = "The Amazon Resource Name (ARN) specifying the role"
}

