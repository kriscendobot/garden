#!/bin/bash
# design-pr-gauntlet-coverage-audit-test.sh — the bounded readiness audit of the
# automatic-gauntlet regime (designs/manual-gauntlet-trigger.md). The unit used
# to STAGE a gauntlet for every uncovered design PR; on 2026-08-30 that mass-staged 69
# gauntlets in one pass (~$482 on one host). Its first snapshot and historical
# backlog are now ALERT-ONLY: it tells the maintainer about a bot-authored OPEN
# NON-DRAFT PR with no gauntlet coverage. A separately
# bounded path stages only PRs created after the durable arm epoch.
#
# Under test (all deterministic, NO LLM):
#   * An uncovered non-draft bot PR (#47) raises exactly ONE maintainer alert and
#     stages NO gauntlet record (the whole point — no autonomous spend).
#   * A covered PR — active record (#48) or completed in tada/ (#53) — is quiet.
#   * Historical DRAFT PRs (#49, #52) are skipped.
#   * A non-bot PR (#50) and a probe (#51) are skipped.
#   * A stalled per-PR metadata read (#54) is an inconclusive skip; scanning continues.
#   * The garden's OWN repo (#28) is excluded.
#   * Dedup: re-running with an UNCHANGED head raises no second alert; a CHANGED head
#     re-alerts.
#   * After arming, at most two newly created bot PRs stage in one tick, including
#     a draft whose producer handoff was missed; an overflow ready PR alerts and
#     remains unstaged, while a draft probe remains exempt.
#   * Failed posts consume the same attempt bound rather than fanning out failures
#     across the rest of the new-PR set.
#   * A post-arm PR whose gauntlet already FINISHED is never re-staged, whether the
#     history is an archived record (#59), a legacy identity-less tada report bound
#     by its stage reports (#60), a halted report (#61), or a date-sharded PR-keyed
#     report (#62); an uncovered control (#63) still stages.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-dpgca-test.XXXXXX")"
trap 'rm -rf "$TR"' EXIT

# --- seed a bare journal with the watch set + two pre-existing gauntlet records ----
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
# A pre-existing ACTIVE gauntlet record covering minion.town #48 (quiet case).
printf 'repo: kriscendobot/minion.town\npr_number: 48\nkind: feature\n' \
  >"$TR/seed/jobs/gauntlet/kriscendobot-minion.town-pr48-gauntlet.md"
# A COMPLETED gauntlet for minion.town #53 — its record lives in jobs/tada/.
printf '# gauntlet (completed)\n\ndone\n' \
  >"$TR/seed/jobs/tada/kriscendobot-minion.town-pr53-gauntlet.md"
# FINISHED gauntlet history for post-arm PRs #59-#62 (2026-10-06: the audit re-staged
# endo-but-for-bots#1425/#1426 because a finished run leaves jobs/gauntlet/).
mkdir -p "$TR/seed/jobs/gauntlet-archived" "$TR/seed/jobs/tada/2026/10/05"
# #59: an ARCHIVED record only.
printf -- '---\narchived: true\n---\n\n---\nrepo: kriscendobot/minion.town\npr_number: 59\nstage: panel\n---\n' \
  >"$TR/seed/jobs/gauntlet-archived/build-fifty-nine-gauntlet.md"
# #60: TADA-ONLY legacy review-budget report under a build-job name with no PR
# identity; only its own stage reports name the PR (the #1426 shape).
printf 'gauntlet-status: review-budget-reached\n# gauntlet build-sixty-gauntlet — review budget reached\n\nApplied 6 rounds.\n' \
  >"$TR/seed/jobs/tada/2026/10/05/build-sixty-gauntlet.md"
printf 'Panel round 1 on https://github.com/kriscendobot/minion.town/pull/60 came back must-fix.\n' \
  >"$TR/seed/jobs/tada/2026/10/05/build-sixty-gauntlet-panel-1.md"
# #61: a HALTED tada report carrying PR identity in its frontmatter.
printf -- '---\npr: https://github.com/kriscendobot/minion.town/pull/61\nrepo: kriscendobot/minion.town\npr_number: 61\nstate: halted\ngauntlet-status: halted\n---\n# gauntlet build-sixty-one-gauntlet — HALTED\n' \
  >"$TR/seed/jobs/tada/2026/10/05/build-sixty-one-gauntlet.md"
# #62: a COMPLETE report under the PR-keyed basename, date-sharded (not flat).
printf 'gauntlet-status: complete\n# gauntlet — complete\n' \
  >"$TR/seed/jobs/tada/2026/10/05/kriscendobot-minion.town-pr62-gauntlet.md"
# Decoys that must NOT cover the uncovered control #63: a legacy report whose
# stage report names pull/630 (prefix), and a coalesced run that never spent.
printf 'gauntlet-status: review-budget-reached\n# gauntlet build-decoy-gauntlet\n' \
  >"$TR/seed/jobs/tada/2026/10/05/build-decoy-gauntlet.md"
