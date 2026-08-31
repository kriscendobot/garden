#!/bin/bash
# policy-refusal-quarantine-test.sh — a PROVIDER SAFETY/USAGE-POLICY refusal is a
# DETERMINISTIC block, so the fleet must QUARANTINE the job (park it held in plan/
# with ONE concise maintainer notice) on the FIRST observation rather than leave it
# in doin for the reaper to requeue and re-escalate every cycle. Two Ironhorse fuzz
# repairs failed identically after a Codex cyber-content block ("This content was
# flagged for possible cybersecurity risk … Trusted Access for Cyber program"),
# proving that retrying the unchanged prompt only repeats the failure.
#
# Subtests (hermetic; no systemd, no network — a local bare journal):
#   1. CLASSIFIER — the text and file classifiers match the observed provider
#                   refusal envelopes and REJECT benign security-discussing prose
#                   and a quota-cap refusal (the disjoint environmental class).
#                   The file case puts the refusal outside the retained 64 KiB tail.
#   2. GARDENER   — the real worker spine detects a refusal outside the final
#                   64 KiB and stamps the quarantine hint without escalating.
#   3. QUARANTINE — a stale doin claim carrying <!-- garden-policy-refusal --> is
#                   PARKED in plan/ (gate=go-ahead, doomed:true, doom_signature:
#                   policy-refusal) on the FIRST reap EVEN with the requeue/overrun
#                   doom thresholds pinned huge — so it is the policy path, not a
#                   counter, that quarantines it; gone from doin/, NOT in todo/, the
#                   original body preserved, the marker stripped from the parked body.
#   4. NOTICE     — exactly ONE maintainer notice is posted, keyed policy-refusal,
#                   whose body names the policy block and the rephrase/remove remedy.
#
# Usage: policy-refusal-quarantine-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
BRANCH=journal2
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Hermetic baseline: scrub any fleet env a live gardener may have exported.
# shellcheck disable=SC2046
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_)' || true) 2>/dev/null || true
export GARDEN_TEST=1

# ============================================================================
hr; echo "SUBTEST 1 — CLASSIFIER: is_provider_policy_refusal_text"; hr
# shellcheck source=../common.sh
source "$JOBS/common.sh"

CODEX_BLOCK="$(cat "$HERE/fixtures/codex-policy-refusal-resume.jsonl")"
class_ok=1
is_provider_policy_refusal_text "$CODEX_BLOCK" \
  || { class_ok=0; echo "    missed the observed Codex cyber-block envelope"; }
is_provider_policy_refusal_text "response was blocked by our content policy" \
  || { class_ok=0; echo "    missed a generic content-policy block"; }
is_provider_policy_refusal_text "Your request was flagged as potentially violating our usage policies." \
  || { class_ok=0; echo "    missed a usage-policy-violation envelope"; }
# Negative: benign prose that merely DISCUSSES security must not self-quarantine.
if is_provider_policy_refusal_text "Added a regression test for the cybersecurity fuzz finding; the fix is minimal."; then
  class_ok=0; echo "    false-positive on benign security-discussing prose"
fi
# Negative: a quota/limit cap is the DISJOINT environmental class, not a policy refusal.
if is_provider_policy_refusal_text "You've hit your weekly limit · resets Aug 15, 3am (UTC)"; then
  class_ok=0; echo "    false-positive on a provider quota cap (should be excluded)"
fi
[ "$class_ok" -eq 1 ] \
  && ok "classifier matches provider refusal envelopes, rejects benign prose and quota caps" \
  || bad "classifier misclassified at least one case"

# Regression: Ironhorse fuzz repair emitted megabytes after the provider refusal.
# The compact diagnostic tail no longer contained the refusal, but classification
# must inspect the complete transcript before that capture is reduced.
FULL_TRANSCRIPT="$(mktemp)"
{
  head -c 1048576 /dev/zero | tr '\0' x
  printf '\nThis content was flagged for possible cybersecurity risk. See the Trusted Access for Cyber program.\n'
  head -c 2097152 /dev/zero | tr '\0' y
} > "$FULL_TRANSCRIPT"
full_ok=1
if is_provider_policy_refusal_text "$(tail -c 65536 "$FULL_TRANSCRIPT")"; then
  full_ok=0; echo "    fixture error: compact tail unexpectedly contains the refusal"
fi
is_provider_policy_refusal_file "$FULL_TRANSCRIPT" \
  || { full_ok=0; echo "    file classifier missed refusal outside compact diagnostic tail"; }
rm -f "$FULL_TRANSCRIPT"
[ "$full_ok" -eq 1 ] \
  && ok "file classifier finds a refusal across a multi-megabyte transcript after the compact tail loses it" \
  || bad "complete-transcript refusal classification failed"

