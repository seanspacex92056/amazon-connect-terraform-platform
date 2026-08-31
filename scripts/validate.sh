#!/usr/bin/env bash
set -euo pipefail
terraform fmt -recursive -check
for env in dev prod; do
  terraform -chdir="envs/${env}" init -backend=false
  terraform -chdir="envs/${env}" validate
done
