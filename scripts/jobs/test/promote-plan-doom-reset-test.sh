#!/bin/bash
# promote-plan-doom-reset-test.sh — regression guard for the PROMOTION-CLEARS-THE-
# CYCLE-COUNTERS fix (improve-promote-plan-doom-reset, 2026-07-29).
#
# THE GAP THIS CLOSES: when the reaper DOOMS a job it parks it in jobs/plan/ under a
# held `go-ahead` gate with its cycle markers still in the body — notably the gardener's
# `<!-- garden-deadline-overrun: N -->` counter, which clean_body deliberately PRESERVES
# across a requeue so the count accumulates. promote-plan.sh's strip_frontmatter removed
# only the plan frontmatter and passed the body through verbatim, so the promoted todo
# job carried N forward. With GARDEN_REAP_OVERRUN_THRESHOLD=1 the very next reap cycle
# re-read the stale count, cleared the threshold on its FIRST evaluation, and parked the
# job straight back in plan/ WITHOUT ever granting it a requeue: promotion was a no-op
# the job could not escape. Observed live on the 07-26 doom park of
# endo-sturdyref-agent-surface-build-gauntlet, which then sat behind its go-ahead for
# days while the press tick advised that a promoting liaison "should clear or requeue
# past it" — a manual step no promoter reliably performs.
#
# THE FIX: promotion is a deliberate "run this again" act, so promote-plan.sh CLEARS the
# whole cycle-marker family (reap-count, deadline-overrun, elapsed-constancy, and the
# per-cycle reap-now / productive-cycle / outage-cycle hints) and records what it
# cleared in the existing
# `<!-- garden-promoted-from-plan: … -->` provenance comment, so the reset is auditable
# rather than silent. The reaper's protection is unchanged: a job that still fails
# deterministically re-accumulates and re-dooms on its own.
#
# THE PARKING HALF (fu-improve-promote-plan-doom-reset, 2026-07-29). Stripping only on
# the way OUT of plan/ left the way IN open: post-plan.sh — the primitive a producer
# RE-PARKS through, handing back a body it read off the board — passed that body through
# verbatim, so a stale `<!-- garden-deadline-overrun: N -->` was smuggled into plan/ and
# re-doomed the next promotion. post-plan.sh now performs the SAME strip, with the same
# common.sh helpers (strip_cycle_markers / cycle_marker_summary — one spelling of the
# family, shared by both halves), recording what it cleared in a `cleared:` frontmatter
# field emitted only when something actually was.
#
# SUBTEST 1 — promote-plan strips EVERY cycle marker from the promoted body, keeps the
#             work body and the execution frontmatter (role/model/handler-timeout), and
#             records the cleared set in the provenance comment (`cleared=none` when the
#             parked body carried none — the common non-doom promotion).
# SUBTEST 2 — end-to-end: reaper dooms an overrunning claim → promote → the promoted
#             job REQUEUES on its next stale cycle instead of re-dooming immediately;
#             the control (same body with the marker still on it) DOES re-doom, so the
#             reaper's protection is demonstrably intact.
# SUBTEST 3 — post-plan strips the same family at PARK time, records it in `cleared:`,
#             leaves a marker-free post byte-identical (idempotent, no stray field), and
#             never touches a body's own `---` rules or non-cycle HTML comments.
# SUBTEST 4 — end-to-end through the parking half: re-park a marker-carrying body with
#             post-plan → promote → the job REQUEUES on its next stale cycle instead of
#             being re-doomed on its first evaluation.
#
# THE ANNOTATION HALF (fu-fu-improve-promote-plan-doom-reset, 2026-07-29). post-plan
# and promote-plan bracket plan/ at both ends, but annotate-plan.sh is a THIRD writer
# into a parked body — it appends producer-supplied note text verbatim, so a producer
# piping a live job body as a note ("here is what the last cycle reported") re-introduced
# the whole family behind both strips. The promotion strip would still clear it at the
# exit, but the parked body meanwhile carries counters the job never earned: it is what
# every reader of plan/ sees, and it makes the promoter's `cleared=` provenance report a
# reset that never happened. annotate-plan.sh now performs the SAME strip on the note,
# with the same common.sh helpers, recording it as a `cleared=` token on the
# `<!-- garden-annotation: … -->` marker, emitted only when something actually was.
#
# SUBTEST 5 — annotate-plan strips the family from the appended note, keeps the note's
#             prose / non-cycle comments / `---` rules and the parked body, records the
#             cleared set on the annotation marker (and adds no token when there was
#             nothing to clear), refuses a note that is ENTIRELY markers, and promotes to
#             a `cleared=none` todo job rather than a laundered reset.
#
# Usage: promote-plan-doom-reset-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env (a live gardener running this test as a board job would
# otherwise splice its own GARDEN_*/JOURNAL_* state underneath the fixture).
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true

TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-promote-reset.XXXXXX")"; trap 'rm -rf "$TR"' EXIT
git_id=(-c user.name=test -c user.email=test@localhost)

# seed_board <dir> — throwaway origin with the board structure and nothing claimed.
seed_board() {
  local tr="$1" bare="$1/journal.git" seed="$1/seed" branch=journal2 d
  git init -q --bare "$bare"
  git init -q "$seed"; git -C "$seed" checkout -q -b "$branch"
  ( cd "$seed"
    mkdir -p jobs/todo jobs/doin jobs/tada jobs/plan work repos msgs hosts entries schedules cursors \
             inbox/maintainer/unread inbox/maintainer/read
    for d in jobs/todo jobs/doin jobs/tada jobs/plan work repos msgs hosts entries schedules cursors \
             inbox/maintainer/unread inbox/maintainer/read; do touch "$d/.gitkeep"; done )
  git -C "$seed" add -A
  git -C "$seed" "${git_id[@]}" commit -q -m "seed: board structure"
  git -C "$seed" remote add origin "$bare"
  git -C "$seed" push -q -u origin "$branch"
  printf '%s\n' "$bare"
}

# ============================================================================
hr; echo "SUBTEST 1 — promote-plan clears the cycle-marker family and records what it cleared"; hr
T1="$TR/strip"; mkdir -p "$T1"
BARE1="$(seed_board "$T1")"
export JOURNAL_REMOTE="$BARE1" JOURNAL_BRANCH=journal2
export GARDEN=promotehost GARDEN_STATE="$T1/state" GARDEN_SCRATCH="$T1/scratch"
export GARDEN_POST_ATTEMPTS=50
mkdir -p "$GARDEN_SCRATCH"

# park <base> <extra-body-lines…> — a plan job in the reaper's doom-park shape.
park() {
  local base="$1"; shift
  local wt; wt="$(mktemp -d "$T1/park.XXXXXX")"
  git clone -q --single-branch --branch journal2 "$BARE1" "$wt"
  {
    printf -- '---\ngate: go-ahead\npriority: normal\nposted_by: test\n'
    printf 'role: builder\nmodel: opus\nhandler-timeout: 5400\n'
    printf 'doomed: true\ndoom_signature: deadline-overrun\n'
    printf -- '---\n\n'
    printf '# %s\n\nthe original work body for %s\n\n' "$base" "$base"
    local line; for line in "$@"; do printf '%s\n' "$line"; done
  } > "$wt/jobs/plan/$base.md"
  git -C "$wt" add "jobs/plan/$base.md"
  git -C "$wt" "${git_id[@]}" commit -q -m "park $base"
  git -C "$wt" push -q origin HEAD:journal2
  rm -rf "$wt"
}
readback() {  # readback <relpath> — file contents from a fresh clone
  local v; v="$(mktemp -d "$T1/rb.XXXXXX")"
  git clone -q --single-branch --branch journal2 "$BARE1" "$v" 2>/dev/null
  cat "$v/$1" 2>/dev/null; rm -rf "$v"
}

