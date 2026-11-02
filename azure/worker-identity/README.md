# TRACE worker identity

This Terraform configuration creates a user-assigned identity, federates it to the `trace/trace-worker` Kubernetes service account, and grants it `Cognitive Services OpenAI User` on the selected Foundry resource. It does not change the cluster or start the worker.

Use the existing Azure Blob backend with a separate state key. Set the four input variables to the resource group, location, AKS OIDC issuer, and Foundry resource ID, then run `terraform init`, `terraform validate`, and `terraform plan`. Review the exact plan before applying it. The `worker_client_id` output supplies the Kubernetes service-account annotation.
