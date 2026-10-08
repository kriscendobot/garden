#!/bin/bash
# Return only trusted PR metadata used by the deterministic review docket.
set -euo pipefail
url="${1:?usage: review-docket-pr-gh.sh <canonical-pr-url>}"
now="$(date -u +%FT%TZ)"
GH="${GARDEN_GH:-gh}"
"$GH" pr view "$url" --json headRefOid,state,statusCheckRollup,latestReviews,mergedAt,closedAt \
  | jq -c --arg now "$now" '
    def ci:
      [.statusCheckRollup[]?.conclusion // .status // ""] as $s
      | if ($s|length)==0 then "unknown"
        elif any($s[]; .=="FAILURE" or .=="ERROR" or .=="CANCELLED" or .=="TIMED_OUT") then "red"
        elif any($s[]; .=="PENDING" or .=="QUEUED" or .=="IN_PROGRESS" or .=="") then "pending"
        elif all($s[]; .=="SUCCESS" or .=="NEUTRAL" or .=="SKIPPED") then "green"
        else "unknown" end;
    {head_oid:.headRefOid, state:(if .mergedAt then "MERGED" else .state end),
     completed_at:(.mergedAt // .closedAt // null), observed_at:$now,
     ci:{state:ci,observed_at:$now},
     reviews:[.latestReviews[]? | {id:(.id // "-"), state, author:.author.login,
       submitted_at:.submittedAt}]}
  '
