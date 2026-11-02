# Existing resource adoption

These import declarations target the existing AKS cluster, PostgreSQL server, Foundry account, and Log Analytics workspace. They do not create replacement resources. Use `terraform plan -generate-config-out=generated.tf` with the existing resource IDs to generate candidate configuration; review every generated setting and remove sensitive values before committing it. The initial adoption plan must show imports only, with no changes, replacement, or deletion, before applying.

Use a separate state key in the existing Azure Blob backend. Do not adopt the backend storage account into a state that depends on itself, or import AKS-managed node-group resources separately.
