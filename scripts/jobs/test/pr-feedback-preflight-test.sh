#!/bin/bash
# pr-feedback-preflight-test.sh — deterministic regression coverage for the
# correlation-aware PR-feedback recheck gate.
#
# Fixtures are JSON evidence, not live GitHub data. They model the feedback's
# timestamp and reviewed head separately from later commits and comments, so an
# acknowledgement has to prove it belongs to THIS feedback.
set -euo pipefail
# Explicit positive test-context sentinel: protects this standalone suite even when
# invoked outside the test-tree entrypoint heuristic.
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PRE="$JOBS/gardening/pr-feedback-preflight.sh"
FIXTURES="$HERE/fixtures/pr-feedback-preflight"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true

TR=/home/kris/.garden-pr-feedback-preflight-test
rm -rf "$TR"; mkdir -p "$TR"
REPO=endojs/endo-but-for-bots
PR=722
CID=4699091386
REVIEWER=kriskowal

run_pre() {  # run_pre <fixture> [comment-id] [reviewer]
  local fixture="$1" cid="${2:-$CID}" reviewer="${3:-$REVIEWER}"
  local stub="$TR/evidence.sh"
  { printf '#!/bin/bash\ncat %q\n' "$FIXTURES/$fixture"; } > "$stub"; chmod +x "$stub"
  set +e
  OUT="$(env GARDEN=testhost GARDEN_STATE="$TR/state" GARDEN_NO_MAINTAINER_ALERT=1 \
               GARDEN_PREFLIGHT_EVIDENCE="$stub" \
               bash "$PRE" "$REPO" "$PR" "$cid" "$reviewer" 2>&1)"
  RC=$?
  set -e
}

expect() {  # expect <fixture> <rc> <description>
  run_pre "$1"
  [ "$RC" -eq "$2" ] && ok "$3" || bad "$3 (exit $RC, want $2: $OUT)"
}

hr; echo "STATIC — pr-feedback-preflight.sh parses"; hr
bash -n "$PRE" && ok "pr-feedback-preflight.sh parses" || bad "syntax error"

hr; echo "PROCEED — review body at an unchanged reviewed head"; hr
expect review-body-unchanged-head.json 0 "review-body feedback on unchanged head proceeds"

hr; echo "PROCEED — older generic acknowledgment"; hr
expect older-generic-ack.json 0 "older Addressed acknowledgment cannot resolve newer feedback"

hr; echo "PROCEED — unrelated comment acknowledgment"; hr
expect unrelated-comment-ack.json 0 "generic PR comment acknowledgment has no feedback correlation"

hr; echo "PROCEED — unrelated post-feedback commit acknowledgment"; hr
expect unrelated-commit-ack.json 0 "generic commit acknowledgment without reviewed SHA cannot resolve feedback"

hr; echo "NO-OP — genuine post-review peer resolution"; hr
expect genuine-peer-resolution.json 2 "post-review commit advances reviewed head and acknowledges reviewer"
grep -q "advancing reviewed head" <<<"$OUT" && ok "logged reviewed-head correlation" || bad "missing reviewed-head correlation log ($OUT)"

hr; echo "NO-OP — direct same-thread reply"; hr
expect same-thread-reply.json 2 "post-feedback same-thread reply resolves feedback"

hr; echo "NO-OP — explicit feedback-id citation"; hr
expect explicit-id-citation.json 2 "post-feedback id citation resolves feedback"

hr; echo "FAIL-OPEN — malformed/incomplete evidence"; hr
expect incomplete-evidence.json 0 "incomplete metadata proceeds rather than silently no-oping"

hr; echo "RESULT: $PASS passed, $FAIL failed"; hr
rm -rf "$TR"
[ "$FAIL" -eq 0 ]
