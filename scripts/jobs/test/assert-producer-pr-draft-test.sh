#!/bin/bash
# assert-producer-pr-draft-test.sh — the completion-time DRAFT GUARDRAIL of the
# manual-gauntlet-trigger regime (designs/manual-gauntlet-trigger.md). Replaces the
# retired assert-design-pr-gauntlet.sh sensor and auto-gauntlet-handoff.sh stager.
#
# The guardrail's whole job: a producer PR may complete WITHOUT a gauntlet only while
# DRAFT; a bot-authored OPEN NON-DRAFT PR named by the completion report needs a
# gauntlet, else completion is blocked. It NEVER mutates PR state.
#
# Under test (all deterministic, NO LLM):
#   * NEGATIVE (the retired-stager replacement proof): a DRAFT producer PR completes
#     cleanly (rc 0), stages NO gauntlet record, and makes NO GitHub mutation.
#   * A NON-DRAFT PR with no gauntlet is BLOCKED (rc 1), still with no mutation.
#   * A NON-DRAFT PR already covered by a gauntlet record passes (rc 0).
#   * A probe, a non-bot-authored PR, and an open-questions carve-out all pass.
#   * A PR named only in the JOB FILE (not the report) is a citation → pass.
#   * An inconclusive gh read fails OPEN (rc 0) — a GitHub blip never wedges completion.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-producer-draft-test.XXXXXX")"
trap 'rm -rf "$TR"' EXIT

# --- seed a bare journal with ONE pre-existing gauntlet record (covers #202) --------
git init -q --bare "$TR/journal.git"
git init -q "$TR/seed"
git -C "$TR/seed" checkout -q -b journal2
mkdir -p "$TR/seed/jobs/"{todo,doin,tada,index,gauntlet} "$TR/seed/work"
touch "$TR/seed/jobs/todo/.gitkeep" "$TR/seed/jobs/doin/.gitkeep" \
  "$TR/seed/jobs/tada/.gitkeep" "$TR/seed/jobs/index/.gitkeep" \
  "$TR/seed/jobs/gauntlet/.gitkeep" "$TR/seed/work/.gitkeep"
printf 'repo: endojs/endo-but-for-bots\npr_number: 202\nkind: feature\n' \
  >"$TR/seed/jobs/gauntlet/endojs-endo-but-for-bots-pr202-gauntlet.md"
git -C "$TR/seed" add -A
git -C "$TR/seed" -c user.name=test -c user.email=test@example.invalid commit -q -m seed
git -C "$TR/seed" remote add origin "$TR/journal.git"
git -C "$TR/seed" push -q origin HEAD:journal2

GARDEN_ROOT="$(cd "$JOBS/../.." && pwd)"; export GARDEN_ROOT
export GARDEN_TEST=1 JOURNAL_REMOTE="$TR/journal.git" JOURNAL_BRANCH=journal2
export GARDEN_STATE="$TR/state" GARDEN=producer-draft-test
export GARDEN_BOT_LOGIN=kriscendobot
export GARDEN_PRODUCER_CLONE="$TR/state/producer/journal"
export GARDEN_GH="$HERE/assert-producer-pr-draft-gh-stub.sh"

GATE="$JOBS/assert-producer-pr-draft.sh"
fail() { echo "FAIL: $*" >&2; exit 1; }

repo=endojs/endo-but-for-bots
jobf="$TR/job.md"; printf -- '---\nrole: builder\n---\nBuild the feature.\n' >"$jobf"
probe_jobf="$TR/probe-job.md"; printf -- '---\nrole: builder\n---\nprobe the design.\n' >"$probe_jobf"