park allmarkers \
  '<!-- garden-reaped: 4 -->' \
  '<!-- garden-deadline-overrun: 2 -->' \
  '<!-- garden-elapsed-constancy: 2 -->' \
  '<!-- garden-reap-now -->' \
  '<!-- garden-productive-cycle -->' \
  '<!-- garden-outage-cycle -->'
"$JOBS/promote-plan.sh" allmarkers > "$T1/promote.log" 2>&1 \
  || { echo "  (promote-plan rc=$?)"; sed 's/^/    /' "$T1/promote.log"; }
body="$(readback jobs/todo/allmarkers.md)"

strip_ok=1
for m in 'garden-reaped:' 'garden-deadline-overrun:' 'garden-elapsed-constancy:' 'garden-reap-now' 'garden-productive-cycle' 'garden-outage-cycle'; do
  printf '%s\n' "$body" | grep -q -- "$m" && { strip_ok=0; echo "    marker survived promotion: $m"; }
done
[ "$strip_ok" -eq 1 ] \
  && ok "every cycle marker (reaped / wall-hit / elapsed-constancy / reap-now / productive / outage) is cleared on promotion" \
  || bad "promotion left cycle markers on the todo body"

printf '%s\n' "$body" | grep -q 'the original work body for allmarkers' \
  && ok "the work body survives the marker strip" || bad "work body lost"
printf '%s\n' "$body" | grep -q '^gate:' \
  && bad "plan frontmatter leaked into the promoted body" || ok "plan frontmatter still stripped"
{ printf '%s\n' "$body" | grep -q '^role: builder$' \
  && printf '%s\n' "$body" | grep -q '^model: opus$' \
  && printf '%s\n' "$body" | grep -q '^handler-timeout: 5400$'; } \
  && ok "execution keys (role/model/handler-timeout) still preserved across promotion" \
  || bad "execution keys lost (regression on the earlier model-pin fix)"

prov="$(printf '%s\n' "$body" | grep 'garden-promoted-from-plan' | head -1)"
{ printf '%s' "$prov" | grep -q 'cleared=' \
  && printf '%s' "$prov" | grep -q 'reaped=4' \
  && printf '%s' "$prov" | grep -q 'deadline-overrun=2' \
  && printf '%s' "$prov" | grep -q 'elapsed-constancy=2' \
  && printf '%s' "$prov" | grep -q 'reap-now' \
  && printf '%s' "$prov" | grep -q 'productive-cycle' \
  && printf '%s' "$prov" | grep -q 'outage-cycle'; } \
  && ok "provenance records the cleared set: $prov" \
  || bad "provenance does not record what was cleared ($prov)"

# orchestrate.sh keys the promotion timestamp off `at=<value>`; the appended
# cleared= token must not shift what that parse returns.
at_parsed="$(printf '%s\n' "$body" | sed -n 's/.*garden-promoted-from-plan:.* at=\([^ >]*\).*/\1/p' | tail -1)"
printf '%s' "$at_parsed" | grep -Eq '^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z$' \
  && ok "orchestrate.sh's at= parse still yields the timestamp ($at_parsed)" \
  || bad "at= parse broken by the cleared= token (got '$at_parsed')"

# A clean (non-doom) plan job promotes with cleared=none — the marker strip must not
# invent provenance where there was nothing to clear.
park cleanjob
"$JOBS/promote-plan.sh" cleanjob > "$T1/promote-clean.log" 2>&1 \
  || { echo "  (promote-plan rc=$?)"; sed 's/^/    /' "$T1/promote-clean.log"; }
readback jobs/todo/cleanjob.md | grep -q 'cleared=none' \
  && ok "an undoomed promotion records cleared=none" \
  || bad "cleared=none missing on a marker-free promotion"

