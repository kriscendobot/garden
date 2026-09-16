#!/bin/bash
# Regression coverage for the first-class pending-maintainer-decision gate.
#
# Pins four invariants:
#   1. the gate cannot be posted without both an answerable question and URL;
#   2. annotate-plan can atomically repair a wrongly deferred/synthetic-blocked job;
#   3. promotion requires the explicit maintainer path; and
#   4. an awaiting-maintainer job survives a real foreman tick in plan/, unclaimed.
set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
BRANCH=journal2
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }

# Scrub live-fleet settings before installing the hermetic fixture.
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true
export GARDEN_TEST=1
TR="$(mktemp -d "${TMPDIR:-$HOME}/.garden-awaiting-maintainer-test.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
git_id=(-c user.name=test -c user.email=test@localhost)

new_journal() { # <tag>
  local tag="$1" bare="$TR/$1.git" seed="$TR/$1.seed"
  git init -q --bare "$bare"
  git init -q "$seed"; git -C "$seed" checkout -q -b "$BRANCH"
  mkdir -p "$seed"/jobs/{todo,doin,tada,plan} "$seed"/{work,repos,msgs,hosts,entries,schedules,cursors,config} \
    "$seed"/inbox/maintainer/{unread,read}
  for d in jobs/todo jobs/doin jobs/tada jobs/plan work repos msgs hosts entries \
           schedules cursors config inbox/maintainer/unread inbox/maintainer/read; do
    touch "$seed/$d/.gitkeep"
  done
  git -C "$seed" add -A
  git -C "$seed" "${git_id[@]}" commit -q -m seed
  git -C "$seed" remote add origin "$bare"
  git -C "$seed" push -q -u origin "$BRANCH"
  printf '%s\n' "$bare"
}

show_path() { git -C "$1" show "$BRANCH:$2" 2>/dev/null || true; }
has_path() { git -C "$1" cat-file -e "$BRANCH:$2" 2>/dev/null; }

BARE="$(new_journal primitive)"
export JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH"
export GARDEN=testhost GARDEN_STATE="$TR/state" GARDEN_ROOT="$TR" GARDEN_POST_ATTEMPTS=10
printf '# pending work\n' > "$TR/body"

rc=0
"$JOBS/post-plan.sh" --awaiting-maintainer missing-fields "$TR/body" >/dev/null 2>&1 || rc=$?
[ "$rc" -ne 0 ] && ok "post refuses an opaque awaiting-maintainer hold" \
  || bad "post accepted awaiting-maintainer without question/URL"

"$JOBS/post-plan.sh" --awaiting-maintainer \
  --question "Which deployment should serve the guest?" \
  --asked-at "https://github.com/example/project/issues/7#issuecomment-9" \
  pending-answer "$TR/body" >/dev/null
got="$(show_path "$BARE" jobs/plan/pending-answer.md)"
{ grep -q '^gate: awaiting-maintainer$' <<<"$got" \
  && grep -q '^maintainer_question: Which deployment should serve the guest?$' <<<"$got" \
  && grep -q '^asked_at: https://github.com/example/project/issues/7#issuecomment-9$' <<<"$got"; } \
  && ok "post records the gate, question, and answer URL" \
  || bad "posted gate metadata is incomplete: $got"

# Seed the exact workaround this gate replaces: a fake blocked edge used only to
# keep the foreman away. annotate-plan must change the gate and remove the edge in
# one CAS commit.
EDIT="$TR/edit"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$EDIT"
printf -- '---\ngate: blocked\nblocked_on: made-up-human-answer\npriority: normal\n---\n\n# repaired work\n' \
  > "$EDIT/jobs/plan/repair-me.md"
git -C "$EDIT" add jobs/plan/repair-me.md
git -C "$EDIT" "${git_id[@]}" commit -q -m 'seed synthetic blocker'
git -C "$EDIT" push -q origin "HEAD:$BRANCH"
"$JOBS/annotate-plan.sh" --awaiting-maintainer \
  --question "Tier 1 only, or Tier 1 plus Tier 2?" \
  --asked-at "https://github.com/example/project/pull/8#issuecomment-10" \
  repair-me </dev/null >/dev/null
got="$(show_path "$BARE" jobs/plan/repair-me.md)"
{ grep -q '^gate: awaiting-maintainer$' <<<"$got" && ! grep -q '^blocked_on:' <<<"$got"; } \
  && ok "annotate atomically replaces a synthetic blocked edge" \
  || bad "annotate left the wrong gate/edge: $got"

rc=0
"$JOBS/promote-plan.sh" pending-answer >/dev/null 2>&1 || rc=$?
{ [ "$rc" -eq 5 ] && has_path "$BARE" jobs/plan/pending-answer.md \
  && ! has_path "$BARE" jobs/todo/pending-answer.md; } \
  && ok "ordinary promotion cannot clear the maintainer-decision gate" \
  || bad "ordinary promotion cleared or mishandled the gate (rc=$rc)"

"$JOBS/promote-plan.sh" --maintainer pending-answer >/dev/null
got="$(show_path "$BARE" jobs/todo/pending-answer.md)"
{ grep -q 'garden-promoted-from-plan: gate=awaiting-maintainer .* maintainer=true ' <<<"$got" \
  && ! grep -q '^gate:' <<<"$got"; } \
  && ok "explicit maintainer promotion releases the job with provenance" \
  || bad "maintainer promotion did not produce a clean todo job: $got"

# End-to-end foreman regression on an otherwise empty board. A zero settle window
# takes two ticks: settle-start, then pump. The handler may mint unrelated work;
# the held job itself must remain in plan/ and never appear in todo/ or doin/.
FBARE="$(new_journal foreman)"; FSTATE="$TR/foreman-state"
export JOURNAL_REMOTE="$FBARE" GARDEN_STATE="$FSTATE"
"$JOBS/post-plan.sh" --awaiting-maintainer \
  --question "May this work begin?" \
  --asked-at "https://github.com/example/project/issues/11" \
  foreman-must-not-claim "$TR/body" >/dev/null
tick() {
  env GARDEN_FOREMAN_IDLE_SETTLE=0 GARDEN_FOREMAN_ACTIVE_TARGET=1 \
    GARDEN_FOREMAN_HANDLER="$HERE/foreman-stub.sh" \
    GARDEN_FOREMAN_STUB_CALLS="$FSTATE/stub-calls" \
    "$JOBS/foreman.sh" >/dev/null 2>&1
}
tick; tick
{ has_path "$FBARE" jobs/plan/foreman-must-not-claim.md \
  && ! has_path "$FBARE" jobs/todo/foreman-must-not-claim.md \
  && ! has_path "$FBARE" jobs/doin/foreman-must-not-claim.md; } \
  && ok "awaiting-maintainer job survives a real foreman tick unclaimed" \
  || bad "foreman moved the awaiting-maintainer job out of plan/"

echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
