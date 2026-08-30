#!/bin/bash
# ensure-pr-test.sh — a re-claimed job must converge on ONE pull request.
#
# Reproduces the endojs/endo-but-for-bots #865/#871 duplicate hermetically (an
# earlier incarnation left a PR on a DIFFERENT head branch; the next incarnation
# must adopt it rather than open a second) and pins the rest of the find-or-create
# contract: exactly-one adoption, ambiguity refusal, inconclusive-query refusal,
# the embedded job marker, draft-by-default, and the journal work/<base> record
# that lets a later call resolve the PR with no GitHub query at all.
#
# Fixtures only: a JSON PR database behind a fake `gh`, and a throwaway bare
# journal. No network, no real GitHub, no systemd.
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
ROOT="$(cd "$JOBS/../.." && pwd)"
ENSURE="$JOBS/gardening/ensure-pr.sh"
STUB="$HERE/ensure-pr-gh-stub.sh"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Hermetic baseline: scrub ambient fleet env so a live host's settings cannot
# leak into the fixtures (mirrors run-test.sh).
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_)' || true) 2>/dev/null || true
export GARDEN_TEST=1
export GARDEN_ROOT="$ROOT"

# /tmp is noexec in the garden container and the stub must be executable, so the
# root goes under $HOME (per-invocation, so two concurrent runs cannot clobber).
TR="$(mktemp -d "$HOME/.garden-ensure-pr-test.XXXXXX")"
trap '[ "$FAIL" -eq 0 ] && rm -rf "$TR"' EXIT
chmod +x "$STUB"

REPO=endojs/endo-but-for-bots
BASE_BRANCH=master-abc1234
JOB=endo-sturdyref-agent-surface-build
MARKER="<!-- garden-job: $JOB -->"

export FAKE_PR_DB="$TR/prs.json"
export FAKE_GH_LOG="$TR/gh.log"

reset_db() { printf '%s\n' "${1:-[]}" > "$FAKE_PR_DB"; : > "$FAKE_GH_LOG"; }

# run <head-branch> [extra args...] — invoke ensure-pr.sh with the fake gh and no
# journal (the journal round-trip has its own section below).
run() {
  local head="$1"; shift
  set +e
  OUT="$(env GARDEN=testhost GARDEN_STATE="$TR/state" GARDEN_GH="$STUB" \
             GARDEN_ENSURE_PR_NO_JOURNAL=1 ${LIMIT:+GARDEN_ENSURE_PR_LIST_LIMIT="$LIMIT"} \
             bash "$ENSURE" "$JOB" "$REPO" "$head" "$BASE_BRANCH" \
             --title 'feat(sturdyref): agent surface' --body 'What it does.' "$@" 2>"$TR/err")"
  RC=$?
  ERR="$(cat "$TR/err")"
  set -e
}
creates() { grep -c '^pr create' "$FAKE_GH_LOG" 2>/dev/null || true; }
db_len()  { jq 'length' "$FAKE_PR_DB"; }

hr; echo "STATIC — ensure-pr.sh parses"; hr
bash -n "$ENSURE" && ok "ensure-pr.sh parses" || bad "syntax error in ensure-pr.sh"

hr; echo "CREATE — no PR exists yet"; hr
reset_db
run feat/sturdyref
[ "$RC" -eq 0 ] || bad "create should exit 0, got $RC ($ERR)"
[ "$OUT" = 1 ] && ok "prints the new PR number on stdout" || bad "expected PR number 1 on stdout, got '$OUT'"
[ "$(db_len)" = 1 ] && ok "exactly one PR now exists" || bad "expected 1 PR, got $(db_len)"
jq -e --arg m "$MARKER" '.[0].body | contains($m)' "$FAKE_PR_DB" >/dev/null \
  && ok "the created body carries the <!-- garden-job: ... --> marker" || bad "marker missing from the created body"
jq -e '.[0].isDraft' "$FAKE_PR_DB" >/dev/null \
  && ok "the PR is opened DRAFT by default" || bad "the PR was not opened draft"

hr; echo "ADOPT — the same head branch on a second incarnation"; hr
: > "$FAKE_GH_LOG"
run feat/sturdyref
[ "$RC" -eq 0 ] && [ "$OUT" = 1 ] && ok "re-run adopts the existing PR (#1)" || bad "re-run should print 1 and exit 0, got rc=$RC out='$OUT' ($ERR)"
[ "$(creates)" = 0 ] && ok "re-run created NOTHING" || bad "re-run opened a duplicate PR"

