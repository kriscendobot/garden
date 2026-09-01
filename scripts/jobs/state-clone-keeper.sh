#!/bin/bash
# state-clone-keeper.sh — reclaim leaked per-identity journal clones under
# $GARDEN_STATE, on EVERY host.
#
# ── Why this exists (two inode-starvation incidents, three days apart) ────────
# Every per-identity actor in the fleet gets its own full clone of journal2 at
# $GARDEN_STATE/<kind>/<id>/journal — a doer inbox (inbox-read.sh → ensure_clone),
# a gardener/cleric/monk worker id, a standing monitor. Each costs ~17k-29k
# inodes. Until this keeper, NOTHING removed them.
#
# complete-job.sh now drops a completed doer's inbox (the common path), but that
# alone cannot recover the majority case: a job that is doomed, reaper-killed, or
# lost to a host crash NEVER reaches complete-job.sh, and no worker id, cleric,
# monk or monitor goes through it at all. Those leak unconditionally, so the
# sweep below is the load-bearing half of the fix.
#
# The two incidents:
#   * 2026-08-28, endolin-garden-ece02cb4 — /dev/nvme0n1p2 reached ZERO free
#     inodes with 3972 of 3984 inbox dirs holding a clone (~206M inodes). Every
#     `git clone` of journal2 failed ENOSPC, so no gardener could read its inbox,
#     claim, or report: the whole host's fleet wedged SILENTLY. Block space was
#     never the constraint (756G free throughout).
#   * 2026-08-31, endolin-garden2-5bcdff64 — 2851 inbox clones holding 69,052,121
#     inodes, 28% of the entire 244M-inode filesystem, at 1.11% free. Beyond
#     inbox/, 267 further clones sat in monitors/ (142), gardeners/ (101),
#     clerics/ (20) and monks/ (4) — on a host running ONE to TWO workers, which
#     is how sharply worker ids outlive their workers.
#
# Hosts can SHARE a filesystem (both endolin instances are on /dev/nvme0n1p2), so
# one host's leak starves its sibling too. That is why this is NOT leader-gated:
# each host can only see and reclaim its own $GARDEN_STATE, so every host must
# sweep its own. It deliberately does not consult is-main-host.sh.
#
# ── What it removes, and what it refuses to ──────────────────────────────────
# A clone is reclaimed only when EVERY guard below passes. The guards are
# cumulative and each one alone is sufficient to keep a clone:
#
#   1. PER-KIND LIVENESS. inbox/<doer> is live while <doer> sits in jobs/todo or
#      jobs/doin on a FRESHLY SYNCED clone (a job parked in plan/ needs no clone;
#      one is re-created when it is promoted). gardeners/<id>, clerics/<id> and
#      monks/<id> are live while garden-<kind>@<id>.service is active.
#      monitors/<role>-<n> is live while garden-<role>@<n>.service is active;
#      a monitor name that maps to no unit falls through to the guards below.
#   2. IDLE FLOOR. Untouched for at least GARDEN_STATE_CLONE_MIN_IDLE seconds
#      (default 6h — deliberately more conservative than the 2h used for the
#      supervised by-hand reclaims, because this runs unattended).
#   3. NO LIVE PROCESS rooted in it (any /proc/*/cwd under the directory).
#   4. NO FRESH LOCK. A journal.lock newer than the idle floor means a peer is
#      mid-operation even if the clone itself looks quiet.
#
# Removal goes through state_cleanup (common.sh), which is confined to
# $GARDEN_STATE and refuses $GARDEN_STATE itself. Kinds are a CLOSED list: the
# keeper can only ever touch the five named below, so $GARDEN_STATE/maintainer,
# $GARDEN_STATE/producer, this keeper's own clone, and every other state dir are
# structurally out of reach — not merely unmatched by a predicate.
#
# Nothing durable is lost: all message state lives on origin/$JOURNAL_BRANCH and
# ensure_clone re-clones on demand. This is exactly the operation performed by
# hand on both hosts, twice, without loss.
#
# ── Bounded, and never silently bounded ──────────────────────────────────────
# At most GARDEN_STATE_CLONE_MAX_SWEEP clones per tick (default 200), so a first
# run on a badly-leaked host cannot spend an unbounded tick and any latent bug
# has a capped blast radius. When the cap binds, the remainder is LOGGED with a
# count — a bounded sweep that reported "done" would read as "the host is clean"
# when it is not.
#
# USAGE
#   state-clone-keeper.sh [--dry-run]
#     --dry-run   report exactly what would be reclaimed, remove nothing.
#
# ENV
#   GARDEN_STATE_CLONE_MIN_IDLE   seconds a clone must be idle (default 21600)
#   GARDEN_STATE_CLONE_MAX_SWEEP  max clones reclaimed per tick (default 200)
#   GARDEN_STATE_CLONE_KINDS      override the swept kinds (testing only)
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG="state-clone-keeper"

