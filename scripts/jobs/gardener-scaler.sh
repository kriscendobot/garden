#!/bin/bash
# gardener-scaler.sh — reconcile this host's gardener pool to journal state.
#
# Usage: gardener-scaler.sh
#
# The journal's hosts/<host> file declares how many concurrent gardeners this
# host should run (its local concurrency limit). This timer-driven service —
# the sibling of repo-watcher, but for worker count rather than the watch set —
# syncs the journal and scales the local garden-gardener@N pool to match,
# starting missing instances and stopping extras. Absent or unparsable → leave
# the pool unchanged (a no-op WARN); only an explicit `gardeners: 0` scales to zero.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="gardener-scaler"

DIR="${GARDEN_SCALER_CLONE:-$GARDEN_STATE/gardener-scaler/journal}"
ensure_clone "$DIR"
sync_clone "$DIR"

host="$GARDEN"

# Host-identity DRIFT guard — a deterministic preflight that runs EVERY tick,
# host-level, independent of the desired-count read below. It catches the drift
# class the reconcile step CANNOT: when the gitignored .garden file (or an
# inherited-env GARDEN) makes every worker resolve the SAME drifted identity
# consistently, reconcile-identity sees no /proc-vs-resolved inconsistency and
# does nothing, yet GARDEN still mislabels all per-host state and flips the leader
# gate to follower. On a genuine unrecorded divergence the guard posts ONE loud
# kind:error journal entry (deduped per drift state, so it fires on tick 1 of a
# regression) instead of silently mislabeling the whole pool. Never fails the tick.
"$HERE/identity-drift-guard.sh" || true

# Identity reconciliation runs EVERY tick, independent of the desired-count read
# below: a worker whose in-process GARDEN has drifted from this host's identity
# (a long-lived instance that inherited a since-corrected value at spawn — e.g. a
# stale `GARDEN=endolinbot2` override removed after the worker started) must be
# restarted onto the corrected identity even when the SIZE signal (hosts/<host>) is
# structurally missing. The step is size-orthogonal and gated on the same busy
# marker the scale path defers on, so a mid-job worker restarts between claims, not
# mid-flight. See install-units.sh reconcile_identity.
"$HERE/install-units.sh" reconcile-identity

f="$DIR/hosts/$host"
want=""
if [ -f "$f" ]; then
  v="$(sed -n 's/^gardeners:[[:space:]]*//p' "$f" | head -1)"
  [[ "$v" =~ ^[0-9]+$ ]] && want="$v"
fi

# "Cannot determine desired count" (absent hosts/<host>, or a malformed/missing
# gardeners: line) is a NO-OP, not a scale-to-0: tearing the whole local fleet
# down is exactly wrong when the desired-count signal is structurally missing.
# Leave the pool unchanged and warn; only an explicitly-read `gardeners: 0` is
# allowed to scale to zero. (Even an explicit scale-down no longer SIGTERMs an
# in-flight handler: install-units.sh scale gates `disable --now` on the busy
# marker, deferring a mid-job gardener to a later tick — but a structurally-absent
# signal must still not trigger that path at all.)
if [ -z "$want" ]; then
  log "WARN host '$host' desired gardeners undeterminable (missing/unparsable hosts/$host); leaving pool unchanged"
  exit 0
fi
log "host '$host' desired gardeners: $want"

# delegate the actual enable/disable to the installer's scale path (which uses
# the same mockable unit_ctl), keeping one place that knows how to scale.
"$HERE/install-units.sh" scale "$want"