hr; echo "ADOPT — a DIFFERENT head branch, matched by the job marker (#865/#871)"; hr
# The exact 2026-07-28 shape: an earlier stranded incarnation left its PR on an
# in-repo branch; this incarnation works a fork head. Only the marker relates them.
: > "$FAKE_GH_LOG"
run kriscendobot:feat/sturdyref-fork
[ "$RC" -eq 0 ] && [ "$OUT" = 1 ] && ok "a different head still resolves to #1 via the marker" || bad "marker adoption failed: rc=$RC out='$OUT' ($ERR)"
[ "$(creates)" = 0 ] && ok "no second PR was opened on the new head (#865/#871 closed)" || bad "opened a duplicate on the new head — the #865/#871 defect"
[ "$(db_len)" = 1 ] && ok "still exactly one PR" || bad "PR count drifted to $(db_len)"

hr; echo "REFUSE — two candidates is ambiguous, never a third"; hr
reset_db "$(jq -n --arg m "$MARKER" '[
  {number: 865, headRefName: "feat/in-repo", author: {login: "kriscendobot"}, body: ("stranded\n" + $m)},
  {number: 871, headRefName: "feat/fork",    author: {login: "kriscendobot"}, body: ("finished\n" + $m)}
]')"
run feat/fork
[ "$RC" -eq 3 ] && ok "ambiguity exits 3" || bad "ambiguity should exit 3, got $RC ($ERR)"
printf '%s\n' "$OUT" | grep -qx 865 && printf '%s\n' "$OUT" | grep -qx 871 \
  && ok "both candidate numbers are printed for a human to resolve" || bad "expected 865 and 871 on stdout, got '$OUT'"
[ "$(creates)" = 0 ] && ok "an ambiguous state adds NO third PR" || bad "created a PR despite ambiguity"

hr; echo "IGNORE — a stranger's PR on a same-named head branch is not ours"; hr
# `gh pr list --head` matches the ref NAME across every fork, so a third party's
# `feat/sturdyref` would match. Adopting it would push our commits onto someone
# else's branch; open our own instead, and say out loud what was ignored.
reset_db '[{"number": 999, "headRefName": "feat/sturdyref", "author": {"login": "stranger"}, "body": "somebody else"}]'
run feat/sturdyref
[ "$RC" -eq 0 ] && [ "$OUT" != 999 ] && ok "a stranger's same-named head is NOT adopted" || bad "adopted a stranger's PR: rc=$RC out='$OUT' ($ERR)"
printf '%s\n' "$ERR" | grep -q '999' && ok "the ignored PR is named in a WARN, not dropped silently" || bad "the ignored stranger PR was not logged: $ERR"

hr; echo "REFUSE — an unreadable query is inconclusive, not 'no PR exists'"; hr
reset_db
FAKE_GH_FAIL=list-definitive run feat/sturdyref
[ "$RC" -eq 4 ] && ok "a failed discovery query exits 4" || bad "failed query should exit 4, got $RC ($ERR)"
[ "$(creates)" = 0 ] && ok "nothing is created when discovery is unreadable" || bad "created a PR on an unreadable query"

hr; echo "REFUSE — a targeted head result page at the limit may be truncated"; hr
reset_db '[{"number": 700, "headRefName": "feat/sturdyref", "author": {"login": "stranger"}, "body": "unrelated"}]'
LIMIT=1 run feat/sturdyref
unset LIMIT
[ "$RC" -eq 4 ] && ok "a possibly-truncated page exits 4 rather than creating" || bad "truncated page should exit 4, got $RC ($ERR)"
[ "$(creates)" = 0 ] && ok "nothing is created on a possibly-truncated page" || bad "created a PR on a truncated page"

hr; echo "ADOPT - marker lookup paginates past 200 open PRs"; hr
reset_db "$(jq -n --arg m "$MARKER" '[range(1; 202) as $n |
  {number: $n, headRefName: ("unrelated-" + ($n | tostring)), author: {login: "kriscendobot"}, body: "unrelated"}]
  + [{number: 865, headRefName: "feat/sturdyref", author: {login: "kriscendobot"}, body: ("standing\n" + $m)}]')"
run feat/sturdyref
[ "$RC" -eq 0 ] && [ "$OUT" = 865 ] && ok "a known head with a marker beyond 200 open PRs is adopted" || bad "paginated marker adoption failed: rc=$RC out='$OUT' ($ERR)"
[ "$(creates)" = 0 ] && ok "a busy repository does not trigger duplicate creation" || bad "opened a duplicate after a paginated marker lookup"

