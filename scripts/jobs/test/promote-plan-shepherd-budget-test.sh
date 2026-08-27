#!/bin/bash
# promote-plan-shepherd-budget-test.sh: an orchestrated `*-shepherd-*` child may
# not enter todo/ with the ordinary 2400s handler budget.

set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"

mapfile -t ambient_vars < <(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_)' || true)
[ "${#ambient_vars[@]}" -eq 0 ] || unset "${ambient_vars[@]}"
export GARDEN_TEST=1

TR="$(mktemp -d "${TMPDIR:-/tmp}/promote-shepherd-budget.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
BARE="$TR/journal.git"
SEED="$TR/seed"
git_id=(-c user.name=test -c user.email=test@localhost)
pass=0
fail=0
ok() { printf '  ok   %s\n' "$1"; pass=$((pass+1)); }
bad() { printf '  FAIL %s\n' "$1"; fail=$((fail+1)); }

git init -q --bare "$BARE"
git init -q "$SEED"
git -C "$SEED" checkout -q -b journal2
mkdir -p "$SEED/jobs/plan" "$SEED/jobs/todo" "$SEED/jobs/doin" "$SEED/jobs/tada"
touch "$SEED/jobs/plan/.gitkeep" "$SEED/jobs/todo/.gitkeep" \
  "$SEED/jobs/doin/.gitkeep" "$SEED/jobs/tada/.gitkeep"
git -C "$SEED" add -A
git -C "$SEED" "${git_id[@]}" commit -q -m seed
git -C "$SEED" remote add origin "$BARE"
git -C "$SEED" push -q -u origin journal2

export JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2
export GARDEN=testhost GARDEN_STATE="$TR/state" GARDEN_POST_ATTEMPTS=20
export GARDEN_HANDLER_TIMEOUT=2400 GARDEN_SHEPHERD_HANDLER_TIMEOUT=7200

park() { # <base> [execution frontmatter lines]
  local base="$1" metadata="${2:-}" wt
  wt="$(mktemp -d "$TR/park.XXXXXX")"
  git clone -q --single-branch --branch journal2 "$BARE" "$wt"
  {
    printf '%s\n' '---' 'gate: orchestrated' 'orchestrated_by: campaign' 'priority: normal'
    [ -z "$metadata" ] || printf '%s\n' "$metadata"
    printf '%s\n\n# %s\n\nrun the stage\n' '---' "$base"
  } > "$wt/jobs/plan/$base.md"
  git -C "$wt" add "jobs/plan/$base.md"
  git -C "$wt" "${git_id[@]}" commit -q -m "park $base"
  git -C "$wt" push -q origin HEAD:journal2
  rm -rf "$wt"
}

origin_has() { git -C "$BARE" cat-file -e "journal2:$1" 2>/dev/null; }
origin_show() { git -C "$BARE" show "journal2:$1" 2>/dev/null; }
promote_rc() {
  local base="$1" rc=0
  "$JOBS/promote-plan.sh" "$base" > "$TR/$base.log" 2>&1 || rc=$?
  printf '%s\n' "$rc"
}

park campaign-shepherd-ci
rc="$(promote_rc campaign-shepherd-ci)"
[ "$rc" -eq 4 ] \
  && ok "missing shepherd execution metadata is refused" \
  || bad "missing metadata returned $rc instead of 4"
{ origin_has jobs/plan/campaign-shepherd-ci.md \
  && ! origin_has jobs/todo/campaign-shepherd-ci.md; } \
  && ok "a refused child remains parked and never enters todo" \
  || bad "a refused child moved out of plan"
grep -q 'role: shepherd.*handler-budget-role: shepherd.*handler-timeout: 7200' "$TR/campaign-shepherd-ci.log" \
  && ok "the refusal names every accepted remedy" \
  || bad "the refusal did not explain the required metadata"

park role-shepherd-ci 'role: shepherd'
[ "$(promote_rc role-shepherd-ci)" -eq 0 ] \
  && origin_show jobs/todo/role-shepherd-ci.md | grep -q '^role: shepherd$' \
  && ok "role: shepherd promotes and survives frontmatter stripping" \
  || bad "role: shepherd did not promote intact"

park budget-role-shepherd-ci 'handler-budget-role: shepherd'
[ "$(promote_rc budget-role-shepherd-ci)" -eq 0 ] \
  && origin_show jobs/todo/budget-role-shepherd-ci.md | grep -q '^handler-budget-role: shepherd$' \
  && ok "an equivalent handler budget role promotes and survives" \
  || bad "handler-budget-role: shepherd did not promote intact"

park timeout-shepherd-ci 'handler-timeout: 7200'
[ "$(promote_rc timeout-shepherd-ci)" -eq 0 ] \
  && origin_show jobs/todo/timeout-shepherd-ci.md | grep -q '^handler-timeout: 7200$' \
  && ok "an explicit shepherd-sized timeout promotes and survives" \
  || bad "the shepherd-sized timeout did not promote intact"

park short-shepherd-ci 'handler-timeout: 5400'
[ "$(promote_rc short-shepherd-ci)" -eq 4 ] \
  && ok "a non-equivalent short timeout is refused" \
  || bad "a short timeout was accepted"

park overridden-shepherd-ci 'handler-budget-role: shepherd
handler-timeout: 5400'
[ "$(promote_rc overridden-shepherd-ci)" -eq 4 ] \
  && ok "a short explicit timeout overrides and invalidates a long budget role" \
  || bad "a short override was masked by the budget role"

park campaign-worker-ci
[ "$(promote_rc campaign-worker-ci)" -eq 0 ] \
  && ok "an ordinary orchestrated child keeps the fleet default" \
  || bad "the narrow basename guard blocked an ordinary child"

printf 'passed %d, failed %d\n' "$pass" "$fail"
[ "$fail" -eq 0 ]
