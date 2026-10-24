#!/bin/bash
# The press wrapper's default window must come from a freshly fetched producer
# clone: a lagging origin/journal2 once reported the prior window. Cover the
# refresh, the pinned ref, and the loud refusal of a stale newest stamp.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_)' || true) 2>/dev/null || true
export GARDEN_TEST=1
TR="$(mktemp -d "${TMPDIR:-$HOME}/.press-report-test.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
git_id=(-c user.name=test -c user.email=test@example.invalid)
BARE="$TR/origin.git"; SEED="$TR/seed"; BRANCH=journal2
git init -q --bare "$BARE"
git init -q "$SEED"; git -C "$SEED" checkout -q -b "$BRANCH"
mkdir -p "$SEED"/{jobs/{todo,doin,tada,plan,orch,gauntlet},schedules}
touch "$SEED/jobs/todo/.gitkeep"
stamp() {
  printf '%s\n' '---' 'cadence: 6h' "last_dispatched: $1" \
    'job_basename_prefix: claude-on-minion-town-completion-press' '---' \
    > "$SEED/schedules/claude-on-minion-town-completion-press.md"
  GIT_COMMITTER_DATE="$1" GIT_AUTHOR_DATE="$1" git -C "$SEED" add -A
  GIT_COMMITTER_DATE="$1" GIT_AUTHOR_DATE="$1" git -C "$SEED" "${git_id[@]}" commit -qm "dispatch $1"
  git -C "$SEED" push -q origin "HEAD:$BRANCH"
}
git -C "$SEED" remote add origin "$BARE"
stamp 2026-10-24T01:35:00Z
stamp 2026-10-24T07:35:00Z

export JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" GARDEN=testhost GARDEN_STATE="$TR/state"
export GARDEN_ROOT="$(cd "$JOBS/../.." && pwd)" GARDEN_PRODUCER_CLONE="$TR/producer"
# 2026-10-24T13:51:22Z, the incident's report time.
export GARDEN_REPORT_NOW=1792849882
fail=0

# Seed the producer clone at the 07:35 dispatch, then land the 13:50 dispatch
# upstream only: the wrapper must fetch it rather than report 01:35->07:35.
git clone -q --branch "$BRANCH" "$BARE" "$GARDEN_PRODUCER_CLONE"
stamp 2026-10-24T13:50:08Z
out="$TR/report.json"
if "$JOBS/claude-on-minion-town-completion-report.sh" > "$out" 2>"$TR/err" \
   && jq -e '.window.since == "2026-10-24T07:35:00Z" and .window.until == "2026-10-24T13:50:08Z"' "$out" >/dev/null; then
  echo "PASS: refreshed producer clone reports the current window"
else
  echo "FAIL: stale window or error"; cat "$out" "$TR/err"; fail=1
fi

# No newer dispatch upstream at all: the newest stamp is older than the cadence,
# so the wrapper must refuse loudly instead of reporting the prior window.
export GARDEN_REPORT_NOW=$(( 1792849882 + 6 * 3600 ))
if "$JOBS/claude-on-minion-town-completion-report.sh" > "$out" 2>"$TR/err"; then
  echo "FAIL: stale newest stamp was accepted"; fail=1
elif grep -q 'current dispatch stamp is unavailable' "$TR/err" && [ ! -s "$out" ]; then
  echo "PASS: stale newest stamp refused loudly"
else
  echo "FAIL: unexpected refusal shape"; cat "$TR/err"; fail=1
fi

# Explicit --since bypasses the schedule-derived window and its refresh gate.
if "$JOBS/claude-on-minion-town-completion-report.sh" --repo "$GARDEN_PRODUCER_CLONE" \
     --since 2026-10-24T00:00:00Z --until 2026-10-24T01:00:00Z > "$out" 2>"$TR/err" \
   && jq -e '.window.since == "2026-10-24T00:00:00Z"' "$out" >/dev/null; then
  echo "PASS: explicit --since still works"
else
  echo "FAIL: explicit --since"; cat "$out" "$TR/err"; fail=1
fi
exit "$fail"
