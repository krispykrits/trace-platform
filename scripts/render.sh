#!/usr/bin/env bash
set -euo pipefail

: "${TRACE_IMAGE:?Set TRACE_IMAGE to an ACR image digest}"
: "${TRACE_WORKER_CLIENT_ID:?Set TRACE_WORKER_CLIENT_ID}"
: "${TRACE_API_CLIENT_ID:?Set TRACE_API_CLIENT_ID}"
[[ "$TRACE_IMAGE" =~ ^[a-z0-9-]+\.azurecr\.io/[a-z0-9._/-]+@sha256:[a-f0-9]{64}$ ]] || { echo 'Invalid ACR image digest.' >&2; exit 2; }
[[ "$TRACE_WORKER_CLIENT_ID" =~ ^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$ ]] || { echo 'Invalid worker identity client ID.' >&2; exit 2; }
[[ "$TRACE_API_CLIENT_ID" =~ ^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$ ]] || { echo 'Invalid API identity client ID.' >&2; exit 2; }

root=$(cd "$(dirname "$0")/.." && pwd)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
cp "$root/kubernetes/trace/"*.yaml "$tmp/"
sed -i "s/REPLACE_WITH_WORKER_IDENTITY_CLIENT_ID/$TRACE_WORKER_CLIENT_ID/; s/REPLACE_WITH_API_IDENTITY_CLIENT_ID/$TRACE_API_CLIENT_ID/" "$tmp/workloads.yaml"
image_name=${TRACE_IMAGE%@*}
image_digest=${TRACE_IMAGE#*@}
cat >> "$tmp/kustomization.yaml" <<KUSTOMIZE
images:
  - name: trace-runtime
    newName: $image_name
    digest: $image_digest
KUSTOMIZE
kubectl kustomize "$tmp"
