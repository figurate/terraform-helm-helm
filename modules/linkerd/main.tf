resource "tls_private_key" "trust_anchor" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "trust_anchor" {
  allowed_uses = [
    "crl_signing",
    "client_auth",
    "server_auth",
    "cert_signing",
  ]
  key_algorithm         = tls_private_key.trust_anchor.algorithm
  private_key_pem       = tls_private_key.trust_anchor.private_key_pem
  is_ca_certificate     = true
  validity_period_hours = 87600
  subject {
    common_name = "identity.linkerd.cluster.local"
  }
}

resource "tls_private_key" "issuer" {
  algorithm = "RSA"
}

resource "tls_cert_request" "issuer" {
  key_algorithm   = "RSA"
  private_key_pem = tls_private_key.issuer.private_key_pem
  subject {
    common_name = "identity.linkerd.cluster.local"
  }
}

resource "tls_locally_signed_cert" "certificate" {
  allowed_uses = [
    "crl_signing",
    "cert_signing",
    "client_auth",
    "server_auth",
  ]
  ca_cert_pem           = tls_self_signed_cert.trust_anchor.cert_pem
  ca_key_algorithm      = tls_self_signed_cert.trust_anchor.key_algorithm
  ca_private_key_pem    = tls_private_key.trust_anchor.private_key_pem
  cert_request_pem      = tls_cert_request.issuer.cert_request_pem
  validity_period_hours = 8760
  is_ca_certificate     = true
}

module "release" {
  source = "../.."

  name           = var.name
  repository_url = "https://helm.linkerd.io/stable"
  chart          = "linkerd/linkerd2"
  env = {
    "global.identityTrustAnchorsPEM" = tls_self_signed_cert.trust_anchor.cert_pem
    "identity.issuer.crtExpiry"      = tls_locally_signed_cert.certificate.validity_end_time
    "identity.issuer.tls.crtPEM"     = tls_locally_signed_cert.certificate.cert_pem
    "identity.issuer.tls.keyPEM"     = tls_private_key.issuer.private_key_pem
  }
}
