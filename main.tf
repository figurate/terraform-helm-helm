resource "helm_release" "release" {
  name       = var.name
  repository = var.repository_url
  chart      = var.chart

  dynamic "set" {
    for_each = var.config
    content {
      name  = set.key
      value = set.value
    }
  }
}
