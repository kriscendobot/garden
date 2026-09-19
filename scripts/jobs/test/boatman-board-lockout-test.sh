#!/bin/bash
# boatman-board-lockout-test.sh — regression guard for the DEDICATED FERRY DISPATCH
# change (job dedicated-ferry-dispatch): the boatman is dispatched ONLY by
# scripts/ferry.sh off the dedicated jobs/ferry/ board, and is LOCKED OUT of the
# generic job board mechanically (not just by doc).
#
# WHAT THIS PINS:
#   1. post-job.sh REFUSES a `role: boatman` post (via --role) and writes nothing.
#   2. post-job.sh REFUSES a body that carries `role: boatman` in its frontmatter.
#   3. post-job.sh posts a NON-boatman job normally (the guard is narrow).
#   4. claim-job.sh SKIPS a `role: boatman` job already on the board (defense in
#      depth for any path that reached todo/ — post-plan/promote/hand-written):
#      it is never claimed and stays in todo/; a sibling non-boatman job IS claimed.
#   5. With ONLY the boatman job left, claim finds NOTHING (exit 3) — it is never
#      race-claimed and run under the bot identity.
#
# Real scripts drive a throwaway journal remote + host-local $GARDEN_STATE; systemd
# is not required. Modeled on project-pause-enforcement-test.sh.
set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env so a live gardener running this as a board job cannot splice
# its own GARDEN_*/JOURNAL_* underneath the fixture.
# shellcheck disable=SC2046
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true
export GARDEN_TEST=1

BRANCH=journal2
declare -a GIT_ID=(-c user.name=test -c user.email=test@localhost)
TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-boatlock.XXXXXX")"; trap 'rm -rf "$TR"' EXIT

# new_journal <tag> [--with-board] → echo bare path. --with-board seeds two todo
# jobs: one carrying `role: boatman` (must be locked out) and one ordinary.
new_journal() {
  local tag="$1" board="${2:-}"; local bare="$TR/$tag.git" seed="$TR/$tag.seed"
  git init -q --bare "$bare"
  git init -q "$seed"; git -C "$seed" checkout -q -b "$BRANCH"
  ( cd "$seed"
    mkdir -p jobs/todo jobs/doin jobs/tada jobs/plan jobs/index work repos msgs hosts \
             entries schedules cursors config \
             inbox/maintainer/unread inbox/maintainer/read
    for d in jobs/todo jobs/doin jobs/tada jobs/plan jobs/index work repos msgs hosts \
             entries schedules cursors config \
             inbox/maintainer/unread inbox/maintainer/read; do touch "$d/.gitkeep"; done
    if [ "$board" = --with-board ]; then
      printf -- '---\nrole: boatman\nidentity_switch_authorized: true\n---\n\n# ferry-stray\n\nferry #387 upstream\n' > jobs/todo/ferry-stray.md
      printf '# endo-safe-seed\n\ndo some ordinary endo work\n' > jobs/todo/endo-safe-seed.md
    fi )
  git -C "$seed" add -A
  git -C "$seed" "${GIT_ID[@]}" commit -q -m "seed board"
  git -C "$seed" remote add origin "$bare"
  git -C "$seed" push -q -u origin "$BRANCH"
  printf '%s\n' "$bare"
}

runj() { # runj <bare> <state> <garden> <script> [args...]
  local bare="$1" state="$2" garden="$3" script="$4"; shift 4
  env GARDEN="$garden" GARDEN_STATE="$state" HOME="$TR" \
      JOURNAL_REMOTE="$bare" JOURNAL_BRANCH="$BRANCH" \
      GARDEN_PRODUCER_CLONE="$state/producer/journal" \
      GARDEN_NO_MAINTAINER_ALERT=1 \
      "$JOBS/$script" "$@"
}
btree()  { git -C "$1" ls-tree -r --name-only "$BRANCH"; }
has()    { btree "$1" | grep -qx "$2"; }
bodyfile() { local f; f="$(mktemp "$TR/body.XXXXXX")"; printf '%s\n' "$1" > "$f"; printf '%s' "$f"; }

