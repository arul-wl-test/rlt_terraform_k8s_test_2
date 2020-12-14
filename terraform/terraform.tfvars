project = "silken-network-252121"
region = "us-central1"
cluster_name = "rlt-test-k8s"
initial_node_count = 2
autoscaling_min_node_count = 1
autoscaling_max_node_count = 2
disk_size_gb = 50
disk_type = "pd-standard"
machine_type = "n1-standard-2"
name_prefix = "rlt-test"
cidr_block = "10.0.0.0/16"
cidr_subnetwork_width_delta = 4
cidr_subnetwork_spacing = 0
secondary_cidr_block = "10.1.0.0/16"
secondary_cidr_subnetwork_width_delta = 4
secondary_cidr_subnetwork_spacing = 0
log_config = {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
allowed_public_restricted_subnetworks = []
location = "us-central1"
master_authorized_networks_config = [
    {
      cidr_blocks = [
        {
          cidr_block   = "0.0.0.0/0"
          display_name = "all-for-testing"
        },
      ]
    },
  ]
enable_private_nodes = "true"
disable_public_endpoint = "false"
enable_vertical_pod_autoscaling = "true"
resource_labels = {
    environment = "testing"
  }
cluster_service_account_name = "test-private-cluster-sa"
master_ipv4_cidr_block = "10.5.0.0/28"
dev_namespace_name = "dev"
prod_namespace_name = "prod"
