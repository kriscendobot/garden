#!/bin/bash
# schedule-once-dependabotany-handler-timeout-test.sh — a dependabotany-recheck-*
# one-shot must dispatch with the family's 7200s handler budget.
#
# Regression for improve-one-shot-dependabot-handler-budget: set-schedule-once.sh
# emitted no handler-timeout, so the 2026-10-28T15:03Z PR #1553 one-shot ran at
# the 2400s default and deterministically timed out.
#
# Asserts:
#   1. STAMPED  — a plain-body dependabotany-recheck-* one-shot dispatches a job
#      whose leading frontmatter carries handler-timeout: 7200 (exactly once,
#      alongside the scheduler's routing fields).
#   2. OVERRIDE — an explicit handler-timeout in the body's leading frontmatter is
#      preserved, not overwritten or duplicated.
#   3. OTHER    — a one-shot outside the family gets no stamp.
#
# Hermetic: a throwaway bare journal and deployed-root copy; no network.
# shellcheck disable=SC2046
set -uo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }

unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true
export GARDEN_TEST=1
TR="$(mktemp -d "${TMPDIR:-/tmp}/schedule-once-depb-timeout.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
git_id=(-c user.name=test -c user.email=test@localhost)
JBARE="$TR/journal.git"; ROOT="$TR/root"; STATE="$TR/state"
BRANCH=journal2; MAIN=main2

git init -q "$ROOT"; git -C "$ROOT" checkout -q -b "$MAIN"
mkdir -p "$ROOT/scripts"; cp -a "$JOBS/../." "$ROOT/scripts/"
git -C "$ROOT" "${git_id[@]}" add -A
git -C "$ROOT" "${git_id[@]}" commit -q -m "deployed root"

git init -q --bare "$JBARE"
SEED="$TR/seed"; git init -q "$SEED"; git -C "$SEED" checkout -q -b "$BRANCH"
mkdir -p "$SEED/schedules" "$SEED/jobs/todo"
touch "$SEED/schedules/.gitkeep" "$SEED/jobs/todo/.gitkeep"
git -C "$SEED" "${git_id[@]}" add -A
git -C "$SEED" "${git_id[@]}" commit -q -m seed
git -C "$SEED" remote add origin "$JBARE"
git -C "$SEED" push -q -u origin "$BRANCH"

env_common=(GARDEN=testhost GARDEN_ROOT="$ROOT" GARDEN_STATE="$STATE"
  GARDEN_MAIN_BRANCH="$MAIN" JOURNAL_REMOTE="$JBARE" JOURNAL_BRANCH="$BRANCH"
  GARDEN_NO_MAINTAINER_ALERT=1)
set_once() {  # set_once <name> <body-file>
  env "${env_common[@]}" bash "$ROOT/scripts/jobs/set-schedule-once.sh" \
    "$1" 2030-01-01T00:00:00Z "$1" "$2" </dev/null >"$TR/set.log" 2>&1 \
    || bad "set-schedule-once $1 failed: $(cat "$TR/set.log")"
}
frontmatter() { awk 'NR==1&&$0=="---"{f=1;next} f&&$0=="---"{exit} f' "$1"; }

printf 'Wear the botanist role and re-evaluate PR #1553.\n' > "$TR/plain"
printf -- '---\nhandler-timeout: 3600\n---\nRe-evaluate PR #9.\n' > "$TR/override"
printf 'Some unrelated one-shot.\n' > "$TR/other"
set_once dependabotany-recheck-endo-but-for-bots-pr1553 "$TR/plain"
set_once dependabotany-recheck-endo-but-for-bots-pr9 "$TR/override"
set_once unrelated-once "$TR/other"

env "${env_common[@]}" GARDEN_SCHEDULER_CLONE="$STATE/scheduler/journal" \
  GARDEN_SCHEDULER_NOW=2000000000 \
  bash "$ROOT/scripts/jobs/scheduler.sh" >"$TR/tick.log" 2>&1
PEEK="$TR/peek"; git clone -q --branch "$BRANCH" "$JBARE" "$PEEK"

echo "== 1. STAMPED: a plain-body dependabotany one-shot carries 7200s"
job="$PEEK/jobs/todo/dependabotany-recheck-endo-but-for-bots-pr1553.md"
if [ -f "$job" ]; then
  fm="$(frontmatter "$job")"
  [ "$(grep -c '^handler-timeout:' <<<"$fm")" -eq 1 ] && grep -qx 'handler-timeout: 7200' <<<"$fm" \
    && ok "dispatched job frontmatter carries handler-timeout: 7200" \
    || bad "dispatched job frontmatter lacks a single 7200 budget: $(cat "$job")"
  grep -qx 'dispatch: automatic' <<<"$fm" && ok "routing fields merged into the same frontmatter" \
    || bad "routing fields not in the leading frontmatter: $(cat "$job")"
  grep -q 'PR #1553' "$job" && ok "body preserved" || bad "body lost: $(cat "$job")"
  [ ! -e "$PEEK/schedules/dependabotany-recheck-endo-but-for-bots-pr1553.md" ] \
    && ok "one-shot schedule removed" || bad "one-shot schedule not removed"
else
  bad "one-shot was not dispatched: $(cat "$TR/tick.log")"
fi

echo "== 2. OVERRIDE: an explicit body handler-timeout wins"
job="$PEEK/jobs/todo/dependabotany-recheck-endo-but-for-bots-pr9.md"
if [ -f "$job" ]; then
  fm="$(frontmatter "$job")"
  [ "$(grep -c '^handler-timeout:' <<<"$fm")" -eq 1 ] && grep -qx 'handler-timeout: 3600' <<<"$fm" \
    && ok "explicit 3600 preserved, not duplicated" \
    || bad "explicit override not preserved: $(cat "$job")"
else
  bad "override one-shot was not dispatched: $(cat "$TR/tick.log")"
fi

echo "== 3. OTHER: a non-dependabotany one-shot is not stamped"
job="$PEEK/jobs/todo/unrelated-once.md"
if [ -f "$job" ]; then
  ! grep -q '^handler-timeout:' "$job" && ok "no budget stamped outside the family" \
    || bad "unrelated one-shot was stamped: $(cat "$job")"
else
  bad "unrelated one-shot was not dispatched: $(cat "$TR/tick.log")"
fi

echo "RESULT: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
