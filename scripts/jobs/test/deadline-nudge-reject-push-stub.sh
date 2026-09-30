#!/bin/bash
# Counts invocations and refuses every push with a receive-side hook rejection:
# a definite failure that no amount of re-syncing can turn into a success.

set -euo pipefail
: "${GARDEN_NUDGE_REJECT_COUNT:?}"
printf 'x\n' >> "$GARDEN_NUDGE_REJECT_COUNT"
printf '%s\n' \
  'remote: error: GH013: Repository rule violations found for refs/heads/journal2.' \
  ' ! [remote rejected] HEAD -> journal2 (push declined due to repository rule violations)' \
  "error: failed to push some refs to 'origin'" >&2
exit 1
