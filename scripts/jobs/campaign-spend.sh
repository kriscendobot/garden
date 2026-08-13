#!/bin/bash
# campaign-spend.sh — derive one budgeted orchestration's recorded actual spend.
# Reads only the orchestration's enumerated child ledgers for enforcement, and
# never persists a mutable campaign counter. Cache reads are deliberately excluded.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="campaign-spend"

usage() {
  cat <<'EOF'
Usage: campaign-spend.sh [--dir SYNCED-JOURNAL] <campaign-base>

Print one JSON object containing the campaign's declared budget, derived token
spend, coverage, and current notional/real-equivalent reporting calibration.
EOF
}

directory=""
while [ $# -gt 0 ]; do
  case "$1" in
    --dir) directory="${2:?--dir needs a journal directory}"; shift 2;;
    -h|--help) usage; exit 0;;
    -*) die "unknown option: '$1'";;
    *) break;;
  esac
done
base="${1:?usage: campaign-spend.sh [--dir SYNCED-JOURNAL] <campaign-base>}"
[ $# -eq 1 ] || die "campaign-spend.sh accepts exactly one campaign base"
case "$base" in */*|.*|-*|'') die "illegal campaign base: '$base'";; esac

if [ -z "$directory" ]; then
  directory="${GARDEN_CAMPAIGN_CLONE:-$GARDEN_STATE/campaign-spend/journal}"
  ensure_clone "$directory"
  sync_clone "$directory"
fi

record="$directory/$JOBS_ORCH/$base.md"
[ -f "$record" ] || die "campaign '$base' has no orchestration record"
budget="$(orch_budget_tokens "$record")"
created_at="$(orch_created_at "$record")"
children="$(orch_children "$record")"
case "$budget" in ''|0|*[!0-9]*) die "campaign '$base' has invalid budget_tokens '$budget'";; esac
[ -n "$created_at" ] || die "campaign '$base' is missing created_at"
date -u -d "$created_at" +%s >/dev/null 2>&1 || die "campaign '$base' has invalid created_at '$created_at'"
[ -n "$children" ] || die "campaign '$base' names no children"
command -v jq >/dev/null 2>&1 || die "campaign-spend.sh needs jq"

matching_rows="$(mktemp "${TMPDIR:-/tmp}/garden-campaign-rows.XXXXXX")"
trap 'rm -f "$matching_rows"' EXIT

for child in $children; do
  ledger="$directory/usage/$child.jsonl"
  [ -e "$ledger" ] || continue
  [ -f "$ledger" ] && [ -r "$ledger" ] || die "campaign ledger usage/$child.jsonl is unreadable"
  line_number=0
  while IFS= read -r row || [ -n "$row" ]; do
    line_number=$((line_number + 1))
    [ -n "$row" ] || continue
    if ! jq -e 'type == "object"' >/dev/null 2>&1 <<<"$row"; then
      die "malformed JSON in usage/$child.jsonl line $line_number"
    fi
    jq -e '.ts | type == "string"' >/dev/null 2>&1 <<<"$row" \
      || die "usage/$child.jsonl line $line_number is missing a string ts"
    timestamp="$(jq -r '.ts' <<<"$row")"
    [ -n "$timestamp" ] || die "usage/$child.jsonl line $line_number is missing ts"
    date -u -d "$timestamp" +%s >/dev/null 2>&1 || die "usage/$child.jsonl line $line_number has invalid ts '$timestamp'"
    if ! jq -e '
      ([.input_tokens?, .output_tokens?, .cache_creation_tokens?, .cache_read_tokens?]
           | all(. == null or (type == "number" and . >= 0 and floor == .)))
      and (.total_cost_usd == null or (.total_cost_usd | type == "number" and . >= 0))
    ' >/dev/null 2>&1 <<<"$row"; then
      die "usage/$child.jsonl line $line_number has invalid token or cost accounting"
    fi
    [[ "$timestamp" < "$created_at" ]] && continue
    printf '%s\n' "$row" >> "$matching_rows"
  done < "$ledger"
done

campaign_summary="$(jq -sc '
  reduce .[] as $row ({engagements:0, spend_tokens:0, notional_usd:0, unpriced:0, unmetered:0};
    .engagements += 1
    | (($row.source == "none")
       or ([$row.input_tokens?, $row.output_tokens?, $row.cache_creation_tokens?, $row.cache_read_tokens?]
           | all(. == null))) as $unmetered
    | .spend_tokens += (if $unmetered then 0 else
                          (($row.input_tokens // 0) + ($row.output_tokens // 0)
                           + ($row.cache_creation_tokens // 0))
                        end)
    | .notional_usd += ($row.total_cost_usd // 0)
    | .unpriced += (if $row.total_cost_usd == null then 1 else 0 end)
    | .unmetered += (if $unmetered then 1 else 0 end))
' "$matching_rows")" || die "could not aggregate campaign '$base'"

# Reporting-only calibration: the latest Friday 9 p.m. Pacific reset through
# now, divided by the real weekly cost of two $200/month subscriptions. Tests may
# pin the cutoff and clock without changing the admission quantity.
calibration_as_of="${GARDEN_CAMPAIGN_NOW:-$(date -u +%FT%TZ)}"
if [ -n "${GARDEN_CAMPAIGN_CALIBRATION_CUTOFF:-}" ]; then
  calibration_cutoff="$GARDEN_CAMPAIGN_CALIBRATION_CUTOFF"
else
  local_day="$(TZ=America/Los_Angeles date -d "$calibration_as_of" +%u)"
  local_clock="$(TZ=America/Los_Angeles date -d "$calibration_as_of" +%H%M%S)"
  days_since_friday=$(( (local_day + 2) % 7 ))
  if [ "$days_since_friday" -eq 0 ] && [ "$local_clock" -lt 210000 ]; then
    days_since_friday=7
  fi
  local_date="$(TZ=America/Los_Angeles date -d "$calibration_as_of - $days_since_friday days" +%F)"
  calibration_cutoff="$(TZ=America/Los_Angeles date -d "$local_date 21:00:00" -u +%FT%TZ)"
fi

fleet_notional="0"
if [ -d "$directory/usage" ]; then
  shopt -s nullglob
  fleet_ledgers=("$directory"/usage/*.jsonl)
  shopt -u nullglob
  if [ "${#fleet_ledgers[@]}" -gt 0 ]; then
    # Enforcement already validated every named campaign ledger strictly. The
    # fleet-wide price calibration is display metadata, so unrelated malformed
    # lines are ignored rather than turning them into an admission decision.
    fleet_notional="$(jq -Rn --arg cutoff "$calibration_cutoff" '
      [inputs | fromjson? | select((.ts // "") >= $cutoff) | (.total_cost_usd // 0)] | add // 0
    ' "${fleet_ledgers[@]}" 2>/dev/null || printf '0')"
  fi
fi

jq -cn --argjson budget "$budget" --argjson summary "$campaign_summary" \
  --argjson fleet_notional "$fleet_notional" --arg as_of "$calibration_as_of" '
  ($summary.spend_tokens) as $spend
  | ($fleet_notional / (400 * 12 / 52)) as $index
  | {budget_tokens:$budget,
     spend_tokens:$spend,
     unspent_tokens:([$budget - $spend, 0] | max),
     overshoot_tokens:([$spend - $budget, 0] | max),
     notional_usd:$summary.notional_usd,
     real_equivalent_usd:(if $index > 0 then ($summary.notional_usd / $index) else 0 end),
     notional_to_real_index:$index,
     calibration_as_of:$as_of,
     engagements:$summary.engagements,
     unpriced:$summary.unpriced,
     unmetered:$summary.unmetered}
'
