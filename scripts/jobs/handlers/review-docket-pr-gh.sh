#!/bin/bash
# Return only trusted PR metadata used by the deterministic review docket.
set -euo pipefail
url="${1:?usage: review-docket-pr-gh.sh <canonical-pr-url>}"
now="$(date -u +%FT%TZ)"
GH="${GARDEN_GH:-gh}"
fields=headRefOid,state,statusCheckRollup,latestReviews,mergedAt,closedAt
err="$(mktemp)"
trap 'rm -f "$err"' EXIT

if json="$("$GH" pr view "$url" --json "$fields" 2>"$err")"; then
  :
elif grep -qE 'HTTP 403|Resource not accessible by|FORBIDDEN|403 Forbidden' "$err" \
    && ! grep -qi 'rate limit' "$err"; then
  # Fine-grained PATs can read the PR and Actions runs while GraphQL denies
  # PullRequest.statusCheckRollup. Re-read the metadata without that field so a
  # CI permission gap cannot discard trusted head, state, or review evidence,
  # then derive the best available CI view from the authorized Actions endpoint.
  [[ "$url" =~ ^https://github\.com/([^/]+)/([^/]+)/pull/([0-9]+)/?$ ]] \
    || { printf 'invalid canonical PR URL: %s\n' "$url" >&2; exit 2; }
  repo="${BASH_REMATCH[1]}/${BASH_REMATCH[2]}"
  json="$("$GH" pr view "$url" --json headRefOid,state,latestReviews,mergedAt,closedAt)"
  head="$(printf '%s' "$json" | jq -er '.headRefOid')"
  runs="$("$GH" api "repos/$repo/actions/runs?head_sha=$head&per_page=100")"
  checks="$(printf '%s' "$runs" | jq -ce '
    if (.workflow_runs | type) != "array" then error("no workflow_runs") else . end
    | [.workflow_runs[] | {
        status: ((.status // "") | ascii_upcase),
        conclusion: ((.conclusion // "") | ascii_upcase)
      }]')"
  json="$(printf '%s' "$json" | jq -c --argjson checks "$checks" \
    '. + {statusCheckRollup:$checks}')"
else
  cat "$err" >&2
  exit 1
fi

printf '%s' "$json" \
  | jq -c --arg now "$now" '
    def ci:
      [.statusCheckRollup[]? | ((.conclusion // .status // "") | ascii_upcase)] as $s
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
