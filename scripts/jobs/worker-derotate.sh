#!/bin/bash
# worker-derotate.sh — take a silent host's worker capacity out of rotation, and put
# it back when its heartbeat resumes. Deterministic, NO LLM, leader-only.
#
# Usage:
#   worker-derotate.sh                         one tick (the scheduler runs it inline)
#   worker-derotate.sh adopt <host> <monk> <cleric>
#                                              hand a manually zeroed row to this
#                                              mechanism: it restores <monk> <cleric>
#                                              on the host's next fresh heartbeat
#   worker-derotate.sh status                  print every ownership marker
#
# WHAT IT OWNS. config/worker-leveling's per-host physical caps are the fleet-shared
# ceiling budget-level.sh apportions the monk envelope across. A host that stops
# heartbeating keeps its cap, so budget-level keeps reserving slots for workers that
# will never claim. This tick zeroes such a host's row and restores it exactly when
# the host returns. It never touches hosts/<host>'s own monks:/clerics: declaration
# (host-owned; set-workers.sh refuses cross-host writes); a zero cap merely excludes
# the host from budget-level's apportionment, so the live hosts absorb the envelope.
#
# LIVENESS has two independent legs. common.sh host_liveness is the SAME budget/live
# heartbeat predicate and GARDEN_HOST_OFFLINE_AFTER threshold the rolling-deploy
# canary rotation uses.  The control-plane leg also rejects a host when an addressed
# sysop operation has remained without its matching sysop-log record beyond
# GARDEN_SYSOP_LOG_STALE_AFTER.  A budget publisher can remain healthy while the
# sysop bridge is wedged; such a host must not keep capacity that the leader cannot
# operate.  The outstanding operation is also the probe, so an idle sysop topic is
# available (not falsely stale merely because sysop has had nothing to record).
#
# OWNERSHIP is a journal-durable marker, worker-derotate/<host>, committed in the
# SAME commit that zeroes the row, recording the exact prior caps (reason=, the
# worker_model_unsupported_latch metadata shape). It lives on the journal, not in
# host-local state, for the reason the foreman brake does: the leader that zeroed a
# host may not be the leader that sees it return. Transitions:
#   unavailable, no marker, row nonzero → zero row + write marker (one notice)
#   available, marker, row still 0 0    → restore recorded caps + drop marker
#   available/unavailable, marker, row not 0 0 → an operator re-set the row while it was
#                                      derotated: relinquish (drop the marker), never
#                                      overwrite their value
#   no marker, row 0 0               → an operator's zero: never restored by this tick
# The marker is itself the edge latch, so each episode posts exactly one derotation
# notice and one recovery notice, however many ticks it spans.
#
# FAIL SAFE, NOT TOWARD CAPACITY. A host with no parseable heartbeat is UNKNOWN, not
# offline: it is neither zeroed nor restored, and the condition is raised once
# (edge-latched) until it resolves. If the leader's OWN heartbeat reads stale, the
# leader's journal view is untrustworthy and the whole tick freezes loudly. An
# offline host must be observed offline on GARDEN_WORKER_DEROTATE_CONFIRM
# consecutive ticks (default 2) before it is zeroed, so one late sample does not
# churn the fleet. The leader never derotates itself: it is demonstrably running.
#
# Test seams: GARDEN_WORKER_DEROTATE_CLONE (journal clone), GARDEN_WORKER_DEROTATE_NOW
# (epoch clock), GARDEN_WORKER_DEROTATE_DWELL_DIR (host-local confirm streaks).
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG=worker-derotate

: "${GARDEN_WORKER_LEVELING_PATH:=config/worker-leveling}"
: "${GARDEN_WORKER_DEROTATE_PATH:=worker-derotate}"
: "${GARDEN_WORKER_DEROTATE_CONFIRM:=2}"
: "${GARDEN_SYSOP_LOG_STALE_AFTER:=120}"
: "${GARDEN_WORKER_DEROTATE_DWELL_DIR:=$GARDEN_STATE/worker-derotate/dwell}"
[[ "$GARDEN_WORKER_DEROTATE_CONFIRM" =~ ^[1-9][0-9]*$ ]] || GARDEN_WORKER_DEROTATE_CONFIRM=2
[[ "$GARDEN_SYSOP_LOG_STALE_AFTER" =~ ^[1-9][0-9]*$ ]] || GARDEN_SYSOP_LOG_STALE_AFTER=120

