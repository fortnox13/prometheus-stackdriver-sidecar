data "kubectl_path_documents" "manifests-account" {
  pattern = "./manifests/1-*.yaml"
}

resource "kubectl_manifest" "test" {
#   providers = {
#     kubectl = kubectl.gke-1
#   }

  count     = length(data.kubectl_path_documents.manifests-account.documents)
  yaml_body = element(data.kubectl_path_documents.manifests-account.documents, count.index)
}

data "kubectl_path_documents" "prometheus" {
  pattern = "./manifests/2-gke-prometheus-deployment.yaml"
  vars = {
    KUBE_NAMESPACE     = "prometheus"
    KUBE_CLUSTER       = "gke"
    GCP_LOCATION       = "us-central1-c"
    GCP_PROJECT        = "tttttttttttttttttttttttttttttt"
    DATA_DIR           = "/prometheus"
    DATA_VOLUME        = "prometheus-storage-volume"
    SIDECAR_IMAGE_TAG  = "0.8.2"
    PROMETHEUS_VER_TAG = "v2.19.3"
  }
}


resource "kubectl_manifest" "prometheus" {
#   providers = {
#     kubernetes = kubernetes.gke-1
#   }
  yaml_body = element(data.kubectl_path_documents.prometheus.documents, 1)
}