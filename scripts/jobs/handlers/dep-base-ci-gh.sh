#!/bin/bash
# dep-base-ci-gh.sh — prove which failed Dependabot-PR checks already fail on base.
#
# Usage: dep-base-ci-gh.sh <owner/name> <pr-number>
#
# Success prints one TSV record:
#   shared  base_oid  head_oid  pr_failed  base_failed  shared_failed  all_shared
#
# It succeeds only when at least one exact check identity is failed on both the PR
# head and its exact base commit. CheckRun names and StatusContext contexts occupy
# separate namespaces. Empty rollups, no overlap, pagination beyond the fixed
# 100-context read, malformed data, and API failures all return nonzero so the
# watcher falls open to an ordinary botanist review.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$HERE/../common.sh"
GARDEN_TAG="dep-base-ci"

repo="${1:?usage: dep-base-ci-gh.sh <owner/name> <pr-number>}"
pr="${2:?usage: dep-base-ci-gh.sh <owner/name> <pr-number>}"
[[ "$repo" =~ ^([^/]+)/([^/]+)$ ]] || die "invalid owner/name '$repo'"
owner="${BASH_REMATCH[1]}"; name="${BASH_REMATCH[2]}"
[[ "$pr" =~ ^[0-9]+$ ]] || die "invalid PR number '$pr'"

require_tools jq "${GARDEN_GH:-gh}"

prf="$(mktemp)"; basef="$(mktemp)"; out="$(mktemp)"
trap 'rm -f "$prf" "$basef" "$out"' EXIT

query_pr='query($owner:String!,$name:String!,$number:Int!){repository(owner:$owner,name:$name){pullRequest(number:$number){state baseRefOid headRefOid statusCheckRollup{contexts(first:100){nodes{__typename ... on CheckRun{name status conclusion checkSuite{workflowRun{workflow{name}}}} ... on StatusContext{context state}} pageInfo{hasNextPage}}}}}}'
gh_api_retry graphql -f query="$query_pr" \
  -F owner="$owner" -F name="$name" -F number="$pr" > "$prf"

# Refuse a moving/closed/malformed PR and any rollup whose fixed page is incomplete.
jq -e '
  .data.repository.pullRequest as $p
  | ($p.state == "OPEN")
    and (($p.baseRefOid // "") | test("^[0-9a-fA-F]{40,64}$"))
    and (($p.headRefOid // "") | test("^[0-9a-fA-F]{40,64}$"))
    and (($p.statusCheckRollup.contexts.pageInfo.hasNextPage // false) == false)
    and (($p.statusCheckRollup.contexts.nodes // null) | type == "array")
' "$prf" >/dev/null || exit 1
base_oid="$(jq -r '.data.repository.pullRequest.baseRefOid' "$prf")"

query_base='query($owner:String!,$name:String!,$oid:GitObjectID!){repository(owner:$owner,name:$name){object(oid:$oid){__typename ... on Commit{oid statusCheckRollup{contexts(first:100){nodes{__typename ... on CheckRun{name status conclusion checkSuite{workflowRun{workflow{name}}}} ... on StatusContext{context state}} pageInfo{hasNextPage}}}}}}}'
gh_api_retry graphql -f query="$query_base" \
  -F owner="$owner" -F name="$name" -F oid="$base_oid" > "$basef"

jq -e --arg oid "$base_oid" '
  .data.repository.object as $c
  | ($c.__typename == "Commit")
    and (($c.oid // "") | ascii_downcase) == ($oid | ascii_downcase)
    and (($c.statusCheckRollup.contexts.pageInfo.hasNextPage // false) == false)
    and (($c.statusCheckRollup.contexts.nodes // null) | type == "array")
' "$basef" >/dev/null || exit 1

# GitHub's statusCheckRollup has already selected the current rollup entries. Keep
# only terminal failure-class results, deduplicate identities, and intersect them.
# Names never leave this handler: the watcher receives counts + immutable SHAs, so
# repository-controlled check text cannot become instructions in a job body.
jq -nr --slurpfile p "$prf" --slurpfile b "$basef" '
  def failure:
    ((.conclusion // .state // "") | ascii_upcase) as $c
    | $c == "FAILURE" or $c == "ERROR" or $c == "CANCELLED"
      or $c == "TIMED_OUT" or $c == "ACTION_REQUIRED" or $c == "STARTUP_FAILURE";
  def failed_keys:
    [ .[]
      | select(failure)
      | if .__typename == "CheckRun" and ((.name // "") | length) > 0
        then "check:" + (.checkSuite.workflowRun.workflow.name // "") + ":" + .name
        elif .__typename == "StatusContext" and ((.context // "") | length) > 0
        then "status:" + .context
        else empty end ] | unique;
  ($p[0].data.repository.pullRequest) as $pr
  | ($b[0].data.repository.object) as $base
  | ($pr.statusCheckRollup.contexts.nodes | failed_keys) as $pf
  | ($base.statusCheckRollup.contexts.nodes | failed_keys) as $bf
  | [$pf[] | select(. as $x | $bf | index($x))] as $shared
  | select(($shared | length) > 0)
  | ["shared", ($pr.baseRefOid | ascii_downcase), ($pr.headRefOid | ascii_downcase),
     ($pf | length), ($bf | length), ($shared | length),
     (if ($shared | length) == ($pf | length) then 1 else 0 end)]
  | @tsv
' > "$out"

[ -s "$out" ] || exit 1
cat "$out"
