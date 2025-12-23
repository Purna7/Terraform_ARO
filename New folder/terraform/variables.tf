# Use this variable to import an existing resource group by ID, or leave blank to create a new one
variable "resource_group_id" {
  description = "ID of existing resource group to import. Leave blank to create a new resource group."
  type        = string
  default     = ""
}

# List of VNets to create or import. Each object should have at least a name, and either an id (to import) or address_space (to create)
variable "vnets" {
  description = "List of VNets to create or import. Each object must have a name, and either an id (to import) or address_space (to create)."
  type = list(object({
    name          = string
    id            = optional(string, "")
    address_space = optional(list(string), [])
  }))
  default = []
}

# List of subnets to create or import. Each object should have at least a name, vnet_name, and either an id (to import) or address_prefixes (to create)
variable "subnets" {
  description = "List of subnets to create or import. Each object must have a name, vnet_name, and either an id (to import) or address_prefixes (to create)."
  type = list(object({
    name              = string
    vnet_name         = string
    id                = optional(string, "")
    address_prefixes  = optional(list(string), [])
    service_endpoints = optional(list(string), [])
  }))
  default = []
}

# Environment
variable "env" {
  description = "Deployment environment (prod, stage, qa, dev)"
  type        = string
}

# Resource Group
variable "existing_resource_group_name" {
  description = "Name of existing resource group (if using existing)"
  type        = string
  default     = ""
}
variable "existing_resource_group_id" {
  description = "ID of existing resource group (optional, for cluster_profile)"
  type        = string
  default     = ""
}
variable "resource_group_name" {
  description = "Name for new resource group (if creating)"
  type        = string
  default     = ""
}
variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
}

# VNet
variable "existing_vnet_name" {
  description = "Name of existing VNet (if using existing)"
  type        = string
  default     = ""
}
variable "vnet_name" {
  description = "Name for new VNet (if creating)"
  type        = string
  default     = ""
}
variable "vnet_address_space" {
  description = "Address space for new VNet (if creating)"
  type        = list(string)
  default     = ["10.0.0.0/22"]
}

# Subnets
variable "existing_master_subnet_name" {
  description = "Name of existing master subnet (if using existing)"
  type        = string
  default     = ""
}
variable "master_subnet_name" {
  description = "Name for new master subnet (if creating)"
  type        = string
  default     = ""
}
variable "master_subnet_address_prefixes" {
  description = "Address prefixes for new master subnet"
  type        = list(string)
  default     = ["10.0.0.0/23"]
}
variable "existing_worker_subnet_name" {
  description = "Name of existing worker subnet (if using existing)"
  type        = string
  default     = ""
}
variable "worker_subnet_name" {
  description = "Name for new worker subnet (if creating)"
  type        = string
  default     = ""
}
variable "worker_subnet_address_prefixes" {
  description = "Address prefixes for new worker subnet"
  type        = list(string)
  default     = ["10.0.2.0/23"]
}

# ARO Cluster
variable "aro_cluster_name" {
  description = "ARO cluster name"
  type        = string
}
variable "domain" {
  description = "Cluster domain name"
  type        = string
}
variable "pull_secret" {
  description = "OpenShift pull secret"
  type        = string
  sensitive   = true
}
variable "openshift_version" {
  description = "ARO OpenShift version"
  type        = string
  default     = "4.15.18"
}
variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

# Authentication
variable "aro_auth_type" {
  description = "ARO authentication type: 'existing' or 'new' service principal"
  type        = string
  default     = "existing"
}
variable "client_id" {
  description = "Azure Service Principal Client ID (if using existing)"
  type        = string

}
variable "client_secret" {
  description = "Azure Service Principal Client Secret (if using existing)"
  type        = string
  sensitive   = true

}

# Networking
variable "pod_cidr" {
  description = "Pod CIDR for ARO cluster"
  type        = string
  default     = "10.128.0.0/14"
}
variable "service_cidr" {
  description = "Service CIDR for ARO cluster"
  type        = string
  default     = "172.30.0.0/16"
}

# Master/Worker Profiles
variable "master_vm_size" {
  description = "VM size for master nodes"
  type        = string
  default     = "Standard_D8s_v3"
}
variable "master_count" {
  description = "Number of master nodes"
  type        = number
  default     = 3
}
variable "master_disk_size_gb" {
  description = "Disk size (GB) for master nodes"
  type        = number
  default     = 128
}
variable "worker_vm_size" {
  description = "VM size for worker nodes"
  type        = string
  default     = "Standard_D4s_v3"
}
variable "worker_count" {
  description = "Number of worker nodes"
  type        = number
  default     = 3
}
variable "worker_disk_size_gb" {
  description = "Disk size (GB) for worker nodes"
  type        = number
  default     = 128
}

# API/Ingress
variable "apiserver_visibility" {
  description = "API server visibility (Public/Private)"
  type        = string
  default     = "Private"
}
variable "ingress_visibility" {
  description = "Ingress visibility (Public/Private)"
  type        = string
  default     = "Private"
}

# Tags
variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