DIR="${GARDEN_WORKER_DEROTATE_CLONE:-$GARDEN_STATE/worker-derotate/journal}"
CFG="$DIR/$GARDEN_WORKER_LEVELING_PATH"
now_s() { printf '%s\n' "${GARDEN_WORKER_DEROTATE_NOW:-$(date -u +%s)}"; }
iso() { date -u -d "@$1" +%FT%TZ 2>/dev/null || printf '@%s\n' "$1"; }

# row_caps <host> — echo "<monk> <cleric>" from the synced worker-leveling, or
# nothing when the host has no row.
row_caps() {
  [ -f "$CFG" ] || return 0
  awk -v h="$1" '$1=="host"&&$2==h{print $3" "$4;exit}' "$CFG"
}
marker_file() { printf '%s/%s/%s\n' "$DIR" "$GARDEN_WORKER_DEROTATE_PATH" "$1"; }
marker_field() { sed -n "s/^$2:[[:space:]]*//p" "$(marker_file "$1")" 2>/dev/null | head -1; }
leveling_hosts() { [ -f "$CFG" ] && awk '$1=="host"&&$2!=""{print $2}' "$CFG" | sort -u; }

# sysop_control_liveness <host> <now-epoch> — rc 0 means no overdue operation;
# rc 1 means an operation is older than the sysop acknowledgement allowance and
# still has no matching durable sysop-log record. Messages and records are both in
# the already-synced journal snapshot, so this is a deterministic bridge check with
# no systemd or remote-host query. Ack messages share the host topic but are not
# operations and are deliberately ignored.
SYSOP_CONTROL_DETAIL=""
sysop_control_liveness() {
  local host="$1" now="$2" path msgid sent epoch age oldest_age=-1 oldest_id="" malformed_id=""
  for path in "$DIR/msgs/host/$host"/*.md; do
    [ -f "$path" ] || continue
    grep -q '^op:[[:space:]]*[^[:space:]]' "$path" 2>/dev/null || continue
    grep -q '^sysop_ack:' "$path" 2>/dev/null && continue
    msgid="${path##*/}"; msgid="${msgid%.md}"
    [ -f "$DIR/sysop-log/$host/$msgid.md" ] && continue
    sent="$(sed -n 's/^sent_at:[[:space:]]*//p' "$path" 2>/dev/null | head -1)"
    epoch=""; [ -z "$sent" ] || epoch="$(date -u -d "$sent" +%s 2>/dev/null || true)"
    if ! [[ "$epoch" =~ ^[0-9]+$ ]]; then malformed_id="${malformed_id:-$msgid}"; continue; fi
    age=$(( now - epoch )); [ "$age" -lt 0 ] && age=0
    if [ "$age" -gt "$oldest_age" ]; then oldest_age="$age"; oldest_id="$msgid"; fi
  done
  if [ -n "$malformed_id" ]; then
    SYSOP_CONTROL_DETAIL="unlogged sysop op $malformed_id has no parseable sent_at"
    return 1
  fi
  if [ "$oldest_age" -gt "$GARDEN_SYSOP_LOG_STALE_AFTER" ]; then
    SYSOP_CONTROL_DETAIL="unlogged sysop op $oldest_id is ${oldest_age}s old (stale threshold ${GARDEN_SYSOP_LOG_STALE_AFTER}s)"
    return 1
  fi
  if [ "$oldest_age" -ge 0 ]; then
    SYSOP_CONTROL_DETAIL="sysop op $oldest_id pending within allowance (${oldest_age}s old)"
  else
    SYSOP_CONTROL_DETAIL="no unlogged sysop operations"
  fi
  return 0
}

