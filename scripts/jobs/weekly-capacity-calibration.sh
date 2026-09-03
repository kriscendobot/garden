#!/bin/bash
# weekly-capacity-calibration.sh — the deterministic, no-LLM weekly capacity
# calibration (designs/recurring-budget-calibration.md; designs/live-budget-admission.md
# open question 1). Measures each Claude account's real weekly capacity from the
# journal usage/ CostRecord ledger and records it, so the maintainer no longer
# hand-back-calculates a weekly token number.
#
# It is designed to run as the scheduler's `preflight:` hook on the
# weekly-at-Fri-21:00-America/Los_Angeles cadence (the confirmed subscription reset
# anchor): on each due tick it folds the week that just closed, upserts one
# weekly-capacity record per account keyed on (host, anchor), computes the
# max-over-trailing-N-weeks per account, rewrites the token bucket, and returns
# exit 2 ("no work") so the scheduler advances the anchor and posts NOTHING. Any
# other exit is fail-open: the scheduler treats the tick as work-present and
# dispatches the schedule's short investigation body. Wire it with:
#   GARDEN_SCHEDULE_PREFLIGHT=weekly-capacity-calibration.sh set-schedule.sh \
#     weekly-capacity weekly-at-Fri-21:00-America/Los_Angeles ...
# Run bare (no args) for an operator calibration; it then exits 0 on success.
#
# BOUNDARY — it MEASURES and RECORDS, it does not ACTUATE. It never writes
# config/budget-pools. Turning a measured capacity into an actuated cap (and thus
# into full-authority worker leveling) stays a deliberate maintainer act: promote a
# measured figure into config/budget-pools with provenance
# `weekly-capacity-calibration <date>`, and budget-level.sh then levels against it
# (see budget-level.sh's provenance gate and budget-pools-placeholder.tsv). This
# boundary is the audit's own lesson: do not wire an uncalibrated/auto-measured
# setpoint straight to a full-authority actuator (cybernetics-audit.md § 2.3). The
# auto-promotion question is an open maintainer decision already owned by
# recurring-budget-calibration.md and live-budget-admission.md open question 1.
#
# Idempotency is mandatory (the scheduler runs a preflight inside its CAS retry
# loop): the weekly-capacity append is an upsert keyed on (host, anchor) and the
# bucket refill is skipped when bucket.json's refilled_at already equals this
# anchor. A late/overlapping/re-run tick for one anchor therefore happens once.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG=weekly-capacity-calibration

: "${GARDEN_WEEKLY_CAL_TRAILING:=4}"     # trailing weekly records the max is taken over
: "${GARDEN_WEEKLY_CAL_ATTEMPTS:=3}"     # bounded CAS retries on a lost journal push
[[ "$GARDEN_WEEKLY_CAL_TRAILING" =~ ^[1-9][0-9]*$ ]] || GARDEN_WEEKLY_CAL_TRAILING=4
[[ "$GARDEN_WEEKLY_CAL_ATTEMPTS" =~ ^[1-9][0-9]*$ ]] || GARDEN_WEEKLY_CAL_ATTEMPTS=3

scheduled=false
[ "$#" -gt 0 ] && scheduled=true
finish() { if $scheduled; then exit 2; else exit 0; fi; }
# A hard failure returns non-(0|2) so the scheduler dispatches the investigation body.
fail() { log "WARN: weekly-capacity calibration could not complete: $1"; exit 1; }

if ! is_main_host; then
  log "follower host; weekly-capacity calibration is leader-only"
  finish
fi
command -v jq >/dev/null 2>&1 || fail "jq unavailable (cannot fold the usage ledger)"

now="${GARDEN_WEEKLY_CAL_NOW:-$(date -u +%s)}"
[[ "$now" =~ ^[0-9]+$ ]] || fail "invalid calibration clock '$now'"
this_anchor="$(GARDEN_USAGE_NOW="$now" meter_week_anchor_epoch "$now")" || fail "cannot resolve this week's reset anchor"
prior_anchor="$(GARDEN_USAGE_NOW="$now" meter_week_anchor_epoch "$((this_anchor - 1))")" || fail "cannot resolve the prior reset anchor"
anchor_iso="$(date -u -d "@$this_anchor" +%FT%TZ 2>/dev/null)" || fail "cannot format anchor"
win_start_iso="$(date -u -d "@$prior_anchor" +%FT%TZ 2>/dev/null)" || fail "cannot format window start"
computed_iso="$(date -u -d "@$now" +%FT%TZ 2>/dev/null)" || fail "cannot format compute time"

