#!/bin/bash
# design-pr-gauntlet-coverage-audit-test.sh — the standing backstop that the two
# completion-time scripts' own comments presuppose ("the design-gauntlet
# sensor/audit will surface it") but which did not exist until now.
#
# Grounding incident: kriscendobot/minion.town#47 — a SECURITY-CRITICAL ocap-redesign
# design PR opened NON-DRAFT on 2026-08-16 that sat over a day with zero review and
# NO gauntlet ever staged, because both completion-time scripts deliberately decline
# to stage for an already-non-draft design PR (the #671/#867 force-draft hazard) and
# left that case "for the audit". This is the audit.
#
# Under test (all deterministic, NO LLM):
#   * A bot-authored OPEN DESIGN-ONLY PR with NO gauntlet record gets one staged —
#     INCLUDING the non-draft-at-birth shape the two sibling scripts cannot cover.
#   * The draft variant of the same is staged too (state is never touched either way).
#   * A design PR that ALREADY has a gauntlet record is an idempotent no-op.
#   * A code PR, a NON-bot-authored PR, and a probe stage nothing.
#   * The garden's OWN repo is excluded (no PR workflow runs on it).
#   * Re-running the audit is idempotent (exactly one record per PR).

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-dpgca-test.XXXXXX")"
trap 'rm -rf "$TR"' EXIT

# --- seed a bare journal with the watch set + one pre-existing gauntlet record ----
git init -q --bare "$TR/journal.git"
git init -q "$TR/seed"
git -C "$TR/seed" checkout -q -b journal2
mkdir -p "$TR/seed/jobs/"{todo,doin,tada,index,gauntlet} "$TR/seed/work" \
  "$TR/seed/comment-repos"
touch "$TR/seed/jobs/todo/.gitkeep" "$TR/seed/jobs/doin/.gitkeep" \
  "$TR/seed/jobs/tada/.gitkeep" "$TR/seed/jobs/index/.gitkeep" \
  "$TR/seed/jobs/gauntlet/.gitkeep" "$TR/seed/work/.gitkeep"
# Watch set: the bot's own fork PLUS the garden's own repo (which must be EXCLUDED).
touch "$TR/seed/comment-repos/kriscendobot-minion.town"
touch "$TR/seed/comment-repos/kriscendobot-garden"
# A pre-existing gauntlet record covering minion.town #48 (idempotent no-op case).
printf 'repo: kriscendobot/minion.town\npr_number: 48\nkind: feature\n' \
  >"$TR/seed/jobs/gauntlet/kriscendobot-minion.town-pr48-gauntlet.md"
# A COMPLETED gauntlet for minion.town #53 — its record lives in jobs/tada/ (a run
# that already finished), NOT jobs/gauntlet/. gauntlet_record_for_pr scans only
# jobs/gauntlet/, so the audit must ALSO honour a completed run in tada/ or it would
# re-stage every tick (the regression the sensor's base-keyed tada/ check prevents).
printf '# gauntlet (completed)\n\ndone\n' \
  >"$TR/seed/jobs/tada/kriscendobot-minion.town-pr53-gauntlet.md"
git -C "$TR/seed" add -A
git -C "$TR/seed" -c user.name=test -c user.email=test@example.invalid commit -q -m seed
git -C "$TR/seed" remote add origin "$TR/journal.git"
git -C "$TR/seed" push -q origin HEAD:journal2

GARDEN_ROOT="$(cd "$JOBS/../.." && pwd)"; export GARDEN_ROOT
export GARDEN_TEST=1 JOURNAL_REMOTE="$TR/journal.git" JOURNAL_BRANCH=journal2
export GARDEN_STATE="$TR/state" GARDEN=dpgca-test
export GARDEN_BOT_LOGIN=kriscendobot

AUDIT="$JOBS/design-pr-gauntlet-coverage-audit.sh"

fail() { echo "FAIL: $*" >&2; exit 1; }

# A gauntlet RECORD exists on origin/journal2 iff <base>.md is in jobs/gauntlet.
record_count() {  # record_count <gauntlet-base>
  local base="$1" clone="$TR/check-$RANDOM"
  git clone -q --single-branch --branch journal2 "$TR/journal.git" "$clone" >/dev/null 2>&1
  local n
  n="$(git -C "$clone" ls-tree -r --name-only origin/journal2 -- jobs/gauntlet 2>/dev/null \
        | grep -c "/$base\.md\$" || true)"
  rm -rf "$clone"
  printf '%s\n' "$n"
}

