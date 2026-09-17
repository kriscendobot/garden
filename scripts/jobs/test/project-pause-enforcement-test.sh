#!/bin/bash
# project-pause-enforcement-test.sh — regression guard for the PROJECT PAUSE
# enforcement (job enforce-project-pause-as-journal-state): a maintainer pause on a
# whole project, represented as JOURNAL STATE (pauses/<slug>.md on journal2) and
# enforced at the post/claim/promote chokepoints so a host running a STALE garden
# cannot violate it — the gap that produced the 2026-09-16/17 IronHorse fuzz storm.
#
# WHAT THIS PINS:
#   1. pause-project.sh on writes pauses/<slug>.md; status/list report it; off lifts it.
#   2. project_pause_hit predicate matches by the always-readable filename slug and by
#      `match:` patterns; misses an unpaused project.
#   3. post-job.sh REFUSES a paused-project job (rc=GARDEN_PAUSED_RC) and posts nothing;
#      an unpaused job posts normally.
#   4. post-plan.sh REFUSES parking a paused-project job; an unpaused one parks.
#   5. claim-job.sh SKIPS a paused todo job already on the board (defense in depth):
#      it is never claimed, and stays in todo/.
#   6. promote-plan.sh REFUSES to promote a paused plan item EVEN under --maintainer;
#      an unpaused plan item promotes.
#   7. FAIL SAFE — a corrupt/unreadable pause record still BLOCKS a matching job
#      (existence + filename slug is the signal), consistent with foreman_braked.
#   8. LIFT re-opens all four chokepoints.
#   9. The refusal delivers a COALESCED per-project maintainer alert (key
#      project-pause-active-<slug>), not one message per job.
#
# Real scripts drive throwaway journal remotes + host-local $GARDEN_STATE; systemd is
# not required. Modeled on foreman-brake-test.sh / post-loop-wallclock-deadline-test.sh.
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
TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-ppause.XXXXXX")"; trap 'rm -rf "$TR"' EXIT

# GARDEN_PAUSED_RC is the refusal exit code the chokepoints use; read it from common.sh
# so the test tracks the source of truth rather than hard-coding 78.
PAUSED_RC="$(bash -c 'source "'"$JOBS"'/common.sh" >/dev/null 2>&1; printf %s "$GARDEN_PAUSED_RC"')"
[ -n "$PAUSED_RC" ] || PAUSED_RC=78

# new_journal <tag> [--with-board] → echo bare path. Fresh throwaway journal seeded
# with the board directory skeleton. --with-board also seeds two todo + two plan jobs:
# one IronHorse-named (paused project) and one endo-named (unpaused).
new_journal() {
  local tag="$1" board="${2:-}"; local bare="$TR/$tag.git" seed="$TR/$tag.seed"
  git init -q --bare "$bare"
  git init -q "$seed"; git -C "$seed" checkout -q -b "$BRANCH"
  ( cd "$seed"
    mkdir -p jobs/todo jobs/doin jobs/tada jobs/plan jobs/index work repos msgs hosts \
             entries schedules cursors config pauses \
             inbox/maintainer/unread inbox/maintainer/read
    for d in jobs/todo jobs/doin jobs/tada jobs/plan jobs/index work repos msgs hosts \
             entries schedules cursors config pauses \
             inbox/maintainer/unread inbox/maintainer/read; do touch "$d/.gitkeep"; done
    if [ "$board" = --with-board ]; then
      printf '# ironhorse-fuzz-seed\n\nrepair an ironhorse fuzz finding\n' > jobs/todo/ironhorse-fuzz-seed.md
      printf '# endo-safe-seed\n\ndo some ordinary endo work\n' > jobs/todo/endo-safe-seed.md
      printf -- '---\ngate: deferred\npriority: normal\n---\n\n# ironhorse-262-seed\n\nrun an ironhorse test262 sweep\n' > jobs/plan/ironhorse-262-seed.md
      printf -- '---\ngate: deferred\npriority: normal\n---\n\n# endo-plan-seed\n\npark some ordinary endo work\n' > jobs/plan/endo-plan-seed.md
    fi )
  git -C "$seed" add -A
  git -C "$seed" "${GIT_ID[@]}" commit -q -m "seed board"
  git -C "$seed" remote add origin "$bare"
  git -C "$seed" push -q -u origin "$BRANCH"
  printf '%s\n' "$bare"
}