# ============================================================================
# Reaper fixture: a throwaway bare journal + seeded board.
TR="$(mktemp -d "$(dirname "$HOME")/.garden-policy-refusal-test.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
BARE="$TR/journal.git"; SEED="$TR/seed"
git_id=(-c user.name=test -c user.email=test@localhost)
git init -q --bare "$BARE"
git init -q "$SEED"; git -C "$SEED" checkout -q -b "$BRANCH"
( cd "$SEED"
  mkdir -p jobs/todo jobs/doin jobs/tada jobs/plan work \
           inbox/maintainer/unread inbox/maintainer/read
  for d in jobs/todo jobs/doin jobs/tada jobs/plan work \
           inbox/maintainer/unread inbox/maintainer/read; do touch "$d/.gitkeep"; done )
git -C "$SEED" add -A
git -C "$SEED" "${git_id[@]}" commit -q -m "seed: board structure"
git -C "$SEED" remote add origin "$BARE"
git -C "$SEED" push -q -u origin "$BRANCH"

export JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH"
export GARDEN=testhost GARDEN_STATE="$TR/state"
export GARDEN_POST_ATTEMPTS=50 GARDEN_REAP_PUSH_ATTEMPTS=50
# Pin the ORDINARY doom thresholds HUGE so a stale claim could NEVER doom by
# requeue-count / overrun / constancy — only the policy-refusal path can park it.
export GARDEN_REAP_DOOM_THRESHOLD=99 GARDEN_REAP_OVERRUN_THRESHOLD=99
export GARDEN_REAP_ELAPSED_CONSTANCY_THRESHOLD=99
export GARDEN_CLAIM_TTL=3600 GARDEN_REAP_MAX_PER_TICK=8

