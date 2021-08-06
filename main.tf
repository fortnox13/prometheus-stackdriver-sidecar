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
    KUBE_CLUSTER       = "cluster-2"
    GCP_LOCATION       = "us-west2-a"
    GCP_PROJECT        = "test-last-one"
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


resource "helm_release" "node-exporter" {
  name             = "node-exporter"
  repository       = "prometheus-community.github.io/helm-charts"
  chart            = "prometheus-community/prometheus-node-exporter"
  create_namespace = false
  namespace        = "prometheus"

  values = [
#     # The file with all values that should override the default values for the chart:
#     "${file("manifests/pingfederate.yaml")}"
  ]
}