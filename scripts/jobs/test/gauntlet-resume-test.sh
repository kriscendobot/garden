#!/bin/bash
# gauntlet-resume-test.sh — hermetic coverage for gauntlet.sh's operator-facing,
# CAS-safe resume-from-stage primitive.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
BRANCH=journal2
TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-gauntlet-resume-test.XXXXXXXX")"
PASS=0; FAIL=0
ok() { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
trap 'rm -rf "$TR"' EXIT

# shellcheck disable=SC2046
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_)' || true) 2>/dev/null || true
BARE="$TR/journal.git"; SEED="$TR/seed"; VERIFY="$TR/verify"
git_id=(-c user.name=test -c user.email=test@localhost)
git init -q --bare "$BARE"
git init -q "$SEED"
git -C "$SEED" checkout -q -b "$BRANCH"
mkdir -p "$SEED/jobs/"{todo,doin,tada,plan,gauntlet,index} "$SEED/work" \
  "$SEED/inbox/maintainer/"{unread,read}
for d in jobs/todo jobs/doin jobs/tada jobs/plan jobs/gauntlet jobs/index work \
  inbox/maintainer/unread inbox/maintainer/read; do touch "$SEED/$d/.gitkeep"; done

cat >"$SEED/jobs/tada/g-resume.md" <<'EOF'
---
pr: https://github.com/testowner/testrepo/pull/42
repo: testowner/testrepo
pr_number: 42
build_job: build-42
kind: feature
stage: fix
iteration: 2
max_iterations: 6
resumes: 4
max_resumes: 7
stage_retries: 2
max_stage_retries: 3
current_child: g-resume-fix-2
state: halted
created_by: test
created_at: 2026-09-17T00:00:00Z
orchestration-status: halted
gauntlet-status: halted
---
# halted gauntlet
EOF
cat >"$SEED/jobs/tada/g-resume-fix-2.md" <<'EOF'
---
orchestration-failed: true
---
old failed result which must not be consumed after resume
EOF
cat >"$SEED/jobs/tada/g-complete.md" <<'EOF'
---
gauntlet-status: complete
---
EOF
cat >"$SEED/jobs/gauntlet/g-generated-halt.md" <<'EOF'
---
pr: https://github.com/testowner/testrepo/pull/43
repo: testowner/testrepo
pr_number: 43
build_job:
kind: feature
stage: clean
iteration: 0
max_iterations: 5
resumes: 0
max_resumes: 4
stage_retries: 0
max_stage_retries: 0
current_child: g-generated-halt-clean
state: running
created_by: test
created_at: 2026-09-17T00:00:00Z
---
EOF
git -C "$SEED" add -A
git -C "$SEED" "${git_id[@]}" commit -q -m seed
git -C "$SEED" remote add origin "$BARE"
git -C "$SEED" push -q -u origin "$BRANCH"

export JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH"
export GARDEN=testhost GARDEN_STATE="$TR/state"
export GARDEN_GAUNTLET_CLONE="$TR/state/gauntlet/journal"
export GARDEN_CLAIM_TTL=14400 GARDEN_HANDLER_KILL_AFTER=60
export GARDEN_SHEPHERD_HANDLER_TIMEOUT=7200

"$JOBS/gauntlet.sh" --resume-from-stage g-resume FIX --iteration 2 >"$TR/resume.log" 2>&1
git clone -q --single-branch --branch "$BRANCH" "$BARE" "$VERIFY"

record="$VERIFY/jobs/gauntlet/g-resume.md"
todo="$VERIFY/jobs/todo/g-resume-fix-2.md"
if [ -f "$record" ] && [ -f "$todo" ] \
  && [ ! -e "$VERIFY/jobs/tada/g-resume.md" ] \
  && [ ! -e "$VERIFY/jobs/tada/g-resume-fix-2.md" ]; then
  ok "resume atomically replaced terminal/stale reports with an active record and fresh FIX todo"
else
  bad "resume did not produce the expected record/todo ownership"
fi
generated_halt="$VERIFY/jobs/tada/g-generated-halt.md"
if [ -f "$generated_halt" ] \
  && grep -qx 'gauntlet-status: halted' "$generated_halt" \
  && grep -qx 'pr: https://github.com/testowner/testrepo/pull/43' "$generated_halt" \
  && grep -qx 'max_iterations: 5' "$generated_halt" \
  && grep -qx 'max_resumes: 4' "$generated_halt"; then
  ok "new halt reports retain the machine metadata required for a later safe resume"
else
  bad "driver-generated halt did not retain resumable metadata"
fi
if grep -qx 'stage: fix' "$record" \
  && grep -qx 'iteration: 2' "$record" \
  && grep -qx 'current_child: g-resume-fix-2' "$record" \
  && grep -qx 'state: running' "$record" \
  && grep -qx 'resumes: 0' "$record" \
  && grep -qx 'stage_retries: 0' "$record" \
  && grep -qx 'max_resumes: 7' "$record" \
  && grep -qx 'max_stage_retries: 3' "$record"; then
  ok "resume preserved policy bounds while resetting per-attempt counters"
else
  bad "resumed record fields are wrong"
fi
if grep -q '^# Gauntlet stage: FIX round 2' "$todo"; then
  ok "fresh child body targets the explicitly requested FIX round"
else
  bad "fresh child body is not FIX round 2"
fi

# The accepted journal history must expose the two safe swaps: terminal→pending,
# then stale-child+pending→fresh-todo+running. There is never an unowned base.
activation="$(git -C "$VERIFY" log --format=%H --grep='resume at fix/2' -1)"
restart="$(git -C "$VERIFY" log --format=%H --grep='restart stage g-resume-fix-2' -1)"
if [ -n "$activation" ] && [ -n "$restart" ] \
  && git -C "$VERIFY" show --format= --name-status "$activation" \
    | grep -Eq $'^(R[0-9]+\tjobs/tada/g-resume.md\tjobs/gauntlet/g-resume.md|A\tjobs/gauntlet/g-resume.md)$' \
  && git -C "$VERIFY" show --format= --name-status "$restart" | grep -q $'D\tjobs/tada/g-resume-fix-2.md' \
  && git -C "$VERIFY" show --format= --name-status "$restart" | grep -q $'A\tjobs/todo/g-resume-fix-2.md'; then
  ok "git history proves each resume transition landed as one CAS commit"
else
  bad "resume transitions were not committed as atomic swaps"
fi

# Repeating the same command is an idempotent success; a conflicting stage is not.
if "$JOBS/gauntlet.sh" --resume-from-stage g-resume fix --iteration 2 >"$TR/repeat.log" 2>&1; then
  ok "same-stage resume is idempotent"
else
  bad "same-stage resume should be idempotent"
fi
if "$JOBS/gauntlet.sh" --resume-from-stage g-resume panel --iteration 3 >"$TR/conflict.log" 2>&1; then
  bad "conflicting resume was accepted"
else
  ok "conflicting resume is refused while the resumed stage is active"
fi
if "$JOBS/gauntlet.sh" --resume-from-stage g-complete clean >"$TR/nonhalt.log" 2>&1; then
  bad "completed gauntlet was resumable"
else
  ok "only a halted gauntlet is resumable"
fi

echo
echo "gauntlet resume tests: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