# env wrapper: run a jobs script against a bare remote + isolated host state.
runj() { # runj <bare> <state> <garden> <script> [args...]
  local bare="$1" state="$2" garden="$3" script="$4"; shift 4
  env GARDEN="$garden" GARDEN_STATE="$state" HOME="$TR" \
      JOURNAL_REMOTE="$bare" JOURNAL_BRANCH="$BRANCH" \
      GARDEN_PRODUCER_CLONE="$state/producer/journal" \
      GARDEN_NO_MAINTAINER_ALERT=1 \
      "$JOBS/$script" "$@"
}

# tree helpers against a bare remote
btree()  { git -C "$1" ls-tree -r --name-only "$BRANCH"; }
has()    { btree "$1" | grep -qx "$2"; }
bodyfile() { local f; f="$(mktemp "$TR/body.XXXXXX")"; printf '%s\n' "$1" > "$f"; printf '%s' "$f"; }

# ============================================================================
hr; echo "SUBTEST 1 — pause-project.sh on|status|list|off"; hr
B1="$(new_journal s1)"; S1="$TR/s1state"
runj "$B1" "$S1" host1 pause-project.sh ironhorse on \
  --maintainer kumavis --directive "kriscendobot/garden#91, 2026-09-09" \
  --scope "all IronHorse implementation/review/test262/fuzz" >/dev/null 2>&1
has "$B1" "pauses/ironhorse.md" && ok "on wrote pauses/ironhorse.md to journal2" || bad "pause record not on the remote after 'on'"
st="$(runj "$B1" "$S1" host1 pause-project.sh status ironhorse 2>&1 || true)"
grep -q 'PAUSED: ironhorse' <<<"$st" && ok "status reports PAUSED" || bad "status did not report PAUSED (got: $st)"
ls_out="$(runj "$B1" "$S1" host1 pause-project.sh list 2>&1 || true)"
grep -q 'ironhorse' <<<"$ls_out" && grep -q 'kumavis' <<<"$ls_out" && ok "list surfaces the pause + maintainer" || bad "list missed the pause (got: $ls_out)"
runj "$B1" "$S1" host1 pause-project.sh ironhorse off >/dev/null 2>&1
has "$B1" "pauses/ironhorse.md" && bad "record still present after 'off'" || ok "off lifted (deleted) the pause record"

# ============================================================================
hr; echo "SUBTEST 2 — project_pause_hit predicate (slug + patterns, and miss)"; hr
( set +e
  export GARDEN_STATE="$TR/s2/pred"; mkdir -p "$GARDEN_STATE"
  # shellcheck source=../common.sh
  source "$JOBS/common.sh"
  CLONE="$TR/s2clone"; mkdir -p "$CLONE/$GARDEN_PAUSES_PATH"
  printf 'project: ironhorse\nmatch: test262\n---\npaused\n' > "$CLONE/$GARDEN_PAUSES_PATH/ironhorse.md"
  bf="$TR/s2body"; printf 'ordinary endo work\n' > "$bf"
  # (a) base names the slug → hit
  if project_pause_hit "$CLONE" "ironhorse-fuzz-x" "$bf" >/dev/null; then echo HIT_SLUG; else echo MISS_SLUG; fi
  # (b) body matches a match: pattern (test262) though base does not name slug → hit
  printf 'run a test262 sweep\n' > "$bf"
  if project_pause_hit "$CLONE" "some-sweep" "$bf" >/dev/null; then echo HIT_PATTERN; else echo MISS_PATTERN; fi
  # (c) neither base nor body identifies with the paused project → miss
  printf 'ordinary endo work\n' > "$bf"
  if project_pause_hit "$CLONE" "endo-safe" "$bf" >/dev/null; then echo HIT_UNRELATED; else echo MISS_UNRELATED; fi
  # (d) no records at all → miss
  rm -f "$CLONE/$GARDEN_PAUSES_PATH/ironhorse.md"
  if project_pause_hit "$CLONE" "ironhorse-fuzz-x" "$bf" >/dev/null; then echo HIT_NORECORD; else echo MISS_NORECORD; fi
) > "$TR/s2.out" 2>/dev/null || true
grep -qx HIT_SLUG      "$TR/s2.out" && ok "predicate matches a job whose base names the slug" || bad "predicate missed the slug match"
grep -qx HIT_PATTERN   "$TR/s2.out" && ok "predicate matches a match: body pattern"             || bad "predicate missed the pattern match"
grep -qx MISS_UNRELATED "$TR/s2.out" && ok "predicate misses an unrelated (unpaused) job"        || bad "predicate false-positived an unrelated job"
grep -qx MISS_NORECORD "$TR/s2.out" && ok "predicate misses when there is no pause record"      || bad "predicate hit with no record present"

