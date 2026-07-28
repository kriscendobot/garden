#!/bin/bash
# set-kimi-fallback.sh — arm/disarm routing builder work to kimi-k3 with an
# automatic opus fallback (CAS write of the per-instance journal flag).
#
# Usage: set-kimi-fallback.sh on|off
#
# Writes config/kimi-takes-opus-work on the journal. This is the single reversible
# enablement for the kimi-k3-takes-opus-work relaxation: while it is `off` (the
# default, absent file) a mystic stays barred from builder/designer jobs exactly as
# before, so landing the feature code is a no-op. When it is `on`, a mystic may
# claim a `role: builder` job pinned `model: kimi-k3` IFF that job carries a
# `fallback-model:` chain (job_eligible_for_kind), and the reaper re-routes such a
# job to opus on genuine failure. designer stays barred regardless (graduated).
#
# This is the FINER kill switch: `set-kimi-fallback.sh off` bars new kimi builder
# claims immediately while any in-flight fallback chain still re-routes to opus. The
# BLUNT switch is `set-mystics.sh 0` (stop all kimi). Neither is a code edit.
# Design: designs/kimi-k3-takes-opus-work-with-opus-fallback.md.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="set-kimi-fallback"

state="${1:?usage: set-kimi-fallback.sh on|off}"
case "$state" in
  on|off) : ;;
  *) die "illegal state '$state' (expected on|off)";;
esac

DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
ensure_clone "$DIR"

for attempt in $(seq 1 50); do
  sync_clone "$DIR"
  mkdir -p "$DIR/config"
  printf '%s\n' "$state" > "$DIR/config/kimi-takes-opus-work"
  git -C "$DIR" add "config/kimi-takes-opus-work"
  # `|| rc=$?` (not an `if`): a false `if` with no `else` exits 0 and would swallow
  # commit_and_push's rc=2 "nothing to commit" (idempotent re-run) and loop forever.
  rc=0; commit_and_push "$DIR" "config: kimi-takes-opus-work=$state" || rc=$?
  [ "$rc" -eq 0 ] && { log "set kimi-takes-opus-work=$state"; exit 0; }
  [ "$rc" -eq 2 ] && { log "kimi-takes-opus-work already $state"; exit 0; }
  log "set kimi-takes-opus-work lost a push race (attempt $attempt); re-syncing"
  backoff "$attempt"
done
die "could not set kimi-takes-opus-work after retries"
