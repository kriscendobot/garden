#!/bin/bash
# Hermetic contract tests for handlers/dep-recheck-state-gh.sh.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HANDLER="$HERE/../handlers/dep-recheck-state-gh.sh"
TR="$(mktemp -d "${TMPDIR:-/tmp}/dep-recheck-state-test.XXXXXX")"
trap 'rm -rf "$TR"' EXIT

GH="$TR/gh"
cat > "$GH" <<'EOF'
#!/bin/bash
cat "${GH_FIXTURE:?}"
EOF
chmod +x "$GH"

FIX="$TR/pr.json"
jq -n '{data:{repository:{pullRequest:{
  number:17, state:"OPEN", isDraft:false, mergeable:"MERGEABLE",
  reviewDecision:"APPROVED",
  headRefOid:"1111111111111111111111111111111111111111",
  baseRefOid:"2222222222222222222222222222222222222222",
  statusCheckRollup:{contexts:{nodes:[
    {__typename:"CheckRun", name:"red", status:"COMPLETED", conclusion:"FAILURE",
     checkSuite:{workflowRun:{workflow:{name:"ci"}}}},
    {__typename:"StatusContext", context:"green", state:"SUCCESS"}
  ], pageInfo:{hasNextPage:false}}}
}}}}' > "$FIX"

run() {
  env GARDEN_TEST=1 GARDEN=test GARDEN_STATE="$TR/state" \
    GARDEN_API_COOLDOWN_SECS=0 GARDEN_GH="$GH" GH_FIXTURE="$1" \
    "$HANDLER" owner/repo 17
}

first="$(run "$FIX")"
[[ "$first" =~ ^17$'\t'1111111111111111111111111111111111111111$'\t'2222222222222222222222222222222222222222$'\t'[0-9a-f]{64}$ ]]

REORDER="$TR/reorder.json"
jq '.data.repository.pullRequest.statusCheckRollup.contexts.nodes |= reverse' "$FIX" > "$REORDER"
[ "$(run "$REORDER")" = "$first" ]

CLEARED="$TR/cleared.json"
jq '(.data.repository.pullRequest.statusCheckRollup.contexts.nodes[0].conclusion) = "SUCCESS"' "$FIX" > "$CLEARED"
[ "$(run "$CLEARED")" != "$first" ]

ABSENT="$TR/absent.json"
jq '.data.repository.pullRequest.statusCheckRollup = null' "$FIX" > "$ABSENT"
run "$ABSENT" >/dev/null

INCOMPLETE="$TR/incomplete.json"
jq '.data.repository.pullRequest.statusCheckRollup.contexts.pageInfo.hasNextPage = true' "$FIX" > "$INCOMPLETE"
if run "$INCOMPLETE" >/dev/null 2>&1; then
  echo "FAIL: incomplete status rollup was accepted" >&2
  exit 1
fi

echo "PASS: recheck state is bounded, order-stable, blocker-sensitive, and fail-open"