# ============================================================================
hr; echo "SUBTEST 2 — end-to-end: doom → promote → REQUEUES (no instant re-doom); control still dooms"; hr
T2="$TR/e2e"; mkdir -p "$T2"
BARE2="$(seed_board "$T2")"
export JOURNAL_REMOTE="$BARE2" GARDEN=reaphost GARDEN_STATE="$T2/state" GARDEN_SCRATCH="$T2/scratch"
export GARDEN_REAP_PUSH_ATTEMPTS=50 GARDEN_CLAIM_TTL=3600
export GARDEN_REAP_DOOM_THRESHOLD=5 GARDEN_REAP_OVERRUN_THRESHOLD=1
mkdir -p "$GARDEN_SCRATCH"

# place_stale <base> <body-file> — a STALE claim in doin (claimed_at long past TTL)
# whose body is <body-file> verbatim, exactly as a re-claim would carry it.
place_stale() {
  local base="$1" bodyfile="$2" wt; wt="$(mktemp -d "$T2/edit.XXXXXX")"
  git clone -q --single-branch --branch journal2 "$BARE2" "$wt"
  {
    cat "$bodyfile"
    printf -- '\n---\nclaim:\n  host: reaphost\n  gardener: 7\n  claimed_at: 2020-01-01T00:00:00Z\n'
  } > "$wt/jobs/doin/$base.md"
  printf 'worktree_dir: %s\n' "$T2/nonexistent-wt-$base" > "$wt/work/$base"
  git -C "$wt" add "jobs/doin/$base.md" "work/$base"
  git -C "$wt" "${git_id[@]}" commit -q -m "place stale $base"
  git -C "$wt" push -q origin HEAD:journal2
  rm -rf "$wt"
}
resync2() { rm -rf "$T2/v"; git clone -q --single-branch --branch journal2 "$BARE2" "$T2/v"; }

# (a) a deterministic overrunner dooms at GARDEN_REAP_OVERRUN_THRESHOLD=1. The
#     parked frontmatter preserves the count while its body drops the stale marker.
printf '# ovrjob\n\nthe original work body for ovrjob\n\n<!-- garden-deadline-overrun: 1 -->\n' > "$T2/ovr-body.md"
place_stale ovrjob "$T2/ovr-body.md"
"$JOBS/reaper.sh" > "$T2/reap1.log" 2>&1 || { echo "  (reaper rc=$?)"; sed 's/^/    /' "$T2/reap1.log"; }
resync2
{ [ -f "$T2/v/jobs/plan/ovrjob.md" ] && grep -q '^doomed: true$' "$T2/v/jobs/plan/ovrjob.md" \
  && grep -q '^deadline_overruns: 1$' "$T2/v/jobs/plan/ovrjob.md" \
  && ! grep -Eq '^<!-- garden-deadline-overrun:' "$T2/v/jobs/plan/ovrjob.md"; } \
  && ok "precondition: the overrunning claim is doom-parked with metadata preserved and its cycle marker stripped" \
  || bad "doom park did not happen as expected (the fixture's premise)"

# (b) promote it, then simulate the re-claim: the promoted body + a fresh (stale) claim
#     block is exactly what the reaper reads next cycle.
"$JOBS/promote-plan.sh" ovrjob > "$T2/promote.log" 2>&1 \
  || { echo "  (promote-plan rc=$?)"; sed 's/^/    /' "$T2/promote.log"; }
resync2
[ -f "$T2/v/jobs/todo/ovrjob.md" ] \
  && ok "the doomed job promoted back into todo/" || bad "promotion did not land in todo/"
cp "$T2/v/jobs/todo/ovrjob.md" "$T2/promoted-body.md"
place_stale ovrjob "$T2/promoted-body.md"
"$JOBS/reaper.sh" > "$T2/reap2.log" 2>&1 || { echo "  (reaper rc=$?)"; sed 's/^/    /' "$T2/reap2.log"; }
resync2
e2e_ok=1
[ -f "$T2/v/jobs/todo/ovrjob.md" ] || { e2e_ok=0; echo "    promoted job was not requeued to todo/"; }
[ -f "$T2/v/jobs/plan/ovrjob.md" ] && { e2e_ok=0; echo "    promoted job was RE-DOOMED on its first cycle (the bug)"; }
[ "$e2e_ok" -eq 1 ] \
  && ok "a promoted doom job gets a REAL requeue cycle instead of being re-doomed immediately" \
  || bad "promotion is still a no-op the job cannot escape"

