#!/bin/bash
# test_gauntlet_stage_retry_budget.sh — a dead gauntlet stage gets a bounded,
# reason-aware retry budget that is independent of panel iterations and CI resumes.
#
# Guards (hermetic local journal, no network/systemd/agent):
#   A. A requeue-exhausted stage whose final handler cycle was proven transient is
#      re-posted under the SAME basename, its held plan entry is removed, the
#      gauntlet record audits stage_retries=1, and a later success advances.
#   B. A retryable stage that fails past max_stage_retries halts with
#      "failed N times" and the named exhausted budget.
#   C. policy-refusal is deterministic: it halts on the first failure and is never
#      re-posted, even when retry budget remains.
#   D. requeue-exhausted without transient proof is not retried and the halt says
#      why the unknown failure was refused.
#
# Load-bearing mutation proof (2026-08-31, each run against this complete fixture):
#   Command after each source mutation:
#     GARDEN_TEST=1 bash tests/checks/test_gauntlet_stage_retry_budget.sh
#   - Changed the transient classification comparison to an impossible value:
#       FAIL: transient-classified first failure is re-posted under the same basename (rc=1)
#   - Changed the exhausted-budget comparison from -gt to -ge:
#       FAIL: first failure spends retry 1/1 rather than halting (rc=1)
#   - Changed the policy-refusal branch to call retry_failed_stage:
#       FAIL: policy-refusal halts immediately without re-posting (rc=1)
#   - Deleted the unknown requeue-exhausted halt branch:
#       FAIL: unclassified requeue-exhausted halts without re-posting (rc=1)
#   Restored baseline output: RESULTS: 16 passed, 0 failed (rc=0).

set -uo pipefail

HARNESS_DIR=$(cd "$(dirname "$0")" && pwd)
PROJECT_ROOT=${GAUNTLET_TEST_PROJECT_ROOT:-$(cd "$HARNESS_DIR/../.." && pwd)}
JOBS="$PROJECT_ROOT/scripts/jobs"
BRANCH=journal2
PASS=0
FAIL=0

ok() { PASS=$((PASS + 1)); echo "  PASS: $1"; }
ko() { FAIL=$((FAIL + 1)); echo "  FAIL: $1"; }

echo "=== test_gauntlet_stage_retry_budget ==="
[ -f "$JOBS/gauntlet.sh" ] || { echo "missing $JOBS/gauntlet.sh"; exit 2; }

# Scrub the live fleet environment before selecting the fixture paths.
# shellcheck disable=SC2046  # intentional word-split over the matched variable names
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_)' || true) 2>/dev/null || true
export GARDEN_TEST=1

TEST_ROOT=$(mktemp -d "$HOME/.garden-gauntlet-stage-retry.XXXXXX")
trap 'rm -rf "$TEST_ROOT"' EXIT
BARE="$TEST_ROOT/journal.git"
STATE="$TEST_ROOT/state"
VERIFY="$TEST_ROOT/verify"
git_id=(-c user.name=test -c user.email=test@localhost)

git init -q --bare "$BARE"
SEED="$TEST_ROOT/seed"
git init -q "$SEED"
git -C "$SEED" checkout -q -b "$BRANCH"
(
  cd "$SEED" || exit 1
  mkdir -p jobs/todo jobs/doin jobs/tada jobs/plan jobs/gauntlet jobs/index work \
    inbox/maintainer/unread inbox/maintainer/read
  for directory in jobs/todo jobs/doin jobs/tada jobs/plan jobs/gauntlet jobs/index work \
    inbox/maintainer/unread inbox/maintainer/read; do
    touch "$directory/.gitkeep"
  done
)
git -C "$SEED" add -A
git -C "$SEED" "${git_id[@]}" commit -q -m seed
git -C "$SEED" remote add origin "$BARE"
git -C "$SEED" push -q -u origin "$BRANCH"

export JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH"
export GARDEN=testhost GARDEN_STATE="$STATE" GARDEN_POST_ATTEMPTS=20
export GARDEN_CLAIM_TTL=14400 GARDEN_HANDLER_KILL_AFTER=60
export GARDEN_SHEPHERD_HANDLER_TIMEOUT=7200

refresh() {
  rm -rf "$VERIFY"
  git clone -q --single-branch --branch "$BRANCH" "$BARE" "$VERIFY"
}

exists() { # <board-subdirectory> <base>
  refresh
  [ -e "$VERIFY/$1/$2.md" ]
}

record_field() { # <gauntlet> <field>
  refresh
  sed -n "s/^$2:[[:space:]]*//p" "$VERIFY/jobs/gauntlet/$1.md" 2>/dev/null | head -1
}

tada_body() {
  refresh
  cat "$VERIFY/jobs/tada/$1.md" 2>/dev/null
}

tick() {
  "$JOBS/gauntlet.sh" >"$TEST_ROOT/tick.log" 2>&1
}

post_gauntlet() {
  "$JOBS/post-gauntlet.sh" "$@" >/dev/null 2>&1
}

# Move a posted stage into the exact held-plan shape the reaper produces.
doom_stage() { # <base> <doom-signature> <failure-classification>
  local edit="$TEST_ROOT/edit-$1"
  rm -rf "$edit"
  git clone -q --single-branch --branch "$BRANCH" "$BARE" "$edit"
  {
    printf '%s\n' '---'
    printf 'gate: go-ahead\n'
    printf 'doomed: true\n'
    printf 'doom_signature: %s\n' "$2"
    printf 'failure_classification: %s\n' "$3"
    printf '%s\n\n' '---'
    cat "$edit/jobs/todo/$1.md"
  } > "$edit/jobs/plan/$1.md"
  git -C "$edit" rm -q "jobs/todo/$1.md"
  git -C "$edit" add "jobs/plan/$1.md"
  git -C "$edit" "${git_id[@]}" commit -q -m "doom $1 ($2/$3)"
  git -C "$edit" push -q origin "HEAD:$BRANCH"
}

