#!/bin/bash
# provider-quota-backoff-test.sh - reset-aware reaper scheduling for provider caps.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }

# shellcheck disable=SC2046 # Intentionally unset the matching test environment.
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_)' || true) 2>/dev/null || true
export GARDEN_TEST=1
# shellcheck source=../common.sh
source "$JOBS/common.sh"

NOW="$(date -u -d '2026-08-13 01:00:00 UTC' +%s)"
SESSION_RESET="$(date -u -d '2026-08-13 02:00:00 UTC' +%s)"
WEEKLY_RESET="$(date -u -d '2026-08-15 03:00:00 UTC' +%s)"
[ "$(provider_quota_reset_epoch "You've hit your session limit · resets 2am (UTC)" "$NOW")" = "$SESSION_RESET" ] \
  && ok "time-only session reset parsed as the next UTC occurrence" \
  || bad "time-only session reset epoch"
[ "$(provider_quota_reset_epoch "You've hit your weekly limit · resets Aug 15, 3am (UTC)" "$NOW")" = "$WEEKLY_RESET" ] \
  && ok "dated weekly reset parsed as the named UTC date" \
  || bad "dated weekly reset epoch"

TR="$(mktemp -d "$(dirname "$HOME")/.garden-provider-quota-backoff-test.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
BARE="$TR/journal.git"; SEED="$TR/seed"; BRANCH=journal2
git_id=(-c user.name=test -c user.email=test@localhost)
git init -q --bare "$BARE"
git init -q "$SEED"; git -C "$SEED" checkout -q -b "$BRANCH"
(
  cd "$SEED"
  mkdir -p jobs/todo jobs/doin jobs/tada jobs/plan work inbox/maintainer/unread inbox/maintainer/read
  for directory in jobs/todo jobs/doin jobs/tada jobs/plan work inbox/maintainer/unread inbox/maintainer/read; do
    touch "$directory/.gitkeep"
  done
  for base in session-cap weekly-cap; do
    if [ "$base" = session-cap ]; then
      type=session; reset_at=2026-08-13T02:00:00Z
    else
      type=weekly; reset_at=2026-08-15T03:00:00Z
    fi
    {
      printf '# %s\n\nquota-backed-off work\n\n' "$base"
      printf '<!-- garden-provider-quota-backoff: type=%s reset-at=%s -->\n\n' "$type" "$reset_at"
      printf '%s\n' '---' 'claim:' '  host: testhost' '  gardener: 1' \
        '  claimed_at: 2026-08-12T00:00:00Z'
    } > "jobs/doin/$base.md"
  done
)
git -C "$SEED" add -A
git -C "$SEED" "${git_id[@]}" commit -q -m seed
git -C "$SEED" remote add origin "$BARE"; git -C "$SEED" push -q -u origin "$BRANCH"

export JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH"
export GARDEN=testhost GARDEN_STATE="$TR/state"
export GARDEN_REAP_DOOM_THRESHOLD=99 GARDEN_REAP_OVERRUN_THRESHOLD=99
export GARDEN_CLAIM_TTL=60 GARDEN_HANDLER_TIMEOUT=1 GARDEN_HANDLER_KILL_AFTER=1 GARDEN_REAP_SAFETY_SLACK=1
export GARDEN_REAP_PUSH_ATTEMPTS=5 GARDEN_REAP_MAX_PER_TICK=8

snapshot() {
  rm -rf "$TR/verify"
  git clone -q --single-branch --branch "$BRANCH" "$BARE" "$TR/verify"
}
run_reaper_at() {
  GARDEN_REAPER_NOW="$1" "$JOBS/reaper.sh" > "$TR/reaper.log" 2>&1
  snapshot
}

run_reaper_at "$NOW"
if [ -f "$TR/verify/jobs/doin/session-cap.md" ] && [ -f "$TR/verify/jobs/doin/weekly-cap.md" ] \
   && [ ! -f "$TR/verify/jobs/todo/session-cap.md" ] && [ ! -f "$TR/verify/jobs/todo/weekly-cap.md" ]; then
  ok "before either reset, both TTL-expired claims remain held"
else
  bad "a quota-backed-off claim requeued before its reset"
fi
grep -q "provider session limit until 2026-08-13T02:00:00Z" "$TR/reaper.log" \
  && grep -q "provider weekly limit until 2026-08-15T03:00:00Z" "$TR/reaper.log" \
  && ok "reaper log distinguishes the short session and long weekly holds" \
  || bad "reaper hold log omitted a typed reset"

run_reaper_at "$(( SESSION_RESET + 60 ))"
if [ -f "$TR/verify/jobs/todo/session-cap.md" ] && [ -f "$TR/verify/jobs/doin/weekly-cap.md" ]; then
  ok "session claim requeued just after its short reset while weekly stayed held"
else
  bad "short reset scheduling did not requeue only the session claim"
fi
if grep -q 'garden-provider-quota-backoff' "$TR/verify/jobs/todo/session-cap.md"; then
  bad "consumed session backoff marker persisted into todo"
else
  ok "consumed session backoff marker was stripped on requeue"
fi

run_reaper_at "$(( WEEKLY_RESET + 60 ))"
if [ -f "$TR/verify/jobs/todo/weekly-cap.md" ] && [ ! -f "$TR/verify/jobs/doin/weekly-cap.md" ]; then
  ok "weekly claim requeued just after its long reset"
else
  bad "long weekly reset scheduling did not requeue the claim"
fi

echo "provider-quota-backoff-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
