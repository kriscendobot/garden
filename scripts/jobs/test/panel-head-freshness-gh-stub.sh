#!/bin/bash
set -euo pipefail
[ "${1:-}" = pr ] && [ "${2:-}" = view ] || exit 64
pr="$3"
[ -z "${GARDEN_GH_CALL_LOG:-}" ] || printf '%s\n' "$*" >>"$GARDEN_GH_CALL_LOG"
case "$pr" in
  475)  head=a4767d542b49f67dbae326482e8be80774e3e289 ;;
  858)  head=1ec375e2dc9935bc1f2e7502b424ae37494e3926 ;;
  1226) head=8515b8cdef24aa26e8382bcc68b28f3295958883 ;;
  200)  head=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa ;;
  201)  head=bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb ;;
  202)  printf '{"state":"MERGED","headRefOid":"cccccccccccccccccccccccccccccccccccccccc"}\n'; exit 0 ;;
  203)  head=dddddddddddddddddddddddddddddddddddddddd ;;
  *) exit 64 ;;
esac
printf '{"state":"OPEN","headRefOid":"%s"}\n' "$head"
