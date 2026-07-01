resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "9.7.0"
  namespace        = "argocd"
  create_namespace = true

  values = [
    templatefile("${path.module}/values/argocd-values.yaml", {
      certificate_arn = module.acm.acm_certificate_arn
      domain          = var.domain
    })
  ]

  depends_on = [ module.eks, module.acm ]
}