# --- stubs: a PR source and a gh `pr view`, both committed on the repo filesystem --
# (NOT generated under $TMPDIR: /tmp is mounted noexec in CI, so an executable stub
# there fails the audit's `[ -x ]` gate — the reason the sibling tests keep their
# stubs in test/ too.) Their fixtures cover: an uncovered NON-DRAFT design PR (#47,
# the incident), an already-covered one (#48), a code PR (#49), a non-bot PR (#50),
# a probe (#51), an uncovered DRAFT design PR (#52), and the garden own repo (#28).
export GARDEN_DPGCA_PR_SOURCE="$HERE/design-pr-audit-pr-source-stub.sh"
export GARDEN_GH="$HERE/design-pr-audit-gh-stub.sh"
# A spy stager: records which PRs the audit DECIDES to stage (its own skip logic,
# independent of post-gauntlet.sh's dedup) then forwards to the real stager so the
# on-journal records the record_count assertions read still get written.
export GARDEN_DPGCA_POST_GAUNTLET="$HERE/design-pr-audit-stager-spy.sh"
export GARDEN_DPGCA_REAL_POST_GAUNTLET="$JOBS/post-gauntlet.sh"
export GARDEN_DPGCA_STAGE_LOG="$TR/stage-calls.log"
: >"$GARDEN_DPGCA_STAGE_LOG"

echo '== run the audit over the watched set =='
"$AUDIT"

echo '== (a) the NON-DRAFT-at-birth design PR (#47, the grounding incident) is staged =='
[ "$(record_count kriscendobot-minion.town-pr47-gauntlet)" -eq 1 ] \
  || fail 'minion.town #47 (non-draft, uncovered) did NOT get a gauntlet — the exact bypass this audit exists to close'

echo '== (b) the DRAFT uncovered design PR (#52) is staged too (state never gates the audit) =='
[ "$(record_count kriscendobot-minion.town-pr52-gauntlet)" -eq 1 ] \
  || fail 'minion.town #52 (draft, uncovered) did NOT get a gauntlet'

echo '== (c) the already-covered design PR (#48) stays at exactly one record =='
[ "$(record_count kriscendobot-minion.town-pr48-gauntlet)" -eq 1 ] \
  || fail 'minion.town #48 (already covered) record count is not exactly 1'

echo '== (d) a code PR (#49), a non-bot PR (#50), and a probe (#51) stage nothing =='
[ "$(record_count kriscendobot-minion.town-pr49-gauntlet)" -eq 0 ] || fail 'code PR #49 wrongly got a gauntlet'
[ "$(record_count kriscendobot-minion.town-pr50-gauntlet)" -eq 0 ] || fail 'non-bot PR #50 wrongly got a gauntlet'
[ "$(record_count kriscendobot-minion.town-pr51-gauntlet)" -eq 0 ] || fail 'probe PR #51 wrongly got a gauntlet'

echo '== (e) the garden OWN repo (#28) is excluded — no PR workflow runs on it =='
[ "$(record_count kriscendobot-garden-pr28-gauntlet)" -eq 0 ] \
  || fail "the garden's own repo design PR #28 wrongly got a gauntlet"

echo '== (g) a design PR whose gauntlet already COMPLETED (record in tada/, #53) is NOT re-staged =='
# The decisive assertion is on the audit's OWN decision (the spy log), because
# post-gauntlet.sh would refuse a duplicate on its own — so record_count alone could
# not tell "the audit correctly skipped" from "the audit tried and post-gauntlet
# blocked it". The audit must never even CALL the stager for #53.
if grep -q 'pr53-gauntlet' "$GARDEN_DPGCA_STAGE_LOG"; then
  fail 'the audit re-staged #53 whose gauntlet already completed (tada/) — the every-tick re-stage regression'
fi
# And it DID decide to stage the genuinely-uncovered ones.
grep -q 'pr47-gauntlet' "$GARDEN_DPGCA_STAGE_LOG" || fail 'spy did not record the #47 staging'
grep -q 'pr52-gauntlet' "$GARDEN_DPGCA_STAGE_LOG" || fail 'spy did not record the #52 staging'
# It never called the stager for the covered/ineligible ones either.
for p in pr48 pr49 pr50 pr51; do
  grep -q "${p}-gauntlet" "$GARDEN_DPGCA_STAGE_LOG" && fail "audit wrongly called the stager for minion.town #$p"
done
grep -q 'garden-pr28' "$GARDEN_DPGCA_STAGE_LOG" && fail 'audit wrongly called the stager for the garden own repo #28'
true

echo '== (f) re-running the audit is idempotent (exactly one record per newly-staged PR) =='
"$AUDIT"
[ "$(record_count kriscendobot-minion.town-pr47-gauntlet)" -eq 1 ] || fail '#47 duplicated on re-run'
[ "$(record_count kriscendobot-minion.town-pr52-gauntlet)" -eq 1 ] || fail '#52 duplicated on re-run'

echo 'PASS: the standing audit stages a gauntlet for every uncovered bot-authored OPEN design PR (draft OR non-draft), never touches draft state, and leaves covered PRs, code PRs, non-bot PRs, probes, and the garden own repo alone; idempotent on re-run'
