#!/bin/bash
# journal-contention-watch.sh — host-local journal latency/retry anomaly checker.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
# shellcheck source=journal-contention-lib.sh
source "$HERE/journal-contention-lib.sh"
export GARDEN_TAG=journal-contention-watch

: "${GARDEN_CONTENTION_STATE:=$GARDEN_STATE/journal-contention-watch}"
: "${GARDEN_CONTENTION_NOTICE:=$HERE/watchdog-notice.sh}"
: "${GARDEN_CONTENTION_WINDOW:=256}"
: "${GARDEN_CONTENTION_RING:=512}"
: "${GARDEN_CONTENTION_MAX_STEALS:=3}"
: "${GARDEN_CONTENTION_LATCH_MAX:=600}"
# Clone hard guard, calibrated 2026-09-23 against both hosts' live clones: healthy
# per-service journal clones span 0-128 packs (median 6, p90 40) and up to ~335 MB,
# with one compact 1-pack 1.9 GB outlier; the pathological clones were 4.2-90 GB at
# 1,391-40,806 packs. Size (the incidents: 6.6 GB, 105 GB) and gc.log are the real
# signals; pack count is kept only an order of magnitude above the healthy maximum,
# so a healthy clone is never flagged and never churn-rebuilt by the remedy.
: "${GARDEN_CONTENTION_CLONE_MAX_BYTES:=4294967296}"
: "${GARDEN_CONTENTION_MAX_PACKS:=1000}"
: "${GARDEN_CONTENTION_PUSH_CAP:=50}"
: "${GARDEN_CONTENTION_REMEDY:=1}"
: "${GARDEN_CONTENTION_REMEDY_INTERVAL:=21600}"
: "${GARDEN_CONTENTION_CADENCE:=300}"
# Fetch drift needs a real trend: enough samples over a long enough span, a newest
# median at or above the floor, and (a 1.5x rise or a projection to the hard guard
# within the horizon). A short-lived per-job inbox clone never qualifies.
: "${GARDEN_CONTENTION_DRIFT_FLOOR:=10}"
: "${GARDEN_CONTENTION_DRIFT_MIN_SAMPLES:=12}"
: "${GARDEN_CONTENTION_DRIFT_MIN_SPAN:=3600}"
: "${GARDEN_CONTENTION_DRIFT_HORIZON:=86400}"
# Samples older than this are ignored: without it one lock give-up paged forever.
: "${GARDEN_CONTENTION_MAX_AGE:=21600}"
# Storm guard: more than this many keys of one class active in one tick collapse
# into a single summary notice.
: "${GARDEN_CONTENTION_STORM_MAX:=5}"
# Only rings for clones under this garden root are analyzed (sanitized slug
# prefix); foreign paths (a test fixture sourcing common.sh against live state)
# are purged instead of paged. Tests set it empty.
GARDEN_CONTENTION_SLUG_PREFIX="${GARDEN_CONTENTION_SLUG_PREFIX-$(contention_clone_slug "$GARDEN_ROOT")_}"
: "${GARDEN_CONTENTION_NOW_EPOCH:=$(date -u +%s)}"
# Script-owned tick deadline, inside the unit's TimeoutStartSec=240: a SIGTERM
# mid-tick would lose the heartbeat and every notice/remedy after the killed clone.
# Stop starting clone work once less than RESERVE seconds of BUDGET remain, defer
# the rest to the next tick (deferred clones go first then), and still write the
# heartbeat. A clone rebuild starts only with REMEDY_MIN seconds left.
: "${GARDEN_CONTENTION_TICK_BUDGET:=210}"
: "${GARDEN_CONTENTION_RESERVE:=20}"
: "${GARDEN_CONTENTION_REMEDY_MIN:=120}"
: "${GARDEN_CONTENTION_TEST_SLUG_COST:=0}" # test hook: fake seconds charged per analyzed clone

