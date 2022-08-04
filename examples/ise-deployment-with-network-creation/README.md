# ISE Deployment with ISE Network creation

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan -var-file "azure.tfvars"
$ terraform apply -var-file "azure.tfvars"
```

Note that this example may create resources which cost money. Run `terraform destroy -var-file "azure.tfvars"` when you don't need these resources.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_azure"></a> [azure](#requirement\_azure) | >= 3.11.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azure"></a> [azure](#provider\_azure) | >= 3.11.0 |

