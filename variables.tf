variable "subscription_id" {
  description = "Azure subscription ID to deploy into."
  type        = string
}

variable "project_name" {
  description = "The name of the project."
  type        = string
  default     = "stewardship"
}

variable "environment" {
  description = "Environment name, e.g. prod."
  type        = string
  default     = "prod"
}

variable "owner" {
  description = "Owner tag value."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
  default     = "southafricanorth"
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key used to log in to the VMs."
  type        = string
  default     = "~/.ssh/azure_vm_key.pub"
}