# set_row_caps <host> <monk> <cleric> — rewrite ONE host row in place, preserving
# every other line verbatim (fleet ceilings, comments, peer rows).
set_row_caps() {
  local tmp; tmp="$(mktemp)"
  awk -v h="$1" -v m="$2" -v c="$3" \
    '$1=="host"&&$2==h{print "host\t" h "\t" m "\t" c;next} {print}' "$CFG" >"$tmp" && mv "$tmp" "$CFG"
}

dwell_file() { printf '%s/%s\n' "$GARDEN_WORKER_DEROTATE_DWELL_DIR" "${1//[^A-Za-z0-9._-]/_}"; }
dwell_bump() {
  local f n=0; f="$(dwell_file "$1")"
  [ ! -f "$f" ] || n="$(head -1 "$f" 2>/dev/null || echo 0)"
  [[ "$n" =~ ^[0-9]+$ ]] || n=0; n=$((n+1))
  mkdir -p "${f%/*}" 2>/dev/null || true
  printf '%s\n' "$n" >"$f" 2>/dev/null || true
  printf '%s\n' "$n"
}
dwell_reset() { rm -f "$(dwell_file "$1")" 2>/dev/null || true; }

# restore_notice <host> <message> — close the derotation episode. The recovery
# amends the open notice when THIS host delivered it; after a leader handoff the
# new leader has no local alert record to close, so it posts a standalone notice.
restore_notice() {
  local skey="worker-derotate-$1"
  if [ -f "$GARDEN_STATE/alerts/${skey//[^A-Za-z0-9._-]/_}.last" ]; then
    alert_maintainer_clear "$skey" "$2"
  else
    alert_maintainer "worker-derotate-restored-$1" "RECOVERED: $2"
  fi
}

# journal_transition <message> <mutator> [args...] — CAS loop: sync, re-run the
# mutator against the fresh clone (it re-validates and returns 3 when the change no
# longer applies), commit exactly the leveling row + marker, push.
journal_transition() {
  local msg="$1" attempt rc; shift
  for attempt in $(seq 1 8); do
    sync_clone "$DIR"
    rc=0; "$@" || rc=$?
    if [ "$rc" -eq 3 ]; then clone_unlock "$DIR"; return 3; fi
    [ "$rc" -eq 0 ] || { clone_unlock "$DIR"; return "$rc"; }
    git -C "$DIR" add -A -- "$GARDEN_WORKER_LEVELING_PATH" "$GARDEN_WORKER_DEROTATE_PATH"
    rc=0; commit_and_push "$DIR" "$msg" || rc=$?
    [ "$rc" -ne 0 ] && [ "$rc" -ne 2 ] || return 0
    backoff "$attempt"
  done
  return 1
}

