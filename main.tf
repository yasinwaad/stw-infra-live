module "resource_group" {
  source = "git::https://github.com/yasinwaad/terraform-azure-resourcegroup.git?ref=v1.0.0"

  project_name = var.project_name
  environment  = var.environment
  owner        = var.owner
  location     = var.location
}

module "vnet" {
  source = "git::https://github.com/yasinwaad/stw-tf-vnet.git?ref=v1.0.0"

  project_name        = var.project_name
  environment         = var.environment
  owner               = var.owner
  location            = var.location
  resource_group_name = module.resource_group.resource_group_name
}

module "subnets_nsg" {
  source = "git::https://github.com/yasinwaad/stw-tf-subnets-nsg.git?ref=v1.0.0"

  project_name        = var.project_name
  environment         = var.environment
  owner               = var.owner
  location            = var.location
  resource_group_name = module.resource_group.resource_group_name
  vnet_name           = module.vnet.vnet_name

  nsg_rules = {
    allow-ssh-from-bastion = {
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "10.0.2.0/26"
      destination_address_prefix = "*"
    }
  }
}

module "public_ip" {
  source = "git::https://github.com/yasinwaad/stw-tf-public-ip.git?ref=v1.0.0"

  project_name        = var.project_name
  environment         = var.environment
  owner               = var.owner
  location            = var.location
  resource_group_name = module.resource_group.resource_group_name

  public_ips = {
    bastion = {}
    nat     = {}
  }
}

module "bastion" {
  source = "git::https://github.com/yasinwaad/stw-tf-bastion.git?ref=v1.0.0"

  project_name        = var.project_name
  environment         = var.environment
  owner               = var.owner
  location            = var.location
  resource_group_name = module.resource_group.resource_group_name
  vnet_name           = module.vnet.vnet_name
  public_ip_id        = module.public_ip.public_ip_ids["bastion"]

  depends_on = [module.subnets_nsg]
}

module "nat_gateway" {
  source = "git::https://github.com/yasinwaad/stw-tf-nat-gateway.git?ref=v1.0.0"

  project_name        = var.project_name
  environment         = var.environment
  owner               = var.owner
  location            = var.location
  resource_group_name = module.resource_group.resource_group_name
  public_ip_id        = module.public_ip.public_ip_ids["nat"]
  subnet_id           = module.subnets_nsg.subnet_id
}

module "storage" {
  source = "git::https://github.com/yasinwaad/stw-tf-storage.git?ref=v1.0.0"

  project_name        = var.project_name
  environment         = var.environment
  owner               = var.owner
  location            = var.location
  resource_group_name = module.resource_group.resource_group_name

  storage_accounts = {
    syslog = {
      containers = ["syslog"]
    }
  }
}

module "vm_nic" {
  source = "git::https://github.com/yasinwaad/stw-tf-vm-nic.git?ref=v1.0.0"

  project_name        = var.project_name
  environment         = var.environment
  owner               = var.owner
  location            = var.location
  resource_group_name = module.resource_group.resource_group_name
  subnet_id           = module.subnets_nsg.subnet_id
  ssh_public_key      = file(var.ssh_public_key_path)

  vms = {
    linux = {}
  }
}

module "data_disks" {
  source = "git::https://github.com/yasinwaad/stw-tf-data-disks.git?ref=v1.0.0"

  project_name        = var.project_name
  environment         = var.environment
  owner               = var.owner
  location            = var.location
  resource_group_name = module.resource_group.resource_group_name
  virtual_machine_ids = module.vm_nic.vm_ids

  data_disks = {
    data1 = {
      vm_key = "linux"
      lun    = 10
    }
    data2 = {
      vm_key = "linux"
      lun    = 20
    }
  }
}

module "monitoring" {
  source = "git::https://github.com/yasinwaad/stw-tf-monitoring.git?ref=v1.0.0"

  project_name        = var.project_name
  environment         = var.environment
  owner               = var.owner
  location            = var.location
  resource_group_name = module.resource_group.resource_group_name
  storage_account_id  = module.storage.storage_account_ids["syslog"]
  virtual_machine_ids = module.vm_nic.vm_ids
}