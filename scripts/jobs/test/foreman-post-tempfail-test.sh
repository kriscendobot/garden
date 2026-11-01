#!/bin/bash
# foreman-post-tempfail-test.sh — a post-job.sh EX_TEMPFAIL (a busy producer
# journal lock) is retried in place with backoff; exhausted retries log a WARN,
# exit EX_TEMPFAIL, and leave the anti-flap LAST_STEP untouched.

set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }

# shellcheck disable=SC2046
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true
export GARDEN_TEST=1

TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-foreman-post-tempfail.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
BARE="$TR/journal.git"
SEED="$TR/seed"
STATE="$TR/state"
BASE=tempfail-step
BRANCH=journal2

git init -q --bare "$BARE"
git init -q "$SEED"
git -C "$SEED" checkout -q -b "$BRANCH"
(
  cd "$SEED"
  mkdir -p jobs/todo jobs/doin jobs/tada jobs/plan jobs/index \
    plan/milestones plan/designs work repos msgs hosts entries schedules cursors \
    config inbox/maintainer/unread inbox/maintainer/read
  for d in jobs/todo jobs/doin jobs/tada jobs/plan jobs/index plan/designs work repos msgs \
    hosts entries schedules cursors config inbox/maintainer/unread inbox/maintainer/read; do
    touch "$d/.gitkeep"
  done
  printf '%s\n' '---' 'status: active' '---' '# M1' > plan/milestones/M1.md
)
git -C "$SEED" add -A
git -C "$SEED" -c user.name=test -c user.email=test@localhost commit -q -m seed
git -C "$SEED" remote add origin "$BARE"
git -C "$SEED" push -q -u origin "$BRANCH"
mkdir -p "$STATE/foreman"
printf '%s\n' previously-posted-step > "$STATE/foreman/last-step"

# A post-job.sh stand-in that answers EX_TEMPFAIL for the first POST_STUB_FAILS
# calls (counted in $TR/post-calls), then hands off to the real post-job.sh.
cat > "$TR/post-stub.sh" <<'STUB'
#!/bin/bash
echo call >> "$POST_STUB_CALLS"
if [ "$(wc -l < "$POST_STUB_CALLS")" -le "${POST_STUB_FAILS:-0}" ]; then
  cat > /dev/null
  echo "[post] repository lock for producer/journal busy; skipping tick (rc=75)" >&2
  exit 75
fi
exec "$POST_STUB_REAL" "$@"
STUB
chmod +x "$TR/post-stub.sh"
CALLS="$TR/post-calls"

tick() {
  local now="$1"; shift
  env GARDEN=okhost GARDEN_STATE="$STATE" HOME="$TR" \
    JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
    GARDEN_FOREMAN_NOW="$now" GARDEN_FOREMAN_IDLE_SETTLE=0 \
    GARDEN_FOREMAN_ACTIVE_TARGET=5 \
    GARDEN_FOREMAN_HANDLER="$HERE/foreman-stub.sh" \
    GARDEN_FOREMAN_STUB_BASE="$BASE" \
    GARDEN_FOREMAN_POST_JOB="$TR/post-stub.sh" GARDEN_FOREMAN_POST_TEMPFAIL_DELAY=0 \
    POST_STUB_CALLS="$CALLS" POST_STUB_REAL="$JOBS/post-job.sh" \
    "$@" \
    "$JOBS/foreman.sh" >"$TR/tick-$now.log" 2>&1
}

tree() { git -C "$BARE" ls-tree -r --name-only "$BRANCH"; }
calls() { if [ -f "$CALLS" ]; then wc -l < "$CALLS"; else echo 0; fi; }

echo "================================================================"
echo "FOREMAN POST-JOB TEMPFAIL RETRY"
echo "================================================================"

echo "--- tempfail that clears within the retry budget"
tick 1000 POST_STUB_FAILS=2 # establish settle marker
rm -f "$CALLS"
rc=0; tick 1001 POST_STUB_FAILS=2 || rc=$?
LOG="$TR/tick-1001.log"
if [ "$rc" -eq 0 ] && tree | grep -qx "jobs/todo/$BASE.md"; then
  ok "two tempfails then success posts the step in the same tick"
else
  bad "retry did not post the step (rc=$rc)"; cat "$LOG"
fi
if [ "$(calls)" -eq 3 ] && grep -q "retry 2/3" "$LOG"; then
  ok "post-job was retried in place (3 calls)"
else
  bad "unexpected post-job call count: $(calls)"
fi
if [ "$(cat "$STATE/foreman/last-step")" = "$BASE" ] && ! grep -q ERROR "$LOG"; then
  ok "the eventual success records LAST_STEP and logs no ERROR"
else
  bad "LAST_STEP not advanced or ERROR logged after a recovered tempfail"
fi

echo "--- tempfail that persists past the retries"
STATE="$TR/state-exhausted"; mkdir -p "$STATE/foreman"
printf '%s\n' previously-posted-step > "$STATE/foreman/last-step"
BASE=persistent-tempfail-step
tick 2000 POST_STUB_FAILS=99
rm -f "$CALLS"
rc=0; tick 2001 POST_STUB_FAILS=99 || rc=$?
LOG="$TR/tick-2001.log"
if [ "$rc" -eq 75 ] && [ "$(calls)" -eq 4 ]; then
  ok "exhausted retries exit EX_TEMPFAIL after 1+3 attempts"
else
  bad "exhausted tick rc=$rc calls=$(calls)"
fi
if grep -q "WARN: post-job tempfail persisted" "$LOG" && ! grep -q ERROR "$LOG"; then
  ok "exhaustion logs a WARN, not an ERROR"
else
  bad "exhaustion log is wrong"; cat "$LOG"
fi
if [ "$(cat "$STATE/foreman/last-step")" = previously-posted-step ] \
   && grep -q "guard=post-tempfail base=$BASE rc=75 retries=3" "$STATE/foreman/decisions.log"; then
  ok "LAST_STEP is untouched and the decision log records post-tempfail"
else
  bad "anti-flap state touched or decision missing"
fi
if ! tree | grep -qx "jobs/todo/$BASE.md"; then
  ok "nothing was posted while the lock stayed busy"
else
  bad "a tempfailed post reached the board"
fi

echo "--- the wall-clock deadline bounds the retries"
STATE="$TR/state-deadline"; mkdir -p "$STATE/foreman"
BASE=deadline-tempfail-step
tick 3000 POST_STUB_FAILS=99
rm -f "$CALLS"
rc=0; tick 3001 POST_STUB_FAILS=99 GARDEN_FOREMAN_POST_TEMPFAIL_DELAY=1 \
  GARDEN_FOREMAN_POST_TEMPFAIL_DEADLINE=2 || rc=$?
if [ "$rc" -eq 75 ] && [ "$(calls)" -eq 2 ]; then
  ok "a retry whose sleep would pass the deadline is not started"
else
  bad "deadline did not bound retries (rc=$rc calls=$(calls))"
fi

echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