printf 'Fixed https://github.com/kriscendobot/minion.town/pull/630 and more.\n' \
  >"$TR/seed/jobs/tada/2026/10/05/build-decoy-gauntlet-fix-1.md"
printf 'gauntlet-status: coalesced\nrepo: kriscendobot/minion.town\npr_number: 63\n' \
  >"$TR/seed/jobs/tada/2026/10/05/build-coalesced-gauntlet.md"
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
# Count alert-log lines whose key names a given PR (via the pr<N> slug).
alert_count() {  # alert_count <pr-token e.g. pr47>
  grep -c "minion.town-$1-" "$GARDEN_AUDIT_ALERT_LOG" 2>/dev/null || true
}

# --- stubs (committed, not under noexec /tmp) --------------------------------------
export GARDEN_DPGCA_PR_SOURCE="$HERE/design-pr-audit-pr-source-stub.sh"
export GARDEN_GH="$HERE/design-pr-audit-gh-stub.sh"
# Alert sink spy — captures every maintainer alert the audit raises.
export GARDEN_ALERT_CMD="$HERE/design-pr-audit-alert-spy.sh"
export GARDEN_AUDIT_ALERT_LOG="$TR/alert-calls.log"
: >"$GARDEN_AUDIT_ALERT_LOG"
# Gauntlet-post spy — proves the historical snapshot is inert and records the
# bounded post-arm staging calls without mutating the fixture journal.
export GARDEN_DPGCA_GAUNTLET_POST="$HERE/design-pr-audit-gauntlet-spy.sh"
export GARDEN_AUDIT_GAUNTLET_LOG="$TR/gauntlet-calls.log"
: >"$GARDEN_AUDIT_GAUNTLET_LOG"
# Durable dedup markers live under a test-owned dir (defaults into GARDEN_STATE).
export GARDEN_DPGCA_DEDUP_DIR="$TR/dedup"
export GARDEN_DPGCA_SOURCE_TIMEOUT_SECS=1
export GARDEN_DPGCA_KILL_AFTER=1s

echo '== run the readiness audit over the watched set =='
"$AUDIT" 2>&1 | tee "$TR/audit.log"

echo '== (a) the uncovered non-draft PR (#47) raised exactly ONE alert =='
[ "$(alert_count pr47)" -eq 1 ] || fail "minion.town #47 should have raised exactly one alert (got $(alert_count pr47))"

echo '== (b) NON-MUTATING: #47 got NO gauntlet record staged =='
[ "$(record_count kriscendobot-minion.town-pr47-gauntlet)" -eq 0 ] \
  || fail 'the readiness audit STAGED a gauntlet for #47 — it must only ALERT, never stage'
[ ! -s "$GARDEN_AUDIT_GAUNTLET_LOG" ] \
  || fail 'the first historical snapshot invoked the gauntlet post path'

echo '== (c) covered PRs (#48 active record, #53 completed in tada) are quiet =='
[ "$(alert_count pr48)" -eq 0 ] || fail '#48 (covered by active gauntlet) wrongly alerted'
[ "$(alert_count pr53)" -eq 0 ] || fail '#53 (covered by completed gauntlet) wrongly alerted'

echo '== (d) historical draft PRs (#49, #52) are skipped =='
[ "$(alert_count pr49)" -eq 0 ] || fail '#49 (draft) wrongly alerted'
[ "$(alert_count pr52)" -eq 0 ] || fail '#52 (draft) wrongly alerted'

echo '== (e) a non-bot PR (#50) and a probe (#51) are skipped =='
[ "$(alert_count pr50)" -eq 0 ] || fail '#50 (non-bot) wrongly alerted'
[ "$(alert_count pr51)" -eq 0 ] || fail '#51 (probe) wrongly alerted'

echo '== (f) the stalled #54 read is an inconclusive skip, and scanning continued =='
grep -q 'metadata read timed out for https://github.com/kriscendobot/minion.town/pull/54; skipping (inconclusive)' "$TR/audit.log" \
  || fail 'the stalled #54 metadata read was not reported as an inconclusive timeout'
[ "$(alert_count pr54)" -eq 0 ] || fail '#54 (inconclusive) wrongly alerted'

echo '== (g) the garden OWN repo (#28) is excluded =='
[ "$(alert_count pr28)" -eq 0 ] || fail "the garden's own repo PR #28 wrongly alerted"
grep -q "skipping the garden's own repo kriscendobot/garden" "$TR/audit.log" \
  || fail 'the garden own repo exclusion was not logged'

echo '== (h) dedup: re-running with the SAME head raises no second alert for #47 =='
"$AUDIT" >/dev/null 2>&1
[ "$(alert_count pr47)" -eq 1 ] || fail "#47 re-alerted on an unchanged head (got $(alert_count pr47), want 1)"

