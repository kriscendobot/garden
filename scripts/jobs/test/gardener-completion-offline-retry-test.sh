#!/bin/bash
# gardener-completion-offline-retry-test.sh — a handler that FINISHED (exit 0 +
# completion signal) must not lose its completion to one transient EX_TEMPFAIL
# from complete-job.sh. gardener.sh re-tries the completion a bounded number of
# times before falling back to the TTL requeue (2026-11-01 oros: a finished
# ninth-slice builder lost its completion to one 10s repo-lock wait).
#
# CASE blip: complete-job returns 75 twice, then succeeds -> job lands in tada.
# CASE down: complete-job returns 75 every time -> exactly 1+RETRIES attempts,
#            job left in doin, "after N retries" logged.

set -euo pipefail
mapfile -t inherited_garden_vars < <(
  compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true
)
[ "${#inherited_garden_vars[@]}" -eq 0 ] || unset "${inherited_garden_vars[@]}"
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-completion-offline-retry-test.XXXXXX")"
trap '[ "${KEEP_GARDEN_TEST_TMP:-0}" = 1 ] || rm -rf "$TR"' EXIT

fail() { echo "FAIL: $*" >&2; exit 1; }

# Flaky complete-job: fail with EX_TEMPFAIL the first $FLAKY_FAILS calls, then
# delegate to the real complete-job.sh.
cat > "$TR/flaky-complete-job.sh" <<FLAKY
#!/bin/bash
n=\$(( \$(cat "\$FLAKY_COUNT" 2>/dev/null || echo 0) + 1 ))
echo "\$n" > "\$FLAKY_COUNT"
[ "\$n" -le "\$FLAKY_FAILS" ] && exit 75
exec "$JOBS/complete-job.sh" "\$@"
FLAKY
chmod +x "$TR/flaky-complete-job.sh"

run_case() { # <name> <flaky-fails>
  local fails="$2" dir="$TR/$1" d
  git init -q --bare "$dir/journal.git"
  git init -q "$dir/seed"
  git -C "$dir/seed" checkout -q -b journal2
  for d in jobs/plan jobs/todo jobs/doin jobs/tada jobs/index jobs/gauntlet \
    jobs/orchestration jobs/bids work inbox/maintainer/unread inbox/maintainer/read \
    entries msgs hosts schedules cursors reputation/events reputation/pending reputation/verdicts; do
    mkdir -p "$dir/seed/$d"; touch "$dir/seed/$d/.gitkeep"
  done
  printf -- '---\nrole: researcher\n---\nLook something up.\n' > "$dir/seed/jobs/todo/retryjob.md"
  git -C "$dir/seed" add -A
  git -C "$dir/seed" -c user.name=test -c user.email=test@example.invalid commit -q -m seed
  git -C "$dir/seed" remote add origin "$dir/journal.git"
  git -C "$dir/seed" push -q origin HEAD:journal2

  env GARDEN=completion-offline-retry-test GARDEN_STATE="$dir/state" \
    JOURNAL_REMOTE="$dir/journal.git" JOURNAL_BRANCH=journal2 \
    GARDEN_ONESHOT=1 GARDEN_IDLE_SLEEP=1 GARDEN_BOT_LOGIN=kriscendobot \
    GARDEN_PRODUCER_CLONE="$dir/state/producer/journal" \
    GARDEN_GARDENER_COMPLETE_JOB="$TR/flaky-complete-job.sh" \
    FLAKY_COUNT="$dir/flaky.count" FLAKY_FAILS="$fails" \
    GARDEN_COMPLETION_OFFLINE_RETRIES=3 GARDEN_COMPLETION_OFFLINE_BACKOFF_SECS=0 \
    GARDEN_STUB_RC=0 GARDEN_STUB_SIGNAL=1 GARDEN_STUB_REPORT='Looked it up.' \
    GARDEN_STUB_CALL_LOG="$dir/handler-calls.log" \
    GARDEN_JOB_HANDLER="$HERE/completion-signal-handler-stub.sh" \
    "$JOBS/gardener.sh" 1 > "$dir/gardener.log" 2>&1 || true

  git clone -q --single-branch --branch journal2 "$dir/journal.git" "$dir/verify"
}

run_case blip 2
v="$TR/blip/verify"
[ "$(cat "$TR/blip/flaky.count")" = 3 ] || fail "blip: expected 3 complete-job calls, got $(cat "$TR/blip/flaky.count")"
[ -n "$(find "$v/jobs/tada" -type f -name retryjob.md -print -quit)" ] \
  || { cat "$TR/blip/gardener.log" >&2; fail 'blip: a transient completion outage was not retried into tada'; }
[ ! -e "$v/jobs/doin/retryjob.md" ] || fail 'blip: job left in doin after a successful retry'
grep -q "retrying (2/3)" "$TR/blip/gardener.log" || fail 'blip: retry was not logged'

run_case down 99
v="$TR/down/verify"
[ "$(cat "$TR/down/flaky.count")" = 4 ] || fail "down: expected 4 complete-job calls (1+3 retries), got $(cat "$TR/down/flaky.count")"
[ -z "$(find "$v/jobs/tada" -type f -name retryjob.md -print -quit)" ] || fail 'down: completed despite a persistent outage'
[ -e "$v/jobs/doin/retryjob.md" ] || fail 'down: job not left in doin for the TTL requeue'
grep -q "after 3 retries); left in doin for TTL requeue" "$TR/down/gardener.log" || fail 'down: exhaustion was not logged'

echo 'PASS: a transient completion outage is retried into tada; a persistent one is bounded and left in doin'
