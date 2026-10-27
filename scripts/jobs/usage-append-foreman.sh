#!/bin/bash
# usage-append-foreman.sh — write one usage row for a foreman `claude -p` call.
# The foreman's milestone generation runs no job session, so without this row its
# spend was unmetered, and under the road it would land in the maintainer's share
# (designs/budget-road.md § The foreman's part). Rows go to
# usage/foreman-<YYYYMMDD>.jsonl with role: foreman and the step's arc.
#
#   usage-append-foreman.sh <arc-or-empty> <step-base-or-empty> <measurement-json-file>
#
# Best-effort: accounting never fails a foreman tick.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$HERE/common.sh"

arc="${1:-}" step="${2:-}" mfile="${3:?usage: usage-append-foreman.sh <arc> <step> <measurement-file>}"
[ -s "$mfile" ] || exit 0
measurement="$(cat "$mfile")"
jq -e 'type == "object"' >/dev/null 2>&1 <<<"$measurement" || measurement='{"source":"none"}'
dir="${GARDEN_FOREMAN_CLONE:-$GARDEN_STATE/foreman/journal}"
ensure_clone "$dir"
day="$(date -u +%Y%m%d)"
row="$(jq -c --arg ts "$(date -u +%FT%TZ)" --arg host "$GARDEN" --arg arc "$arc" --arg step "$step" '
  . + {ts:$ts, base:"foreman", host:$host, outcome:"foreman", role:"foreman", provider:"anthropic", elapsed_s:(.elapsed_s // 0)}
  + (if $arc != "" then {arc:$arc} else {} end)
  + (if $step != "" then {step:$step} else {} end)' <<<"$measurement")" || exit 0
for attempt in $(seq 1 8); do
  sync_clone "$dir"
  mkdir -p "$dir/usage"
  printf '%s\n' "$row" >> "$dir/usage/foreman-$day.jsonl"
  git -C "$dir" add "usage/foreman-$day.jsonl" || exit 0
  rc=0; commit_and_push "$dir" "usage(foreman) ${arc:-unarced}" || rc=$?
  [ "$rc" -eq 0 ] && exit 0
  [ "$rc" -eq 2 ] && exit 0
  backoff "$attempt"
done
exit 0
