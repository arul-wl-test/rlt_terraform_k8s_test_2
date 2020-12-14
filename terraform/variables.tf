variable "project" {
  type = string
  description = "GCP Project"
}

variable "region" {
  type = string
  description = "GCP Region"
}

variable "cluster_name" {
  type = string
  description = "GKE cluster name"
}

variable "initial_node_count" {
  type        = number
  description = "Initial Node Count"
}

variable "autoscaling_min_node_count" {
  type        = number
  description = "Autoscaling Min Node Count"
}

variable "autoscaling_max_node_count" {
  type        = number
  description = "Autoscaling Max Node Count"
}

variable "disk_size_gb" {
  type        = number
  description = "Disk size in GB"
}

variable "disk_type" {
  type        = string
  description = "Disk type"
}

variable "machine_type" {
  type        = string
  description = "Machine type"
}

variable "name_prefix" {
  description = "A name prefix used in resource names to ensure uniqueness across a project."
  type        = string
}

variable "cidr_block" {
  description = "The IP address range of the VPC in CIDR notation. A prefix of /16 is recommended. Do not use a prefix higher than /27."
  type        = string
}

variable "cidr_subnetwork_width_delta" {
  description = "The difference between your network and subnetwork netmask; an /16 network and a /20 subnetwork would be 4."
  type        = number
}

variable "cidr_subnetwork_spacing" {
  description = "How many subnetwork-mask sized spaces to leave between each subnetwork type."
  type        = number
}

variable "secondary_cidr_block" {
  description = "The IP address range of the VPC's secondary address range in CIDR notation. A prefix of /16 is recommended. Do not use a prefix higher than /27."
  type        = string
}

variable "secondary_cidr_subnetwork_width_delta" {
  description = "The difference between your network and subnetwork's secondary range netmask; an /16 network and a /20 subnetwork would be 4."
  type        = number
}

variable "secondary_cidr_subnetwork_spacing" {
  description = "How many subnetwork-mask sized spaces to leave between each subnetwork type's secondary ranges."
  type        = number
}

variable "log_config" {
  description = "The logging options for the subnetwork flow logs. Setting this value to `null` will disable them. See https://www.terraform.io/docs/providers/google/r/compute_subnetwork.html for more information and examples."
  type = object({
    aggregation_interval = string
    flow_sampling        = number
    metadata             = string
  })
}

variable "allowed_public_restricted_subnetworks" {
  description = "The public networks that is allowed access to the public_restricted subnetwork of the network"
  type        = list(string)
}

variable "location" {
  type        = string
  description = "Cluster Location"
}

variable "master_authorized_networks_config" {
  type = list
  description = "Master Authorized Networks Config"
}

variable "enable_private_nodes" {
  type = string
  description = "Flag to enable private nodes"
}

variable "disable_public_endpoint" {
  type = string
  description = "Flag to disable public endpoint"
}

variable "enable_vertical_pod_autoscaling" {
  type = string
  description = "Flag to Enable Vertical Pod Autoscaling"
}

variable "resource_labels" {
  description = "The GCE resource labels (a map of key/value pairs) to be applied to the cluster."
  type        = map
}

variable "cluster_service_account_name" {
  description = "The name of the custom service account used for the GKE cluster. This parameter is limited to a maximum of 28 characters."
  type        = string
}

variable "cluster_service_account_description" {
  description = "A description of the custom service account used for the GKE cluster."
  type        = string
  default     = "Test GKE Cluster Service Account managed by Terraform"
}

variable "master_ipv4_cidr_block" {
  description = "The IP range in CIDR notation (size must be /28) to use for the hosted master network. This range will be used for assigning internal IP addresses to the master or set of masters, as well as the ILB VIP. This range must not overlap with any other ranges in use within the cluster's network."
  type        = string
}

variable "dev_namespace_name" {
  type = string
  description = "Dev Namespace Name"
}

variable "prod_namespace_name" {
  type = string
  description = "Prod Namespace Name"
}