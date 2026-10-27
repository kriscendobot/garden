#!/bin/bash
# foreman-stub.sh — deterministic foreman handler for tests. Records that it was
# invoked (so the cost gate can be asserted: a busy board or a within-settle tick
# must make NO call) and emits one fixed JOB block naming the next step. Because
# the base is fixed, re-invocation proposes the same step, which exercises the
# foreman's anti-flap path.
set -euo pipefail
: "${1:?usage: foreman-stub.sh <digest-file>}"
[ -n "${GARDEN_FOREMAN_STUB_CALLS:-}" ] && echo "called" >> "$GARDEN_FOREMAN_STUB_CALLS"
[ -z "${GARDEN_FOREMAN_STUB_DIGEST:-}" ] || cp "$1" "$GARDEN_FOREMAN_STUB_DIGEST"
[ "${GARDEN_FOREMAN_STUB_RC:-0}" -eq 0 ] || exit "$GARDEN_FOREMAN_STUB_RC"
stub_base="${GARDEN_FOREMAN_STUB_BASE:-foreman-next-step}"
# On the foreman's bounded invalid/duplicate re-prompt,
# GARDEN_FOREMAN_STUB_RETRY_BASE (when set) replaces the proposal; the literal
# `none` emits no block at all.
if [ -n "${GARDEN_FOREMAN_STUB_RETRY_BASE:-}" ] && grep -qE '^rejected_(completed|duplicate|malformed)_base: ' "$1"; then
  [ -z "${GARDEN_FOREMAN_STUB_RETRY_DIGEST:-}" ] || cp "$1" "$GARDEN_FOREMAN_STUB_RETRY_DIGEST"
  [ "$GARDEN_FOREMAN_STUB_RETRY_BASE" != none ] || exit 0
  stub_base="$GARDEN_FOREMAN_STUB_RETRY_BASE"
fi
printf 'JOB %s\n' "$stub_base"
[ -z "${GARDEN_FOREMAN_STUB_ARC:-}" ] || printf 'ARC %s\n' "$GARDEN_FOREMAN_STUB_ARC"
cat <<'EOF'
endo-but-for-bots: build the next unblocked milestone step (test stub).
ENDJOB
EOF