DIR="${GARDEN_WEEKLY_CAL_CLONE:-$GARDEN_STATE/weekly-capacity-calibration/journal}"
: "${GARDEN_CLAUDE_SUBSCRIPTIONS_FILE:=}"

# subscription_monthly_usd <host> — the account's real monthly subscription cost from
# config/claude-subscriptions, if configured. Empty when the file or row is absent
# (the notional-to-real index is then omitted from the record, per the design).
subscription_monthly_usd() {
  local host="$1" file="${GARDEN_CLAUDE_SUBSCRIPTIONS_FILE:-$DIR/config/claude-subscriptions}"
  [ -r "$file" ] || return 0
  awk -v want="$host" '
    /^[[:space:]]*#/ || /^[[:space:]]*$/ { next }
    $1 == want { print $2; found=1; exit }
    END { if (!found) exit 0 }
  ' "$file" 2>/dev/null
}

# _calibrate_once — do the whole fold/upsert/refill against the clone's current tip
# and stage the changes, then attempt one push. Re-callable after a sync for the CAS
# retry. Prints nothing on stdout; logs a one-line summary. Returns the push rc
# (0 landed / nothing-to-commit, non-zero lost-CAS or hard failure).
_calibrate_once() {
  local dir="$1"
  local usage_dir="$dir/usage" cap_dir="$dir/budget/weekly-capacity"
  local fold host billable notional eng unpriced unmetered
  local wc_file monthly real_weekly index record staged=0

  mkdir -p "$cap_dir" || return 1
  # Per-host fold of the closed week [prior_anchor, this_anchor). Resilient to a
  # partial/garbled line (fromjson? skips it). Missing usage dir → no accounts.
  fold=""
  if [ -d "$usage_dir" ]; then
    fold="$(find "$usage_dir" -maxdepth 1 -type f -name '*.jsonl' -print0 2>/dev/null \
      | xargs -0 -r cat 2>/dev/null \
      | jq -Rrn --argjson lo "$prior_anchor" --argjson hi "$this_anchor" '
          [ inputs | fromjson?
            | select((.ts // "" | fromdateiso8601? // -1) as $t | $t >= $lo and $t < $hi) ]
          | group_by(.host // "")
          | map(select(.[0].host // "" != "") | {
              host: .[0].host,
              billable: (map((.input_tokens//0)+(.output_tokens//0)+(.cache_creation_tokens//0)) | add // 0),
              notional: (map(.total_cost_usd // 0) | add // 0),
              eng: length,
              unpriced: (map(select(.total_cost_usd == null)) | length),
              unmetered: (map(select((.source? == "none") or (.input_tokens == null and .output_tokens == null and .cache_creation_tokens == null))) | length)
            })
          | .[] | [.host, .billable, .notional, .eng, .unpriced, .unmetered] | @tsv' 2>/dev/null)" \
      || return 1
  fi

  while IFS=$'\t' read -r host billable notional eng unpriced unmetered; do
    [ -n "$host" ] || continue
    wc_file="$cap_dir/$host.jsonl"
    # Upsert: skip if a record for this (host, anchor) already exists.
    if [ -f "$wc_file" ] && jq -e --arg a "$anchor_iso" 'select(.anchor == $a)' "$wc_file" >/dev/null 2>&1; then
      continue
    fi
    monthly="$(subscription_monthly_usd "$host")"
    real_weekly=""; index=""
    if [[ "$monthly" =~ ^[0-9]+([.][0-9]+)?$ ]]; then
      real_weekly="$(awk -v m="$monthly" 'BEGIN{printf "%.2f", m*12/52}')"
      awk "BEGIN{exit !($real_weekly>0)}" \
        && index="$(awk -v n="$notional" -v r="$real_weekly" 'BEGIN{printf "%.4f", n/r}')"
    fi
    record="$(jq -cn \
      --arg anchor "$anchor_iso" --arg ws "$win_start_iso" --arg we "$anchor_iso" \
      --arg host "$host" --argjson billable "$billable" --argjson notional "$notional" \
      --argjson eng "$eng" --argjson unpriced "$unpriced" --argjson unmetered "$unmetered" \
      --arg computed "$computed_iso" --arg real_weekly "$real_weekly" --arg index "$index" '
        {anchor:$anchor, window_start:$ws, window_end:$we, host:$host,
         billable_tokens:$billable, notional_usd:$notional,
         engagements:$eng, unpriced:$unpriced, unmetered:$unmetered, computed_at:$computed}
        + (if $real_weekly != "" then {real_weekly_usd:($real_weekly|tonumber)} else {} end)
        + (if $index != "" then {notional_to_real_index:($index|tonumber)} else {} end)' 2>/dev/null)" \
      || return 1
    printf '%s\n' "$record" >> "$wc_file" || return 1
    git -C "$dir" add "budget/weekly-capacity/$host.jsonl"
    staged=1
    log "weekly-capacity $host anchor=$anchor_iso billable=$billable notional=\$$notional eng=$eng${index:+ index=$index}"
  done <<<"$fold"

  # Rebuild the token bucket: capacity = sum over accounts of the max billable over
  # the trailing N weekly records. Idempotent on the anchor. Rewritten in place.
  local bucket="$dir/budget/bucket.json" old_refill
  old_refill="$(jq -r '.refilled_at // empty' "$bucket" 2>/dev/null || true)"
  if [ "$old_refill" != "$anchor_iso" ] && [ -d "$cap_dir" ] && compgen -G "$cap_dir/*.jsonl" >/dev/null; then
    local per_account capacity
    # Per account: the MAX billable over the trailing N weekly records (not the
    # average — a near-quota week reveals more about the ceiling than idle weeks;
    # design § 4). Combined capacity is the SUM of the per-account maxima (the two
    # subscriptions are independent quotas), even when each peaked in a different week.
    per_account="$(for wc_file in "$cap_dir"/*.jsonl; do
        [ -f "$wc_file" ] || continue
        jq -sc --argjson n "$GARDEN_WEEKLY_CAL_TRAILING" '
          { host: (map(.host) | last // ""),
            cap:  (sort_by(.anchor) | .[-$n:] | map(.billable_tokens // 0) | max // 0) }' "$wc_file" 2>/dev/null
      done | jq -sc 'map(select(.host != "")) | {obj: (map({key:.host, value:.cap}) | from_entries), sum: (map(.cap) | add // 0)}' 2>/dev/null || true)"
    if [ -n "$per_account" ]; then
      capacity="$(printf '%s' "$per_account" | jq -r '.sum')"
      mkdir -p "$dir/budget" || return 1
      printf '%s\n' "$per_account" | jq --arg refill "$anchor_iso" --arg computed "$computed_iso" \
        '{capacity: .sum, refilled_at: $refill, per_account_capacity: .obj, computed_at: $computed}' \
        > "$bucket" 2>/dev/null || return 1
      git -C "$dir" add "budget/bucket.json"
      staged=1
      log "token bucket refilled: capacity=$capacity refilled_at=$anchor_iso"
    fi
  fi

  [ "$staged" -eq 1 ] || { log "weekly-capacity: nothing new to record for anchor $anchor_iso (idempotent skip)"; return 0; }
  local rc=0
  commit_and_push "$dir" "weekly-capacity($GARDEN) calibrate anchor=$anchor_iso" || rc=$?
  # 0 landed, 2 nothing-to-commit (a concurrent identical calibration won) — both fine.
  [ "$rc" -eq 0 ] || [ "$rc" -eq 2 ]
}

ensure_clone "$DIR"
# Contain sync_clone's transient `exit GARDEN_OFFLINE_RC` / hard `die` so a journal
# outage fails open (skip this tick) rather than crashing with a raw controller code.
sync_rc=0
( sync_clone "$DIR" ) || sync_rc=$?
if [ "$sync_rc" -eq "$GARDEN_OFFLINE_RC" ]; then
  log "WARN: weekly-capacity preflight offline (journal clone/sync, rc=$sync_rc); skipping this tick, retry next cadence (fail-open)"
  finish
elif [ "$sync_rc" -ne 0 ]; then
  log "WARN: weekly-capacity preflight failed (journal clone/sync, rc=$sync_rc); skipping this tick, retry next cadence (fail-open)"
  finish
fi
sync_clone "$DIR"

if _calibrate_once "$DIR"; then
  finish
fi
for attempt in $(seq 2 "$GARDEN_WEEKLY_CAL_ATTEMPTS"); do
  backoff "$((attempt - 1))"
  if ( sync_clone "$DIR"; _calibrate_once "$DIR" ); then
    finish
  fi
done
log "WARN: weekly-capacity calibration exhausted $GARDEN_WEEKLY_CAL_ATTEMPTS journal-push attempts; the ledger will retry next cadence (fail-open)"
finish