# ============================================================================
hr; echo "SUBTEST 1 — post-job.sh refuses --role boatman, writes nothing"; hr
B1="$(new_journal s1)"; S1="$TR/s1state"
set +e
runj "$B1" "$S1" host1 post-job.sh --role boatman ferry-viarole "$(bodyfile 'ferry #1 upstream')" >/dev/null 2>&1
rc=$?
set -e
{ [ "$rc" -ne 0 ] && ! has "$B1" "jobs/todo/ferry-viarole.md"; } \
  && ok "post-job refused --role boatman (rc=$rc) and wrote nothing" \
  || bad "post-job did NOT refuse --role boatman (rc=$rc, on-board=$(has "$B1" jobs/todo/ferry-viarole.md && echo yes || echo no))"

# ============================================================================
hr; echo "SUBTEST 2 — post-job.sh refuses a body carrying role: boatman"; hr
B2="$(new_journal s2)"; S2="$TR/s2state"
set +e
runj "$B2" "$S2" host2 post-job.sh ferry-viabody \
  "$(bodyfile '---
role: boatman
identity_switch_authorized: true
---

ferry #2 upstream')" >/dev/null 2>&1
rc=$?
set -e
{ [ "$rc" -ne 0 ] && ! has "$B2" "jobs/todo/ferry-viabody.md"; } \
  && ok "post-job refused a role: boatman body (rc=$rc) and wrote nothing" \
  || bad "post-job did NOT refuse a role: boatman body (rc=$rc)"

# ============================================================================
hr; echo "SUBTEST 3 — post-job.sh posts a NON-boatman job normally (guard is narrow)"; hr
B3="$(new_journal s3)"; S3="$TR/s3state"
set +e
runj "$B3" "$S3" host3 post-job.sh --role fixer fix-ordinary "$(bodyfile 'fix #3')" >/dev/null 2>&1
rc=$?
set -e
{ [ "$rc" -eq 0 ] && has "$B3" "jobs/todo/fix-ordinary.md"; } \
  && ok "post-job posts a non-boatman job normally" \
  || bad "post-job failed on an ordinary job (rc=$rc)"

# ============================================================================
hr; echo "SUBTEST 4 — claim-job.sh skips a role: boatman board job, claims a sibling"; hr
B4="$(new_journal s4 --with-board)"; S4="$TR/s4state"
# Board has ferry-stray (role: boatman, must be locked out) + endo-safe-seed (ordinary).
set +e
claimed="$(runj "$B4" "$S4" host4 claim-job.sh 1 2>/dev/null)"; crc=$?
set -e
{ [ "$crc" -eq 0 ] && [ "$claimed" = endo-safe-seed ]; } \
  && ok "claim landed the ordinary job, not the boatman job" \
  || bad "claim returned '$claimed' (rc=$crc); expected endo-safe-seed"
has "$B4" "jobs/todo/ferry-stray.md" \
  && ok "the role: boatman job stayed in todo/ (never claimed)" \
  || bad "the role: boatman job left todo/ (was it claimed?)"

# ============================================================================
hr; echo "SUBTEST 5 — with ONLY the boatman job left, claim finds NOTHING (exit 3)"; hr
# Drain the ordinary job so only the boatman candidate remains.
rpt="$(mktemp "$TR/rpt.XXXXXX")"; printf 'done\n' > "$rpt"
runj "$B4" "$S4" host4 complete-job.sh 1 endo-safe-seed "$rpt" >/dev/null 2>&1 || true
set +e
claimed2="$(runj "$B4" "$S4" host4 claim-job.sh 1 2>/dev/null)"; crc2=$?
set -e
{ [ "$crc2" -eq 3 ] && [ -z "$claimed2" ] && has "$B4" "jobs/todo/ferry-stray.md"; } \
  && ok "sole boatman candidate → claim finds NOTHING (exit 3), job stays in todo (never run under the bot)" \
  || bad "claim wrongly took the sole boatman candidate (rc=$crc2 claimed='$claimed2')"

hr
echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