mkdir -p "$GARDEN_CONTENTION_STATE"/{stats,confirm,alerts,remedy,remedy-await}
now="$GARDEN_CONTENTION_NOW_EPOCH"
export JC_SINCE=$(( now - GARDEN_CONTENTION_MAX_AGE ))
hard_fetch="$(awk -v cap="$GARDEN_FETCH_TIMEOUT" 'BEGIN { printf "%.6f", cap * 0.70 }')"

tick_charged=0
tick_remaining() { printf '%s' $(( GARDEN_CONTENTION_TICK_BUDGET - SECONDS - tick_charged - GARDEN_CONTENTION_RESERVE )); }

float_true() { awk "BEGIN { exit !($*) }"; }
ring() { printf '%s/%s/%s\n' "$GARDEN_CONTENTION_DIR" "$1" "$2"; }

notice_open() { # key body
  local key="$1" body="$2" marker="$GARDEN_CONTENTION_STATE/alerts/$1" bf
  [ -e "$marker" ] && return 0
  bf="$(mktemp)"; printf '%s\n' "$body" > "$bf"
  "$GARDEN_CONTENTION_NOTICE" "$key" "$bf"
  : > "$marker"; rm -f "$bf"
}
notice_close() {
  local key="$1" marker="$GARDEN_CONTENTION_STATE/alerts/$1" bf
  [ -e "$marker" ] || return 0
  bf="$(mktemp)"
  # shellcheck disable=SC2016
  printf 'Journal contention condition `%s` cleared on %s.\n' "$key" "$GARDEN" > "$bf"
  GARDEN_WATCHDOG_RECOVERY_IF_OPEN_ONLY=1 "$GARDEN_CONTENTION_NOTICE" --recovered "$key" "$bf"
  rm -f "$marker" "$bf"
}

# Baseline/drift conditions require two consecutive ticks; hard guards pass 1.
# Confirmed per-clone conditions are queued by class (PENDING_*) and opened after
# the sweep, so the storm guard can collapse a class-wide burst into one notice.
declare -A EVALUATED=() PENDING_BODY=() PENDING_CLASS=() CLASS_ACTIVE=()
condition_update() { # key active hard body [class]
  local key="$1" active="$2" hard="$3" body="$4" class="${5:-}" cf="$GARDEN_CONTENTION_STATE/confirm/$1" n=0
  EVALUATED[$key]=1
  if [ "$active" -eq 1 ]; then
    if [ "$hard" -eq 1 ]; then n=2
    else n="$(cat "$cf" 2>/dev/null || echo 0)"; case "$n" in *[!0-9]*|'') n=0;; esac; n=$((n+1)); fi
    printf '%s\n' "$n" > "$cf"
    if [ "$n" -ge 2 ]; then
      if [ -n "$class" ]; then
        PENDING_BODY[$key]="$body"; PENDING_CLASS[$key]="$class"
        CLASS_ACTIVE[$class]=$(( ${CLASS_ACTIVE[$class]:-0} + 1 ))
      else
        notice_open "$key" "$body"
      fi
    fi
  else
    rm -f "$cf"
    notice_close "$key"
  fi
  return 0
}

