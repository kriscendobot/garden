#!/bin/bash
# design-build-handoff-test.sh — regression test for the deterministic
# design-to-build dispatch (scripts/jobs/design-build-handoff.sh) and its
# acceptance by the posted-follow-up gate (assert-followup-posted.sh).
#
# Grounding: `design-minion-town-oauth-bonds` completed with draft design PR
# kriscendobot/minion.town#168 and its gauntlet staged, its report said "The build
# is one builder job", and the gate blocked the completion at 2026-10-07T22:13:39Z
# even though the build was already the parked next child of its orchestration.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-design-build-test.XXXXXX")"
trap 'rm -rf "$TR"' EXIT

git init -q --bare "$TR/journal.git"
git init -q "$TR/seed"
git -C "$TR/seed" checkout -q -b journal2
mkdir -p "$TR/seed/jobs/"{plan,todo,doin,tada,orch,gauntlet,index} \
  "$TR/seed/inbox/maintainer/"{unread,read}
for d in plan todo doin tada orch gauntlet index; do touch "$TR/seed/jobs/$d/.gitkeep"; done
touch "$TR/seed/inbox/maintainer/unread/.gitkeep" "$TR/seed/inbox/maintainer/read/.gitkeep"
git -C "$TR/seed" add -A
git -C "$TR/seed" -c user.name=test -c user.email=test@example.invalid commit -q -m seed
git -C "$TR/seed" remote add origin "$TR/journal.git"
git -C "$TR/seed" push -q origin HEAD:journal2

GARDEN_ROOT="$(cd "$JOBS/../.." && pwd)"; export GARDEN_ROOT
export GARDEN_TEST=1 JOURNAL_REMOTE="$TR/journal.git" JOURNAL_BRANCH=journal2
export GARDEN_STATE="$TR/state" GARDEN=design-build-test
export GARDEN_PRODUCER_CLONE="$TR/producer"

HANDOFF="$JOBS/design-build-handoff.sh"
GATE="$JOBS/assert-followup-posted.sh"
fail() { echo "FAIL: $*" >&2; exit 1; }
# Keep the gate's auto-escalation out of the way so a block is observable.
gate() { GARDEN_FOLLOWUP_GATE_MESSAGE_USER=false "$GATE" "$@"; }

