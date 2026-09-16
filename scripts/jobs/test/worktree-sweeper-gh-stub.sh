#!/bin/bash
set -euo pipefail
[ "${1:-}" = pr ] && [ "${2:-}" = view ] || exit 2
case "${3:-}" in
  10) printf 'CLOSED\n' ;;
  11) printf 'OPEN\n' ;;
  *) exit 1 ;;
esac