remedy_clone() { # clone slug reason; prints applied|backoff|disabled|deferred|out-of-scope
  local clone="$1" slug="$2" reason="$3" last=0 old ts
  local stamp="$GARDEN_CONTENTION_STATE/remedy/$slug"
  [ "$GARDEN_CONTENTION_REMEDY" = 1 ] || { printf 'disabled'; return 0; }
  case "${clone%/}/" in "${GARDEN_STATE%/}/"*) ;; *) printf 'out-of-scope'; return 0;; esac
  [ "${clone%/}" != "${GARDEN_STATE%/}" ] || { printf 'out-of-scope'; return 0; }
  last="$(cat "$stamp" 2>/dev/null || echo 0)"; case "$last" in *[!0-9]*|'') last=0;; esac
  if [ "$last" -gt 0 ] && [ $(( now - last )) -lt "$GARDEN_CONTENTION_REMEDY_INTERVAL" ]; then printf 'backoff'; return 0; fi
  ts="$(date -u -d "@$now" +%Y%m%dT%H%M%SZ 2>/dev/null || printf '%s' "$now")"
  old="${clone}.contention-old.${ts}"
  if (
    GARDEN_CLONE_LOCK_SOFT=1 GARDEN_LOCK_SOFT_WAIT="${GARDEN_CONTENTION_REMEDY_LOCK_WAIT:-2}"
    export GARDEN_CLONE_LOCK_SOFT GARDEN_LOCK_SOFT_WAIT
    # Fit the rebuild's bounded fetch attempts into what is left of the tick.
    fit=$(( $(tick_remaining) / (GARDEN_FETCH_TIMEOUT + GARDEN_FETCH_KILL_AFTER) ))
    [ "$fit" -ge 1 ] || fit=1
    if [ "$fit" -lt "$GARDEN_FETCH_RETRIES" ]; then export GARDEN_FETCH_RETRIES="$fit"; fi
    clone_lock "$clone"
    [ -e "$clone" ] || { clone_unlock "$clone"; exit 1; }
    mv -- "$clone" "$old"
    if [ -n "${GARDEN_CONTENTION_ENSURE_CLONE_CMD:-}" ]; then
      "$GARDEN_CONTENTION_ENSURE_CLONE_CMD" "$clone"
      clone_unlock "$clone"
    else
      ensure_clone "$clone" # re-entrant lock; ensure_clone releases it
    fi
    if [ "${GARDEN_CONTENTION_DELETE_SYNC:-0}" = 1 ]; then rm -rf -- "$old"
    else ( rm -rf -- "$old" >/dev/null 2>&1 & ) </dev/null >/dev/null 2>&1; fi
  ); then
    printf '%s\n' "$now" > "$stamp"
    log "rebuilt contention-affected clone $clone ($reason)"
    printf 'applied'
  else
    printf 'deferred'
  fi
}

