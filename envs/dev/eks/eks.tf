module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = "${var.eks_cluster_name}-eks"
  kubernetes_version = var.eks_version

  vpc_id             = data.terraform_remote_state.vpc.outputs.vpc_id
  subnet_ids         = data.terraform_remote_state.vpc.outputs.private_subnet_ids

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  # Optional
  endpoint_public_access = true

  # EKS Auto Mode
  compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }
}