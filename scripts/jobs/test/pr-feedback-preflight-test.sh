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

# --- live-path harness (no GARDEN_PREFLIGHT_EVIDENCE) --------------------------
# The fixture stub above short-circuits BEFORE the real gh/jq plumbing, so it can
# never exercise the argv-size bug or the gather-failure reporting. These tests
# instead stub `gh` on PATH and drive the genuine gather_evidence path, with a
# review-comment corpus deliberately larger than MAX_ARG_STRLEN (131072 B).
REVIEWED_SHA=7fe035b52869c9b29bf298574924cdb2bc74301d

make_live_gh() {  # make_live_gh -> writes $TR/bin/gh dispatching on the API path
  mkdir -p "$TR/bin"
  cat > "$TR/bin/gh" <<'GH'
#!/bin/bash
# Fake gh for the preflight live-path tests. Dispatches on the endpoint path (the
# last argument) to a canned fixture; honors GH_FAIL_PULL / GH_FAIL_PULL_MSG to
# simulate a transport failure on the pull fetch.
path=""; for a in "$@"; do path="$a"; done
case "$path" in
  *"/reviews/"*)  cat "$GH_REVIEW" ;;
  *"/comments"*)  cat "$GH_COMMENTS" ;;
  *"/commits"*)   cat "$GH_COMMITS" ;;
  *"/pulls/"*)
    if [ "${GH_FAIL_PULL:-0}" = 1 ]; then
      printf '%s\n' "${GH_FAIL_PULL_MSG:-gh: HTTP 503 upstream boom}" >&2; exit 1
    fi
    cat "$GH_PULL" ;;
  *) printf 'fake gh: unexpected path: %s\n' "$path" >&2; exit 1 ;;
esac
GH
  chmod +x "$TR/bin/gh"
}

# big_comments <path> [resolving] — writes a comments array > 131072 B. When
# resolving=1 the first comment is a same-thread reply to CID (which must resolve
# to NO-OP), proving the oversized corpus was parsed, not truncated or dropped.
big_comments() {
  local path="$1" resolving="${2:-0}" head='[]'
  [ "$resolving" = 1 ] && head='[{"id":990,"in_reply_to_id":'"$CID"',"created_at":"2026-07-14T22:42:00Z","body":"Done."}]'
  jq -c --argjson head "$head" -n '
    $head + [ range(0;400) | {
      id: (. + 1000),
      in_reply_to_id: null,
      created_at: "2026-07-10T00:00:00Z",
      body: ("padding-" + ("x" * 500))
    } ]' > "$path"
}

run_live() {  # run_live <comments-file> [pull-fail-msg] — genuine gather path
  local comments="$1" fail_msg="${2:-}"
  make_live_gh
  printf '{"id":%s,"submitted_at":"2026-07-14T22:40:24Z","commit_id":"%s","body":"please fix"}\n' \
    "$CID" "$REVIEWED_SHA" > "$TR/review.json"
  printf '{"head":{"sha":"%s"}}\n' "$REVIEWED_SHA" > "$TR/pull.json"
  printf '[]\n' > "$TR/commits.json"
  rm -f "$TR/alert.log"
  # Quoted array expansion keeps a multi-word failure message a SINGLE env entry.
  local -a fail_env=()
  [ -n "$fail_msg" ] && fail_env=(GH_FAIL_PULL=1 GH_FAIL_PULL_MSG="$fail_msg")
  set +e
  OUT="$(env -u GARDEN_PREFLIGHT_EVIDENCE \
             PATH="$TR/bin:$PATH" \
             GARDEN=testhost GARDEN_STATE="$TR/state" \
             GARDEN_ALERT_CMD="$TR/alert-sink.sh" \
             GH_REVIEW="$TR/review.json" GH_PULL="$TR/pull.json" \
             GH_COMMITS="$TR/commits.json" GH_COMMENTS="$comments" \
             "${fail_env[@]}" \
             bash "$PRE" "$REPO" "$PR" "$CID" "$REVIEWER" 2>&1)"
  RC=$?
  set -e
}

