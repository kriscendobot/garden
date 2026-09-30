#!/bin/bash
# arc-spend.sh — derive one arc's spend from immutable usage ledgers.
#
# Two config schemas (designs/accountant-arc-apportionment.md § The arc):
#   schema 1  rolling window: spend over the trailing `window_seconds` (the
#             Ironhorse press arc; `press_interval_seconds` required).
#   schema 2  fixed weekly window: spend since `window_start`, rolled forward in
#             whole weeks, so a slice re-cut each week never inherits last week's
#             spend. `rank` and `summary` ride along; `token_cap` may be 0 (an arc
#             kept on the slate but unfunded this week).
# Exit codes: 2 no config, 3 malformed/inactive config, 4 untrusted ledger,
# 5 arc retired from the slate (its plans stay parked).
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$HERE/common.sh"
export GARDEN_TAG="arc-spend"

directory=""
now_epoch="${GARDEN_ARC_BUDGET_NOW:-$(date -u +%s)}"
while [ $# -gt 0 ]; do
  case "$1" in
    --dir) directory="${2:?--dir needs a journal directory}"; shift 2 ;;
    --now-epoch) now_epoch="${2:?--now-epoch needs an epoch}"; shift 2 ;;
    -h|--help)
      echo "Usage: arc-spend.sh [--dir SYNCED-JOURNAL] [--now-epoch EPOCH] <arc>"
      exit 0 ;;
    -*) die "unknown option: '$1'" ;;
    *) break ;;
  esac
done
arc="${1:?usage: arc-spend.sh [--dir DIR] [--now-epoch EPOCH] <arc>}"
[ $# -eq 1 ] || die "arc-spend.sh accepts exactly one arc"
case "$arc" in -*|*/*|.*|'') die "illegal arc: '$arc'" ;; esac
case "$now_epoch" in ''|*[!0-9]*) die "invalid now epoch: '$now_epoch'" ;; esac

if [ -z "$directory" ]; then
  directory="${GARDEN_ARC_SPEND_CLONE:-$GARDEN_STATE/arc-spend/journal}"
  ensure_clone "$directory"
  sync_clone "$directory"
fi
config="$directory/config/arc-budgets/$arc"
[ -f "$config" ] || { log "arc '$arc' has no budget config"; exit 2; }
command -v jq >/dev/null 2>&1 || die "arc-spend.sh needs jq"

if jq -e --arg arc "$arc" '.schema == 2 and .status == "retired" and .arc == $arc' \
     "$config" >/dev/null 2>&1; then
  log "arc '$arc' is retired from the slate"
  exit 5
fi
schema="$(jq -r '.schema // empty' "$config" 2>/dev/null || true)"
case "$schema" in
  1)
    if ! jq -e --arg arc "$arc" '
      type == "object" and .schema == 1 and .status == "active" and .arc == $arc
      and (.token_cap | type == "number" and floor == . and . > 0)
      and (.window_seconds | type == "number" and floor == . and . > 0)
      and (.press_interval_seconds | type == "number" and floor == . and . > 0)
    ' "$config" >/dev/null 2>&1; then
      log "arc '$arc' has malformed or inactive budget config"
      exit 3
    fi
    window_seconds="$(jq -r '.window_seconds' "$config")"
    cutoff_epoch=$(( now_epoch - window_seconds ))
    ;;
  2)
    if ! jq -e --arg arc "$arc" '
      type == "object" and .schema == 2 and .status == "active" and .arc == $arc
      and .window == "week"
      and (.token_cap | type == "number" and floor == . and . >= 0)
      and (.window_start | type == "string" and (try fromdateiso8601 catch null) != null)
      and ((.rank // 1) | type == "number" and floor == . and . >= 0)
    ' "$config" >/dev/null 2>&1; then
      log "arc '$arc' has malformed or inactive budget config"
      exit 3
    fi
    window_seconds=604800
    anchor="$(jq -r '.window_start | fromdateiso8601' "$config")"
    # Roll the anchor forward (or back) in whole weeks to the week containing now,
    # so a late carry-forward never lets last week's spend hold this week's slice.
    delta=$(( now_epoch - anchor ))
    weeks=$(( delta / window_seconds ))
    [ "$delta" -ge 0 ] || [ $(( delta % window_seconds )) -eq 0 ] || weeks=$(( weeks - 1 ))
    cutoff_epoch=$(( anchor + weeks * window_seconds ))
    ;;
  *)
    log "arc '$arc' has malformed or inactive budget config"
    exit 3 ;;
esac

token_cap="$(jq -r '.token_cap' "$config")"
cutoff="$(date -u -d "@$cutoff_epoch" +%FT%TZ)"
as_of="$(date -u -d "@$now_epoch" +%FT%TZ)"

ledgers=()
if [ -d "$directory/usage" ]; then
  if command -v rg >/dev/null 2>&1; then
    mapfile -t ledgers < <(rg -l --glob '*.jsonl' \
      '"arc"[[:space:]]*:[[:space:]]*"'"$arc"'"' "$directory/usage" 2>/dev/null || true)
  else
    mapfile -t ledgers < <(grep -El '"arc"[[:space:]]*:[[:space:]]*"'"$arc"'"' \
      "$directory"/usage/*.jsonl 2>/dev/null || true)
  fi
fi
if [ "${#ledgers[@]}" -eq 0 ]; then
  rows='[]'
else
  rows="$(jq -s --arg arc "$arc" --argjson cutoff_epoch "$cutoff_epoch" '
    [ .[] | select(.arc? == $arc) ] as $arc_rows
    | if any($arc_rows[];
        ((.ts? | type) != "string")
        or ((try (.ts | fromdateiso8601) catch null) == null)
        or ((.source? // "") == "none")
        or ([.input_tokens?, .output_tokens?, .cache_creation_tokens?] | all(. == null))
        or ([.input_tokens?, .output_tokens?, .cache_creation_tokens?]
            | any(. != null and (type != "number" or . < 0 or floor != .))))
      then error("unmetered or malformed matching arc usage row")
      else [ $arc_rows[] | select((.ts | fromdateiso8601) >= $cutoff_epoch) ] end
  ' "${ledgers[@]}" 2>/dev/null)" || { log "arc '$arc' usage ledger is untrusted"; exit 4; }
fi

jq -cn --arg arc "$arc" --arg cutoff "$cutoff" --arg as_of "$as_of" \
  --argjson cap "$token_cap" --argjson window "$window_seconds" \
  --argjson rows "$rows" --slurpfile cfg "$config" '
  ($cfg[0]) as $c
  | ($rows | map((.input_tokens // 0) + (.output_tokens // 0)
               + (.cache_creation_tokens // 0)) | add // 0) as $spend
  | {arc:$arc, schema:$c.schema, token_cap:$cap, window_seconds:$window,
     press_interval_seconds:($c.press_interval_seconds // null), cutoff:$cutoff,
     as_of:$as_of, spend_tokens:$spend, remaining_tokens:([$cap-$spend,0]|max),
     over_budget:($spend >= $cap), engagements:($rows|length),
     completions:([$rows[] | select(.outcome? == "tada") | .base] | unique | length)}
  + (if $c.schema == 2 then {window:"week", window_start:$cutoff,
       rank:($c.rank // null), summary:($c.summary // "")} else {} end)
'
