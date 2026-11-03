# TRACE workload identities

This configuration creates separate API and worker identities federated to their Kubernetes service accounts. Only the worker receives the Foundry inference role. PostgreSQL Entra roles and database permissions must be configured separately.

Use the existing worker identity backend state and review the Terraform plan before applying. The `api_client_id` and `worker_client_id` outputs configure the corresponding Kubernetes service accounts.