# alert sink: records that a maintainer alert fired, with its body.
printf '#!/bin/bash\nprintf "%%s\\n" "$2" >> %q\n' "$TR/alert.log" > "$TR/alert-sink.sh"
chmod +x "$TR/alert-sink.sh"

# --- issue-comment (PR conversation) target-resolution harness ----------------
# When the triggering id is a PR CONVERSATION comment, the review and inline-comment
# surfaces 404 and resolution must fall through to issues/comments/<id>. These tests
# drive the genuine gather path with a fake gh whose dispatch distinguishes the
# single-object target lookups from the paginated corpus fetches, and prove: the id
# now RESOLVES (no gather-failure alert), reviewed_head_sha is the current head, and a
# citation in either a commit or a CONVERSATION comment reaches NO-OP.
make_live_gh_issue() {  # make_live_gh_issue -> gh where the target is an issue comment
  mkdir -p "$TR/bin"
  cat > "$TR/bin/gh" <<'GH'
#!/bin/bash
# Fake gh for the issue-comment target-resolution tests. The review and inline-comment
# surfaces 404 so resolution falls through to issues/comments/<id>. Order matters: the
# single-object target lookups (/pulls/comments/<id>, /issues/comments/<id>) must be
# matched BEFORE the paginated corpus fetches (/pulls/<pr>/comments, /issues/<pr>/comments).
path=""; for a in "$@"; do path="$a"; done
case "$path" in
  *"/pulls/"*"/reviews/"*)   printf 'gh: HTTP 404 Not Found\n' >&2; exit 1 ;;
  *"/pulls/comments/"*)      printf 'gh: HTTP 404 Not Found\n' >&2; exit 1 ;;
  *"/issues/comments/"*)     cat "$GH_ISSUE_COMMENT" ;;
  *"/issues/"*"/comments"*)  cat "$GH_ISSUE_CORPUS" ;;
  *"/pulls/"*"/comments"*)   cat "$GH_INLINE_CORPUS" ;;
  *"/commits"*)              cat "$GH_COMMITS" ;;
  *"/pulls/"*)               cat "$GH_PULL" ;;
  *) printf 'fake gh: unexpected path: %s\n' "$path" >&2; exit 1 ;;
esac
GH
  chmod +x "$TR/bin/gh"
}

run_live_issue() {  # run_live_issue <commits-file> <issue-corpus-file>
  local commits="$1" corpus="$2"
  make_live_gh_issue
  # Issue comment: a timeline comment with NO commit_id, posted at the feedback time.
  printf '{"id":%s,"created_at":"2026-07-14T22:40:24Z","body":"please fix the thing"}\n' \
    "$CID" > "$TR/issue-comment.json"
  printf '{"head":{"sha":"%s"}}\n' "$REVIEWED_SHA" > "$TR/pull.json"
  printf '[]\n' > "$TR/inline-corpus.json"
  rm -f "$TR/alert.log"
  set +e
  OUT="$(env -u GARDEN_PREFLIGHT_EVIDENCE \
             PATH="$TR/bin:$PATH" \
             GARDEN=testhost GARDEN_STATE="$TR/state" \
             GARDEN_ALERT_CMD="$TR/alert-sink.sh" \
             GH_ISSUE_COMMENT="$TR/issue-comment.json" GH_PULL="$TR/pull.json" \
             GH_COMMITS="$commits" GH_INLINE_CORPUS="$TR/inline-corpus.json" \
             GH_ISSUE_CORPUS="$corpus" \
             bash "$PRE" "$REPO" "$PR" "$CID" "$REVIEWER" 2>&1)"
  RC=$?
  set -e
}