run_gate() {  # run_gate <job-file> <report-text> ; sets RC, resets the call log
  local jf="$1" report_text="$2"
  : >"$TR/gh-calls.log"
  export GARDEN_GH_CALL_LOG="$TR/gh-calls.log"
  local rep="$TR/report.md"; printf '%s\n' "$report_text" >"$rep"
  set +e
  "$GATE" some-base "$jf" "$rep" >"$TR/gate.out" 2>&1
  RC=$?
  set -e
}
# assert the gate made NO mutating gh call (only `pr view` is allowed).
assert_no_mutation() {
  ! grep -qE 'pr (ready|merge|edit|close|reopen)' "$TR/gh-calls.log" \
    || fail "the gate made a MUTATING gh call: $(grep -E 'pr (ready|merge|edit|close|reopen)' "$TR/gh-calls.log" | tr '\n' '|')"
}

echo '== (a) NEGATIVE: a DRAFT producer PR completes cleanly, no record, no mutation =='
run_gate "$jobf" "Draft PR: https://github.com/$repo/pull/200"
[ "$RC" -eq 0 ] || fail "draft PR #200 should pass (rc=$RC): $(cat "$TR/gate.out")"
assert_no_mutation
# The gate never stages a record; the only records on the journal are the seed's.
clone="$TR/neg-check"; git clone -q --single-branch --branch journal2 "$TR/journal.git" "$clone"
[ ! -e "$clone/jobs/gauntlet/endojs-endo-but-for-bots-pr200-gauntlet.md" ] \
  || fail 'the gate STAGED a gauntlet record for a draft PR — it must never stage'

echo '== (b) a NON-DRAFT uncovered PR is BLOCKED (rc 1), still no mutation =='
run_gate "$jobf" "Ready PR: https://github.com/$repo/pull/201"
[ "$RC" -eq 1 ] || fail "non-draft uncovered PR #201 should BLOCK (rc=$RC): $(cat "$TR/gate.out")"
assert_no_mutation

echo '== (c) a NON-DRAFT PR already covered by a gauntlet passes (rc 0) =='
run_gate "$jobf" "Ready PR: https://github.com/$repo/pull/202"
[ "$RC" -eq 0 ] || fail "non-draft covered PR #202 should pass (rc=$RC): $(cat "$TR/gate.out")"

echo '== (d) a NON-DRAFT probe passes (rc 0) =='
run_gate "$probe_jobf" "Probe PR: https://github.com/$repo/pull/203"
[ "$RC" -eq 0 ] || fail "non-draft probe PR #203 should pass (rc=$RC): $(cat "$TR/gate.out")"

echo '== (e) a NON-DRAFT PR authored by someone else passes (citation) =='
run_gate "$jobf" "Related: https://github.com/$repo/pull/204"
[ "$RC" -eq 0 ] || fail "non-bot-authored PR #204 should pass (rc=$RC): $(cat "$TR/gate.out")"

echo '== (f) a NON-DRAFT open-questions carve-out passes (rc 0) =='
run_gate "$jobf" "Design PR: https://github.com/$repo/pull/205"
[ "$RC" -eq 0 ] || fail "open-questions carve-out PR #205 should pass (rc=$RC): $(cat "$TR/gate.out")"

echo '== (g) a PR named only in the JOB FILE (not the report) is a citation → pass =='
citing_jobf="$TR/citing-job.md"
printf -- '---\nrole: builder\n---\nFix the crash in https://github.com/%s/pull/201.\n' "$repo" >"$citing_jobf"
run_gate "$citing_jobf" "Done. No PR opened by this job."
[ "$RC" -eq 0 ] || fail "a report naming no PR must pass even when the JOB FILE cites one (rc=$RC): $(cat "$TR/gate.out")"

echo '== (h) an inconclusive gh read fails OPEN (rc 0) =='
run_gate "$jobf" "Ready PR: https://github.com/$repo/pull/207"
[ "$RC" -eq 0 ] || fail "an inconclusive gh read must fail OPEN, not block (rc=$RC): $(cat "$TR/gate.out")"

echo 'PASS: the draft guardrail passes draft/covered/probe/non-bot/carve-out/citation/inconclusive completions, blocks a bot-authored non-draft uncovered PR, and never mutates PR state or stages a record'
