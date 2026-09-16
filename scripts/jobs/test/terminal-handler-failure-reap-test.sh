#!/bin/bash
# terminal-handler-failure-reap-test.sh — a deterministic handler failure is
# durably made eligible for prompt reaping before diagnostic reporting runs.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }

mapfile -t ambient_vars < <(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true)
[ "${#ambient_vars[@]}" -eq 0 ] || unset "${ambient_vars[@]}"
export GARDEN_TEST=1
TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-terminal-failure.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
BARE="$TR/journal.git"; BRANCH=journal2
git_id=(-c user.name=test -c user.email=test@localhost)

git init -q --bare "$BARE"
SEED="$TR/seed"; git init -q "$SEED"; git -C "$SEED" checkout -q -b "$BRANCH"
(
  cd "$SEED"
  mkdir -p jobs/todo jobs/doin jobs/tada work repos msgs hosts entries schedules cursors
  for d in jobs/todo jobs/doin jobs/tada work repos msgs hosts entries schedules cursors; do touch "$d/.gitkeep"; done
  printf '%s\n' '---' 'tier: minion' '---' '# failjob' '' 'exercise deterministic handler failure' > jobs/todo/failjob.md
)
git -C "$SEED" add -A
git -C "$SEED" "${git_id[@]}" commit -q -m seed
git -C "$SEED" remote add origin "$BARE"
git -C "$SEED" push -q -u origin "$BRANCH"

env GARDEN=failhost GARDEN_STATE="$TR/state" \
    JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
    GARDEN_ONESHOT=1 GARDEN_IDLE_SLEEP=1 GARDEN_STUB_RC=2 \
    GARDEN_JOB_HANDLER="$HERE/completion-signal-handler-stub.sh" \
    "$JOBS/gardener.sh" 1 >"$TR/gardener.log" 2>&1 || true

V="$TR/verify"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$V"
if grep -qx '<!-- garden-terminal-handler-failure -->' "$V/jobs/doin/failjob.md"; then
  ok "non-transient failure durably stamped on the still-claimed job"
else
  bad "terminal-handler-failure marker absent; log: $(grep -iE 'terminal|FAILED' "$TR/gardener.log" | tail -4)"
fi
if [ -f "$V/inboxes/failhost/gardener.md" ]; then
  ok "ordinary diagnostic reporting still ran"
else
  bad "expected gardener inbox diagnostic was not written"
fi

# The board fact must precede the reporting commit, so a reporting-side failure
# or interruption cannot strand the claim until its TTL.
subjects="$(git -C "$V" log --reverse --format='%s')"
stamp_line="$(printf '%s\n' "$subjects" | grep -n '^terminal-failure: hint jobs/doin/failjob.md ' | head -1 | cut -d: -f1 || true)"
report_line="$(printf '%s\n' "$subjects" | grep -n '^inboxes(gardener): error from lane 0 state handler-nonzero$' | head -1 | cut -d: -f1 || true)"
if [ -n "$stamp_line" ] && [ -n "$report_line" ] && [ "$stamp_line" -lt "$report_line" ]; then
  ok "terminal-failure board stamp committed before error-reporting side effects"
else
  bad "commit ordering wrong or missing (stamp=${stamp_line:-missing}, report=${report_line:-missing})"
fi

# A fresh claim is far younger than this TTL.  The real reaper must nevertheless
# consume the terminal marker immediately and advance the bounded doom cycle.
env GARDEN=reaphost GARDEN_STATE="$TR/reaper-state" \
    JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
    GARDEN_CLAIM_TTL=3600 GARDEN_REAP_DOOM_THRESHOLD=5 \
    "$JOBS/reaper.sh" >"$TR/reaper.log" 2>&1 || true

R="$TR/reaped"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$R"
if [ -f "$R/jobs/todo/failjob.md" ] && [ ! -f "$R/jobs/doin/failjob.md" ]; then
  ok "reaper promptly moved the fresh terminal-failure claim doin to todo"
else
  bad "fresh terminal-failure claim was not reaped; log: $(grep -iE 'terminal|reap|stale' "$TR/reaper.log" | tail -5)"
fi
if grep -qx '<!-- garden-reaped: 1 -->' "$R/jobs/todo/failjob.md" \
   && ! grep -q 'garden-terminal-handler-failure' "$R/jobs/todo/failjob.md"; then
  ok "bounded doom count advanced and the one-cycle terminal marker was consumed"
else
  bad "requeued body did not carry reaped=1 with terminal marker removed"
fi

# A repeated real failure stays explicitly deterministic at the retry bound; the
# terminal marker must not be mistaken for the transient reap-now classification.
env GARDEN=failhost GARDEN_STATE="$TR/state-2" \
    JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
    GARDEN_ONESHOT=1 GARDEN_IDLE_SLEEP=1 GARDEN_STUB_RC=2 \
    GARDEN_JOB_HANDLER="$HERE/completion-signal-handler-stub.sh" \
    "$JOBS/gardener.sh" 2 >"$TR/gardener-2.log" 2>&1 || true
env GARDEN=reaphost GARDEN_STATE="$TR/reaper-state" \
    JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
    GARDEN_CLAIM_TTL=3600 GARDEN_REAP_DOOM_THRESHOLD=2 \
    "$JOBS/reaper.sh" >"$TR/reaper-2.log" 2>&1 || true

D="$TR/doomed"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$D"
if [ -f "$D/jobs/plan/failjob.md" ] \
   && grep -qx 'failure_classification: deterministic' "$D/jobs/plan/failjob.md" \
   && ! grep -q 'garden-terminal-handler-failure' "$D/jobs/plan/failjob.md"; then
  ok "retry exhaustion preserves deterministic classification and parks cleanly"
else
  bad "repeated terminal failure did not doom as deterministic"
fi

echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
