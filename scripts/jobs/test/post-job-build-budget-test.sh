#!/bin/bash
# post-job-build-budget-test.sh -- automatic build basenames receive the builder wall.

# shellcheck disable=SC2015,SC2046
set -uo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TR="$(mktemp -d "${TMPDIR:-/tmp}/post-job-build-budget.XXXXXX")"
PASS=0
FAIL=0
ok()  { printf '  PASS: %s\n' "$*"; PASS=$((PASS+1)); }
bad() { printf '  FAIL: %s\n' "$*"; FAIL=$((FAIL+1)); }
trap 'rm -rf "$TR"' EXIT

unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_)' || true) 2>/dev/null || true

BARE="$TR/journal.git"
SEED="$TR/seed"
git init -q --bare "$BARE"
git init -q "$SEED"
git -C "$SEED" checkout -q -b journal2
(
  cd "$SEED" || exit
  mkdir -p jobs/todo jobs/doin jobs/tada jobs/plan jobs/index
  touch jobs/todo/.gitkeep jobs/doin/.gitkeep jobs/tada/.gitkeep jobs/plan/.gitkeep jobs/index/.gitkeep
  git add -A
  git -c user.name=test -c user.email=test@localhost commit -q -m seed
  git remote add origin "$BARE"
  git push -q -u origin journal2
)

export JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2 \
  GARDEN_STATE="$TR/state" GARDEN_PRODUCER_CLONE="$TR/state/producer/journal" \
  GARDEN=idhost GARDEN_ROLE=gardener GARDEN_NO_MAINTAINER_ALERT=1

post() { printf '%s\n' "$2" | "$JOBS/post-job.sh" "$1" >/dev/null 2>&1; }
job() { git -C "$BARE" cat-file -p "journal2:jobs/todo/$1.md"; }
field() { job "$1" | sed -n "2,/^---\$/s/^$2:[[:space:]]*//p" | head -1; }
budget() {
  job "$1" > "$TR/$1.md"
  job_handler_budget_base "$TR/$1.md"
}

# shellcheck source=../common.sh
source "$JOBS/common.sh"

post feature-build 'compile and test the feature'
[ "$(field feature-build handler-budget-role)" = builder ] \
  && [ "$(budget feature-build)" = 7200 ] \
  && ok "a terminal -build basename receives the 7200s builder budget" \
  || bad "a terminal -build basename did not receive the builder budget"

post feature-build-3 'retry the build'
[ "$(field feature-build-3 handler-budget-role)" = builder ] \
  && [ "$(budget feature-build-3)" = 7200 ] \
  && ok "a terminal -build-<n> retry receives the 7200s builder budget" \
  || bad "a terminal -build-<n> retry did not receive the builder budget"

post feature-building 'ordinary work'
post feature-build-later 'ordinary work'
[ -z "$(field feature-building handler-budget-role)" ] \
  && [ -z "$(field feature-build-later handler-budget-role)" ] \
  && ok "near-match basenames remain on ordinary routing" \
  || bad "a non-terminal or non-build basename received builder inference"

post explicit-role-build $'---\nrole: fixer\n---\n\nfix during a build'
[ -z "$(field explicit-role-build handler-budget-role)" ] \
  && [ "$(field explicit-role-build role)" = fixer ] \
  && ok "an explicit performing role is not overridden" \
  || bad "builder inference overrode an explicit performing role"

post explicit-budget-build $'---\nhandler-budget-role: shepherd\n---\n\nwait for CI'
[ "$(field explicit-budget-build handler-budget-role)" = shepherd ] \
  && ok "an explicit handler budget role is preserved" \
  || bad "builder inference overrode an explicit handler budget role"

post explicit-timeout-build $'---\nhandler-timeout: 10800\n---\n\na long build'
[ -z "$(field explicit-timeout-build handler-budget-role)" ] \
  && [ "$(field explicit-timeout-build handler-timeout)" = 10800 ] \
  && ok "an explicit handler timeout is preserved without inferred metadata" \
  || bad "builder inference overrode an explicit handler timeout"

printf '%s\n' $'---\ntier: mentat\ndispatch: manual\n---\n\nmanual build' \
  | GARDEN_MANUAL_DISPATCH=1 "$JOBS/post-job.sh" manual-build >/dev/null 2>&1
[ -z "$(field manual-build handler-budget-role)" ] \
  && ok "manual build basenames are excluded from automatic inference" \
  || bad "a manual job received automatic builder inference"

printf 'RESULTS: %s passed, %s failed\n' "$PASS" "$FAIL"
[ "$FAIL" -eq 0 ]
