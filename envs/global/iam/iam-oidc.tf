module "iam_iam-oidc-provider" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-oidc-provider"
  version = "6.6.1"

  url = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
}
