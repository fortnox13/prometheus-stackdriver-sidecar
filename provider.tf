provider "google" {}

terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.11.3"
    }
  }
}

provider "kubectl" {
  # Configuration options
  alias                  = "gke-1"
  host                   = "https://34.134.252.150"
  cluster_ca_certificate = base64decode("./gke.cert")
  token                  = data.google_client_config.default.access_token
}

