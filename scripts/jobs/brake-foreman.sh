#!/bin/bash
# brake-foreman.sh — set, clear, or report the FOREMAN brake: a throttle that
# stops ONLY the foreman's autonomous pump, independent of the fleet drain.
#
# Usage:
#   brake-foreman.sh on  [reason...]   set the brake   (the foreman stops pumping)
#   brake-foreman.sh off               clear the brake (the foreman resumes)
#   brake-foreman.sh status            report whether the brake is set
#
# WHY a separate brake. The garden's only lever used to be the fleet drain, which
# is all-or-nothing: silencing the foreman's pump also stopped every gardener. That
# actively blocked work — an orchestration chain had to be promoted by hand because
# the leader had to stay drained purely to keep the foreman quiet. The brake
# decouples the two: with the drain OFF and the brake ON, gardeners keep claiming
# while the foreman pumps NOTHING. The drain keeps its meaning and keeps stopping
# the foreman too (foreman_braked = fleet_draining OR brake-set), so the truth table is:
#
#   fleet drain | foreman brake | gardeners claim? | foreman pumps?
#   ------------|---------------|------------------|----------------
#   on          | either        | no               | no
#   off         | on            | yes              | no
#   off         | off           | yes              | yes
#
# WHY journal-backed (not a host-local marker like the drain). The foreman is a
# leader-only singleton that runs on whichever host the journal `leader` marker
# names. A host-local brake would be left behind when the leader moves, and the new
# leader's foreman would start pumping immediately. A journal flag is fleet policy
# expressed in fleet state: it follows the leader across a handoff, is reachable
# from ANY host without a new sysop op, and is auditable in git history. The cost is
# one stat on the journal clone the foreman already syncs each tick, and it fails
# SAFE — an unreadable/offline journal makes the foreman's sync_clone exit the tick
# before the brake read, so the pump never fires on a journal it could not read.
#
# The brake is written to journal2 at $GARDEN_FOREMAN_BRAKE_PATH (default
# config/foreman-brake) and CAS-raced onto origin the same way set-main-host.sh
# writes the leader marker: first pusher wins, losers re-sync and retry. Its
# EXISTENCE is the programmatic signal (foreman_braked in common.sh keys on
# existence only, like the drain marker); its CONTENTS are a short prose note so
# whoever finds the file understands what it does and how to clear it.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="brake-foreman"

action="${1:-status}"

# A dedicated producer clone (shared with the other journal writers), CAS-raced.
DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"

# brake_set_on_remote — true when the brake file is present in the synced clone.
brake_set_on_remote() { [ -e "$DIR/$GARDEN_FOREMAN_BRAKE_PATH" ]; }

case "$action" in
  on)
    shift || true
    reason="$*"
    ensure_clone "$DIR"
    for attempt in $(seq 1 50); do
      sync_clone "$DIR"
      if brake_set_on_remote; then
        log "foreman brake already set; nothing to do"; exit 0
      fi
      brake_dir="$(dirname "$GARDEN_FOREMAN_BRAKE_PATH")"
      [ "$brake_dir" = "." ] || mkdir -p "$DIR/$brake_dir"
      {
        echo "The FOREMAN is BRAKED."
        echo
        echo "While this file exists on journal2, the garden's foreman pump is"
        echo "silenced: it promotes no deferred plan jobs and generates no new"
        echo "milestone steps. This is the FOREMAN-ONLY brake — it does NOT drain"
        echo "the fleet. Gardeners keep claiming and running jobs normally; only"
        echo "the autonomous pump that generates new work is paused."
        echo
        echo "The fleet drain (scripts/jobs/drain-fleet.sh) still stops the foreman"
        echo "too, so a drained fleet needs no brake. Use this brake when you want"
        echo "the fleet working but the pump quiet."
        echo
        echo "To let the foreman resume pumping, clear this brake:"
        echo "    scripts/jobs/brake-foreman.sh off"
        echo
        echo "set_by: $GARDEN"
        echo "set_at: $(date -u +%FT%TZ)"
        [ -n "$reason" ] && echo "reason: $reason"
      } > "$DIR/$GARDEN_FOREMAN_BRAKE_PATH"
      git -C "$DIR" add "$GARDEN_FOREMAN_BRAKE_PATH"
      rc=0; commit_and_push "$DIR" "foreman brake ON (set by $GARDEN)${reason:+: $reason}" || rc=$?
      [ "$rc" -eq 0 ] && { log "foreman brake ON — the pump is silenced (gardeners keep claiming)"; exit 0; }
      [ "$rc" -eq 2 ] && { log "foreman brake already set"; exit 0; }
      log "brake-foreman lost a push race (attempt $attempt); retrying"
      backoff "$attempt"
    done
    die "could not set the foreman brake after retries"
    ;;
  off)
    ensure_clone "$DIR"
    for attempt in $(seq 1 50); do
      sync_clone "$DIR"
      if ! brake_set_on_remote; then
        log "foreman was not braked (no brake at $GARDEN_FOREMAN_BRAKE_PATH); the pump is already free"
        exit 0
      fi
      git -C "$DIR" rm -q "$GARDEN_FOREMAN_BRAKE_PATH"
      rc=0; commit_and_push "$DIR" "foreman brake OFF (cleared by $GARDEN)" || rc=$?
      [ "$rc" -eq 0 ] && { log "foreman brake OFF — the pump resumes on the next tick"; exit 0; }
      [ "$rc" -eq 2 ] && { log "foreman brake already clear"; exit 0; }
      log "brake-foreman lost a push race (attempt $attempt); retrying"
      backoff "$attempt"
    done
    die "could not clear the foreman brake after retries"
    ;;
  status)
    ensure_clone "$DIR"
    sync_clone "$DIR"
    if brake_set_on_remote; then
      log "BRAKED"
      log "  brake marker: $GARDEN_FOREMAN_BRAKE_PATH (on journal2)"
      # Surface the prose reason if present, so `status` explains itself.
      sed 's/^/  /' "$DIR/$GARDEN_FOREMAN_BRAKE_PATH" 2>/dev/null || true
      exit 0
    fi
    log "not braked (the foreman pumps normally unless the fleet is draining)"
    ;;
  *)
    die "usage: brake-foreman.sh on [reason...] | off | status"
    ;;
esac
