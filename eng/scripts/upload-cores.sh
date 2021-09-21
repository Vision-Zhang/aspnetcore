#!/usr/bin/env bash

set -euo pipefail
RESET="\033[0m"
YELLOW="\033[0;33m"

__warn() {
  echo -e "${YELLOW}warning: $*${RESET}"
}

if [[ -z "${SYSTEM_PHASENAME:-}" ]]; then jobName="$AGENT_OS"; else jobName="$SYSTEM_PHASENAME"; fi
artifactName="${jobName}_Dumps"

save_nullglob=$(shopt -p nullglob || true)
shopt -s nullglob
files=(
  $SYSTEM_DEFAULTWORKINGDIRECTORY/core.*
  $SYSTEM_DEFAULTWORKINGDIRECTORY/dotnet-*.core
)
$save_nullglob

for file in ${files[@]}; do
  echo "##vso[artifact.upload containerfolder=$artifactName;artifactname=$artifactName]$file"
done

if [[ ${#files[@]} == 0 ]]; then
  __warn "No core files found."
fi
