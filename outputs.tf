output "resource_group_name" {
  description = "Name of the resource group."
  value       = module.resource_group.resource_group_name
}

output "vnet_id" {
  description = "ID of the virtual network."
  value       = module.vnet.vnet_id
}

output "vm_ids" {
  description = "Map of VM IDs."
  value       = module.vm_nic.vm_ids
}

output "storage_account_names" {
  description = "Map of storage account names."
  value       = module.storage.storage_account_names
}

output "dcr_id" {
  description = "ID of the Data Collection Rule."
  value       = module.monitoring.dcr_id
}