# Returns 3 when the clone must be deferred to the next tick (deadline reached
# before its object accounting finished); nothing is recorded for it then.
analyze_clone() {
  local slug="$1" clone metrics budget fetch_stats lock_stats push_stats
  local fn fp50 fp95 fmed fmad fold fnew fmax ffirst flast
  local ln lp50 lp95 lmed lmad lold lnew
  local pn pp50 pp95 pmed pmad pold pnew pmax _
  local steals giveups cas server definite bytes packs gclog
  local fetch_hard=0 fetch_base=0 fetch_drift=0 lock_hard=0 lock_base=0 push_hard=0 push_base=0
  local clone_bad=0 clone_reason="" remedy="none" projected=0 elapsed=0 slope=0 to_cap=0
  local await_file="$GARDEN_CONTENTION_STATE/remedy-await/$slug" await_start=0 await_class="" remedy_class=""

  fetch_stats="$(jc_numeric_stats "$(ring fetch "$slug")" 1000000)"
  lock_stats="$(jc_numeric_stats "$(ring lock-wait "$slug")" 1000000)"
  push_stats="$(jc_numeric_stats "$(ring push-attempts "$slug")" 1)"
  IFS=$'\t' read -r fn fp50 fp95 fmed fmad fold fnew fmax ffirst flast <<< "$fetch_stats"
  IFS=$'\t' read -r ln lp50 lp95 lmed lmad lold lnew _ _ _ <<< "$lock_stats"
  IFS=$'\t' read -r pn pp50 pp95 pmed pmad pold pnew pmax _ _ <<< "$push_stats"
  steals="$(jc_ring_count "$(ring lock-steal "$slug")")"
  giveups="$(jc_ring_count "$(ring lock-giveup "$slug")")"
  cas="$(jc_ring_count "$(ring push-class "$slug")" cas)"
  server="$(jc_ring_count "$(ring push-class "$slug")" server-reject)"
  definite="$(jc_ring_count "$(ring push-class "$slug")" definite-fail)"
  clone=""; if jc_resolve_clone "$slug"; then clone="$JC_FOUND_CLONE"; fi
  if [ -n "$clone" ]; then
    budget="$(tick_remaining)"; [ "$budget" -gt 0 ] || return 3
    metrics="$(JC_METRICS_TIMEOUT="$budget" jc_clone_metrics "$clone")" || return 3
    IFS=$'\t' read -r bytes packs gclog <<< "$metrics"
  else bytes=0; packs=0; gclog=0; fi

  if [ "$fn" -gt 0 ] && float_true "$fmax >= $hard_fetch || $fp95 >= $hard_fetch"; then fetch_hard=1; fi
  if [ "$fn" -gt 0 ] && float_true "$fp95 >= 15 && $fp95 >= ($fmed + 3 * $fmad)"; then fetch_base=1; fi
  # The floor GATES drift: a rise from 2s to 4s is noise however steep its
  # projection (2026-09-23: newest median 2.09s paged "drift" under a 10s floor).
  if [ "$fn" -ge "$GARDEN_CONTENTION_DRIFT_MIN_SAMPLES" ] && [ "$flast" != - ] && [ "$ffirst" != - ]; then
    elapsed=$(( flast - ffirst ))
    if [ "$elapsed" -ge "$GARDEN_CONTENTION_DRIFT_MIN_SPAN" ] && float_true "$fnew >= $GARDEN_CONTENTION_DRIFT_FLOOR"; then
      if float_true "$fold <= 0 || $fnew >= 1.5 * $fold"; then fetch_drift=1; fi
      if float_true "$fnew > $fold"; then
        slope="$(awk -v a="$fold" -v b="$fnew" -v e="$elapsed" 'BEGIN { printf "%.9f", (b-a)/e }')"
        to_cap="$(awk -v n="$fnew" -v t="$hard_fetch" -v s="$slope" 'BEGIN { if (s>0) printf "%.0f", (t-n)/s; else print 999999999 }')"
        [ "$to_cap" -le "$GARDEN_CONTENTION_DRIFT_HORIZON" ] && projected=1
      fi
    fi
  fi
  [ "$projected" -eq 1 ] && fetch_drift=1

  if [ "$giveups" -gt 0 ] || [ "$steals" -gt "$GARDEN_CONTENTION_MAX_STEALS" ]; then lock_hard=1; fi
  if [ "$ln" -gt 0 ] && float_true "$lp95 >= $GARDEN_LOCK_WAIT && $lp95 >= ($lmed + 3 * $lmad)"; then lock_base=1; fi
  if [ "$ln" -ge 3 ] && float_true "$lnew >= 20 && ($lold <= 0 || $lnew >= 1.5 * $lold)"; then lock_base=1; fi
  if [ "$pn" -gt 0 ] && float_true "$pmax >= $GARDEN_CONTENTION_PUSH_CAP"; then push_hard=1; fi
  [ "$definite" -gt 0 ] && push_hard=1
  if [ "$pn" -gt 0 ] && float_true "$pp95 >= 5 && $pp95 >= ($pmed + 3 * $pmad)"; then push_base=1; fi
  if [ "$pn" -ge 3 ] && float_true "$pnew >= 3 && ($pold <= 0 || $pnew >= 1.5 * $pold)"; then push_base=1; fi

  if [ "$bytes" -ge "$GARDEN_CONTENTION_CLONE_MAX_BYTES" ]; then clone_bad=1; clone_reason="size ${bytes}B >= ${GARDEN_CONTENTION_CLONE_MAX_BYTES}B"; fi
  if [ "$packs" -ge "$GARDEN_CONTENTION_MAX_PACKS" ]; then clone_bad=1; clone_reason="${clone_reason:+$clone_reason; }packs $packs >= $GARDEN_CONTENTION_MAX_PACKS"; fi
  if [ "$gclog" -eq 1 ]; then clone_bad=1; clone_reason="${clone_reason:+$clone_reason; }gc.log present"; fi
  if [ -f "$await_file" ]; then
    read -r await_start await_class < "$await_file" || true
    case "$await_start" in *[!0-9]*|'') await_start=0;; esac
    # Do not close a rebuild notice merely because the old clone disappeared:
    # wait for one new, healthy fetch from the replacement clone.
    if [ "$fn" -gt 0 ] && [ "$flast" != - ] && [ "$flast" -gt "$await_start" ] \
      && [ "$fetch_hard" -eq 0 ] && [ "$clone_bad" -eq 0 ]; then
      rm -f "$await_file"; await_class=""
    elif [ "$await_class" = clone ]; then
      clone_bad=1; clone_reason="awaiting a healthy post-rebuild fetch"
    elif [ "$await_class" = fetch ]; then
      fetch_hard=1
    fi
  fi
  if [ -z "$await_class" ] && [ -n "$clone" ] && { [ "$clone_bad" -eq 1 ] || [ "$fetch_hard" -eq 1 ]; }; then
    if [ "$clone_bad" -eq 1 ]; then remedy_class=clone; else remedy_class=fetch; fi
    if [ "$(tick_remaining)" -lt "$GARDEN_CONTENTION_REMEDY_MIN" ]; then remedy="deferred-deadline" # no stamp: retried next tick
    else remedy="$(remedy_clone "$clone" "$slug" "${clone_reason:-fetch ${fmax}s near ${hard_fetch}s cap guard}")"; fi
    if [ "$remedy" = applied ]; then
      printf '%s %s\n' "$now" "$remedy_class" > "$await_file"
      # Old-clone latency must not keep the rebuilt clone anomalous forever. A
      # subsequent healthy fetch is required above before the notice closes.
      mkdir -p "$GARDEN_CONTENTION_DIR/fetch"
      : > "$(ring fetch "$slug")"
    fi
  fi

  {
    printf 'clone: %s\nslug: %s\n' "${clone:-unknown}" "$slug"
    printf 'fetch_count: %s\nfetch_p50_s: %s\nfetch_p95_s: %s\nfetch_max_s: %s\nfetch_cap_s: %s\n' "$fn" "$fp50" "$fp95" "$fmax" "$GARDEN_FETCH_TIMEOUT"
    printf 'lock_count: %s\nlock_p50_s: %s\nlock_p95_s: %s\nlock_steals: %s\nlock_giveups: %s\n' "$ln" "$lp50" "$lp95" "$steals" "$giveups"
    printf 'push_count: %s\npush_p50: %s\npush_p95: %s\npush_cas: %s\npush_server_reject: %s\npush_definite_fail: %s\n' "$pn" "$pp50" "$pp95" "$cas" "$server" "$definite"
    printf 'clone_bytes: %s\nclone_packs: %s\nclone_gc_log: %s\nremedy: %s\nchecked_at_epoch: %s\n' "$bytes" "$packs" "$gclog" "$remedy" "$now"
  } > "$GARDEN_CONTENTION_STATE/stats/$slug"

  condition_update "journal-fetch-slow-$slug" "$(( fetch_hard || fetch_base ))" "$fetch_hard" \
    "Journal fetch anomaly on $GARDEN for ${clone:-$slug}: p95=${fp95}s max=${fmax}s; hard guard=${hard_fetch}s (70% of ${GARDEN_FETCH_TIMEOUT}s cap); remedy=$remedy." fetch-slow
  condition_update "journal-fetch-drift-$slug" "$fetch_drift" 0 \
    "Journal fetch drift on $GARDEN for ${clone:-$slug}: oldest-third median=${fold}s newest-third median=${fnew}s over ${elapsed}s/${fn} samples; floor=${GARDEN_CONTENTION_DRIFT_FLOOR}s, 1.5x rise or projected-to-guard=${to_cap}s within ${GARDEN_CONTENTION_DRIFT_HORIZON}s." fetch-drift
  condition_update "journal-lock-contention-$slug" "$(( lock_hard || lock_base ))" "$lock_hard" \
    "Journal lock contention on $GARDEN for ${clone:-$slug}: p95=${lp95}s, giveups=$giveups, steals=$steals (max $GARDEN_CONTENTION_MAX_STEALS/window), wait floor=${GARDEN_LOCK_WAIT}s." lock-contention
  condition_update "journal-push-contention-$slug" "$(( push_hard || push_base ))" "$push_hard" \
    "Journal push contention on $GARDEN for ${clone:-$slug}: attempts p95=$pp95 max=$pmax (cap $GARDEN_CONTENTION_PUSH_CAP), classes cas=$cas server-reject=$server definite-fail=$definite." push-contention
  condition_update "journal-clone-oversized-$slug" "$clone_bad" 1 \
    "Journal clone guard on $GARDEN for ${clone:-$slug}: ${clone_reason:-healthy}; size=${bytes}B packs=$packs gc.log=$gclog; automatic remedy=$remedy." clone-oversized
}

