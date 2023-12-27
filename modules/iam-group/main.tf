resource "aws_iam_group" "devops" {
  name = "DevOps"
  path = "/"
}

resource "aws_iam_group" "devs" {
  name = "Developers"
  path = "/"
}
resource "aws_iam_group" "maintainers" {
  name = "Maintainers"
  path = "/"
}
