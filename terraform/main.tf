#
# Google Cloud Platform
#
provider "google" {
  project = var.project
  region  = var.region
  credentials = file("/home/arulkr1967/terraform_sa.json")
}

terraform {
  backend "gcs"{
    bucket      = "rlt-test-tfstate"
    prefix      = "terraformstate"
    credentials = "/home/arulkr1967/terraform_sa.json"
  }
}


module vpc-network {
  source = "./modules/vpc"

  name_prefix = var.name_prefix
  project     = var.project
  region      = var.region
  cidr_block  = var.cidr_block
  cidr_subnetwork_width_delta = var.cidr_subnetwork_width_delta
  cidr_subnetwork_spacing = var.cidr_subnetwork_spacing
  secondary_cidr_block = var.secondary_cidr_block
  secondary_cidr_subnetwork_width_delta = var.secondary_cidr_subnetwork_width_delta
  secondary_cidr_subnetwork_spacing = var.secondary_cidr_subnetwork_spacing
  log_config = var.log_config
  allowed_public_restricted_subnetworks = var.allowed_public_restricted_subnetworks
}

module gke-cluster {
  source = "./modules/gke-cluster"
  project     = var.project
  region      = var.region
  cluster_name = var.cluster_name
  network = module.vpc-network.network
  subnetwork = module.vpc-network.public_subnetwork
  master_ipv4_cidr_block = var.master_ipv4_cidr_block
  enable_private_nodes = var.enable_private_nodes
  disable_public_endpoint = var.disable_public_endpoint
  master_authorized_networks_config = var.master_authorized_networks_config
  cluster_secondary_range_name = module.vpc-network.public_subnetwork_secondary_range_name
  enable_vertical_pod_autoscaling = var.enable_vertical_pod_autoscaling
  resource_labels = var.resource_labels
  initial_node_count = var.initial_node_count
  autoscaling_min_node_count = var.autoscaling_min_node_count
  autoscaling_max_node_count = var.autoscaling_max_node_count
  disk_size_gb = var.disk_size_gb
  disk_type = var.disk_type
  machine_type = var.machine_type  
  location = var.location
  name_prefix = var.name_prefix
}

module "gke-service-account" {
  
  source = "./modules/gke-service-account"

  name        = var.cluster_service_account_name
  project     = var.project
  description = var.cluster_service_account_description
}


# ---------------------------------------------------------------------------------------------------------------------
# CREATE A NODE POOL
# ---------------------------------------------------------------------------------------------------------------------

resource "google_container_node_pool" "node_pool" {
  provider = google-beta

  name     = "private-pool"
  project  = var.project
  location = var.location
  cluster  = module.gke-cluster.name

  initial_node_count = "1"

  autoscaling {
    min_node_count = "1"
    max_node_count = "5"
  }

  management {
    auto_repair  = "true"
    auto_upgrade = "true"
  }

  node_config {
    image_type   = "COS"
    machine_type = "n1-standard-1"

    labels = {
      private-pools-example = "true"
    }
    
    tags = [
      module.vpc-network.private,
      "private-pool-example",
    ]

    disk_size_gb = "30"
    disk_type    = "pd-standard"
    preemptible  = false

    service_account = module.gke-service-account.email

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  lifecycle {
    ignore_changes = [initial_node_count]
  }

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}