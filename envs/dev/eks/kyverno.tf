resource "helm_release" "kyverno" {
  name             = kyverno
  repository       = "https://kyverno.github.io/kyverno/"
  chart            = "kyverno"
  version          = "3.8.1"
  namespace        = "kyverno"
  create_namespace = true

  values = [file("${path.module}/values/kyverno-values.yaml")]

  depends_on = [module.eks]
}