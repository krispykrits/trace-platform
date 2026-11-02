# TRACE AKS workloads

The API is internal to the cluster; the worker uses Entra Workload Identity. Before applying these workloads, replace `trace-runtime` with the reviewed ACR image digest and the service-account client ID placeholder with the Terraform output. Use namespace `trace` when creating the prerequisites below.

Create a `trace-runtime` Secret containing `TRACE_POSTGRES_DSN` (TLS `verify-full`), `TRACE_ENTRA_TENANT_ID`, `TRACE_ENTRA_API_CLIENT_ID`, and `TRACE_ENTRA_DELEGATED_SCOPE`. Provision a read-only `trace-source` volume containing the authorized `profile.json`, its referenced source and knowledge files, and `azure.env` with the model's Entra settings. The profile must be owned by UID 10001 with mode 0600. The volume must be usable by both deployments. These resources and source permissions are not created by this manifest.

Review the rendered output with `kubectl kustomize kubernetes/trace` before applying. Deploy the same reviewed image digest to both components; `kubectl rollout undo deployment/trace-api -n trace` or `kubectl rollout undo deployment/trace-worker -n trace` restores a previous deployment revision.
