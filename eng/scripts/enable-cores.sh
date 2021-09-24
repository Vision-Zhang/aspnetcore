#!/usr/bin/env bash

set -euxo pipefail
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

if [[ -e /proc/sys/kernel/core_pattern ]]; then
  echo "/proc/sys/kernel/core_pattern:"
  cat /proc/sys/kernel/core_pattern
  echo ""
fi

if [[ -e /etc/default/apport ]]; then
  echo "/etc/default/apport"
  cat /etc/default/apport
  echo ""

  if command systemctl; then
    if pidof systemctl; then
      systemctl status apport.service || __warn "systemctl: apport disabled."
    else
      __warn "systemctl command exists but service isn't running."
    fi
  else
    __warn "systemctl command does not exist."
  fi

  if command service; then
    service --status-all
  else
    __warn "service command does not exist."
  fi
fi
