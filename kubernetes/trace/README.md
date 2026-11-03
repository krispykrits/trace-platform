# TRACE AKS workloads

The API and worker use separate Entra workload identities and the same reviewed image digest. Both connect to PostgreSQL with Entra tokens and verified TLS. Evidence, source grants, and knowledge are stored in PostgreSQL; no source PVC is required.

Create the `trace-runtime` Secret with `API_POSTGRES_DSN` and `WORKER_POSTGRES_DSN` (host, database, matching managed-identity username, `sslmode=verify-full`, and a trusted root), `TRACE_SOURCE_ID`, `TRACE_ENTRA_TENANT_ID`, `TRACE_ENTRA_API_CLIENT_ID`, `TRACE_ENTRA_DELEGATED_SCOPE`, and the worker's `AZURE_OPENAI_*` model settings. Do not include database passwords. Configure the PostgreSQL identities and least-privilege database grants separately.

The manual deployment workflow requires the GitHub `development` environment and `AZURE_DEPLOY_CLIENT_ID`, `AZURE_TENANT_ID`, `AZURE_SUBSCRIPTION_ID`, `AKS_RESOURCE_GROUP`, `AKS_NAME`, `TRACE_API_CLIENT_ID`, and `TRACE_WORKER_CLIENT_ID` variables. It deploys a reviewed image digest to the internal API and worker.
