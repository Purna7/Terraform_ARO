


# dev.auto.tfvars for simplified, multi-resource pattern

# Leave blank to create a new resource group, or provide an existing resource group ID to import
resource_group_id   = ""
resource_group_name = "dev-aro-rg"
location            = "eastus"

# VNets: List of objects. Provide id to import, or name/address_space to create
vnets = [
  {
    name          = "dev-aro-vnet"
    id            = ""              # Leave blank to create, or provide existing VNet ID to import
    address_space = ["10.0.0.0/22"] # Required if creating
  }
]

# Subnets: List of objects. Provide id to import, or name/vnet_name/address_prefixes to create
subnets = [
  {
    name              = "dev-aro-master-subnet"
    vnet_name         = "dev-aro-vnet"
    id                = ""              # Leave blank to create, or provide existing Subnet ID to import
    address_prefixes  = ["10.0.0.0/23"] # Required if creating
    service_endpoints = ["Microsoft.ContainerRegistry"]
  },
  {
    name              = "dev-aro-worker-subnet"
    vnet_name         = "dev-aro-vnet"
    id                = ""
    address_prefixes  = ["10.0.2.0/23"]
    service_endpoints = ["Microsoft.ContainerRegistry"]
  }
]

# ARO Cluster
aro_cluster_name  = "dev-aro-cluster"
domain            = "dev.example.com"
pull_secret       = "<your-pull-secret>"
openshift_version = "4.15.18"
subscription_id   = "<your-subscription-id>"

# Authentication
aro_auth_type = "existing" # "existing" or "new"
client_id     = "0ec0ad90-d8d8-43c1-9a05-d5c2352aae44"
client_secret = "5XE8Q~rFpjB0mzfXB-ukhaiUmDTf73FRHL_UVa3I"

# Networking
pod_cidr     = "10.128.0.0/14"
service_cidr = "172.30.0.0/16"

# Master/Worker Profiles
master_vm_size      = "Standard_D8s_v3"
master_count        = 3
master_disk_size_gb = 128
master_subnet_name  = "dev-aro-master-subnet"
worker_vm_size      = "Standard_D4s_v3"
worker_count        = 3
worker_disk_size_gb = 128
worker_subnet_name  = "dev-aro-worker-subnet"

# API/Ingress
apiserver_visibility = "Public"
ingress_visibility   = "Public"

# Tags
tags = {
  environment = "dev"
}
