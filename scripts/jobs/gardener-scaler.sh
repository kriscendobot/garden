#!/bin/bash
# gardener-scaler.sh — reconcile this host's worker pools to journal state.
#
# Usage: gardener-scaler.sh
#
# The journal's hosts/<host> file declares how many concurrent workers of each KIND
# this host should run (its local concurrency limits): a `gardeners: N` line and a
# `clerics: N` line. This ONE timer-driven service — the sibling of repo-watcher, but
# for worker count rather than the watch set — syncs the journal and scales EVERY
# worker pool to match by iterating the worker-kind registry (common.sh
# worker_kinds), starting missing instances and stopping extras. Per kind the count
# read has three outcomes, all leaving the pool unchanged except a clean parse:
# file-missing OR value-present-but-unparsable → misconfig, WARN; key-line simply
# absent from an existing file → normal (this host does not declare the kind), quiet
# DEBUG; an explicit `<count_key>: 0` scales any kind to zero. There is NO second
# scaler service — the spine is one loop, one scaler.

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
non_claude_qualified=0
host_has_qualified_non_claude_worker "$f" && non_claude_qualified=1
quota_route_active=0
[ "$(quota_routing_mode)" = race ] && quota_route_active=1

# Reconcile EACH worker kind independently from its own count line. A kind whose
# desired count is structurally missing/unparsable is a NO-OP for THAT kind (leave
# it unchanged and warn), not a scale-to-0 — tearing a pool down is exactly wrong
# when the signal is absent; only an explicitly-read non-gardener `<count_key>: 0`
# scales a kind to zero. Each kind delegates to the installer's scale path (the same mockable
# unit_ctl), keeping one place that knows how to enable/disable instances.
# The two Anthropic spellings (monk canonical, gardener legacy) overlap during the
# staged rename; NEVER arm both for one capacity slot. Pick the host-active spelling
# once — `monks:` present wins, else the legacy `gardeners:` — and skip the shadowed
# one so the scaler arms exactly one Anthropic pool. The shadowed pool is torn down
# by the per-host cutover command's drained transaction, not here; the scaler only
# refrains from (re-)arming it, so it can never re-enable a just-disabled legacy pool.
active_anthropic="$(anthropic_active_kind "$f")"

for kind in $(worker_kinds); do
  if [ "$(worker_kind_field "$kind" provider)" = anthropic ] && [ "$kind" != "$active_anthropic" ]; then
    log "DEBUG host '$host' Anthropic slot is '$active_anthropic'; skipping shadowed kind '$kind' (never both pools armed)"
    continue
  fi
  count_key="$(worker_kind_field "$kind" count_key)"
  # read_desired_count (common.sh) distinguishes the three outcomes: a clean parse
  # (status 0) scales; a key-line simply absent from an existing file (status 2) is
  # a normal condition — this host does not declare this kind — so stay quiet; file
# missing or value unparsable (status 1) is a real misconfig → WARN. All three
# leave the pool unchanged except the clean parse; missing is never scale-to-0,
# while an explicit zero is.
  if want="$(read_desired_count "$f" "$count_key")"; then
    if [ "$(worker_kind_field "$kind" provider)" = anthropic ] && [ "$want" -eq 0 ] && { [ "$quota_route_active" -ne 1 ] || [ "$non_claude_qualified" -ne 1 ]; }; then
      log "WARN host '$host' declares $count_key: 0 without the active quota route and a configured, probe-qualified non-Claude worker; refusing to leave zero qualified workers (use drain-fleet.sh to pause work)"
      continue
    fi
    # `want` is the owner-declared journal target. Compute the probe-gated EFFECTIVE
    # count (0 while the kind's backend is unauthenticated/unavailable, ramping to
    # declared once a real auth success is confirmed, with hysteresis so a transient
    # blip does not tear the pool down) and scale to THAT. An explicitly declared 0
    # remains 0 for every kind. backend_effective_count keeps pure per-host runtime
    # state and writes no journal, so it is invisible to leader/follower. See
    # designs/gnome-backend-verified-autotune.md § 2.
    effective="$(backend_effective_count "$kind" "$want")"
    log "host '$host' desired $count_key: $want (effective $effective)"
    "$HERE/install-units.sh" scale "$kind" "$effective"
  elif [ "$?" -eq 2 ]; then
    log "DEBUG host '$host' declares no $count_key line in hosts/$host; leaving $kind pool unchanged"
  else
    log "WARN host '$host' desired $count_key undeterminable (missing hosts/$host or unparsable value); leaving $kind pool unchanged"
  fi
done
