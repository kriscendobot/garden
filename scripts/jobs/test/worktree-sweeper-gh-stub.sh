#!/bin/bash
set -euo pipefail
[ "${1:-}" = api ] || exit 2
[ -z "${WORKTREE_SWEEPER_GH_CALLS:-}" ] || printf '%s\n' "$*" >> "$WORKTREE_SWEEPER_GH_CALLS"
case "${2:-}" in
  repos/acme/proj/pulls/10) printf 'closed\n' ;;
  repos/acme/proj/pulls/11) printf 'open\n' ;;
  *) exit 1 ;;
esac
