#!/bin/bash
# append-quota-checkpoint.sh — the durable ingestion point for a human-read Claude
# dashboard quota percentage, appended to the manual-checkpoint log
# (journal budget/manual-checkpoints/<subscription>.jsonl; see that dir's README for the row
# schema and the calibration this feeds — designs/manual-quota-calibration.md).
#
# WHY this exists: before this, a maintainer stated a percentage in chat and the
# liaison hand-wrote a JSONL row, re-deriving meter_spend_tokens / meter_sampled_at /
# meter_window_start_epoch / pairing_confidence from a subscription live contribution
# time — a bespoke, error-prone edit. This script does exactly that auto-fill
# deterministically and CAS-races the row onto the journal, so a checkpoint is one
# command, not a hand-edit.
#
# It RECORDS a human-verified data point; it does NOT actuate. Nothing here touches
# config/budget-pools or worker counts. Turning an accumulated set of checkpoints into
# a trusted cap is a separate, deliberate step (fit-quota-calibration.sh to MEASURE,
# then set-budget-pool.sh to PROMOTE) — the same measure/actuate boundary
# weekly-capacity-calibration.sh already draws.
#
#   append-quota-checkpoint.sh <subscription> <weekly_percent> [session_percent] [options]
#
# Options (all optional):
#   --checked-at ISO8601      wall-clock time of the human's dashboard read (default: now)
#   --weekly-resets-at ISO    when the weekly window resets (free text passthrough)
#   --session-resets-at ISO   when the 5-hour session window resets
#   --reported-by NAME        who read the dashboard (default: $GARDEN_CHECKPOINT_REPORTER or kriskowal)
#   --confidence LEVEL        override the auto-derived pairing_confidence
#                             (high|medium|low|none); use `high` ONLY when you KNOW spend
#                             did not move between the meter sample and the read (for example the
#                             claim gate was refusing every claim). The auto-derivation
#                             never asserts `high` on its own.
#   --note TEXT               free-text appended to the row's notes
#   --host-file PATH          read one live contribution from this file (testing)
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG=append-quota-checkpoint

usage() { echo "usage: append-quota-checkpoint.sh <subscription> <weekly_percent> [session_percent] [options]" >&2; exit 2; }

subscription="${1:-}"; [ -n "$subscription" ] || usage
case "$subscription" in -*|*/*|'') usage;; esac
shift
weekly_percent="${1:-}"; [ -n "$weekly_percent" ] || usage
[[ "$weekly_percent" =~ ^[0-9]+([.][0-9]+)?$ ]] || { echo "weekly_percent must be a number" >&2; exit 2; }
shift
session_percent=""
if [ "${1:-}" ] && [[ "${1}" != --* ]]; then session_percent="$1"; shift; fi
[ -z "$session_percent" ] || [[ "$session_percent" =~ ^[0-9]+([.][0-9]+)?$ ]] || { echo "session_percent must be a number" >&2; exit 2; }

checked_at=""; weekly_resets_at=""; session_resets_at=""; note=""
reported_by="${GARDEN_CHECKPOINT_REPORTER:-kriskowal}"; confidence_override=""; host_file=""
while [ "$#" -gt 0 ]; do
  case "$1" in
    --checked-at) checked_at="${2:?}"; shift 2;;
    --weekly-resets-at) weekly_resets_at="${2:?}"; shift 2;;
    --session-resets-at) session_resets_at="${2:?}"; shift 2;;
    --reported-by) reported_by="${2:?}"; shift 2;;
    --confidence) confidence_override="${2:?}"; shift 2;;
    --note) note="${2:?}"; shift 2;;
    --host-file) host_file="${2:?}"; shift 2;;
    *) echo "unknown option: $1" >&2; usage;;
  esac
done
if [ -n "$confidence_override" ]; then
  case "$confidence_override" in high|medium|low|none) ;; *) echo "--confidence must be high|medium|low|none" >&2; exit 2;; esac
fi
command -v jq >/dev/null 2>&1 || { echo "jq unavailable" >&2; exit 1; }

now_epoch="$(date -u +%s)"
[ -n "$checked_at" ] || checked_at="$(date -u -d "@$now_epoch" +%FT%TZ)"
# The reference instant for the pairing-age computation is the human's read time.
checked_epoch="$(date -u -d "$checked_at" +%s 2>/dev/null || echo "$now_epoch")"

DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
ensure_clone "$DIR"

# read_live <live-file> — echo "spend<TAB>window_start_epoch<TAB>sampled_at<TAB>sampled_at_epoch<TAB>status"
# from a budget/live/<subscription>/<host> snapshot, or empty if unreadable.
read_live() {
  local f="$1" spend win at at_ep status
  [ -r "$f" ] || return 1
  spend="$(sed -n 's/^spend:[[:space:]]*//p' "$f" | head -1)"
  win="$(sed -n 's/^window_start_epoch:[[:space:]]*//p' "$f" | head -1)"
  at="$(sed -n 's/^sampled_at:[[:space:]]*//p' "$f" | head -1)"
  at_ep="$(sed -n 's/^sampled_at_epoch:[[:space:]]*//p' "$f" | head -1)"
  status="$(sed -n 's/^status:[[:space:]]*//p' "$f" | head -1)"
  printf '%s\t%s\t%s\t%s\t%s\n' "$spend" "$win" "$at" "$at_ep" "$status"
}