board_file() {  # <relpath> <content-file>
  local rel="$1" content="$2" w="$TR/put"
  rm -rf "$w"; git clone -q --single-branch --branch journal2 "$TR/journal.git" "$w" >/dev/null 2>&1
  mkdir -p "$w/$(dirname "$rel")"
  cp "$content" "$w/$rel"
  git -C "$w" add -A
  git -C "$w" -c user.name=t -c user.email=t@t.invalid commit -q -m "put $rel"
  git -C "$w" push -q origin HEAD:journal2
}
board_has() {  # <relpath>
  local w="$TR/look"
  rm -rf "$w"; git clone -q --single-branch --branch journal2 "$TR/journal.git" "$w" >/dev/null 2>&1
  [ -e "$w/$1" ]
}
board_cat() {  # <relpath>
  board_has "$1" && cat "$TR/look/$1"
}
gauntlet_put() {  # <design-base> <pr-number>
  printf -- '---\npr: https://github.com/kriscendobot/minion.town/pull/%s\nrepo: kriscendobot/minion.town\npr_number: %s\nbuild_job: %s\nkind: feature\nstate: running\n---\n' \
    "$2" "$2" "$1" >"$TR/g.md"
  board_file "jobs/gauntlet/kriscendobot-minion.town-pr$2-gauntlet.md" "$TR/g.md"
}
gauntlet_tada_put() {  # <pr-number> <status> [extra-line]
  { printf 'gauntlet-status: %s\n' "$2"; [ -z "${3:-}" ] || printf '%s\n' "$3"
    printf '# gauntlet kriscendobot-minion.town-pr%s-gauntlet\n' "$1"; } >"$TR/gt.md"
  board_file "jobs/tada/2026/10/07/kriscendobot-minion.town-pr$1-gauntlet.md" "$TR/gt.md"
}
designer_job() {  # <path> [role]
  printf -- '---\nrole: %s\narc: minion-town-ui\ntier: mentor\n---\n# Design: OAuth bonds\n' "${2:-designer}" >"$1"
}
design_report() {  # <path> <pr-number> [follow-ups line]
  cat >"$1" <<EOF
# Design report: minion.town OAuth bonds (draft PR kriscendobot/minion.town#$2)

I wrote the design and opened it as draft PR **kriscendobot/minion.town#$2**.
It cites the related work in kriscendobot/minion.town#114.

## Follow-ups
- The completion machinery will run the design review on draft PR #$2 automatically.
- ${3:-The build is one builder job, or about two if the #114 store has not landed by then.}
- No inbox messages arrived during the job.
EOF
}
marker_count() { grep -c '^<!-- garden-design-build-handoff:' "$1" || true; }
reset_clone() { rm -rf "$GARDEN_PRODUCER_CLONE"; }

echo '== (a) the oauth-bonds replay: an orchestration-owned build is recognized =='
designer_job "$TR/ja.md"
design_report "$TR/ra.md" 168
gauntlet_put design-mt-bonds 168
printf -- '---\norder: serial\nchildren: design-mt-bonds build-mt-bonds\non-child-failure: halt\nstate: running\n---\n' >"$TR/o.md"
board_file jobs/orch/orch-mt-bonds.md "$TR/o.md"
printf -- '---\ngate: orchestrated\norchestrated_by: orch-mt-bonds\n---\nbuild it\n' >"$TR/p.md"
board_file jobs/plan/build-mt-bonds.md "$TR/p.md"
cp "$TR/ra.md" "$TR/ra-raw.md"
reset_clone
if gate design-mt-bonds "$TR/ja.md" "$TR/ra-raw.md"; then
  fail 'precondition: the gate should block the raw incident report'
fi
reset_clone
"$HANDOFF" design-mt-bonds "$TR/ja.md" "$TR/ra.md"
grep -qx '<!-- garden-design-build-handoff: successor=build-mt-bonds state=orchestrated:orch-mt-bonds pr=https://github.com/kriscendobot/minion.town/pull/168 -->' "$TR/ra.md" \
  || fail "no orchestrated marker: $(tail -2 "$TR/ra.md")"
board_has jobs/todo/build-mt-bonds.md && fail 'an orchestration-owned build must not be posted again'
reset_clone
gate design-mt-bonds "$TR/ja.md" "$TR/ra.md" || fail 'gate blocked a verified design-build handoff'
echo '   orchestration child recognized; gate passes'

echo '== (b) idempotent: a second run adds no second marker =='
"$HANDOFF" design-mt-bonds "$TR/ja.md" "$TR/ra.md"
[ "$(marker_count "$TR/ra.md")" -eq 1 ] || fail 'second run duplicated the marker'
echo '   one marker'

echo '== (c) gauntlet still running and no owner: build parked blocked_on the gauntlet =='
designer_job "$TR/jc.md"
design_report "$TR/rc.md" 201
gauntlet_put design-solo 201
reset_clone
"$HANDOFF" design-solo "$TR/jc.md" "$TR/rc.md"
grep -q 'successor=build-solo state=recheck:kriscendobot-minion.town-pr201-gauntlet ' "$TR/rc.md" \
  || fail "no recheck marker: $(tail -2 "$TR/rc.md")"
plan="$(board_cat jobs/plan/build-solo.md)" || fail 'no parked build plan'
printf '%s\n' "$plan" | grep -qx 'gate: blocked' || fail 'parked build is not gate: blocked'
printf '%s\n' "$plan" | grep -qx 'blocked_on: kriscendobot-minion.town-pr201-gauntlet' || fail 'parked build is not blocked_on the gauntlet'
printf '%s\n' "$plan" | grep -qx 'role: builder' || fail 'parked build does not wear the builder role'
printf '%s\n' "$plan" | grep -qx 'arc: minion-town-ui' || fail 'parked build lost the design arc'
printf '%s\n' "$plan" | grep -Fq 'https://github.com/kriscendobot/minion.town/pull/201' || fail 'parked build does not name the design PR'
reset_clone
gate design-solo "$TR/jc.md" "$TR/rc.md" || fail 'gate blocked a parked design-build recheck'
echo '   parked as a typed recheck; gate passes'

echo '== (d) gauntlet already complete: build posted to todo/ =='
designer_job "$TR/jd.md"
design_report "$TR/rd.md" 202
gauntlet_tada_put 202 complete
reset_clone
"$HANDOFF" design-done "$TR/jd.md" "$TR/rd.md"
grep -q 'successor=build-done state=posted ' "$TR/rd.md" || fail "no posted marker: $(tail -2 "$TR/rd.md")"
board_has jobs/todo/build-done.md || fail 'build was not posted to todo/'
echo '   posted to todo/'

echo '== (e) gauntlet finished halted: no build, no marker =='
designer_job "$TR/je.md"
design_report "$TR/re.md" 203
gauntlet_tada_put 203 halted 'orchestration-status: halted-ci'
reset_clone
"$HANDOFF" design-halted "$TR/je.md" "$TR/re.md"
[ "$(marker_count "$TR/re.md")" -eq 0 ] || fail 'halted gauntlet got a marker'
board_has jobs/todo/build-halted.md && fail 'halted gauntlet got a build'
board_has jobs/plan/build-halted.md && fail 'halted gauntlet got a parked build'
echo '   no dispatch'

echo '== (f) existing build job under the derived name is reused =='
designer_job "$TR/jf.md"
design_report "$TR/rf.md" 204
gauntlet_put design-have 204
printf -- '---\nrole: builder\n---\nbuild\n' >"$TR/b.md"
board_file jobs/todo/build-have.md "$TR/b.md"
reset_clone
"$HANDOFF" design-have "$TR/jf.md" "$TR/rf.md"
grep -q 'successor=build-have state=existing ' "$TR/rf.md" || fail "no existing marker: $(tail -2 "$TR/rf.md")"
echo '   existing build recognized'

echo '== (g) no-ops: wrong role, no build in follow-ups, foreign gauntlet, handoff ending =='
designer_job "$TR/jg.md" builder
design_report "$TR/rg.md" 205
gauntlet_put design-g 205
reset_clone
"$HANDOFF" design-g "$TR/jg.md" "$TR/rg.md"
[ "$(marker_count "$TR/rg.md")" -eq 0 ] || fail 'non-designer got a marker'

designer_job "$TR/jh.md"
design_report "$TR/rh.md" 206 'The design panel may want more diagrams.'
gauntlet_put design-h 206
reset_clone
"$HANDOFF" design-h "$TR/jh.md" "$TR/rh.md"
[ "$(marker_count "$TR/rh.md")" -eq 0 ] || fail 'follow-ups without a build got a marker'

designer_job "$TR/ji.md"
design_report "$TR/ri.md" 207
gauntlet_put someone-else 207
reset_clone
"$HANDOFF" design-i "$TR/ji.md" "$TR/ri.md"
[ "$(marker_count "$TR/ri.md")" -eq 0 ] || fail 'a gauntlet staged by another job was taken as this design PR'

designer_job "$TR/jk.md"
design_report "$TR/rk.md" 208
printf '\n<<<GARDEN-JOB-HANDED-OFF: elsewhere>>>\n' >>"$TR/rk.md"
gauntlet_put design-k 208
reset_clone
"$HANDOFF" design-k "$TR/jk.md" "$TR/rk.md"
[ "$(marker_count "$TR/rk.md")" -eq 0 ] || fail 'a handoff-ending report got a marker'
board_has jobs/plan/build-g.md && fail 'non-designer posted a build'
board_has jobs/plan/build-h.md && fail 'no-build follow-ups posted a build'
board_has jobs/plan/build-i.md && fail 'foreign gauntlet posted a build'
echo '   all no-ops'

echo '== (h) a marker naming an absent successor does not pass the gate =='
designer_job "$TR/jl.md"
design_report "$TR/rl.md" 209
printf '\n<!-- garden-design-build-handoff: successor=build-ghost state=posted pr=https://github.com/kriscendobot/minion.town/pull/209 -->\n' >>"$TR/rl.md"
reset_clone
if gate design-l "$TR/jl.md" "$TR/rl.md"; then
  fail 'gate accepted a design-build marker whose successor is not on the board'
fi
echo '   forged marker blocked'

echo 'PASS: design-build-handoff'