echo '== (i) a CHANGED head for #47 re-alerts =='
GARDEN_TEST_PR47_HEAD=bbb47changed "$AUDIT" >/dev/null 2>&1
[ "$(alert_count pr47)" -eq 2 ] || fail "#47 did not re-alert after its head changed (got $(alert_count pr47), want 2)"

echo '== (j) post-arm ready PRs stage promptly, bounded to two per tick =='
GARDEN_TEST_FRESH_PRS=1 "$AUDIT" 2>&1 | tee "$TR/fresh.log"
[ "$(wc -l <"$GARDEN_AUDIT_GAUNTLET_LOG")" -eq 2 ] \
  || fail "expected exactly two bounded gauntlet posts, got $(wc -l <"$GARDEN_AUDIT_GAUNTLET_LOG")"
grep -qx -- '--by design-pr-gauntlet-coverage-audit kriscendobot-minion.town-pr55-gauntlet https://github.com/kriscendobot/minion.town/pull/55' "$GARDEN_AUDIT_GAUNTLET_LOG" \
  || fail '#55 did not stage with the deterministic PR-keyed base'
grep -qx -- '--by design-pr-gauntlet-coverage-audit kriscendobot-minion.town-pr56-gauntlet https://github.com/kriscendobot/minion.town/pull/56' "$GARDEN_AUDIT_GAUNTLET_LOG" \
  || fail '#56 post-arm draft did not stage with the deterministic PR-keyed base'
! grep -q 'pr57-gauntlet' "$GARDEN_AUDIT_GAUNTLET_LOG" \
  || fail '#57 exceeded the per-tick stage cap but was staged'
! grep -q 'pr58-gauntlet' "$GARDEN_AUDIT_GAUNTLET_LOG" \
  || fail '#58 draft probe wrongly staged'
[ "$(alert_count pr58)" -eq 0 ] || fail '#58 draft probe wrongly alerted'
[ "$(alert_count pr57)" -eq 1 ] || fail '#57 overflow should fall back to one maintainer alert'
grep -q "exceeded this tick's stage cap (2)" "$TR/fresh.log" \
  || fail 'the bounded overflow disposition was not logged'

echo '== (k) a failed post consumes the attempt bound =='
: >"$GARDEN_AUDIT_GAUNTLET_LOG"
GARDEN_TEST_FRESH_PRS=1 GARDEN_AUDIT_GAUNTLET_FAIL=1 \
  GARDEN_DPGCA_MAX_NEW_PR_STAGES=1 "$AUDIT" >/dev/null 2>&1
[ "$(wc -l <"$GARDEN_AUDIT_GAUNTLET_LOG")" -eq 1 ] \
  || fail "one failed post should consume the one-attempt bound (got $(wc -l <"$GARDEN_AUDIT_GAUNTLET_LOG"))"

echo '== (l) a PR whose gauntlet already FINISHED (archived / tada-only) is never re-staged =='
: >"$GARDEN_AUDIT_GAUNTLET_LOG"
GARDEN_TEST_FINISHED_PRS=1 GARDEN_DPGCA_MAX_NEW_PR_STAGES=10 "$AUDIT" 2>&1 | tee "$TR/finished.log"
for n in 59 60 61 62; do
  ! grep -q "pr$n-gauntlet" "$GARDEN_AUDIT_GAUNTLET_LOG" \
    || fail "#$n already finished a gauntlet but the audit re-staged it"
  [ "$(alert_count "pr$n")" -eq 0 ] || fail "#$n already finished a gauntlet but the audit alerted"
done
grep -q 'pull/59 already covered by gauntlet history \[archived:build-fifty-nine-gauntlet' "$TR/finished.log" \
  || fail '#59 was not recognized via its archived record'
grep -q 'pull/60 already covered by gauntlet history \[tada:build-sixty-gauntlet' "$TR/finished.log" \
  || fail '#60 was not recognized via its legacy tada-only report'
grep -q 'pull/61 already covered by gauntlet history \[tada:build-sixty-one-gauntlet' "$TR/finished.log" \
  || fail '#61 was not recognized via its halted tada report'
grep -q 'pull/62 already covered by gauntlet history \[tada:kriscendobot-minion.town-pr62-gauntlet' "$TR/finished.log" \
  || fail '#62 was not recognized via its date-sharded PR-keyed tada report'
grep -qx -- '--by design-pr-gauntlet-coverage-audit kriscendobot-minion.town-pr63-gauntlet https://github.com/kriscendobot/minion.town/pull/63' "$GARDEN_AUDIT_GAUNTLET_LOG" \
  || fail '#63 (no real history; only a pull/630 decoy and a coalesced run) should still stage'

echo 'PASS: the readiness audit keeps historical backlog alert-only, reconciles ready and draft post-arm PRs with a shared two-per-tick bound, stays quiet on historical drafts/covered/non-bot/probe/own-repo/inconclusive, dedups alerts on head, and re-alerts on a changed head'
