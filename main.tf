resource "helm_release" "release" {
  name       = var.name
  repository = var.repository_url
  chart      = var.chart

  dynamic "set" {
    for_each = var.env
    content {
      name  = set.key
      value = set.value
    }
  }

  dynamic "set_sensitive" {
    for_each = var.env_sensitive
    content {
      name  = set_sensitive.key
      value = set_sensitive.value
    }
  }
}
