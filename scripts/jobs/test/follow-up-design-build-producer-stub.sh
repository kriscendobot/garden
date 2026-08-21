#!/bin/bash
set -euo pipefail
{
  printf 'CALL %s' "$(basename "$0")"
  printf ' <%s>' "$@"
  printf '\nBODY\n'
  cat
  printf 'ENDBODY\n'
} >> "${FDB_LOG:?set FDB_LOG}"
