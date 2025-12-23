

# Resource Group: Use ID if provided, else create
data "azurerm_resource_group" "imported" {
  count = var.resource_group_id != "" ? 1 : 0
  name  = var.resource_group_name
}

resource "azurerm_resource_group" "this" {
  count    = var.resource_group_id == "" ? 1 : 0
  name     = var.resource_group_name
  location = var.location
}

locals {
  resource_group_id = var.resource_group_id != "" ? var.resource_group_id : (
    length(azurerm_resource_group.this) > 0 ? azurerm_resource_group.this[0].id : data.azurerm_resource_group.imported[0].id
  )
  resource_group_name     = var.resource_group_name
  resource_group_location = var.location
}

# VNet: Use ID if provided, else create
data "azurerm_virtual_network" "imported" {
  for_each            = { for v in var.vnets : v.name => v if v.id != "" }
  name                = each.value.name
  resource_group_name = local.resource_group_name
}

resource "azurerm_virtual_network" "this" {
  for_each            = { for v in var.vnets : v.name => v if v.id == "" }
  name                = each.value.name
  address_space       = each.value.address_space
  location            = local.resource_group_location
  resource_group_name = local.resource_group_name
}

# Subnets: Use ID if provided, else create
data "azurerm_subnet" "imported" {
  for_each             = { for s in var.subnets : s.name => s if s.id != "" }
  name                 = each.value.name
  virtual_network_name = each.value.vnet_name
  resource_group_name  = local.resource_group_name
}

resource "azurerm_subnet" "this" {
  for_each             = { for s in var.subnets : s.name => s if s.id == "" }
  name                 = each.value.name
  resource_group_name  = local.resource_group_name
  virtual_network_name = each.value.vnet_name
  address_prefixes     = each.value.address_prefixes
  service_endpoints    = each.value.service_endpoints
}

locals {
  vnet_ids = merge(
    { for k, v in azurerm_virtual_network.this : k => v.id },
    { for k, v in data.azurerm_virtual_network.imported : k => v.id }
  )
  subnet_ids = merge(
    { for k, v in azurerm_subnet.this : k => v.id },
    { for k, v in data.azurerm_subnet.imported : k => v.id }
  )
}




resource "azurerm_redhat_openshift_cluster" "aro" {
  name                = var.aro_cluster_name
  location            = local.resource_group_location
  resource_group_name = local.resource_group_name

  cluster_profile {
    domain            = var.domain
    resource_group_id = local.resource_group_id
    pull_secret       = var.pull_secret
    version           = var.openshift_version
  }

  dynamic "service_principal" {
    for_each = var.aro_auth_type == "existing" ? [1] : []
    content {
      client_id     = var.client_id
      client_secret = var.client_secret
    }
  }

  network_profile {
    pod_cidr     = var.pod_cidr
    service_cidr = var.service_cidr
  }


  main_profile {
    vm_size   = var.master_vm_size
    subnet_id = local.subnet_ids[var.master_subnet_name]
  }

  worker_profile {
    vm_size      = var.worker_vm_size
    subnet_id    = local.subnet_ids[var.worker_subnet_name]
    node_count   = var.worker_count
    disk_size_gb = var.worker_disk_size_gb
  }

  api_server_profile {
    visibility = var.apiserver_visibility
  }

  ingress_profile {
    visibility = var.ingress_visibility
  }

  tags = var.tags
}