# --- mutators (run inside journal_transition against a freshly synced clone) ----
mut_derotate() {  # host reason detail
  local caps m c f
  caps="$(row_caps "$1")"; [ -n "$caps" ] || return 3
  read -r m c <<<"$caps"
  [ ! -f "$(marker_file "$1")" ] || return 3
  { [ "$m" = 0 ] && [ "$c" = 0 ]; } && return 3
  f="$(marker_file "$1")"; mkdir -p "${f%/*}"
  printf 'host: %s\nreason: %s\nprior_monk: %s\nprior_cleric: %s\nderotated_at: %s\nderotated_by: %s\ndetail: %s\n' \
    "$1" "$2" "$m" "$c" "$(iso "$(now_s)")" "$GARDEN" "$3" >"$f"
  set_row_caps "$1" 0 0
  PRIOR="$m $c"
}
mut_restore() {  # host
  local caps m c pm pc
  [ -f "$(marker_file "$1")" ] || return 3
  caps="$(row_caps "$1")"; read -r m c <<<"${caps:-x x}"
  { [ "$m" = 0 ] && [ "$c" = 0 ]; } || return 3
  pm="$(marker_field "$1" prior_monk)"; pc="$(marker_field "$1" prior_cleric)"
  [[ "$pm" =~ ^[0-9]+$ ]] && [[ "$pc" =~ ^[0-9]+$ ]] || return 4
  set_row_caps "$1" "$pm" "$pc"
  rm -f "$(marker_file "$1")"
  PRIOR="$pm $pc"
}
mut_relinquish() {  # host
  local caps m c
  [ -f "$(marker_file "$1")" ] || return 3
  caps="$(row_caps "$1")"; read -r m c <<<"${caps:-x x}"
  { [ "$m" = 0 ] && [ "$c" = 0 ]; } && return 3
  rm -f "$(marker_file "$1")"
}
mut_adopt() {  # host monk cleric
  local caps m c f
  caps="$(row_caps "$1")"; [ -n "$caps" ] || { echo "worker-derotate: no $GARDEN_WORKER_LEVELING_PATH row for '$1'" >&2; return 2; }
  read -r m c <<<"$caps"
  { [ "$m" = 0 ] && [ "$c" = 0 ]; } || { echo "worker-derotate: '$1' row is '$m $c', not '0 0'; adopt only a zeroed row" >&2; return 2; }
  f="$(marker_file "$1")"
  [ ! -f "$f" ] || { echo "worker-derotate: '$1' is already owned: $(marker_field "$1" reason) prior=$(marker_field "$1" prior_monk) $(marker_field "$1" prior_cleric)" >&2; return 2; }
  mkdir -p "${f%/*}"
  printf 'host: %s\nreason: operator-adopted\nprior_monk: %s\nprior_cleric: %s\nderotated_at: %s\nderotated_by: %s\ndetail: a manually zeroed row handed to worker-derotate for restore on heartbeat\n' \
    "$1" "$2" "$3" "$(iso "$(now_s)")" "$GARDEN" >"$f"
}

case "${1:-tick}" in
  adopt)
    host="${2:-}"; m="${3:-}"; c="${4:-}"
    [[ "$host" =~ ^[A-Za-z0-9._-]+$ ]] && [[ "$m" =~ ^[1-9][0-9]*$ ]] && [[ "$c" =~ ^[0-9]+$ ]] \
      || { echo "usage: worker-derotate.sh adopt <host> <monk-cap≥1> <cleric-cap>" >&2; exit 2; }
    ensure_clone "$DIR"
    rc=0; journal_transition "worker-derotate($host) adopt: restore $m $c on heartbeat (by $GARDEN)" mut_adopt "$host" "$m" "$c" || rc=$?
    [ "$rc" -eq 0 ] || exit "$rc"
    echo "worker-derotate: $host adopted; its next fresh heartbeat restores $m $c"
    exit 0 ;;
  status)
    ensure_clone "$DIR"; sync_clone "$DIR"; clone_unlock "$DIR"
    for f in "$DIR/$GARDEN_WORKER_DEROTATE_PATH"/*; do [ -f "$f" ] && { echo "== ${f##*/}"; cat "$f"; }; done
    exit 0 ;;
  tick) ;;
  *) echo "usage: worker-derotate.sh [adopt <host> <monk> <cleric> | status]" >&2; exit 2 ;;
esac

is_main_host || { log "not the leader; worker derotation is leader-only"; exit 0; }
fleet_draining && { log "leader draining; worker derotation suspended this tick"; exit 0; }

ensure_clone "$DIR"
sync_clone "$DIR"
clone_unlock "$DIR"
[ -f "$CFG" ] || { log "$GARDEN_WORKER_LEVELING_PATH absent; nothing to derotate"; exit 0; }
now="$(now_s)"

# Reference check: the leader is alive by construction, so a stale reading of its
# OWN heartbeat means this journal view (or heartbeat publishing) is broken, and
# every peer's staleness is suspect. Freeze rather than zero the fleet.
self_rc=0; host_liveness "$DIR" "$GARDEN" "$now" || self_rc=$?
if [ "$self_rc" -eq 1 ]; then
  if alert_maintainer_edge worker-derotate-self-stale "self-stale" \