V="$TR/verify"
resync() { rm -rf "$V"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$V"; }
count_unread() { resync; ls -1 "$V/inbox/maintainer/unread" 2>/dev/null | grep -v -x '.gitkeep' | grep -c . || true; }

# Drive the real gardener spine, not only the pure helper. Its handler puts the
# refusal in the middle of a multi-megabyte stream, outside the final 64 KiB. The
# gardener must stamp the quarantine hint and skip the ordinary error escalation.
hr; echo "SUBTEST 2 - GARDENER: full transcript refusal stamps quarantine hint"; hr
IW="$(mktemp -d "$TR/integration.XXXXXX")"
git clone -q --single-branch --branch "$BRANCH" "$BARE" "$IW"
printf '%s\n' '---' 'tier: minion' '---' '# long-refusal' '' 'repair the fuzz target' \
  > "$IW/jobs/todo/long-refusal.md"
git -C "$IW" add jobs/todo/long-refusal.md
git -C "$IW" "${git_id[@]}" commit -q -m "fixture: long policy-refusal job"
git -C "$IW" push -q origin "HEAD:$BRANCH"
rm -rf "$IW"

env GARDEN=policyhost GARDEN_STATE="$TR/gardener-state" \
    GARDEN_ONESHOT=1 GARDEN_IDLE_SLEEP=1 \
    GARDEN_JOB_HANDLER="$HERE/policy-refusal-full-transcript-handler-stub.sh" \
    GARDEN_JOB_HANDLER_BASH=1 \
    bash "$JOBS/gardener.sh" 1 > "$TR/gardener.log" 2>&1 || true
resync
integration_ok=1
if [ ! -f "$V/jobs/doin/long-refusal.md" ] \
  || ! grep -q '^<!-- garden-policy-refusal -->$' "$V/jobs/doin/long-refusal.md"; then
  integration_ok=0; echo "    gardener did not stamp the policy-refusal hint"
fi
if [ -e "$V/inboxes/policyhost/gardener.md" ]; then
  integration_ok=0; echo "    gardener used ordinary error escalation instead of quarantine"
fi
grep -q "was BLOCKED by a provider safety/usage-policy refusal" "$TR/gardener.log" \
  || { integration_ok=0; echo "    gardener log does not record the policy-refusal classification"; }
[ "$integration_ok" -eq 1 ] \
  && ok "gardener classifies the complete multi-megabyte transcript and stamps quarantine without error escalation" \
  || bad "gardener full-transcript policy-refusal path failed"

# Remove the integration claim before the reaper-only assertions below, which
# deliberately expect exactly one quarantined job and one maintainer notice.
IW="$(mktemp -d "$TR/integration-clean.XXXXXX")"
git clone -q --single-branch --branch "$BRANCH" "$BARE" "$IW"
git -C "$IW" rm -q -f --ignore-unmatch jobs/doin/long-refusal.md work/long-refusal
git -C "$IW" "${git_id[@]}" commit -q -m "fixture: remove integration claim"
git -C "$IW" push -q origin "HEAD:$BRANCH"
rm -rf "$IW"

# Place a STALE doin claim carrying the policy-refusal marker (as the gardener would
# have stamped it after detecting the provider block in the failed handler capture).
place_policy_blocked() {
  local base="$1" wt; wt="$(mktemp -d "$TR/edit.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$BARE" "$wt"
  {
    printf '# %s\n\nthe original work body for %s\n\n' "$base" "$base"
    printf '%s\n' '<!-- garden-policy-refusal -->'
    printf '%s\n' '<!-- garden-reap-now -->'
    printf -- '---\nclaim:\n  host: testhost\n  gardener: 3\n  claimed_at: 2020-01-01T00:00:00Z\n'
  } > "$wt/jobs/doin/$base.md"
  printf 'worktree_dir: %s\n' "$TR/nonexistent-wt-$base" > "$wt/work/$base"
  git -C "$wt" add "jobs/doin/$base.md" "work/$base"
  git -C "$wt" "${git_id[@]}" commit -q -m "place policy-blocked $base"
  git -C "$wt" push -q origin "HEAD:$BRANCH"
  rm -rf "$wt"
}

run_reaper() { "$JOBS/reaper.sh" >"$TR/reap.log" 2>&1 || { echo "  (reaper.sh rc=$? — see below)"; sed 's/^/    /' "$TR/reap.log"; }; }

# ============================================================================
hr; echo "SUBTEST 3 - QUARANTINE: policy-blocked claim parked in plan/ on first reap"; hr
place_policy_blocked fuzz-repair
run_reaper
resync

plan_file="$V/jobs/plan/fuzz-repair.md"
q_ok=1
[ -f "$plan_file" ]                  || { q_ok=0; echo "    plan/fuzz-repair.md missing (not quarantined)"; }
[ -f "$V/jobs/doin/fuzz-repair.md" ] && { q_ok=0; echo "    doin/fuzz-repair.md still present"; }
[ -f "$V/jobs/todo/fuzz-repair.md" ] && { q_ok=0; echo "    fuzz-repair leaked into todo/ (requeued, not quarantined)"; }
if [ -f "$plan_file" ]; then
  grep -q '^gate: go-ahead$'                "$plan_file" || { q_ok=0; echo "    gate is not go-ahead"; }
  grep -q '^doomed: true$'                  "$plan_file" || { q_ok=0; echo "    doomed marker missing"; }
  grep -q '^doom_signature: policy-refusal$' "$plan_file" || { q_ok=0; echo "    signature is not policy-refusal"; }
  grep -q '^failure_classification: deterministic$' "$plan_file" || { q_ok=0; echo "    policy refusal is not classified deterministic"; }
  grep -q 'the original work body for fuzz-repair' "$plan_file" || { q_ok=0; echo "    original body not preserved"; }
  grep -q 'garden-policy-refusal'           "$plan_file" && { q_ok=0; echo "    stale policy-refusal marker leaked into the parked body"; }
fi
[ "$q_ok" -eq 1 ] \
  && ok "policy-blocked 'fuzz-repair' quarantined in plan/ on first reap (thresholds pinned huge), body preserved, marker stripped" \
  || bad "quarantine: plan=[$(ls "$V/jobs/plan" 2>/dev/null)] doin=[$(ls "$V/jobs/doin" 2>/dev/null)] todo=[$(ls "$V/jobs/todo" 2>/dev/null)]"

# ============================================================================
hr; echo "SUBTEST 4 - NOTICE: exactly one policy-refusal maintainer notice"; hr
n_ok=1
nunread="$(count_unread)"
[ "$nunread" -eq 1 ] || { n_ok=0; echo "    expected 1 maintainer notice, found $nunread"; }
notice="$V/inbox/maintainer/unread/doomed-fuzz-repair-policy-refusal.md"
if [ -f "$notice" ]; then
  grep -qi 'policy refusal'  "$notice" || { n_ok=0; echo "    notice body does not name the policy refusal"; }
  grep -qi 'rephrase'        "$notice" || { n_ok=0; echo "    notice body omits the rephrase remedy"; }
else
  n_ok=0; echo "    keyed notice doomed-fuzz-repair-policy-refusal.md missing"
fi
[ "$n_ok" -eq 1 ] \
  && ok "exactly one policy-refusal notice posted, naming the block and the rephrase/remove remedy" \
  || bad "notice: unread=[$(ls "$V/inbox/maintainer/unread" 2>/dev/null)]"

echo "policy-refusal-quarantine-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
