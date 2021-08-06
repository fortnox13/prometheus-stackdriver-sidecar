provider "google" {}

terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.11.3"
    }
    #     kubernetes = {
    #   source = "hashicorp/kubernetes"
    #   version = "2.4.1"
    # }
  }
}

provider "kubectl" {
  # Configuration options
  alias                  = "gke-1"
  host                   = "https://35.235.87.26"
  cluster_ca_certificate = base64decode("./gke.cert")
  token                  = data.google_client_config.default.access_token
}
# provider "kubernetes" {
#   # Configuration options
#     alias                  = "gke-1"
#   host                   = "https://35.235.87.26"
#   cluster_ca_certificate = base64decode("./gke.cert")
#   token                  = data.google_client_config.default.access_token
# }
provider "helm" {
  alias = "gke-1"
  kubernetes {
    host                   = "https://35.235.87.26"
  cluster_ca_certificate = base64decode("./gke.cert")
  token                  = data.google_client_config.default.access_token
  config_path = "~/.kube/config"
  }
}