"worker-derotate FROZEN on leader $GARDEN: the leader's own budget/live heartbeat reads stale ($HOST_LIVENESS_DETAIL), so its journal view cannot be trusted to judge peers offline. No host is zeroed or restored until the leader's heartbeat is fresh again."; then
    log "WARN: leader heartbeat stale ($HOST_LIVENESS_DETAIL); derotation frozen this tick"
  fi
  exit 0
fi
alert_maintainer_edge_clear worker-derotate-self-stale \
  "worker-derotate on $GARDEN: the leader's own heartbeat is fresh again; derotation resumed." >/dev/null || true

# The leader is never derotated, but its sysop bridge still needs the same explicit
# availability signal as every peer. This alert does not freeze peer judgement: a
# stopped sysop does not make the leader's synced journal view untrustworthy.
self_sysop_rc=0; sysop_control_liveness "$GARDEN" "$now" || self_sysop_rc=$?
if [ "$self_sysop_rc" -ne 0 ]; then
  alert_maintainer_edge "worker-derotate-sysop-stale-$GARDEN" stale \
    "Host $GARDEN control-plane operations are UNAVAILABLE: $SYSOP_CONTROL_DETAIL. Its budget heartbeat may still be fresh; inspect garden-sysop.service/timer and the addressed operation. (leader=$GARDEN)" >/dev/null || true
else
  alert_maintainer_edge_clear "worker-derotate-sysop-stale-$GARDEN" \
    "Host $GARDEN control-plane operations are available again: $SYSOP_CONTROL_DETAIL. (leader=$GARDEN)" >/dev/null || true
fi

while IFS= read -r h; do
  [ "$h" = "$GARDEN" ] && continue
  lrc=0; host_liveness "$DIR" "$h" "$now" || lrc=$?
  sysop_rc=0; sysop_control_liveness "$h" "$now" || sysop_rc=$?
  sysop_detail="$SYSOP_CONTROL_DETAIL"
  owned=false; [ -f "$(marker_file "$h")" ] && owned=true
  read -r m c <<<"$(row_caps "$h")"

  if [ "$sysop_rc" -ne 0 ]; then
    if alert_maintainer_edge "worker-derotate-sysop-stale-$h" stale \
"Host $h control-plane operations are UNAVAILABLE: $sysop_detail. Its budget heartbeat may still be fresh; worker-derotate will remove its capacity after confirmation. Inspect garden-sysop.service/timer and the addressed operation. (leader=$GARDEN)"; then
      log "WARN: $h sysop bridge stale ($sysop_detail); control-plane operations unavailable"
    fi
  else
    alert_maintainer_edge_clear "worker-derotate-sysop-stale-$h" \
      "Host $h control-plane operations are available again: $sysop_detail. (leader=$GARDEN)" >/dev/null || true
  fi

  if [ "$lrc" -eq 2 ]; then
    dwell_reset "$h"
    if alert_maintainer_edge "worker-derotate-unknown-$h" "$HOST_LIVENESS_DETAIL" \
