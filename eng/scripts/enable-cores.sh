#!/usr/bin/env bash

set -euxo pipefail
RESET="\033[0m"
YELLOW="\033[0;33m"

__warn() {
  echo -e "${YELLOW}warning: $*${RESET}"
  if [[ -n "${TF_BUILD:-}" ]]; then
    echo "##vso[task.logissue type=warning]$*"
  fi
}

if [[ -n "${SYSTEM_DEFAULTWORKINGDIRECTORY:-}" ]]; then
  wd=$SYSTEM_DEFAULTWORKINGDIRECTORY
  echo "##vso[task.setvariable variable=COMPlus_DbgEnableMiniDump]1"
  echo "##vso[task.setvariable variable=COMPlus_DbgMiniDumpName]$wd/dotnet-%d.%t.core"
else
  wd=$(pwd -P)
  export COMPlus_DbgEnableMiniDump=1
  export COMPlus_DbgMiniDumpName="$wd/dotnet-%d.%t.core"
fi

ulimit -c unlimited

if [[ -e /proc/self/coredump_filter ]]; then
  if [[ -w /proc/self/coredump_filter ]]; then
    echo 0x3f >/proc/self/coredump_filter
  else
    __warn "/proc/self/coredump_filter exists but is not writeable."
    ls -l /proc/self/coredump_filter

    echo "/proc/selv/coredump_filter:"
    cat /proc/selv/coredump_filter
    echo ""
  fi
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