# Trim every append-only ring before analysis. The recorder never pays this cost.
for signal_dir in "$GARDEN_CONTENTION_DIR"/*; do
  [ -d "$signal_dir" ] || continue
  [ "$(tick_remaining)" -gt 0 ] || break
  for sample_ring in "$signal_dir"/*; do [ -f "$sample_ring" ] && jc_trim_ring "$sample_ring"; done
done

# Clones deferred by the previous tick run first, so a slow tail is not starved.
deferred_file="$GARDEN_CONTENTION_STATE/deferred"
mapfile -t all_slugs < <(jc_all_slugs | LC_ALL=C sort -u | while IFS= read -r s; do
  if [ -z "$GARDEN_CONTENTION_SLUG_PREFIX" ] || [ "${s#"$GARDEN_CONTENTION_SLUG_PREFIX"}" != "$s" ]; then
    printf '%s\n' "$s"
  else
    # A foreign path's samples are not this garden's journal: purge, never page.
    rm -f "$GARDEN_CONTENTION_DIR"/*/"$s"
  fi
done)
mapfile -t ordered < <({
  if [ -f "$deferred_file" ]; then grep -Fxf <(printf '%s\n' "${all_slugs[@]}") "$deferred_file" || true; fi
  printf '%s\n' "${all_slugs[@]}"
} | awk 'NF && !seen[$0]++')
deferred=()
for slug in "${ordered[@]}"; do
  if [ "${#deferred[@]}" -gt 0 ] || [ "$(tick_remaining)" -le 0 ]; then deferred+=("$slug"); continue; fi
  rc=0; analyze_clone "$slug" || rc=$?
  case "$rc" in 0) ;; 3) deferred+=("$slug");; *) exit "$rc";; esac
  tick_charged=$(( tick_charged + GARDEN_CONTENTION_TEST_SLUG_COST ))
