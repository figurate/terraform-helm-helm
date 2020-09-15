module "release" {
  source = "../.."

  name           = var.name
  repository_url = "https://open-policy-agent.github.io/gatekeeper/charts"
  chart          = "gatekeeper/gatekeeper"
}