# derive_confidence <age-seconds> — the auto-derived pairing_confidence from the snapshot
# age alone (never asserts `high`; that requires human knowledge that spend was frozen).
derive_confidence() {
  local age="$1"
  [[ "$age" =~ ^-?[0-9]+$ ]] || { echo none; return; }
  # A snapshot older than usage-meter.sh's own 30-min remote-staleness bound is not a
  # usable pairing; treat it as no pairing (percentage recorded alone).
  if [ "$age" -lt 0 ] || [ "$age" -gt 1800 ]; then echo none
  elif [ "$age" -le 900 ]; then echo medium
  else echo low
  fi
}

# downgrade_confidence <level> — knock a confidence down one notch. Used when a shared
# subscription's host samples are far apart (the aggregate pairing is looser than any
# single-host reading would be).
downgrade_confidence() {
  case "$1" in high) echo medium;; medium) echo low;; low) echo none;; *) echo none;; esac
}

# aggregate_live <live-dir> — for a (possibly shared) subscription, SUM spend across
# every mapped host contribution in budget/live/<subscription>/* whose meter window
# anchor matches the freshest sample's, and set the pairing globals for _append_once:
#   spend          the AGGREGATE token total across included hosts
#   win            the shared window_start_epoch (the reference anchor)
#   sampled_at     the OLDEST included sample's wall-clock time (conservative pairing instant)
#   sampled_ep     the OLDEST included sample's epoch (drives the age/confidence)
#   meter_hosts_json  an auditable per-host array (only when >1 host file exists), or ""
#   agg_note       free text about exclusions / a wide sample spread, or ""
#   agg_spread     seconds between the oldest and newest included sample (0 for one host)
# A host on a different (or stale) window anchor is EXCLUDED from the sum and noted,
# never summed — rows across a window change are not comparable. Leaves spend empty
# when no usable contribution exists. A single readable file behaves exactly like the
# pre-aggregation single-host read (no meter_hosts, no agg_note).
# NB: assigns the pairing globals WITHOUT `local` so bash dynamic scope reaches the
# caller's locals; its own scratch vars ARE local.
aggregate_live() {
  local live_dir="$1"
  spend=""; win=""; sampled_at=""; sampled_ep=""; meter_hosts_json=""; agg_note=""; agg_spread=0
  [ -d "$live_dir" ] || return 0
  local recs="" f l fspend fwin fat fatep _fstatus ref_win="" freshest=-1
  for f in "$live_dir"/*; do
    [ -f "$f" ] || continue
    l="$(read_live "$f" 2>/dev/null)" || continue
    IFS=$'\t' read -r fspend fwin fat fatep _fstatus <<<"$l"
    [[ "$fspend" =~ ^[0-9]+$ ]] && [[ "$fwin" =~ ^[0-9]+$ ]] && [[ "$fatep" =~ ^[0-9]+$ ]] || continue
    recs+="$(basename "$f")"$'\t'"$fspend"$'\t'"$fwin"$'\t'"$fat"$'\t'"$fatep"$'\n'
    # Reference window = the anchor of the freshest sample (README: shared-subscription
    # percent observations track the freshest sample).
    if [ "$fatep" -gt "$freshest" ]; then freshest="$fatep"; ref_win="$fwin"; fi
  done
  [ -n "$ref_win" ] || return 0
  local agg total inc exc minep oldest refw spread
  agg="$(printf '%s' "$recs" | awk -F'\t' -v ref="$ref_win" '
    { if ($3==ref) { tot+=$2; inc++; if(minep==""||$5<minep){minep=$5;oldest=$4}; if(maxep==""||$5>maxep){maxep=$5} }
      else { exc++ } }
    END { printf "%d\t%d\t%d\t%s\t%s\t%s\t%d",
                 tot, inc, exc, (minep==""?"":minep), (oldest==""?"":oldest), ref,
                 (maxep==""?0:maxep)-(minep==""?0:minep) }')"
  IFS=$'\t' read -r total inc exc minep oldest refw spread <<<"$agg"
  [ "${inc:-0}" -ge 1 ] || return 0
  spend="$total"; win="$refw"; sampled_ep="$minep"; sampled_at="$oldest"; agg_spread="${spread:-0}"
  # Only surface the per-host audit array and aggregation notes when aggregation is
  # actually meaningful (more than one host file). A single-host subscription stays
  # byte-for-byte as before.
  if [ "$(( inc + exc ))" -gt 1 ]; then
    meter_hosts_json="$(printf '%s' "$recs" | jq -R -s --argjson ref "$refw" '
      split("\n") | map(select(length>0)) | map(split("\t")) |
      map({host:.[0], spend:(.[1]|tonumber), window_start_epoch:(.[2]|tonumber),
           sampled_at:.[3], included:((.[2]|tonumber)==$ref)}
          + (if (.[2]|tonumber)==$ref then {} else {excluded_reason:"window \(.[2]) != reference \($ref)"} end))' 2>/dev/null || true)"
    local notes=()
    [ "${exc:-0}" -gt 0 ] && notes+=("$exc host(s) excluded from the sum on a mismatched meter window (see meter_hosts)")
    [ "${agg_spread:-0}" -gt 900 ] && notes+=("contributing samples span ${agg_spread}s; oldest used as the pairing instant and confidence lowered")
    if [ "${#notes[@]}" -gt 0 ]; then local IFS='; '; agg_note="${notes[*]}"; fi
  fi
}

_append_once() {
  local dir="$1"
  local cp_dir="$dir/budget/manual-checkpoints" cp_file
  cp_file="$cp_dir/$subscription.jsonl"
  mkdir -p "$cp_dir" || return 1

  local live spend win sampled_at sampled_ep status age confidence implied prev_win osc_note=""
  local meter_hosts_json="" agg_note="" agg_spread=0
  if [ -n "$host_file" ]; then
    # Single-file test mode: read exactly this one host, no aggregation (behaves as
    # the pre-aggregation script did; keeps --host-file usable for tests).
    if live="$(read_live "$host_file" 2>/dev/null)"; then
      IFS=$'\t' read -r spend win sampled_at sampled_ep status <<<"$live"
    fi
  else
    # Aggregate across every mapped host of this (possibly shared) subscription.
    aggregate_live "$dir/budget/live/$subscription"
  fi
  # Sanitize: only accept numeric spend / epoch; otherwise the pairing is unusable.
  [[ "${spend:-}" =~ ^[0-9]+$ ]] || spend=""
  [[ "${sampled_ep:-}" =~ ^[0-9]+$ ]] || sampled_ep=""
  [[ "${win:-}" =~ ^[0-9]+$ ]] || win=""

  if [ -n "$spend" ] && [ -n "$sampled_ep" ]; then
    age=$(( checked_epoch - sampled_ep ))
    confidence="$(derive_confidence "$age")"
    # Shared subscription with widely-separated host samples: the aggregate pairing is
    # looser than any single reading, so knock the auto-derived confidence down a notch.
    if [ -n "$meter_hosts_json" ] && [ "${agg_spread:-0}" -gt 900 ] && [ "$confidence" != none ]; then
      confidence="$(downgrade_confidence "$confidence")"
    fi
  else
    confidence="none"; spend=""; sampled_at=""; win=""
  fi
  [ -z "$confidence_override" ] || confidence="$confidence_override"

  # implied_weekly_cap_tokens = spend / (weekly_percent/100), only for a usable pairing.
  implied=""
  if [ "$confidence" != none ] && [ -n "$spend" ] \
     && awk -v p="$weekly_percent" 'BEGIN{exit !(p>0)}'; then
    implied="$(awk -v s="$spend" -v p="$weekly_percent" 'BEGIN{printf "%.0f", s/(p/100)}')"
  fi

  # Oscillation guard: if the prior row for this host carried a different meter window
  # anchor, flag it — rows across a window_start_epoch change are NOT comparable
  # (manual-checkpoints/README.md escalation).
  if [ -n "$win" ] && [ -f "$cp_file" ]; then
    prev_win="$(jq -r 'select(.meter_window_start_epoch != null) | .meter_window_start_epoch' "$cp_file" 2>/dev/null | tail -1)"
    if [ -n "$prev_win" ] && [ "$prev_win" != "null" ] && [ "$prev_win" != "$win" ]; then
      osc_note="WINDOW ANCHOR CHANGED since the prior row ($prev_win -> $win); this row is NOT comparable to earlier rows across the boundary (see README oscillation escalation)."
    fi
  fi

  local full_note="$note"
  [ -z "$osc_note" ] || full_note="${full_note:+$full_note }$osc_note"
  [ -z "$agg_note" ] || full_note="${full_note:+$full_note }$agg_note"

  local mh="${meter_hosts_json:-}"; [ -n "$mh" ] || mh=null
  local row
  row="$(jq -cn \
    --arg checked_at "$checked_at" --arg subscription "$subscription" --arg reported_by "$reported_by" \
    --arg weekly_percent "$weekly_percent" --arg weekly_resets_at "$weekly_resets_at" \
    --arg session_percent "$session_percent" --arg session_resets_at "$session_resets_at" \
    --arg spend "$spend" --arg sampled_at "$sampled_at" --arg win "$win" \
    --arg confidence "$confidence" --arg implied "$implied" --arg notes "$full_note" \
    --argjson meter_hosts "$mh" '
    {checked_at:$checked_at, subscription_id:$subscription, reported_by:$reported_by,
     weekly_percent:($weekly_percent|tonumber)}
    + (if $weekly_resets_at != "" then {weekly_resets_at:$weekly_resets_at} else {} end)
    + (if $session_percent != "" then {session_percent:($session_percent|tonumber)} else {} end)
    + (if $session_resets_at != "" then {session_resets_at:$session_resets_at} else {} end)
    + {meter_spend_tokens:(if $spend != "" then ($spend|tonumber) else null end),
       meter_sampled_at:(if $sampled_at != "" then $sampled_at else null end),
       meter_window_start_epoch:(if $win != "" then ($win|tonumber) else null end),
       pairing_confidence:$confidence,
       implied_weekly_cap_tokens:(if $implied != "" then ($implied|tonumber) else null end)}
    + (if $meter_hosts != null then {meter_hosts:$meter_hosts} else {} end)
    + (if $notes != "" then {notes:$notes} else {} end)' 2>/dev/null)" || return 1
  [ -n "$row" ] || return 1

  printf '%s\n' "$row" >> "$cp_file" || return 1
  git -C "$dir" add "budget/manual-checkpoints/$subscription.jsonl" || return 1
  log "checkpoint $subscription weekly=$weekly_percent% spend=${spend:-none} confidence=$confidence implied=${implied:-none}"
  local rc=0
  commit_and_push "$dir" "manual-checkpoint($subscription) weekly=$weekly_percent% confidence=$confidence" || rc=$?
  [ "$rc" -eq 0 ] || [ "$rc" -eq 2 ]
}

sync_clone "$DIR"
if _append_once "$DIR"; then exit 0; fi
for attempt in 2 3 4 5 6 7 8; do
  backoff "$((attempt - 1))"
  if ( sync_clone "$DIR"; _append_once "$DIR" ); then exit 0; fi
done
echo "append-quota-checkpoint: exhausted journal-push attempts" >&2
exit 1
