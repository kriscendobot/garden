#!/bin/bash
# Recording stand-in for post-gauntlet.sh in the readiness-audit regression test.
set -euo pipefail
printf '%s\n' "$*" >>"${GARDEN_AUDIT_GAUNTLET_LOG:?}"
[ "${GARDEN_AUDIT_GAUNTLET_FAIL:-0}" != 1 ]
