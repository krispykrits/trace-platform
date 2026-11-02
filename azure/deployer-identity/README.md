# TRACE deployment identity

This Terraform configuration creates a separate GitHub Actions identity for the `development` environment of `krispykrits/trace-platform`. It can obtain AKS user credentials and deploy within the `trace` namespace. It does not grant ACR push access or Foundry inference access.

Use the existing Azure Blob backend with a separate state key. Set the resource group, location, and AKS resource ID, then run `terraform init`, `terraform validate`, and `terraform plan`. Review the exact plan before applying. Set the deployment workflow's `AZURE_DEPLOY_CLIENT_ID` variable to the `deployer_client_id` output.