# ============================================================================
hr; echo "SUBTEST 3 — post-job.sh refuses a paused post, allows an unpaused post"; hr
B3="$(new_journal s3)"; S3="$TR/s3state"
runj "$B3" "$S3" host3 pause-project.sh ironhorse on --maintainer kumavis \
  --directive "#91" --scope "all ironhorse work" >/dev/null 2>&1
set +e
runj "$B3" "$S3" host3 post-job.sh ironhorse-fuzz-new "$(bodyfile 'repair ironhorse fuzz finding')" >/dev/null 2>&1
rc=$?
set -e
{ [ "$rc" -eq "$PAUSED_RC" ] && ! has "$B3" "jobs/todo/ironhorse-fuzz-new.md"; } \
  && ok "post-job refused the paused job (rc=$PAUSED_RC) and wrote nothing" \
  || bad "post-job did not refuse the paused job (rc=$rc, on-board=$(has "$B3" jobs/todo/ironhorse-fuzz-new.md && echo yes || echo no))"
set +e
runj "$B3" "$S3" host3 post-job.sh endo-ordinary-new "$(bodyfile 'do some ordinary endo work')" >/dev/null 2>&1
rc2=$?
set -e
{ [ "$rc2" -eq 0 ] && has "$B3" "jobs/todo/endo-ordinary-new.md"; } \
  && ok "post-job posts an unpaused job normally" \
  || bad "post-job failed on an unpaused job (rc=$rc2)"

# ============================================================================
hr; echo "SUBTEST 4 — post-plan.sh refuses parking a paused job, allows unpaused"; hr
B4="$(new_journal s4)"; S4="$TR/s4state"
runj "$B4" "$S4" host4 pause-project.sh ironhorse on --maintainer kumavis \
  --directive "#91" --scope "all ironhorse work" >/dev/null 2>&1
set +e
runj "$B4" "$S4" host4 post-plan.sh ironhorse-opt-new "$(bodyfile 'park an ironhorse optimization')" >/dev/null 2>&1
rc=$?
set -e
{ [ "$rc" -eq "$PAUSED_RC" ] && ! has "$B4" "jobs/plan/ironhorse-opt-new.md"; } \
  && ok "post-plan refused the paused park (rc=$PAUSED_RC) and wrote nothing" \
  || bad "post-plan did not refuse the paused park (rc=$rc)"
set +e
runj "$B4" "$S4" host4 post-plan.sh endo-plan-new "$(bodyfile 'park ordinary endo work')" >/dev/null 2>&1
rc2=$?
set -e
{ [ "$rc2" -eq 0 ] && has "$B4" "jobs/plan/endo-plan-new.md"; } \
  && ok "post-plan parks an unpaused job normally" \
  || bad "post-plan failed on an unpaused park (rc=$rc2)"

# ============================================================================
hr; echo "SUBTEST 5 — claim-job.sh skips a paused todo job, claims an unpaused one"; hr
B5="$(new_journal s5 --with-board)"; S5="$TR/s5state"
runj "$B5" "$S5" host5 pause-project.sh ironhorse on --maintainer kumavis \
  --directive "#91" --scope "all ironhorse work" >/dev/null 2>&1
