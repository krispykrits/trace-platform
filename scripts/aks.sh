#!/usr/bin/env bash
set -euo pipefail

: "${AZURE_SUBSCRIPTION_ID:?Set AZURE_SUBSCRIPTION_ID}"
: "${AKS_RESOURCE_GROUP:?Set AKS_RESOURCE_GROUP}"
: "${AKS_NAME:?Set AKS_NAME}"

case "${1:-}" in
  start|stop)
    az aks "$1" --subscription "$AZURE_SUBSCRIPTION_ID" --resource-group "$AKS_RESOURCE_GROUP" --name "$AKS_NAME"
    ;;
  status)
    az aks show --subscription "$AZURE_SUBSCRIPTION_ID" --resource-group "$AKS_RESOURCE_GROUP" --name "$AKS_NAME" --query '{power:powerState.code,provisioning:provisioningState}' --output table
    ;;
  *)
    printf 'Usage: %s {start|stop|status}\n' "$0" >&2
    exit 2
    ;;
esac
