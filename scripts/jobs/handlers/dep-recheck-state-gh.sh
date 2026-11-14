#!/bin/bash
# dep-recheck-state-gh.sh — render one bounded, content-free PR recheck state.
#
# Usage: dep-recheck-state-gh.sh <owner/name> <pr-number>
#
# Success prints one TSV record:
#   pr  head_oid  base_oid  blocker_fingerprint
#
# The fingerprint covers only merge blockers: draft/mergeability/review state and
# every non-success check identity + state. Check names never leave this handler.
# An unreadable, closed, malformed, or >100-context PR returns nonzero so the
# dependabotany preflight fails open to a botanist dispatch.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$HERE/../common.sh"
export GARDEN_TAG="dep-recheck-state"

repo="${1:?usage: dep-recheck-state-gh.sh <owner/name> <pr-number>}"
pr="${2:?usage: dep-recheck-state-gh.sh <owner/name> <pr-number>}"
[[ "$repo" =~ ^([^/]+)/([^/]+)$ ]] || die "invalid owner/name '$repo'"
owner="${BASH_REMATCH[1]}"; name="${BASH_REMATCH[2]}"
[[ "$pr" =~ ^[0-9]+$ ]] || die "invalid PR number '$pr'"

require_tools jq sha256sum "${GARDEN_GH:-gh}"

raw="$(mktemp)"; blockers="$(mktemp)"
trap 'rm -f "$raw" "$blockers"' EXIT

query='query($owner:String!,$name:String!,$number:Int!){repository(owner:$owner,name:$name){pullRequest(number:$number){number state isDraft mergeable reviewDecision headRefOid baseRefOid statusCheckRollup{contexts(first:100){nodes{__typename ... on CheckRun{name status conclusion checkSuite{workflowRun{workflow{name}}}} ... on StatusContext{context state}} pageInfo{hasNextPage}}}}}}'
gh_api_retry graphql -f query="$query" \
  -F owner="$owner" -F name="$name" -F number="$pr" > "$raw"

jq -e --argjson number "$pr" '
  .data.repository.pullRequest as $p
  | ($p.number == $number)
    and ($p.state == "OPEN")
    and (($p.isDraft | type) == "boolean")
    and (($p.mergeable // "") | test("^(MERGEABLE|CONFLICTING|UNKNOWN)$"))
    and (($p.reviewDecision // "") | test("^(|APPROVED|CHANGES_REQUESTED|REVIEW_REQUIRED)$"))
    and (($p.headRefOid // "") | test("^[0-9a-fA-F]{40,64}$"))
    and (($p.baseRefOid // "") | test("^[0-9a-fA-F]{40,64}$"))
    and (($p.statusCheckRollup == null)
      or ((($p.statusCheckRollup.contexts.pageInfo.hasNextPage // false) == false)
        and (($p.statusCheckRollup.contexts.nodes // null) | type == "array")))
' "$raw" >/dev/null || exit 1

# Canonicalize only state that can prevent a merge. Successful checks disappear;
# a blocker clearing, appearing, or changing state necessarily changes the hash.
jq -r '
  .data.repository.pullRequest as $p
  | [ "draft=" + ($p.isDraft | tostring),
      "mergeable=" + $p.mergeable,
      "review=" + ($p.reviewDecision // ""),
      "rollup=" + (if $p.statusCheckRollup == null then "absent" else "present" end) ]
    + [ ($p.statusCheckRollup.contexts.nodes // [])[]
        | ((.conclusion // .state // .status // "") | ascii_upcase) as $s
        | select($s != "SUCCESS" and $s != "NEUTRAL" and $s != "SKIPPED")
        | if .__typename == "CheckRun" and ((.name // "") | length) > 0
          then "check:" + (.checkSuite.workflowRun.workflow.name // "") + ":" + .name + "=" + $s
          elif .__typename == "StatusContext" and ((.context // "") | length) > 0
          then "status:" + .context + "=" + $s
          else error("malformed status context") end ]
  | sort[]
' "$raw" > "$blockers" || exit 1

head_oid="$(jq -r '.data.repository.pullRequest.headRefOid | ascii_downcase' "$raw")"
base_oid="$(jq -r '.data.repository.pullRequest.baseRefOid | ascii_downcase' "$raw")"
fingerprint="$(sha256sum < "$blockers" | cut -d' ' -f1)"
printf '%s\t%s\t%s\t%s\n' "$pr" "$head_oid" "$base_oid" "$fingerprint"