"worker-derotate cannot judge $h: $HOST_LIVENESS_DETAIL. Its worker-leveling row ($m $c) is left exactly as is — neither zeroed nor restored — until a parseable budget/live heartbeat appears. (leader=$GARDEN)"; then
      log "WARN: $h liveness UNKNOWN ($HOST_LIVENESS_DETAIL); row left untouched"
    fi
    continue
  fi
  alert_maintainer_edge_clear "worker-derotate-unknown-$h" \
    "worker-derotate can judge $h again: $HOST_LIVENESS_DETAIL." >/dev/null || true

  # An operator re-set a derotated row: their value wins, the mechanism lets go.
  if $owned && ! { [ "$m" = 0 ] && [ "$c" = 0 ]; }; then
    rc=0; journal_transition "worker-derotate($h) relinquished: row re-set to '${m:-absent} ${c:-}' by an operator (by $GARDEN)" mut_relinquish "$h" || rc=$?
    if [ "$rc" -eq 0 ]; then
      log "$h row was re-set to '${m:-absent} ${c:-}' while derotated; ownership relinquished, row untouched"
      restore_notice "$h" "worker-derotate no longer manages $h: its worker-leveling row was re-set to '${m:-absent} ${c:-}' while it was derotated, so that operator value stands and nothing was restored. (leader=$GARDEN)"
    fi
    continue
  fi

  if [ "$lrc" -eq 0 ] && [ "$sysop_rc" -eq 0 ]; then
    dwell_reset "$h"
    $owned || continue
    PRIOR=""; rc=0
    journal_transition "worker-derotate($h) restored: host available (by $GARDEN)" mut_restore "$h" || rc=$?
    case "$rc" in
      0) log "$h is PRESENT again ($HOST_LIVENESS_DETAIL); restored worker-leveling caps $PRIOR"
         restore_notice "$h" "heartbeat and sysop control plane are available for $h ($HOST_LIVENESS_DETAIL; $sysop_detail); its config/worker-leveling caps are restored to $PRIOR (monk cleric), so budget-level will apportion it workers again. (leader=$GARDEN)" ;;
      3) log "$h restore no longer applies after re-sync; skipped" ;;
      4) alert_maintainer_edge "worker-derotate-bad-marker-$h" "bad-prior" \
"worker-derotate cannot restore $h: $GARDEN_WORKER_DEROTATE_PATH/$h has no valid prior_monk/prior_cleric. The row stays 0 0; fix or delete the marker and set the row by hand. (leader=$GARDEN)" || true ;;
      *) log "WARN: $h restore failed to land (rc=$rc); retrying next tick" ;;
    esac
    continue
  fi

  # Offline or control-plane unavailable.
  if $owned || [ -z "${m:-}" ] || { [ "$m" = 0 ] && [ "$c" = 0 ]; }; then
    dwell_reset "$h"; continue   # already derotated, or an operator's zero: not ours to take
  fi
  streak="$(dwell_bump "$h")"
  if [ "$streak" -lt "$GARDEN_WORKER_DEROTATE_CONFIRM" ]; then
    if [ "$lrc" -eq 0 ]; then confirm_detail="$sysop_detail"; else confirm_detail="$HOST_LIVENESS_DETAIL"; fi
    log "$h UNAVAILABLE ($confirm_detail); confirming $streak/$GARDEN_WORKER_DEROTATE_CONFIRM before derotating"
    continue
  fi
  if [ "$lrc" -eq 0 ]; then
    reason=control-plane-unavailable; detail="$sysop_detail"
  else
    reason=heartbeat-offline; detail="$HOST_LIVENESS_DETAIL"
  fi
  PRIOR=""; rc=0
  journal_transition "worker-derotate($h) zeroed: $reason, prior caps $m $c (by $GARDEN)" mut_derotate "$h" "$reason" "$detail" || rc=$?
  case "$rc" in
    0) dwell_reset "$h"
       log "$h is UNAVAILABLE ($detail); zeroed worker-leveling caps (prior $PRIOR recorded)"
       alert_maintainer "worker-derotate-$h" \
"Host $h is UNAVAILABLE: $detail.
worker-derotate zeroed its config/worker-leveling caps (were $PRIOR monk cleric) so budget-level stops reserving fleet slots for it; the exact prior caps are recorded in journal $GARDEN_WORKER_DEROTATE_PATH/$h. When its budget/live heartbeat and sysop control plane are both available the caps are restored automatically and this notice closes. To keep it out regardless, set its row by hand (any value other than 0 0 relinquishes the marker; delete the marker to keep 0 0). (leader=$GARDEN)" ;;
    3) dwell_reset "$h"; log "$h derotation no longer applies after re-sync; skipped" ;;
    *) log "WARN: $h derotation failed to land (rc=$rc); retrying next tick" ;;
  esac
done < <(leveling_hosts)
exit 0
