#!/bin/bash
# foreman-stub-counter.sh — deterministic foreman handler for the WIP top-up test.
# Emits a DISTINCT JOB base on each call (foreman-step-1, -2, …) by advancing a
# counter file, so successive pumps post different jobs and the board climbs
# toward the WIP target without tripping anti-flap (which only holds on a REPEAT
# of the last posted base). Records each invocation like foreman-stub.sh so the
# cost gate can still be asserted.
#   GARDEN_FOREMAN_STUB_CALLS   append "called" per invocation (cost-gate assert)
#   GARDEN_FOREMAN_STUB_COUNTER counter file holding the last emitted index
set -euo pipefail
: "${1:?usage: foreman-stub-counter.sh <digest-file>}"
[ -n "${GARDEN_FOREMAN_STUB_CALLS:-}" ] && echo "called" >> "$GARDEN_FOREMAN_STUB_CALLS"
counter="${GARDEN_FOREMAN_STUB_COUNTER:?GARDEN_FOREMAN_STUB_COUNTER required}"
n="$(cat "$counter" 2>/dev/null || echo 0)"
n=$(( n + 1 ))
printf '%s\n' "$n" > "$counter"
cat <<EOF
JOB foreman-step-$n
endo-but-for-bots: build milestone step $n (test stub).
ENDJOB
EOF