DRY_RUN=false
case "${1:-}" in
  --dry-run) DRY_RUN=true ;;
  "") : ;;
  *) die "usage: state-clone-keeper.sh [--dry-run]" ;;
esac

: "${GARDEN_STATE_CLONE_MIN_IDLE:=21600}"
: "${GARDEN_STATE_CLONE_MAX_SWEEP:=200}"
# Closed list. inbox is keyed by job base; the rest by systemd instance id.
: "${GARDEN_STATE_CLONE_KINDS:=inbox monitors gardeners clerics monks}"

CLONE="${GARDEN_STATE_CLONE_KEEPER_CLONE:-$GARDEN_STATE/state-clone-keeper/journal}"

# --- board liveness (inbox kind) ---------------------------------------------
# Sync FIRST, and never sweep against a board we could not read: an unreadable
# board reads as an EMPTY board, which makes every live doer look dead and turns
# this keeper into an indiscriminate deleter of the host's live state. That is
# the worst failure available to this script, so it is worth being precise about
# what prevents it.
#
# The protection is ORDERING, not a branch: load_live_doers runs to completion
# before the sweep loop is entered at all, so every failure path inside it is
# safe by construction. On the offline path the protection is specifically
# sync_clone's own `exit $GARDEN_OFFLINE_RC` — it terminates the process rather
# than returning, so the `if ! load_live_doers` below is NOT what saves us there
# and must not be read as if it were. That guard is a backstop for failure shapes
# that do return (a future sync_clone contract change, an alternate clone
# helper); it is deliberately kept, but it is not the load-bearing part.
#
# Fail SAFE toward keeping, the way the foreman brake fails safe toward braked.
live_doers=""
load_live_doers() {
  ensure_clone "$CLONE"
  sync_clone "$CLONE" || return 1
  local f base
  for f in "$CLONE/$JOBS_TODO"/*.md "$CLONE/$JOBS_DOIN"/*.md; do
    [ -e "$f" ] || continue
    base="$(basename "$f")"; base="${base%.md}"          # board files carry .md
    live_doers="$live_doers
$base"
  done
  return 0
}

is_live_doer() {  # is_live_doer <base>
  # -F and -e: some inbox dirs are literally named `--help` / `-h` (a known
  # inbox-send.sh misfire), which a bare `grep "$1"` would parse as options.
  printf '%s' "$live_doers" | grep -qxF -e "$1"
}

# The unit-keyed kinds (gardeners, clerics, monks, and the <role>-<n> monitors)
# decide liveness by asking systemd. If systemd is NOT reachable, every one of
# them answers "not active" — and after the idle floor that would sweep the LIVE
# workers' clones out from under them. That is the same shape as an unreadable
# board, so it gets the same fail-safe: probe systemd ONCE, and if the probe
# fails, drop the unit-keyed kinds from this tick entirely rather than trusting a
# uniformly negative answer. inbox/ is unaffected — it is keyed by the board, not
# by systemd — so a systemd-less host still reclaims the largest kind by far.
systemd_reachable=true
systemctl --user list-units --no-legend >/dev/null 2>&1 || systemd_reachable=false

unit_is_active() {  # unit_is_active <unit>
  systemctl --user is-active --quiet "$1" 2>/dev/null
}

# --- per-kind liveness --------------------------------------------------------
# Returns 0 (live → keep) / 1 (not live → fall through to the remaining guards).
kind_is_live() {  # kind_is_live <kind> <id>
  local kind="$1" id="$2" role n
  case "$kind" in
    inbox)    is_live_doer "$id" ;;
    gardeners) unit_is_active "garden-gardener@${id}.service" ;;
    clerics)   unit_is_active "garden-cleric@${id}.service" ;;
    monks)     unit_is_active "garden-monk@${id}.service" ;;
    monitors)
      # <role>-<n> maps to garden-<role>@<n>.service. A name that does not match
      # that shape (scholar-* cursors, liaison-<GARDEN>, and the historical
      # `gardener-{1..20}` brace-expansion artifact) owns no unit; it is NOT
      # treated as live here and is decided by the idle/process/lock guards.
      if [[ "$id" =~ ^([a-z]+)-([0-9]+)$ ]]; then
        role="${BASH_REMATCH[1]}"; n="${BASH_REMATCH[2]}"
        unit_is_active "garden-${role}@${n}.service"
      else
        return 1
      fi
      ;;
    *) return 0 ;;   # unknown kind → treat as live; never sweep what we do not model
  esac
}

# --- universal guards ---------------------------------------------------------
now="$(date +%s)"

idle_enough() {  # idle_enough <dir>
  local mt; mt="$(stat -c %Y "$1" 2>/dev/null || echo "$now")"
  [ "$(( now - mt ))" -ge "$GARDEN_STATE_CLONE_MIN_IDLE" ]
}

lock_is_stale() {  # lock_is_stale <clone-dir> — a fresh journal.lock means in-use
  local lock="${1}.lock" mt
  [ -e "$lock" ] || return 0
  mt="$(stat -c %Y "$lock" 2>/dev/null || echo "$now")"
  [ "$(( now - mt ))" -ge "$GARDEN_STATE_CLONE_MIN_IDLE" ]
}

# Snapshot every live process cwd ONCE per tick rather than per candidate: with
# thousands of candidates a per-candidate /proc walk dominates the whole run.
live_cwds=""
snapshot_live_cwds() {
  local l
  # shellcheck disable=SC2045
  for l in /proc/[0-9]*/cwd; do
    [ -e "$l" ] || continue
    live_cwds="$live_cwds
$(readlink -f "$l" 2>/dev/null || true)"
  done
}