done

# Storm guard: open queued per-clone conditions, collapsing any class with more
# than STORM_MAX active keys this tick into ONE summary. Keys of a storming class
# are neither opened nor falsely "recovered"; the summary closes when it subsides.
declare -A STORM_LIST=()
for key in "${!PENDING_CLASS[@]}"; do
  class="${PENDING_CLASS[$key]}"
  if [ "${CLASS_ACTIVE[$class]:-0}" -gt "$GARDEN_CONTENTION_STORM_MAX" ]; then
    STORM_LIST[$class]="${STORM_LIST[$class]:-}- ${PENDING_BODY[$key]}"$'\n'
  else
    notice_open "$key" "${PENDING_BODY[$key]}"
  fi
done
for class in fetch-slow fetch-drift lock-contention push-contention clone-oversized; do
  key="journal-contention-storm-$class"; EVALUATED[$key]=1
  if [ -n "${STORM_LIST[$class]:-}" ]; then
    notice_open "$key" "Journal contention storm on $GARDEN: ${CLASS_ACTIVE[$class]} clones hit $class in one tick (storm guard > $GARDEN_CONTENTION_STORM_MAX; one shared cause is likelier than ${CLASS_ACTIVE[$class]} independent faults):
${STORM_LIST[$class]}"
  else
    notice_close "$key"
  fi