hr; echo "ISSUE-COMMENT RESOLUTION — no correlation resolves cleanly (the bug fix)"; hr
printf '[]\n' > "$TR/ic-nocommits.json"; printf '[]\n' > "$TR/ic-nocorpus.json"
run_live_issue "$TR/ic-nocommits.json" "$TR/ic-nocorpus.json"
{ [ "$RC" -eq 0 ] && grep -q 'PROCEED' <<<"$OUT"; } \
  && ok "conversation-comment id resolves and proceeds (no wrong-surface fail-open)" \
  || bad "conversation-comment id did not resolve to a clean PROCEED (exit $RC): $OUT"
grep -qi 'evidence gathering FAILED' <<<"$OUT" \
  && bad "conversation-comment id was mislabelled as a gather FAILURE" \
  || ok "conversation-comment id did not borrow the failure log line"
[ -s "$TR/alert.log" ] \
  && bad "conversation-comment id wrongly filed a gather-failure maintainer alert" \
  || ok "conversation-comment id filed no maintainer alert (the wrong-surface flood is fixed)"

hr; echo "ISSUE-COMMENT RESOLUTION — a commit citing the id resolves to NO-OP"; hr
printf '[{"sha":"%s","commit":{"committer":{"date":"2026-07-14T23:10:00Z"},"message":"fix: address conversation comment %s"}}]\n' \
  "$REVIEWED_SHA" "$CID" > "$TR/ic-commit-cite.json"
run_live_issue "$TR/ic-commit-cite.json" "$TR/ic-nocorpus.json"
{ [ "$RC" -eq 2 ] && grep -q 'citing feedback id' <<<"$OUT"; } \
  && ok "a post-feedback commit citing the conversation-comment id reaches NO-OP" \
  || bad "commit citation on a conversation comment did not NO-OP (exit $RC): $OUT"

hr; echo "ISSUE-COMMENT RESOLUTION — a conversation reply citing the id resolves to NO-OP"; hr
printf '[{"id":555,"created_at":"2026-07-14T23:15:00Z","body":"Fixed in a follow-up, see comment %s"}]\n' \
  "$CID" > "$TR/ic-corpus-cite.json"
run_live_issue "$TR/ic-nocommits.json" "$TR/ic-corpus-cite.json"
{ [ "$RC" -eq 2 ] && grep -q 'citing feedback id' <<<"$OUT"; } \
  && ok "a later conversation comment citing the id reaches NO-OP (corpus is consulted)" \
  || bad "conversation-comment citation was not consulted (exit $RC): $OUT"

hr; echo "ISSUE-COMMENT RESOLUTION — generic ack without an id citation still PROCEEDs"; hr
# reviewed_head_sha == current head for a conversation comment, so the SHA-gated
# generic-acknowledgement path is inert: a bare '@reviewer' ack cannot no-op.
printf '[{"sha":"%s","commit":{"committer":{"date":"2026-07-14T23:10:00Z"},"message":"chore: tidy up\\n\\nAddressed @%s."}}]\n' \
  "$REVIEWED_SHA" "$REVIEWER" > "$TR/ic-generic-ack.json"
run_live_issue "$TR/ic-generic-ack.json" "$TR/ic-nocorpus.json"
{ [ "$RC" -eq 0 ] && grep -q 'PROCEED' <<<"$OUT"; } \
  && ok "a generic ack with no id citation cannot resolve a conversation comment" \
  || bad "generic ack wrongly resolved a conversation comment (exit $RC): $OUT"

hr; echo "ARGV E2BIG REGRESSION — oversized comment corpus, resolving reply"; hr
big_comments "$TR/big-resolving.json" 1
SZ=$(wc -c < "$TR/big-resolving.json")
[ "$SZ" -gt 131072 ] && ok "corpus is $SZ B (> MAX_ARG_STRLEN 131072)" \
  || bad "corpus only $SZ B — not large enough to prove the fix"
run_live "$TR/big-resolving.json"
[ "$RC" -eq 2 ] && ok "oversized corpus parsed without E2BIG and reached the NO-OP verdict" \
  || bad "oversized corpus (exit $RC, want 2): $OUT"
