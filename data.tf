data "aws_eks_cluster" "hacka_cluster" {
  name = "hacka_cluster"
}

data "aws_eks_cluster_auth" "hacka_cluster_auth" {
  name = data.aws_eks_cluster.hacka_cluster.name
}

data "kubernetes_service" "service-ms-upload" {
  metadata {
    name      = "service-ms-upload"
    namespace = "default"
  }
}

data "kubernetes_service" "service-ms-processamento" {
  metadata {
    name      = "service-ms-processamento"
    namespace = "default"
  }
}