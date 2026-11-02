# TRACE image publisher identity

A dedicated GitHub Actions identity pushes TRACE images to the selected ACR. It is federated only to the `development` environment in `krispykrits/TRACE`, and has `AcrPush` and `Reader` only on the selected registry. It does not grant AKS deployment or Foundry inference access.

Use the existing Terraform Blob backend with a separate state key. Supply the existing resource group, location, and registry resource ID, then review a saved plan before applying it. Configure the publishing workflow's client ID from the Terraform output.
