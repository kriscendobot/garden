#!/bin/bash
# Narrow, read-only GitHub interface for driver.py. It assigns every supported
# high-level gh command to its actual quota bucket, then routes the call through
# common.sh's host-wide single-flight admission, cooldown, and retry machinery.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$HERE/../common.sh"
export GARDEN_TAG="${GARDEN_TAG:-proxy-screen}"

case "${1:-} ${2:-}" in
  "api graphql"|"pr list"|"pr view") scope=graphql ;;
  "api "*|"run list") scope=rest ;;
  *) die "screening GitHub interface refuses unsupported command: $*" ;;
esac

gh_read_retry "$scope" "screen:${1:-unknown}-${2:-read}" "$@"