done

# Close any open notice whose key was not evaluated this tick and does not belong
# to a deferred clone: its clone vanished, its ring aged out, or it is a foreign
# (test-fixture) slug purged above. Without this, such a notice never recovers.
for marker in "$GARDEN_CONTENTION_STATE"/alerts/*; do
  [ -e "$marker" ] || continue
  key="${marker##*/}"
  [ -z "${EVALUATED[$key]+x}" ] || continue
  case "$key" in journal-outage-stuck|journal-contention-watch-overrun) continue ;; esac
  keep=0
  for d in "${deferred[@]}"; do [ "${key%-"$d"}" != "$key" ] && { keep=1; break; }; done
  [ "$keep" -eq 1 ] || notice_close "$key"
done

if [ "${#deferred[@]}" -gt 0 ]; then
  printf '%s\n' "${deferred[@]}" > "$deferred_file"
  log "tick deadline: deferred ${#deferred[@]} of ${#ordered[@]} clone(s) to the next tick (budget ${GARDEN_CONTENTION_TICK_BUDGET}s, reserve ${GARDEN_CONTENTION_RESERVE}s)"
  outcome=partial-poll
else
  rm -f "$deferred_file"; outcome=full-poll
fi

# Host-level outage episode: one full checker tick without a new skip closes it.
last_tick="$(jc_field "$GARDEN_CONTENTION_STATE/heartbeat" epoch)"; last_tick="${last_tick:-$(( now - GARDEN_CONTENTION_CADENCE ))}"
skip_ring="$(ring outage-skip host)"; recent_skips="$(awk -v since="$last_tick" '$1 >= since { n++ } END { print n+0 }' "$skip_ring" 2>/dev/null || echo 0)"
skip_total="$(jc_ring_count "$skip_ring")"
episode="$GARDEN_CONTENTION_STATE/outage-episode-start"
latch_active=0
if [ -f "$GARDEN_JOURNAL_OUTAGE_MARKER" ]; then
  expiry="$(head -1 "$GARDEN_JOURNAL_OUTAGE_MARKER" 2>/dev/null || echo 0)"
  case "$expiry" in *[!0-9]*|'') expiry=0;; esac
  [ "$expiry" -gt "$now" ] && latch_active=1
fi
if [ "$recent_skips" -gt 0 ]; then
  [ -f "$episode" ] || printf '%s\n' "$now" > "$episode"
else
  rm -f "$episode"
fi
episode_start="$(cat "$episode" 2>/dev/null || echo "$now")"
outage_age=$(( now - episode_start )); outage_stuck=0
[ "$recent_skips" -gt 0 ] && [ "$latch_active" -eq 1 ] && [ "$outage_age" -gt "$GARDEN_CONTENTION_LATCH_MAX" ] && outage_stuck=1
condition_update journal-outage-stuck "$outage_stuck" 1 \
  "Journal outage latch stuck on $GARDEN for ${outage_age}s (limit ${GARDEN_CONTENTION_LATCH_MAX}s); skips this tick=$recent_skips, trailing skips=$skip_total."
# Two consecutive partial ticks mean this host's clones no longer fit the budget.
condition_update journal-contention-watch-overrun "$([ "$outcome" = partial-poll ] && echo 1 || echo 0)" 0 \
  "Journal contention checker on $GARDEN cannot finish a tick inside its ${GARDEN_CONTENTION_TICK_BUDGET}s budget: deferred ${#deferred[@]} of ${#ordered[@]} clone(s) on consecutive ticks."
printf 'epoch: %s\nlast_tick_at: %s\noutcome: %s\ndeferred_clones: %s\ntick_elapsed_s: %s\noutage_skips: %s\noutage_latch_active: %s\n' \
  "$now" "$(date -u -d "@$now" +%FT%TZ)" "$outcome" "${#deferred[@]}" "$SECONDS" "$skip_total" "$latch_active" > "$GARDEN_CONTENTION_STATE/heartbeat"