hr; echo "FIND-ONLY — look, never create"; hr
reset_db
run feat/sturdyref --find-only
[ "$RC" -eq 2 ] && ok "--find-only with no PR exits 2" || bad "--find-only should exit 2, got $RC ($ERR)"
[ "$(creates)" = 0 ] && ok "--find-only creates nothing" || bad "--find-only created a PR"

hr; echo "MARKER — a body that already carries it does not accumulate copies"; hr
reset_db
run feat/sturdyref --body "What it does.

$MARKER"
[ "$RC" -eq 0 ] || bad "create with a pre-marked body should succeed, got $RC ($ERR)"
n="$(jq -r --arg m "$MARKER" '[.[0].body | split($m) | length - 1] | .[0]' "$FAKE_PR_DB")"
[ "$n" = 1 ] && ok "the marker appears exactly once" || bad "marker appears $n times"

hr; echo "DRAFT — --no-draft is possible but warns (ferry only)"; hr
reset_db
run feat/sturdyref --no-draft
jq -e '.[0].isDraft | not' "$FAKE_PR_DB" >/dev/null && ok "--no-draft opens ready-for-review" || bad "--no-draft still opened a draft"
printf '%s\n' "$ERR" | grep -qi 'no-draft' && ok "--no-draft warns on stderr" || bad "--no-draft passed silently"

hr; echo "JOURNAL — work/<base> records the number, and is the no-query fast path"; hr
BARE="$TR/journal.git"; BRANCH=journal2
export JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH"
git init -q --bare "$BARE"
SEED="$TR/seed"; git init -q "$SEED"
git -C "$SEED" checkout -q -b "$BRANCH"
mkdir -p "$SEED/work" "$SEED/jobs/doin"
printf 'host: testhost\ngardener: 5\n' > "$SEED/work/$JOB"
git -C "$SEED" add -A
git -C "$SEED" -c user.name=test -c user.email=test@localhost commit -q -m "seed: a claimed job"
git -C "$SEED" remote add origin "$BARE"
git -C "$SEED" push -q -u origin "$BRANCH"

reset_db
set +e
OUT="$(env GARDEN=testhost GARDEN_STATE="$TR/state" GARDEN_GH="$STUB" \
           GARDEN_PRODUCER_CLONE="$TR/producer" \
           bash "$ENSURE" "$JOB" "$REPO" feat/sturdyref "$BASE_BRANCH" \
           --title 'feat(sturdyref): agent surface' --body 'What it does.' 2>"$TR/err")"
RC=$?; ERR="$(cat "$TR/err")"
set -e
[ "$RC" -eq 0 ] && [ "$OUT" = 1 ] && ok "creates and reports #1 with the journal wired" || bad "journal-wired run failed: rc=$RC out='$OUT' ($ERR)"
rec="$(git -C "$BARE" show "$BRANCH:work/$JOB" 2>/dev/null)"
printf '%s\n' "$rec" | grep -qx "pr_number: 1"     && ok "work/$JOB records pr_number" || bad "pr_number missing from work/$JOB: $rec"
printf '%s\n' "$rec" | grep -qx "pr_repo: $REPO"   && ok "work/$JOB records pr_repo"   || bad "pr_repo missing from work/$JOB: $rec"
printf '%s\n' "$rec" | grep -qx "host: testhost"   && ok "the claim's own fields survive the stamp" || bad "the record lost its claim fields: $rec"

# The fast path: with the PR gone from GitHub entirely, the recorded number must
# still resolve — proving the answer came from the journal, not a query.
reset_db
set +e
OUT="$(env GARDEN=testhost GARDEN_STATE="$TR/state" GARDEN_GH="$STUB" \
           GARDEN_PRODUCER_CLONE="$TR/producer" \
           bash "$ENSURE" "$JOB" "$REPO" feat/sturdyref "$BASE_BRANCH" \
           --title 'feat(sturdyref): agent surface' --body 'What it does.' 2>"$TR/err")"
RC=$?; ERR="$(cat "$TR/err")"
set -e
[ "$RC" -eq 0 ] && [ "$OUT" = 1 ] && ok "the recorded number resolves on a later call" || bad "fast path failed: rc=$RC out='$OUT' ($ERR)"
[ ! -s "$FAKE_GH_LOG" ] && ok "the fast path made NO GitHub query at all" || bad "the fast path still queried gh: $(cat "$FAKE_GH_LOG")"

hr
if [ "$FAIL" -eq 0 ]; then
  echo "PASS: ensure-pr find-or-create converges on one PR ($PASS checks)"
else
  echo "FAIL: $FAIL check(s) failed, $PASS passed (fixtures kept at $TR)"
fi
[ "$FAIL" -eq 0 ]
