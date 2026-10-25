#!/usr/bin/env bash
# =========================================================================
# DRIFT DETECTION RUNNER SCRIPT
# Executes terraform plan with detailed exitcode & triggers Webhook alert
# =========================================================================

set -euo pipefail

echo "========================================================="
echo "  Executing Automated Infrastructure Drift Detection"
echo "========================================================="

terraform init -input=false

exit_code=0
terraform plan -detailed-exitcode -no-color -out=drift_plan.tfplan || exit_code=$?

if [ "$exit_code" -eq 0 ]; then
  echo "✔ Status: Infrastructure is completely in sync. No drift detected."
elif [ "$exit_code" -eq 2 ]; then
  echo "⚠ ALERT: Infrastructure drift identified! Manual changes detected."
  if [ -n "${TEAMS_WEBHOOK_URL:-}" ]; then
    curl -H "Content-Type: application/json" -d '{"text": "⚠ ALERT: Terraform drift identified in Production Landing Zone!"}' "$TEAMS_WEBHOOK_URL"
  fi
  exit 2
else
  echo "✖ ERROR: Terraform execution encountered a fatal error."
  exit 1
fi
