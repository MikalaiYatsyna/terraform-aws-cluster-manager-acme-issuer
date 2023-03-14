resource "kubernetes_manifest" "acme_issuer" {
  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "ClusterIssuer"
    "metadata" = {
      "name" = "${var.stack}-acme-issuer"
    }
    "spec" = {
      "acme" = {
        "email"  = var.email
        "server" = "https://acme-staging-v02.api.letsencrypt.org/directory"
        "privateKeySecretRef" = {
          "name" = "letsencrypt-${var.stack}"
        }
        "solvers" = [
          {
            "dns01" = {
              "route53" = {
                "region" : data.aws_region.current.name
                "hostedZoneID" = data.aws_route53_zone.zone.id
              }
            }
          }
        ]
      }
    }
  }
}