# Board has ironhorse-fuzz-seed (paused) + endo-safe-seed (unpaused). A claim must land
# the unpaused one and leave the paused one in todo/.
set +e
claimed="$(runj "$B5" "$S5" host5 claim-job.sh 1 2>/dev/null)"; crc=$?
set -e
{ [ "$crc" -eq 0 ] && [ "$claimed" = endo-safe-seed ]; } \
  && ok "claim landed the unpaused endo job, not the paused ironhorse job" \
  || bad "claim returned '$claimed' (rc=$crc); expected endo-safe-seed"
has "$B5" "jobs/todo/ironhorse-fuzz-seed.md" \
  && ok "the paused ironhorse job stayed in todo/ (never claimed)" \
  || bad "the paused ironhorse job left todo/ (was it claimed?)"
# Now drain the endo job so ONLY the paused candidate remains; the claim must find NONE.
rpt="$(mktemp "$TR/rpt.XXXXXX")"; printf 'done\n' > "$rpt"
runj "$B5" "$S5" host5 complete-job.sh 1 endo-safe-seed "$rpt" >/dev/null 2>&1 || true
set +e
claimed2="$(runj "$B5" "$S5" host5 claim-job.sh 1 2>/dev/null)"; crc2=$?
set -e
{ [ "$crc2" -eq 3 ] && [ -z "$claimed2" ] && has "$B5" "jobs/todo/ironhorse-fuzz-seed.md"; } \
  && ok "with only the paused candidate left, claim finds NOTHING (exit 3), job stays parked in todo" \
  || bad "claim wrongly took the sole paused candidate (rc=$crc2 claimed='$claimed2')"

# ============================================================================
hr; echo "SUBTEST 6 — promote-plan.sh refuses a paused plan item (even --maintainer)"; hr
B6="$(new_journal s6 --with-board)"; S6="$TR/s6state"
runj "$B6" "$S6" host6 pause-project.sh ironhorse on --maintainer kumavis \
  --directive "#91" --scope "all ironhorse work" >/dev/null 2>&1
set +e
runj "$B6" "$S6" host6 promote-plan.sh --maintainer ironhorse-262-seed >/dev/null 2>&1
rc=$?
set -e
{ [ "$rc" -eq "$PAUSED_RC" ] && has "$B6" "jobs/plan/ironhorse-262-seed.md" && ! has "$B6" "jobs/todo/ironhorse-262-seed.md"; } \
  && ok "promote refused the paused plan item even under --maintainer (rc=$PAUSED_RC); stayed in plan/" \
  || bad "promote did not refuse the paused plan item (rc=$rc)"
set +e
runj "$B6" "$S6" host6 promote-plan.sh endo-plan-seed >/dev/null 2>&1
rc2=$?
set -e
{ [ "$rc2" -eq 0 ] && has "$B6" "jobs/todo/endo-plan-seed.md"; } \
  && ok "promote moves an unpaused plan item into todo/" \
  || bad "promote failed on an unpaused plan item (rc=$rc2)"

# ============================================================================
hr; echo "SUBTEST 7 — FAIL SAFE: a corrupt/unreadable pause record still blocks"; hr
B7="$(new_journal s7)"; S7="$TR/s7state"
# Push a garbage (non-frontmatter, binary-ish) pause record directly, keyed by the
# ironhorse filename. Its CONTENT is unparseable; the filename slug is still readable.
GV="$(mktemp -d "$TR/gv.XXXXXX")"
git clone -q --single-branch --branch "$BRANCH" "$B7" "$GV"
mkdir -p "$GV/pauses"
printf '\x00\xff\x01garbage-not-frontmatter\x00' > "$GV/pauses/ironhorse.md"
git -C "$GV" add pauses/ironhorse.md
git -C "$GV" "${GIT_ID[@]}" commit -q -m "corrupt pause record"
git -C "$GV" push -q origin "HEAD:$BRANCH"
rm -rf "$GV"
set +e
runj "$B7" "$S7" host7 post-job.sh ironhorse-fuzz-corrupt "$(bodyfile 'repair ironhorse fuzz finding')" >/dev/null 2>&1
rc=$?
set -e
{ [ "$rc" -eq "$PAUSED_RC" ] && ! has "$B7" "jobs/todo/ironhorse-fuzz-corrupt.md"; } \
  && ok "a corrupt pause record still BLOCKS a matching post (fail safe toward paused)" \
  || bad "corrupt pause record failed OPEN — post landed (rc=$rc)"
