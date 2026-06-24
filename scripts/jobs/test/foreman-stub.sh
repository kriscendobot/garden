#!/bin/bash
# foreman-stub.sh — deterministic foreman handler for tests. Records that it was
# invoked (so the cost gate can be asserted: a busy board or a within-settle tick
# must make NO call) and emits one fixed JOB block naming the next step. Because
# the base is fixed, re-invocation proposes the same step, which exercises the
# foreman's anti-flap path.
set -euo pipefail
: "${1:?usage: foreman-stub.sh <digest-file>}"
[ -n "${GARDEN_FOREMAN_STUB_CALLS:-}" ] && echo "called" >> "$GARDEN_FOREMAN_STUB_CALLS"
cat <<'EOF'
JOB foreman-next-step
endo-but-for-bots: build the next unblocked milestone step (test stub).
ENDJOB
EOF