has_live_process() {  # has_live_process <abs-dir>
  printf '%s' "$live_cwds" | grep -qF -e "$1"
}

# --- sweep --------------------------------------------------------------------
if ! load_live_doers; then
  log "journal unreachable; skipping this tick (fail-safe: keeping every clone)"
  exit 0
fi
snapshot_live_cwds

state_abs="$(cd "$GARDEN_STATE" 2>/dev/null && pwd)" || die "no \$GARDEN_STATE at $GARDEN_STATE"
swept=0; kept=0; deferred=0
declare -A swept_by_kind=()

for kind in $GARDEN_STATE_CLONE_KINDS; do
  [ -d "$state_abs/$kind" ] || continue
  # Fail safe: without systemd we cannot tell a live worker id from a dead one.
  if [ "$systemd_reachable" != true ] && [ "$kind" != inbox ]; then
    log "systemd unreachable; skipping unit-keyed kind '$kind' this tick (fail-safe: keeping its clones)"
    continue
  fi
  for clone in "$state_abs/$kind"/*/journal; do
    [ -d "$clone" ] || continue
    iddir="$(dirname "$clone")"
    id="$(basename "$iddir")"
    if kind_is_live "$kind" "$id"; then kept=$((kept+1)); continue; fi
    if ! idle_enough "$clone";  then kept=$((kept+1)); continue; fi
    if ! lock_is_stale "$clone"; then kept=$((kept+1)); continue; fi
    if has_live_process "$iddir"; then kept=$((kept+1)); continue; fi
    if [ "$swept" -ge "$GARDEN_STATE_CLONE_MAX_SWEEP" ]; then deferred=$((deferred+1)); continue; fi
    if [ "$DRY_RUN" = true ]; then
      log "would reclaim $kind/$id"
    else
      state_cleanup "$iddir"
      [ -e "$iddir" ] && { log "WARN: $kind/$id survived state_cleanup"; kept=$((kept+1)); continue; }
    fi
    swept=$((swept+1))
    swept_by_kind[$kind]=$(( ${swept_by_kind[$kind]:-0} + 1 ))
  done
done

summary=""
for kind in $GARDEN_STATE_CLONE_KINDS; do
  [ -n "${swept_by_kind[$kind]:-}" ] || continue
  summary="$summary $kind=${swept_by_kind[$kind]}"
done
verb=reclaimed; [ "$DRY_RUN" = true ] && verb="would reclaim"
log "$verb $swept clone(s)${summary:+ ($summary )}; kept $kept"
# Never a silent cap: a bounded sweep that reported plain success would read as
# "this host is clean" when it demonstrably is not.
if [ "$deferred" -gt 0 ]; then
  log "CAP: $deferred further clone(s) left for the next tick (GARDEN_STATE_CLONE_MAX_SWEEP=$GARDEN_STATE_CLONE_MAX_SWEEP)"
fi
exit 0