# And an unpaused job is unaffected by the corrupt record.
set +e
runj "$B7" "$S7" host7 post-job.sh endo-unaffected "$(bodyfile 'ordinary endo work')" >/dev/null 2>&1
rc2=$?
set -e
{ [ "$rc2" -eq 0 ] && has "$B7" "jobs/todo/endo-unaffected.md"; } \
  && ok "the corrupt record does NOT block an unrelated job (blast radius bounded)" \
  || bad "corrupt record over-blocked an unrelated job (rc=$rc2)"

# ============================================================================
hr; echo "SUBTEST 8 — LIFT re-opens the chokepoints"; hr
B8="$(new_journal s8)"; S8="$TR/s8state"
runj "$B8" "$S8" host8 pause-project.sh ironhorse on --maintainer kumavis \
  --directive "#91" --scope "all ironhorse work" >/dev/null 2>&1
set +e
runj "$B8" "$S8" host8 post-job.sh ironhorse-before-lift "$(bodyfile 'ironhorse work')" >/dev/null 2>&1
rc_before=$?
set -e
runj "$B8" "$S8" host8 pause-project.sh ironhorse off >/dev/null 2>&1
set +e
runj "$B8" "$S8" host8 post-job.sh ironhorse-after-lift "$(bodyfile 'ironhorse work')" >/dev/null 2>&1
rc_after=$?
set -e
{ [ "$rc_before" -eq "$PAUSED_RC" ] && [ "$rc_after" -eq 0 ] && has "$B8" "jobs/todo/ironhorse-after-lift.md"; } \
  && ok "post refused while paused, then SUCCEEDS after lift (chokepoint re-opened)" \
  || bad "lift did not re-open posting (before=$rc_before after=$rc_after)"

# ============================================================================
hr; echo "SUBTEST 9 — a refusal delivers ONE coalesced per-project alert"; hr
B9="$(new_journal s9)"; S9="$TR/s9state"
runj "$B9" "$S9" host9 pause-project.sh ironhorse on --maintainer kumavis \
  --directive "#91" --scope "all ironhorse work" >/dev/null 2>&1
ALERTLOG="$TR/s9-alerts"; : > "$ALERTLOG"
ALERTSTUB="$TR/s9-alertstub.sh"
printf '#!/bin/bash\nprintf "%%s\\n" "$1" >> "%s"\n' "$ALERTLOG" > "$ALERTSTUB"; chmod +x "$ALERTSTUB"
# Drive TWO paused posts; the alert must key on project (project-pause-active-ironhorse),
# so it coalesces per project rather than per job. GARDEN_ALERT_CMD is the capture sink.
for jb in ironhorse-a ironhorse-b; do
  env GARDEN=host9 GARDEN_STATE="$S9" HOME="$TR" \
      JOURNAL_REMOTE="$B9" JOURNAL_BRANCH="$BRANCH" \
      GARDEN_PRODUCER_CLONE="$S9/producer/journal" \
      GARDEN_ALERT_CMD="$ALERTSTUB" GARDEN_ALERT_THROTTLE_SECS=0 \
      "$JOBS/post-job.sh" "$jb" "$(bodyfile 'ironhorse work')" >/dev/null 2>&1 || true
done
uniqkeys="$(sort -u "$ALERTLOG" 2>/dev/null | grep -c . || echo 0)"
allkeys="$(grep -c . "$ALERTLOG" 2>/dev/null || echo 0)"
{ [ "$uniqkeys" -eq 1 ] && grep -qx 'project-pause-active-ironhorse' "$ALERTLOG"; } \
  && ok "both refusals used ONE per-project alert key (project-pause-active-ironhorse); $allkeys deliveries, 1 key" \
  || bad "alert key not coalesced per project (unique keys=$uniqkeys, sample: $(head -2 "$ALERTLOG" | tr '\n' '|'))"

hr
echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
