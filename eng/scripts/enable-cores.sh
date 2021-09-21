#!/usr/bin/env bash

set -euo pipefail
RESET="\033[0m"
YELLOW="\033[0;33m"

__warn() {
  echo -e "${YELLOW}warning: $*${RESET}"
}

ulimit -c unlimited

if [[ -e /proc/self/coredump_filter ]]; then
  echo 0x3f >/proc/self/coredump_filter
else
  __warn "/proc/self/coredump_filter file not found."
fi
