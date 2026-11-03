# Sokoni Data Lake infrastructure

Terraform infrastructure for a secured Azure Data Lake Storage Gen2 foundation. The
dev and prod environments provision a resource group, VNet with a Storage service
endpoint, private-by-default hierarchical-namespace storage, private containers,
least-privilege Blob Data Contributor assignments, and Log Analytics diagnostics.

## Repository layout

- `infra/bootstrap`: one-time state storage and Key Vault bootstrap; uses local state.
- `infra/environments/dev` and `infra/environments/prod`: independently configured
  environments with AzureRM remote state.
- `infra/modules`: reusable resource-group, networking, storage, IAM, and monitoring
  modules.
- `tests/storage.tftest.hcl`: offline plan test for the storage module.
- `azure-pipelines.yml`: CI validation/plan and approval-gated prod deployment.

## Prerequisites

- Terraform 1.6 or later and Azure CLI.
- An Azure subscription and permission to create resource groups, storage accounts,
  Key Vaults, VNets, role assignments, and Log Analytics workspaces.
- An Azure DevOps Azure Resource Manager service connection using workload identity
  federation (recommended), with sufficient deployment permissions.

Never commit credentials or environment-specific secrets. Authenticate with Azure CLI
locally or the pipeline service connection. Terraform's AzureRM backend should use
Microsoft Entra authentication; do not use storage account keys.

## 1. Bootstrap remote state

Choose globally unique lowercase names for the bootstrap storage account and Key
Vault, then run:

```sh
cd infra/bootstrap
az login
terraform init
terraform fmt -check -recursive
terraform validate
terraform plan \
  -var="subscription_id=$(az account show --query id -o tsv)" \
  -var="state_storage_account_name=<globally-unique-name>" \
  -var="key_vault_name=<globally-unique-name>"
terraform apply \
  -var="subscription_id=$(az account show --query id -o tsv)" \
  -var="state_storage_account_name=<globally-unique-name>" \
  -var="key_vault_name=<globally-unique-name>"
```

The state account is intentionally bootstrapped with local state because it cannot
store its own initial state. Back up `terraform.tfstate` securely after bootstrap;
it contains infrastructure metadata. The created `tfstate` container has no public
access. Configure access to the state account for your deployment runner and grant
the runner `Storage Blob Data Contributor` on the container (plus the required Azure
management-plane deployment roles). For production, use a self-hosted runner with
network access restricted to the state account.

The AzureRM provider uses Microsoft Entra authentication for storage data-plane
operations. Because Terraform creates the storage accounts and their containers in
the same apply, the identity must already inherit `Storage Blob Data Contributor`
from a containing scope (for example, the subscription) to create the containers.
The bootstrap identity needs this for the state container, and the environment
deployment identity needs it for ADLS containers. After bootstrap, narrow ongoing
state access to the state container. If inherited data-plane access is not allowed
by your organization, stage account and container creation separately after an
administrator grants the required data-plane role.

## 2. Configure environment variables and backend

Set `subscription_id`, and optionally `data_reader_principal_ids`, `tags`, or
environment-specific values from the pipeline or a local untracked `.tfvars` file.
Do not put secrets in `.tfvars`.

The environment `backend.tf` intentionally has an empty `azurerm` backend block.
Initialize it with values from the bootstrap outputs; for example:

```sh
cd infra/environments/dev
terraform init \
  -backend-config="resource_group_name=rg-sokoni-tfstate" \
  -backend-config="storage_account_name=<bootstrap-output>" \
  -backend-config="container_name=tfstate" \
  -backend-config="key=dev.terraform.tfstate" \
  -backend-config="use_azuread_auth=true" \
  -backend-config="use_cli=true"
```

Use `key=prod.terraform.tfstate` for prod. Keep state configuration identical across
all runs for a given environment. The backend resource group name above is the
bootstrap default and can be changed through bootstrap variables.

Then validate and inspect a plan before applying:

```sh
terraform fmt -check -recursive
terraform validate
terraform plan -var="subscription_id=$(az account show --query id -o tsv)"
# Review the plan before applying.
terraform apply -var="subscription_id=$(az account show --query id -o tsv)"
```

The storage account allows HTTPS only, TLS 1.2+, disables shared-key access and
anonymous container access, and accepts traffic only from its configured Storage
service-endpoint subnet. Make sure workloads and deployment agents access data from
that subnet or through an explicitly designed private networking solution. This
baseline does not create compute or private DNS.

## Azure DevOps pipeline

Create pipeline variables `AZURE_SERVICE_CONNECTION`,
`TFSTATE_STORAGE_ACCOUNT_NAME`, and `AZURE_SUBSCRIPTION_ID`; mark sensitive values
appropriately. The service connection's identity needs state data-plane access and
the deployment permissions described above. Pull requests run formatting,
validation, and mocked tests. Main-branch runs plan and apply dev, then plan and
apply prod. Configure the `prod` environment in Azure DevOps with approvals/checks
to gate its deployment.

## Tests and checks

```sh
terraform -chdir=infra/environments/dev fmt -check -recursive
terraform -chdir=infra/environments/dev init -backend=false
terraform -chdir=infra/environments/dev validate
terraform -chdir=tests init -backend=false
terraform -chdir=tests test
```

`terraform test` uses mocked providers and does not create Azure resources. Run
`terraform validate` before `terraform plan`; never run `apply -auto-approve` for
unreviewed infrastructure.