# (c) control — the reaper's protection is unchanged: an identical body that STILL
#     carries the overrun marker re-dooms at once.
printf '# ctljob\n\nthe original work body for ctljob\n\n<!-- garden-deadline-overrun: 1 -->\n' > "$T2/ctl-body.md"
place_stale ctljob "$T2/ctl-body.md"
"$JOBS/reaper.sh" > "$T2/reap3.log" 2>&1 || { echo "  (reaper rc=$?)"; sed 's/^/    /' "$T2/reap3.log"; }
resync2
{ [ -f "$T2/v/jobs/plan/ctljob.md" ] && [ ! -f "$T2/v/jobs/todo/ctljob.md" ]; } \
  && ok "control: a body that still carries the counter DOES re-doom — reaper protection intact" \
  || bad "control failed: the reaper no longer dooms a genuine deterministic overrunner"

# ============================================================================
hr; echo "SUBTEST 3 — post-plan clears the same family at PARK time (the parking half)"; hr
T3="$TR/park"; mkdir -p "$T3"
BARE3="$(seed_board "$T3")"
export JOURNAL_REMOTE="$BARE3" JOURNAL_BRANCH=journal2
export GARDEN=parkhost GARDEN_STATE="$T3/state" GARDEN_SCRATCH="$T3/scratch"
export GARDEN_POST_ATTEMPTS=50
mkdir -p "$GARDEN_SCRATCH"
readback3() {
  local v; v="$(mktemp -d "$T3/rb.XXXXXX")"
  git clone -q --single-branch --branch journal2 "$BARE3" "$v" 2>/dev/null
  cat "$v/$1" 2>/dev/null; rm -rf "$v"
}

# A body exactly as a re-parker reads it off the board: real work, the accumulated
# cycle markers, plus a `---` rule and a NON-cycle HTML comment that must both survive.
cat > "$T3/dirty-body.md" <<'EOF'
# reparked

the original work body for reparked

---

<!-- some-other-marker: keep me -->
<!-- garden-reaped: 4 -->
<!-- garden-deadline-overrun: 2 -->
<!-- garden-elapsed-constancy: 2 -->
<!-- garden-reap-now -->
<!-- garden-productive-cycle -->
<!-- garden-outage-cycle -->
EOF
"$JOBS/post-plan.sh" --go-ahead --role builder reparked "$T3/dirty-body.md" > "$T3/post.log" 2>&1 \
  || { echo "  (post-plan rc=$?)"; sed 's/^/    /' "$T3/post.log"; }
parked="$(readback3 jobs/plan/reparked.md)"

strip3_ok=1
for m in 'garden-reaped:' 'garden-deadline-overrun:' 'garden-elapsed-constancy:' 'garden-reap-now' 'garden-productive-cycle' 'garden-outage-cycle'; do
  printf '%s\n' "$parked" | grep -q -- "$m" && { strip3_ok=0; echo "    marker survived the park: $m"; }
done
[ "$strip3_ok" -eq 1 ] \
  && ok "every cycle marker is cleared when a live body is re-parked into plan/" \
  || bad "post-plan still smuggles cycle markers into plan/"

printf '%s\n' "$parked" | grep -q 'the original work body for reparked' \
  && ok "the work body survives the park-time strip" || bad "work body lost at park time"
printf '%s\n' "$parked" | grep -q '<!-- some-other-marker: keep me -->' \
  && ok "a non-cycle HTML comment is untouched" || bad "the strip ate a non-cycle HTML comment"
# Plan frontmatter, automatic-routing frontmatter, and the body's rule: 5 total.
[ "$(printf '%s\n' "$parked" | grep -c '^---$')" -eq 5 ] \
  && ok "the body's own '---' rule survives beside both frontmatter blocks" \
  || bad "the body's '---' rule did not survive the park"

