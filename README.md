# stw-infra-live

Live environment for Stewardship. Composes all modules, each pinned to `v1.0.0`, and passes outputs between them.

## Modules

- Resource Group
- VNet
- Subnets + NSG
- Public IP
- Bastion
- NAT Gateway
- Storage Account
- VM + NIC
- Data Disks
- Monitoring (DCR)

## Usage

Generate a `terraform.tfvars` file (not committed) with:

```hcl
subscription_id = "<your subscription id>"
owner           = "<owner name>"
```

Then run:

```bash
terraform init
terraform plan
terraform apply
```