grep -qi 'argument list too long' <<<"$OUT" && bad "E2BIG still reached argv" \
  || ok "no 'Argument list too long' surfaced"

hr; echo "ARGV E2BIG REGRESSION — oversized corpus, no resolution -> PROCEED"; hr
big_comments "$TR/big-benign.json" 0
run_live "$TR/big-benign.json"
{ [ "$RC" -eq 0 ] && grep -q 'PROCEED' <<<"$OUT"; } \
  && ok "oversized benign corpus proceeds cleanly (no E2BIG, correct verdict)" \
  || bad "oversized benign corpus (exit $RC): $OUT"

hr; echo "GATHER FAILURE — reported distinguishably from an empty corpus"; hr
run_live "$TR/big-benign.json" "gh: HTTP 503 upstream is on fire"
[ "$RC" -eq 0 ] && ok "gather failure still fails open (exit 0)" \
  || bad "gather failure did not fail open (exit $RC): $OUT"
grep -qi 'evidence gathering FAILED' <<<"$OUT" \
  && ok "failure logged as a FAILURE, not a finding" \
  || bad "failure not labelled distinguishably: $OUT"
grep -qi '503 upstream is on fire' <<<"$OUT" \
  && ok "failing command's stderr was captured, not swallowed" \
  || bad "stderr not captured in the failure report: $OUT"
{ [ -s "$TR/alert.log" ] && grep -qi 'tool/transport failure' "$TR/alert.log"; } \
  && ok "structural failure filed an auditable maintainer alert" \
  || bad "no maintainer alert recorded for a structural gather failure"

hr; echo "EMPTY CORPUS — a validly-gathered empty result is NOT a failure"; hr
printf '[]\n' > "$TR/empty.json"
run_live "$TR/empty.json"
{ [ "$RC" -eq 0 ] && grep -q 'PROCEED' <<<"$OUT" && grep -q 'no correlated peer resolution' <<<"$OUT"; } \
  && ok "empty corpus proceeds as a finding (PROCEED, no correlation)" \
  || bad "empty corpus not handled as a finding (exit $RC): $OUT"
grep -qi 'evidence gathering FAILED' <<<"$OUT" \
  && bad "empty corpus was mislabelled as a gather FAILURE" \
  || ok "empty corpus did not borrow the failure log line"
[ -s "$TR/alert.log" ] && bad "empty corpus wrongly filed a maintainer alert" \
  || ok "empty corpus filed no maintainer alert"

hr; echo "TRANSIENT FAILURE — WARN-only, no maintainer alert"; hr
run_live "$TR/big-benign.json" "error connecting to api.github.com"
{ [ "$RC" -eq 0 ] && grep -qi 'evidence gathering FAILED' <<<"$OUT"; } \
  && ok "transient failure fails open and is logged as a failure" \
  || bad "transient failure not reported (exit $RC): $OUT"
[ -s "$TR/alert.log" ] && bad "transient blip wrongly filed a maintainer alert" \
  || ok "transient network blip stayed WARN-only (no alert flood)"

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

hr; echo "NO-OP — review-keyed job, every inline thread answered"; hr
expect review-inline-threads-answered.json 2 "replies on all of a review's inline threads resolve a review-keyed job"
grep -q "every inline thread of review" <<<"$OUT" && ok "logged the review-thread correlation" || bad "missing review-thread correlation log ($OUT)"

hr; echo "PROCEED — review-keyed job, only some inline threads answered"; hr
expect review-inline-threads-partial.json 0 "a partially answered review is not a resolution"

hr; echo "NO-OP — explicit feedback-id citation"; hr
expect explicit-id-citation.json 2 "post-feedback id citation resolves feedback"

hr; echo "FAIL-OPEN — malformed/incomplete evidence"; hr
expect incomplete-evidence.json 0 "incomplete metadata proceeds rather than silently no-oping"

hr; echo "RESULT: $PASS passed, $FAIL failed"; hr
rm -rf "$TR"
[ "$FAIL" -eq 0 ]
