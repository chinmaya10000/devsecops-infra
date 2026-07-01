data "aws_caller_identity" "current" {}

resource "helm_release" "external_secrets" {
  name       = "external-secrets"
  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets"
  version    = "2.7.0"
  namespace  = "external-secrets"
  create_namespace = true

  depends_on = [ module.eks ]
}

# eso-irsa.tf mein custom policy add karo
resource "aws_iam_policy" "eso" {
  name = "jerney-eso-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:ListSecrets",
          "secretsmanager:BatchGetSecretValue"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetResourcePolicy",
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "secretsmanager:ListSecretVersionIds"
        ]
        # Sirf jerney/* secrets access — scoped! ✅
        Resource = "arn:aws:secretsmanager:${var.region}:${data.aws_caller_identity.current.account_id}:secret:jerney/*"
      }
    ]
  })
}

module "eso_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name = "jerney-eso-role"

  # Custom policy use karo — not attach_external_secrets_policy
  role_policy_arns = {
    eso = aws_iam_policy.eso.arn
  }

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["external-secrets:external-secrets"]
    }
  }

  tags = {
    ManagedBy = "terraform"
  }
}