printf '%s\n' "$parked" | grep -q '^cleared: reaped=4,deadline-overrun=2,elapsed-constancy=2,reap-now,productive-cycle,outage-cycle$' \
  && ok "the park records what it cleared: $(printf '%s\n' "$parked" | grep '^cleared:')" \
  || bad "post-plan did not record the cleared set ($(printf '%s\n' "$parked" | grep '^cleared:' || echo '<no cleared: field>'))"

# A marker-free post must be BYTE-IDENTICAL to what it always was: no stray `cleared:`
# field, body untouched. (Also the idempotency check — a second strip is a no-op.)
printf '# cleanpark\n\nnothing to clear here\n' > "$T3/clean-body.md"
"$JOBS/post-plan.sh" --deferred cleanpark "$T3/clean-body.md" > "$T3/post-clean.log" 2>&1 \
  || { echo "  (post-plan rc=$?)"; sed 's/^/    /' "$T3/post-clean.log"; }
cleanparked="$(readback3 jobs/plan/cleanpark.md)"
printf '%s\n' "$cleanparked" | grep -q '^cleared:' \
  && bad "an ordinary (marker-free) post grew a spurious 'cleared:' field" \
  || ok "an ordinary post's frontmatter is unchanged (no 'cleared:' field)"
# Automatic routing adds its execution frontmatter before the cycle-marker strip.
# The original marker-free prose must remain unchanged inside that routed body.
{ printf '%s\n' "$cleanparked" | grep -q '^tier: mentor$' \
  && printf '%s\n' "$cleanparked" | grep -q '^# cleanpark$' \
  && printf '%s\n' "$cleanparked" | grep -q '^nothing to clear here$'; } \
  && ok "a marker-free body's routed frontmatter and prose survive the idempotent strip" \
  || bad "the strip mutated a marker-free body's routed content"

# ============================================================================
hr; echo "SUBTEST 4 — end-to-end: re-park via post-plan → promote → REQUEUES (no instant re-doom)"; hr
T4="$TR/e2e-park"; mkdir -p "$T4"
BARE4="$(seed_board "$T4")"
export JOURNAL_REMOTE="$BARE4" GARDEN=parke2ehost GARDEN_STATE="$T4/state" GARDEN_SCRATCH="$T4/scratch"
export GARDEN_REAP_PUSH_ATTEMPTS=50 GARDEN_CLAIM_TTL=3600
export GARDEN_REAP_DOOM_THRESHOLD=5 GARDEN_REAP_OVERRUN_THRESHOLD=1
mkdir -p "$GARDEN_SCRATCH"
resync4() { rm -rf "$T4/v"; git clone -q --single-branch --branch journal2 "$BARE4" "$T4/v"; }
place_stale4() {
  local base="$1" bodyfile="$2" wt; wt="$(mktemp -d "$T4/edit.XXXXXX")"
  git clone -q --single-branch --branch journal2 "$BARE4" "$wt"
  {
    cat "$bodyfile"
    printf -- '\n---\nclaim:\n  host: parke2ehost\n  gardener: 7\n  claimed_at: 2020-01-01T00:00:00Z\n'
  } > "$wt/jobs/doin/$base.md"
  printf 'worktree_dir: %s\n' "$T4/nonexistent-wt-$base" > "$wt/work/$base"
  git -C "$wt" add "jobs/doin/$base.md" "work/$base"
  git -C "$wt" "${git_id[@]}" commit -q -m "place stale $base"
  git -C "$wt" push -q origin HEAD:journal2
  rm -rf "$wt"
}

# A producer re-parks a body it read off the board, counter and all.
printf '# rpjob\n\nthe original work body for rpjob\n\n<!-- garden-deadline-overrun: 1 -->\n' > "$T4/rp-body.md"
"$JOBS/post-plan.sh" --go-ahead rpjob "$T4/rp-body.md" > "$T4/post.log" 2>&1 \
  || { echo "  (post-plan rc=$?)"; sed 's/^/    /' "$T4/post.log"; }