complete_stage() { # <base> <stage=result>
  local edit="$TEST_ROOT/complete-$1"
  rm -rf "$edit"
  git clone -q --single-branch --branch "$BRANCH" "$BARE" "$edit"
  git -C "$edit" rm -q "jobs/todo/$1.md"
  printf '<!-- gauntlet-stage-result: %s -->\n' "$2" > "$edit/jobs/tada/$1.md"
  git -C "$edit" add "jobs/tada/$1.md"
  git -C "$edit" "${git_id[@]}" commit -q -m "complete $1 ($2)"
  git -C "$edit" push -q origin "HEAD:$BRANCH"
}

# A. One transient-proven death is retried, audited, then advances.
post_gauntlet retry-once testowner/testrepo#101
tick
doom_stage retry-once-clean requeue-exhausted transient
tick
if exists jobs/todo retry-once-clean; then
  ok "transient-classified first failure is re-posted under the same basename"
else
  ko "transient-classified first failure is re-posted under the same basename"
fi
if ! exists jobs/plan retry-once-clean; then
  ok "retry atomically removes the held doom plan"
else
  ko "retry atomically removes the held doom plan"
fi
if [ "$(record_field retry-once stage_retries)" = 1 ]; then
  ok "gauntlet record audits stage_retries=1"
else
  ko "gauntlet record audits stage_retries=1"
fi
complete_stage retry-once-clean clean=done
tick
if exists jobs/todo retry-once-panel-1; then
  ok "the retried stage can succeed and advance the gauntlet"
else
  ko "the retried stage can succeed and advance the gauntlet"
fi
if [ "$(record_field retry-once stage_retries)" = 0 ]; then
  ok "advancing resets the per-stage retry count"
else
  ko "advancing resets the per-stage retry count"
fi

# B. max_stage_retries=1 permits one retry; failure number two halts.
post_gauntlet --max-stage-retries 1 retry-exhausted testowner/testrepo#102
tick
doom_stage retry-exhausted-clean requeue-exhausted transient
tick
if exists jobs/todo retry-exhausted-clean; then
  ok "first failure spends retry 1/1 rather than halting"
else
  ko "first failure spends retry 1/1 rather than halting"
fi
doom_stage retry-exhausted-clean requeue-exhausted transient
tick
if exists jobs/tada retry-exhausted && ! exists jobs/todo retry-exhausted-clean; then
  ok "failure past the retry budget halts without another re-post"
else
  ko "failure past the retry budget halts without another re-post"
fi
exhausted_body=$(tada_body retry-exhausted)
if printf '%s\n' "$exhausted_body" | grep -Fq 'failed 2 times'; then
  ok "exhaustion reason reports the total failure count"
else
  ko "exhaustion reason reports the total failure count"
fi
if printf '%s\n' "$exhausted_body" | grep -Fq 'max_stage_retries=1'; then
  ok "exhaustion reason names the stage retry budget"
else
  ko "exhaustion reason names the stage retry budget"
fi

# C. A deterministic policy refusal never consumes the available retry budget.
post_gauntlet --max-stage-retries 2 deterministic testowner/testrepo#103
tick
doom_stage deterministic-clean policy-refusal deterministic
tick
if exists jobs/tada deterministic && ! exists jobs/todo deterministic-clean; then
  ok "policy-refusal halts immediately without re-posting"
else
  ko "policy-refusal halts immediately without re-posting"
fi
deterministic_body=$(tada_body deterministic)
if printf '%s\n' "$deterministic_body" | grep -Fq 'policy-refusal is deterministic'; then
  ok "deterministic halt explains why retry would repeat the refusal"
else
  ko "deterministic halt explains why retry would repeat the refusal"
fi
if ! printf '%s\n' "$deterministic_body" | grep -Fq 'retry budget is exhausted'; then
  ok "deterministic refusal does not masquerade as budget exhaustion"
else
  ko "deterministic refusal does not masquerade as budget exhaustion"
fi

# D. Generic requeue exhaustion is retryable only with positive transient proof.
post_gauntlet --max-stage-retries 2 unknown-requeue testowner/testrepo#104
tick
doom_stage unknown-requeue-clean requeue-exhausted unknown
tick
if exists jobs/tada unknown-requeue && ! exists jobs/todo unknown-requeue-clean; then
  ok "unclassified requeue-exhausted halts without re-posting"
else
  ko "unclassified requeue-exhausted halts without re-posting"
fi
unknown_body=$(tada_body unknown-requeue)
if printf '%s\n' "$unknown_body" | grep -Fq 'does not prove the underlying handler failure was transient'; then
  ok "unknown requeue halt says transient evidence was unavailable"
else
  ko "unknown requeue halt says transient evidence was unavailable"
fi
if [ "$(record_field retry-once max_stage_retries)" = 2 ]; then
  ok "post-gauntlet records the independent max_stage_retries default of 2"
else
  ko "post-gauntlet records the independent max_stage_retries default of 2"
fi
if [ "$(record_field retry-once resumes)" = 0 ]; then
  ok "stage-death retries do not spend the still-pending resume counter"
else
  ko "stage-death retries do not spend the still-pending resume counter"
fi

echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
