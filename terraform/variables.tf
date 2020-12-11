variable "project" {
  default = "silken-network-252121"
}

variable "region" {
  default = "us-central1"
}

variable "cluster_name" {
  default = "rlt-test-k8s"
}

variable "initial_node_count" {
  default = 2
}

variable "autoscaling_min_node_count" {
  default = 1
}

variable "autoscaling_max_node_count" {
  default = 2
}

variable "disk_size_gb" {
  default = 50
}

variable "disk_type" {
  default = "pd-standard"
}

variable "machine_type" {
  default = "n1-standard-2"
}
