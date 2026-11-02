# TRACE AKS workloads

The API is internal to the cluster; the worker uses Entra Workload Identity. Before applying these workloads, replace `trace-runtime` with the reviewed ACR image digest and the service-account client ID placeholder with the Terraform output. Use namespace `trace` when creating the prerequisites below.

Create a `trace-runtime` Secret containing `TRACE_POSTGRES_DSN` (TLS `verify-full`), `TRACE_ENTRA_TENANT_ID`, `TRACE_ENTRA_API_CLIENT_ID`, and `TRACE_ENTRA_DELEGATED_SCOPE`. Provision a read-only `trace-source` volume containing the authorized `profile.json`, its referenced source and knowledge files, and `azure.env` with the model's Entra settings. The profile must be owned by UID 10001 with mode 0600. The volume must be usable by both deployments. These resources and source permissions are not created by this manifest.

Review the rendered output with `kubectl kustomize kubernetes/trace` before applying. Deploy the same reviewed image digest to both components; `kubectl rollout undo deployment/trace-api -n trace` or `kubectl rollout undo deployment/trace-worker -n trace` restores a previous deployment revision.

The manual `Deploy TRACE` workflow promotes a supplied immutable ACR digest after the GitHub `development` environment is configured with `AZURE_DEPLOY_CLIENT_ID`, `AZURE_TENANT_ID`, `AZURE_SUBSCRIPTION_ID`, `AKS_RESOURCE_GROUP`, `AKS_NAME`, and `TRACE_WORKER_CLIENT_ID`. Its separate deployment identity needs federated GitHub authentication and Kubernetes deployment permissions. It checks for the runtime Secret and source volume before applying.

For development, `scripts/aks.sh start`, `stop`, or `status` operates the cluster specified by `AZURE_SUBSCRIPTION_ID`, `AKS_RESOURCE_GROUP`, and `AKS_NAME`. Starting the cluster incurs compute charges.
