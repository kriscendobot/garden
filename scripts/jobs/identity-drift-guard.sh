#!/bin/bash
# identity-drift-guard.sh — deterministic host-identity drift detector. NO LLM.
#
# Usage: identity-drift-guard.sh
#   exit 0 always (a detector must never fail its caller's tick).
#
# GARDEN (resolved in common.sh) is the SINGLE key every per-host structure hangs
# off: the claim metadata, the hosts/<host> worker count, the journal index, and
# the leader/follower predicate (is-main-host.sh). When GARDEN silently diverges
# from `hostname -s` with no recorded parallel-pool override, ALL of that per-host
# state is mislabeled and — on the true leader host — is_main_host compares the
# drifted GARDEN against the `leader` marker and returns FOLLOWER, so every
# leader-only singleton (foreman, scheduler, reaper, bulletin, triager,
# issue-inbox, ci-watcher, orchestrate, the maintainer-inbox Monitor) is skipped.
# This is exactly the endolinbot2 regression: /home/kris/.garden held
# `endolinbot2` while hostname -s and the leader marker were `endolinbot`, and the
# fleet ran as a follower for hours before anyone noticed.
#
# Why the existing guards miss a .garden-FILE override:
#   - gardener.sh logs a per-spawn WARN, but it is a plain `log` line, not a loud
#     greppable `kind:error` JOURNAL entry, and it only fires at a spawn.
#   - gardener-scaler.sh's `install-units.sh reconcile-identity` catches only an
#     INCONSISTENCY between a worker's frozen /proc environ and the resolved
#     $GARDEN. A .garden file makes ALL workers resolve the same drifted value
#     CONSISTENTLY, so the reconcile sees nothing and restarts nothing.
#
# So this guard runs as a gardener-scaler.sh PREFLIGHT (once per tick, host-level,
# independent of the size signal) and, on a genuine unrecorded divergence, posts
# ONE loud `kind:error` journal entry — deduped by a marker so it fires on tick 1
# of a regression and stays quiet until the drift changes or clears — and, on the
# leader path, surfaces that is-main-host will report follower.
#
# See CLAUDE.md § Job system, designs/multibot-leader-follower.md, and issue
# kriskowal/garden#11 (Multibot).

set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="identity-drift-guard"

# Marker recording the drift signature we last reported, so we post the loud
# journal entry once per distinct drift state rather than once per tick. Lives
# under $GARDEN_STATE (per-host, outside any reset-prone worktree), like the
# watchman `seen` and deploy markers.
: "${GARDEN_IDENTITY_DRIFT_MARKER:=$GARDEN_STATE/identity-drift-reported}"

# The reporting sink. Overridable so a test can capture the emission (and assert
# the dedup) without pushing to a real journal. Reads the body on stdin.
: "${GARDEN_IDENTITY_GUARD_EMIT:=}"
emit_error() {
  if [ -n "$GARDEN_IDENTITY_GUARD_EMIT" ]; then
    bash -c "$GARDEN_IDENTITY_GUARD_EMIT"
  else
    GARDEN_ROLE="gardener-scaler" "$HERE/journal-entry.sh" error
  fi
}

host_short="$(hostname -s 2>/dev/null || echo host)"

# No divergence → the common case. Clear any stale marker so a FUTURE regression
# fires again on its first tick, then exit quietly.
if [ "$GARDEN" = "$host_short" ]; then
  rm -f "$GARDEN_IDENTITY_DRIFT_MARKER" 2>/dev/null || true
  exit 0
fi

# GARDEN diverges from hostname -s. The design deliberately permits a
# `GARDEN=<unique>` parallel pool, so a RECORDED deliberate override
# (GARDEN_IDENTITY_OVERRIDE env or $GARDEN_STATE/identity-override file, matching
# the resolved GARDEN — same contract gardener.sh honors at spawn) is legitimate
# and silences the guard. Anything else is drift.
recorded_override="${GARDEN_IDENTITY_OVERRIDE:-}"
if [ -z "$recorded_override" ] && [ -f "$GARDEN_STATE/identity-override" ]; then
  recorded_override="$(head -1 "$GARDEN_STATE/identity-override" 2>/dev/null || true)"