"$JOBS/promote-plan.sh" rpjob > "$T4/promote.log" 2>&1 \
  || { echo "  (promote-plan rc=$?)"; sed 's/^/    /' "$T4/promote.log"; }
resync4
[ -f "$T4/v/jobs/todo/rpjob.md" ] \
  && ok "the re-parked job promoted into todo/" || bad "promotion did not land in todo/"
cp "$T4/v/jobs/todo/rpjob.md" "$T4/promoted-body.md"
place_stale4 rpjob "$T4/promoted-body.md"
"$JOBS/reaper.sh" > "$T4/reap.log" 2>&1 || { echo "  (reaper rc=$?)"; sed 's/^/    /' "$T4/reap.log"; }
resync4
e2e4_ok=1
[ -f "$T4/v/jobs/todo/rpjob.md" ] || { e2e4_ok=0; echo "    the job was not requeued to todo/"; }
[ -f "$T4/v/jobs/plan/rpjob.md" ] && { e2e4_ok=0; echo "    the job was RE-DOOMED on its first cycle (the bug)"; }
[ "$e2e4_ok" -eq 1 ] \
  && ok "a body re-parked through post-plan gets a REAL requeue cycle after promotion" \
  || bad "a stale counter still survives the park→promote round trip"

# ============================================================================
hr; echo "SUBTEST 5 — annotate-plan clears the same family in the appended note (the annotation half)"; hr
T5="$TR/annotate"; mkdir -p "$T5"
BARE5="$(seed_board "$T5")"
export JOURNAL_REMOTE="$BARE5" JOURNAL_BRANCH=journal2
export GARDEN=annotatehost GARDEN_STATE="$T5/state" GARDEN_SCRATCH="$T5/scratch"
export GARDEN_POST_ATTEMPTS=50
mkdir -p "$GARDEN_SCRATCH"
readback5() {
  local v; v="$(mktemp -d "$T5/rb.XXXXXX")"
  git clone -q --single-branch --branch journal2 "$BARE5" "$v" 2>/dev/null
  cat "$v/$1" 2>/dev/null; rm -rf "$v"
}

printf '# annotated\n\nthe original work body for annotated\n' > "$T5/clean.md"
"$JOBS/post-plan.sh" --go-ahead --role builder annotated "$T5/clean.md" > "$T5/post.log" 2>&1 \
  || { echo "  (post-plan rc=$?)"; sed 's/^/    /' "$T5/post.log"; }

# The note a producer pipes when it hands back what the last cycle reported: real
# prose, the accumulated markers, plus a `---` rule and a non-cycle HTML comment.
cat > "$T5/note.md" <<'EOF'
the last cycle reported this, verbatim:

---

<!-- some-other-marker: keep me -->
<!-- garden-reaped: 4 -->
<!-- garden-deadline-overrun: 2 -->
<!-- garden-elapsed-constancy: 2 -->
<!-- garden-reap-now -->
<!-- garden-productive-cycle -->
<!-- garden-outage-cycle -->
EOF
"$JOBS/annotate-plan.sh" annotated "$T5/note.md" > "$T5/ann.log" 2>&1 \
  || { echo "  (annotate-plan rc=$?)"; sed 's/^/    /' "$T5/ann.log"; }
parked5="$(readback5 jobs/plan/annotated.md)"

strip5_ok=1
for m in 'garden-reaped:' 'garden-deadline-overrun:' 'garden-elapsed-constancy:' 'garden-reap-now' 'garden-productive-cycle' 'garden-outage-cycle'; do
  printf '%s\n' "$parked5" | grep -q -- "$m" && { strip5_ok=0; echo "    marker survived the annotation: $m"; }
done
[ "$strip5_ok" -eq 1 ] \
  && ok "every cycle marker is cleared from an appended annotation note" \
  || bad "annotate-plan still smuggles cycle markers into a parked body"

