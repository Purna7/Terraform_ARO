# outputs.tf

output "aro_cluster_name" {
  value = azurerm_redhat_openshift_cluster.aro.name
}

output "aro_api_server" {
  value = azurerm_redhat_openshift_cluster.aro.api_server_profile[0].url
}