fi
if [ "$recorded_override" = "$GARDEN" ]; then
  # A legitimate, recorded parallel pool. Clear any stale drift marker and exit.
  rm -f "$GARDEN_IDENTITY_DRIFT_MARKER" 2>/dev/null || true
  log "identity: GARDEN=$GARDEN diverges from hostname -s=$host_short by RECORDED deliberate override (parallel pool); no drift"
  exit 0
fi

# --- genuine unrecorded drift ------------------------------------------------
# On the leader path, surface that is-main-host will misreport. The comparand is
# the journal `leader` marker; if it names this real host (hostname -s) but GARDEN
# has drifted, the true leader is running as a follower.
leader="$(leader_host 2>/dev/null || true)"
if is_main_host; then
  leader_line="is-main-host currently reports LEADER for GARDEN=$GARDEN"
else
  if [ "$leader" = "$host_short" ]; then
    leader_line="is-main-host reports FOLLOWER: the leader marker names '$leader' (this host's real hostname -s), but the drifted GARDEN=$GARDEN does not match it — every leader-only singleton is being SKIPPED on the true leader host"
  else
    leader_line="is-main-host reports FOLLOWER (leader marker='${leader:-<undeterminable>}', GARDEN=$GARDEN)"
  fi
fi

# Always log loudly each tick (cheap, greppable in the scaler's journal).
log "ERROR identity DRIFT: GARDEN=$GARDEN != hostname -s=$host_short with NO recorded override; $leader_line"

# Dedup the JOURNAL entry: one per distinct drift signature. Signature captures
# what could change (resolved identity, real hostname, and the leader verdict).
sig="GARDEN=$GARDEN|host=$host_short|leader=${leader:-}"
prev=""
[ -f "$GARDEN_IDENTITY_DRIFT_MARKER" ] && prev="$(head -1 "$GARDEN_IDENTITY_DRIFT_MARKER" 2>/dev/null || true)"
if [ "$sig" = "$prev" ]; then
  # Already reported this exact drift state; stay quiet on the journal.
  exit 0
fi

body="$(cat <<EOF
# Host-identity DRIFT detected (deterministic guard)

**GARDEN=\`$GARDEN\`** diverges from **hostname -s=\`$host_short\`** on this host,
with NO recorded parallel-pool override (checked GARDEN_IDENTITY_OVERRIDE and
\`$GARDEN_STATE/identity-override\`).

GARDEN is the single key every per-host structure hangs off — claim metadata, the
\`hosts/<host>\` worker count, the journal index, and the leader/follower
predicate. An unrecorded divergence silently mislabels all of it (here: up to this
host's full gardener pool) and disables the leader gate.

**Leader impact:** $leader_line

**Likely source:** the gitignored per-instance identity file \`$GARDEN_ROOT/.garden\`
(common.sh precedence step 2) or an inherited-env \`GARDEN\`. This is the
endolinbot2 regression class.

**Fix:** if this host is the leader, correct \`$GARDEN_ROOT/.garden\` (and any
inherited \`GARDEN\`) to \`$host_short\` and restart the pool; if this is a
deliberate parallel pool, record the override in \`$GARDEN_STATE/identity-override\`
(or export GARDEN_IDENTITY_OVERRIDE=\`$GARDEN\`) so this guard stays quiet.

Posted once per distinct drift state by \`scripts/jobs/identity-drift-guard.sh\`
(gardener-scaler preflight). It will not repeat until the drift changes or clears.
EOF
)"

if printf '%s\n' "$body" | emit_error; then
  mkdir -p "$(dirname "$GARDEN_IDENTITY_DRIFT_MARKER")" 2>/dev/null || true
  printf '%s\n' "$sig" > "$GARDEN_IDENTITY_DRIFT_MARKER" 2>/dev/null || true
  log "posted identity-drift kind:error journal entry (sig=$sig)"
else
  log "WARN failed to post identity-drift journal entry; will retry next tick"
fi

exit 0