printf '%s\n' "$parked5" | grep -q 'the last cycle reported this, verbatim:' \
  && ok "the note's prose survives the strip" || bad "the note's prose was lost"
printf '%s\n' "$parked5" | grep -q 'the original work body for annotated' \
  && ok "the parked work body is untouched" || bad "the annotation ate the parked body"
printf '%s\n' "$parked5" | grep -q '<!-- some-other-marker: keep me -->' \
  && ok "a non-cycle HTML comment in the note is untouched" || bad "the strip ate a non-cycle HTML comment"
# Plan frontmatter, automatic-routing frontmatter, and the note's own rule.
[ "$(printf '%s\n' "$parked5" | grep -c '^---$')" -eq 5 ] \
  && ok "the note's own '---' rule survives beside both frontmatter blocks" \
  || bad "$(printf '%s\n' "$parked5" | grep -c '^---$') '---' lines (want 5)"
printf '%s\n' "$parked5" \
  | grep -q 'garden-annotation: .*cleared=reaped=4,deadline-overrun=2,elapsed-constancy=2,reap-now,productive-cycle,outage-cycle' \
  && ok "the annotation marker records what it cleared" \
  || bad "annotate-plan did not record the cleared set ($(printf '%s\n' "$parked5" | grep -o 'garden-annotation: .*' || echo '<no marker>'))"

# A marker-free note leaves the marker byte-for-byte what it always was.
"$JOBS/annotate-plan.sh" --note 'an ordinary follow-up note' annotated > "$T5/ann2.log" 2>&1 \
  || { echo "  (annotate-plan rc=$?)"; sed 's/^/    /' "$T5/ann2.log"; }
printf '%s\n' "$(readback5 jobs/plan/annotated.md)" | grep -F 'an ordinary follow-up note' -B2 \
  | grep -q 'cleared=' \
  && bad "an ordinary annotation grew a spurious 'cleared=' token" \
  || ok "an ordinary annotation's marker is unchanged (no 'cleared=' token)"

# A note that is ENTIRELY cycle markers has nothing left to say: refuse it (rc 1)
# rather than appending an empty annotation.
before5="$(readback5 jobs/plan/annotated.md)"
set +e
out5="$("$JOBS/annotate-plan.sh" --note '<!-- garden-reap-now -->' annotated 2>&1)"; rc5=$?
set -e
[ "$rc5" -eq 1 ] && ok "a note that is entirely cycle markers is refused (rc 1)" \
  || bad "marker-only note rc=$rc5 (want 1): $out5"
grep -qi 'entirely cycle markers' <<<"$out5" \
  && ok "the refusal names the sanitization" || bad "refusal message unclear: $out5"
[ "$(readback5 jobs/plan/annotated.md)" = "$before5" ] \
  && ok "the marker-only note left the parked body byte-identical" \
  || bad "the refused annotation still mutated the parked body"

# End-to-end: annotate → promote → the promoted body is marker-free and the
# promotion's own provenance reports `cleared=none` (nothing to reset), rather
# than laundering the annotation's counters into a fake reset record.
"$JOBS/promote-plan.sh" annotated > "$T5/promote.log" 2>&1 \
  || { echo "  (promote-plan rc=$?)"; sed 's/^/    /' "$T5/promote.log"; }
todo5="$(readback5 jobs/todo/annotated.md)"
printf '%s\n' "$todo5" | grep -q 'garden-promoted-from-plan:.* cleared=none' \
  && ok "promotion of an annotated job reports cleared=none (no laundered counters)" \
  || bad "promotion provenance: $(printf '%s\n' "$todo5" | grep -o 'garden-promoted-from-plan:.*' || echo '<none>')"
printf '%s\n' "$todo5" | grep -q 'the last cycle reported this, verbatim:' \
  && ok "the sanitized annotation still reaches the gardener's work body" \
  || bad "the annotation was lost on promotion"

hr
echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
