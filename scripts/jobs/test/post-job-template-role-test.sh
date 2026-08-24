#!/bin/bash
# post-job-template-role-test.sh — canonical prose roles become routing metadata.

# shellcheck disable=SC2015,SC2046
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TR="$(mktemp -d "${TMPDIR:-/tmp}/post-job-template-role-test.XXXXXX")"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
trap 'rm -rf "$TR"' EXIT

unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_)' || true) 2>/dev/null || true

BARE="$TR/journal.git"; git init -q --bare "$BARE"
SEED="$TR/seed"; git init -q "$SEED"; git -C "$SEED" checkout -q -b journal2
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

post_body() { printf '%s\n' "$2" | "$JOBS/post-job.sh" "$1" >/dev/null 2>&1; }
job() { git -C "$BARE" cat-file -p "journal2:jobs/todo/$1.md"; }
role_count() { job "$1" | sed -n '2,/^---$/p' | grep -c '^role:'; }

printf '%s\n' $'---\ntier: mentat\ndispatch: manual\n---\n# Review fix\n\n**Role: fixer.** Address the requested changes.' \
  | GARDEN_MANUAL_DISPATCH=1 "$JOBS/post-job.sh" inferred >/dev/null 2>&1
{ [ "$(job inferred | sed -n '2,/^---$/s/^role:[[:space:]]*//p')" = fixer ] \
  && job inferred | sed -n '2,/^---$/p' | grep -q '^dispatch: manual$'; } \
  && ok "known canonical prose role is normalized into leading metadata" \
  || bad "known canonical prose role was not normalized"

post_body preserved $'---\nrole: shepherd\npriority: high\n---\n\n**Role: fixer.** Address the requested changes.'
{ [ "$(job preserved | sed -n '2,/^---$/s/^role:[[:space:]]*//p')" = shepherd ] \
  && [ "$(role_count preserved)" -eq 1 ] \
  && job preserved | sed -n '2,/^---$/p' | grep -q '^priority: high$'; } \
  && ok "explicit role and neighboring metadata are preserved" \
  || bad "explicit leading metadata was overwritten or lost"

post_body unknown $'**Role: dragon.** Breathe fire.'
[ "$(role_count unknown)" -eq 0 ] \
  && ok "unknown prose role remains body text" \
  || bad "unknown prose role became routing metadata"

post_body ambiguous $'**Role: fixer.** Fix it.\n\n**Role: shepherd.** Then wait for CI.'
[ "$(role_count ambiguous)" -eq 0 ] \
  && ok "ambiguous canonical prose roles are not inferred" \
  || bad "ambiguous prose roles became routing metadata"

printf '%s\n' '**Role: fixer.** Fix it.' \
  | "$JOBS/post-job.sh" --role builder explicit-option >/dev/null 2>&1
[ "$(job explicit-option | sed -n '2,/^---$/s/^role:[[:space:]]*//p')" = builder ] \
  && [ "$(role_count explicit-option)" -eq 1 ] \
  && ok "explicit --role wins over prose template" \
  || bad "prose template overrode explicit --role"

echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
