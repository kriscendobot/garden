#!/bin/bash
# fixer-docket-spooled-completion-test.sh — a completing fixer's successful
# review-docket re-entry completes into tada. A docket failure still retries.

set -euo pipefail
mapfile -t inherited_garden_vars < <(
  compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true
)
[ "${#inherited_garden_vars[@]}" -eq 0 ] || unset "${inherited_garden_vars[@]}"
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-fixer-docket-spool-test.XXXXXX")"
trap '[ "${KEEP_GARDEN_TEST_TMP:-0}" = 1 ] || rm -rf "$TR"' EXIT

fail() { echo "FAIL: $*" >&2; exit 1; }

cat > "$TR/docket-core.sh" <<'CORE'
#!/bin/bash
printf '%s\n' "$*" >> "${GARDEN_DOCKET_CORE_LOG:?}"
exit "${GARDEN_DOCKET_CORE_RC:?}"
CORE
chmod +x "$TR/docket-core.sh"

run_case() { # <name> <docket-core-rc>
  local name="$1" core_rc="$2" dir="$TR/$1" d
  git init -q --bare "$dir/journal.git"
  git init -q "$dir/seed"
  git -C "$dir/seed" checkout -q -b journal2
  for d in jobs/plan jobs/todo jobs/doin jobs/tada jobs/index jobs/gauntlet \
    jobs/orchestration jobs/bids work inbox/maintainer/unread inbox/maintainer/read \
    entries msgs hosts schedules cursors reputation/events reputation/pending reputation/verdicts; do
    mkdir -p "$dir/seed/$d"; touch "$dir/seed/$d/.gitkeep"
  done
  printf -- '---\nrole: fixer\n---\nFix https://github.com/endojs/endo-but-for-bots/pull/209 per review.\n' \
    > "$dir/seed/jobs/todo/fixjob.md"
  git -C "$dir/seed" add -A
  git -C "$dir/seed" -c user.name=test -c user.email=test@example.invalid commit -q -m seed
  git -C "$dir/seed" remote add origin "$dir/journal.git"
  git -C "$dir/seed" push -q origin HEAD:journal2
  : > "$dir/docket-core.log"; : > "$dir/gh-calls.log"; : > "$dir/handler-calls.log"

  env GARDEN=fixer-docket-spool-test GARDEN_STATE="$dir/state" \
    JOURNAL_REMOTE="$dir/journal.git" JOURNAL_BRANCH=journal2 \
    GARDEN_ONESHOT=1 GARDEN_IDLE_SLEEP=1 GARDEN_BOT_LOGIN=kriscendobot \
    GARDEN_PRODUCER_CLONE="$dir/state/producer/journal" \
    GARDEN_GH="$HERE/assert-producer-pr-draft-gh-stub.sh" \
    GARDEN_GH_CALL_LOG="$dir/gh-calls.log" \
    GARDEN_GARDENER_DOCKET_REQUEST="$HERE/review-docket-request-spy.sh" \
    GARDEN_DOCKET_SPY_LOG="$dir/docket-request.log" \
    GARDEN_GARDENER_DOCKET_CORE="$TR/docket-core.sh" \
    GARDEN_DOCKET_CORE_LOG="$dir/docket-core.log" GARDEN_DOCKET_CORE_RC="$core_rc" \
    GARDEN_STUB_RC=0 GARDEN_STUB_SIGNAL=1 \
    GARDEN_STUB_REPORT='Pushed review fixes to https://github.com/endojs/endo-but-for-bots/pull/209.' \
    GARDEN_STUB_CALL_LOG="$dir/handler-calls.log" \
    GARDEN_JOB_HANDLER="$HERE/completion-signal-handler-stub.sh" \
    "$JOBS/gardener.sh" 1 > "$dir/gardener.log" 2>&1 || true

  git clone -q --single-branch --branch journal2 "$dir/journal.git" "$dir/verify"
  grep -q '^reenter https://github.com/endojs/endo-but-for-bots/pull/209 fixjob-fixer-complete$' \
    "$dir/docket-core.log" || fail "$name: fixer re-entry was not sent to the docket core"
}

run_case accepted 0
v="$TR/accepted/verify"
[ -n "$(find "$v/jobs/tada" -type f -name fixjob.md -print -quit)" ] \
  || fail 'accepted re-entry did not complete the fixer into tada'
[ ! -e "$v/jobs/doin/fixjob.md" ] || fail 'accepted re-entry left the fixer in doin'
! grep -q 're-entry FAILED' "$TR/accepted/gardener.log" || fail 'successful intake was treated as a handler failure'

run_case hard 1
v="$TR/hard/verify"
[ -z "$(find "$v/jobs/tada" -type f -name fixjob.md -print -quit)" ] \
  || fail 'a hard docket failure (rc=1) still completed the fixer'
grep -q 're-entry FAILED' "$TR/hard/gardener.log" || fail 'hard docket failure was not logged as a failure'

echo 'PASS: successful fixer review-docket intake completes the job; a hard failure stays retryable'
