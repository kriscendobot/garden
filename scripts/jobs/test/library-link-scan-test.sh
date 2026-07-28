#!/bin/bash
# library-link-scan-test.sh — coverage for the tip-synced section-link scan
# wrapper (library-link-scan.sh).
#
# Regression for the 2026-06-27 stale-snapshot false-positive defect: the scholar
# ran the section-link scan in-context off an origin/journal2 snapshot ~80 commits
# behind the tip, so a section file a peer had ALREADY committed read as "missing"
# and the agent made wrong repoint edits. The wrapper must instead sync its
# dedicated clone to the CURRENT origin/journal2 tip before resolving any link,
# so a target committed by a peer after the worker's last in-context fetch still
# resolves. The SYNC-FRESHNESS subtest pins exactly that.
#
# Hermetic: a throwaway bare journal2 origin with a tiny library/ fixture stands
# in for the shared journal. No real journal and no network are touched.
#
# Usage: library-link-scan-test.sh
set -uo pipefail
# Explicit positive test-context sentinel: protects this standalone suite even when
# invoked outside the test-tree entrypoint heuristic.
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
SCAN="$JOBS/library-link-scan.sh"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env so a live gardener invoking this test cannot splice its
# own GARDEN_*/JOURNAL_* state underneath the fixture (mirrors deploy-sync-test.sh).
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true

TR=/home/kris/.garden-link-scan-test
BARE="$TR/origin.git"
STATE="$TR/state"
git_id=(-c user.name=test -c user.email=test@localhost)

seed_file() { mkdir -p "$(dirname "$1/$2")"; printf '%s\n' "$3" > "$1/$2"; }

setup_fixture() {
  rm -rf "$TR"; mkdir -p "$TR"
  git init -q --bare "$BARE"
  local SEED="$TR/seed"; git init -q "$SEED"
  git -C "$SEED" checkout -q -b journal2
  # A source page linking to one section that EXISTS and one that is DANGLING.
  seed_file "$SEED" library/sources/proj--doc.md \
"# proj doc

| Section | Status |
|---|---|
| [core](../sections/proj--doc--core.md) | current |
| [gone](../sections/proj--doc--ghost.md) | DANGLING |"
  seed_file "$SEED" library/sections/proj--doc--core.md \
"---
title: core
---
Abstract."
  seed_file "$SEED" library/sections/README.md "# Sections index"
  git -C "$SEED" add -A
  git -C "$SEED" "${git_id[@]}" commit -q -m "seed"
  git -C "$SEED" remote add origin "$BARE"
  git -C "$SEED" push -q -u origin journal2
}

origin_add() {  # origin_add <relpath> <content> <msg>
  local wt; wt="$(mktemp -d "$TR/push.XXXXXX")"
  git clone -q --branch journal2 "$BARE" "$wt"
  mkdir -p "$(dirname "$wt/$1")"; printf '%s\n' "$2" > "$wt/$1"
  git -C "$wt" add -A; git -C "$wt" "${git_id[@]}" commit -q -m "$3"
  git -C "$wt" push -q origin journal2
  rm -rf "$wt"
}

run_scan() {  # run_scan [args...] ; fills $OUT, $RC
  OUT="$(env JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2 \
             GARDEN_STATE="$STATE" GARDEN_ROOT="$TR" \
             GARDEN=test-host GARDEN_NO_MAINTAINER_ALERT=1 \
             GARDEN_LIBCHECK_CLONE="$STATE/libcheck/journal" \
             GARDEN_PRODUCER_CLONE="$STATE/producer/journal" \
             bash "$SCAN" "$@" 2>&1)"
  RC=$?
}

# Read the committed jobs/todo set from the board origin (post-job pushed there).
board_todo() { git -C "$BARE" ls-tree -r --name-only journal2 -- jobs/todo 2>/dev/null; }

# ============================================================================
hr; echo "STATIC — the wrapper parses (bash -n)"; hr
bash -n "$SCAN" && ok "library-link-scan.sh parses" || bad "syntax error"

# ============================================================================
hr; echo "SCAN — syncs the tip and flags the planted dangling navigation link"; hr
setup_fixture
run_scan
[ "$RC" = 1 ] && ok "exit 1 when a dangling link exists" || bad "exit $RC (want 1)"
grep -qF "proj--doc--ghost.md" <<<"$OUT" && ok "flagged the dangling section link" || bad "missed the dangling link: $OUT"
grep -qF "proj--doc--core.md" <<<"$OUT" && grep -q "DANGLING .*core" <<<"$OUT" \
  && bad "false-positive on the existing section" || ok "no false positive on the existing section"

# ============================================================================
hr; echo "SYNC-FRESHNESS — a target a peer commits AFTER the clone exists resolves"; hr
# The 2026-06-27 regression in miniature: the dedicated clone already exists, but
# the remote tip has advanced. A stale scan would still call the new section
# 'missing'; a sync-tip-first scan resolves it.
origin_add library/sections/proj--doc--ghost.md \
"---
title: ghost no more
---
A peer ingested this after the prior run." \
"peer ingests the formerly-ghost section"
run_scan
grep -qF "proj--doc--ghost.md" <<<"$OUT" \
  && bad "stale: still flags a section the peer already committed" \
  || ok "fresh: peer-committed section now resolves (no stale false positive)"
[ "$RC" = 0 ] && ok "exit 0 once every link resolves" || bad "exit $RC (want 0): $OUT"

# ============================================================================
hr; echo "--exists — the re-verify-before-you-repoint primitive"; hr
run_scan --exists sections/proj--doc--core.md
[ "$RC" = 0 ] && ok "--exists exit 0 for a present target" || bad "--exists exit $RC for present (want 0)"
run_scan --exists library/sections/proj--doc--core.md
[ "$RC" = 0 ] && ok "--exists accepts a leading library/ prefix" || bad "--exists rejected library/ prefix"
run_scan --exists sections/does-not-exist.md
[ "$RC" = 1 ] && ok "--exists exit 1 for an absent target" || bad "--exists exit $RC for absent (want 1)"

# ============================================================================
hr; echo "--actuate — on a dangle, posts ONE scholar-fix job and exits 0"; hr
# Fresh fixture re-plants the dangling ghost link. The ACTUATING shape must NOT
# leave the unit Failed: it posts a remediation job and exits 0.
setup_fixture
run_scan --actuate
[ "$RC" = 0 ] && ok "actuate exits 0 even with a dangle (unit stays Healthy)" || bad "actuate exit $RC (want 0): $OUT"
posted="$(board_todo | grep -F scholar-fix-dangling-nav-links || true)"
[ -n "$posted" ] && ok "posted a scholar-fix-dangling-nav-links job" || bad "no fix job posted: $(board_todo)"
# The job body names the dangling target.
job_path="$(board_todo | grep -F scholar-fix-dangling-nav-links | head -1)"
git -C "$BARE" show "journal2:$job_path" 2>/dev/null | grep -qF "proj--doc--ghost.md" \
  && ok "fix job body names the dangling target" || bad "fix job body omits the target"

# ============================================================================
hr; echo "--actuate IDEMPOTENT — same dangle-set re-run posts nothing new"; hr
before="$(board_todo | grep -c scholar-fix-dangling-nav-links || true)"
run_scan --actuate
after="$(board_todo | grep -c scholar-fix-dangling-nav-links || true)"
[ "$RC" = 0 ] && [ "$before" = "$after" ] && ok "no duplicate fix job on re-run ($before == $after)" || bad "duplicated fix job ($before -> $after, rc=$RC)"

# ============================================================================
hr; echo "--actuate CLEAN — no dangle posts nothing and exits 0"; hr
origin_add library/sections/proj--doc--ghost.md \
"---
title: ghost no more
---
A peer ingested this." "peer ingests the ghost section"
# A clean tip posts no NEW job; the prior fix job from the dangling era may remain
# on the board, so assert the COUNT does not grow rather than that it is zero.
clean_before="$(board_todo | grep -c scholar-fix-dangling-nav-links || true)"
run_scan --actuate
clean_after="$(board_todo | grep -c scholar-fix-dangling-nav-links || true)"
[ "$RC" = 0 ] && ok "actuate exits 0 on a clean tip" || bad "actuate clean exit $RC (want 0): $OUT"
[ "$clean_before" = "$clean_after" ] && ok "clean tip posts no new fix job" || bad "posted on a clean tip ($clean_before -> $clean_after)"

# ============================================================================
hr; echo "--actuate --dry-run — reports a dangle, exits 1, posts nothing"; hr
setup_fixture
dry_before="$(board_todo | grep -c scholar-fix-dangling-nav-links || true)"
run_scan --actuate --dry-run
dry_after="$(board_todo | grep -c scholar-fix-dangling-nav-links || true)"
[ "$RC" = 1 ] && ok "actuate --dry-run exits 1 when a dangle exists" || bad "dry-run exit $RC (want 1)"
[ "$dry_before" = "$dry_after" ] && ok "dry-run posted nothing" || bad "dry-run posted a job ($dry_before -> $dry_after)"

# ============================================================================
hr; echo "UNIT-RENDER — the link-scan service/timer pair is well-formed and discoverable"; hr
SYSD="$(cd "$HERE/../../systemd" && pwd)"
SVC="$SYSD/garden-library-link-scan.service"
TMR="$SYSD/garden-library-link-scan.timer"
[ -f "$SVC" ] && ok "garden-library-link-scan.service exists" || bad "service unit missing"
[ -f "$TMR" ] && ok "garden-library-link-scan.timer exists" || bad "timer unit missing"
grep -q 'self-heal-run.sh garden-library-link-scan' "$SVC" \
  && ok "service wraps the scan in self-heal-run.sh" || bad "service not self-heal-wrapped"
grep -q 'library-link-scan.sh --actuate' "$SVC" \
  && ok "service invokes the ACTUATING --actuate mode" || bad "service does not use --actuate"
grep -q -- '--expect 75' "$SVC" \
  && ok "service treats EX_TEMPFAIL (75) as clean" || bad "service missing --expect 75"
grep -q '^OnCalendar=\*:22' "$TMR" \
  && ok "timer fires at the distinct :22 offset (drift uses :07)" || bad "timer OnCalendar offset wrong"
grep -q '^Persistent=true' "$TMR" && ok "timer is Persistent" || bad "timer not Persistent"
grep -q '^WantedBy=timers.target' "$TMR" \
  && ok "timer is WantedBy=timers.target (auto-enabled by install-units derive)" || bad "timer missing WantedBy"

# ============================================================================
hr
echo "RESULTS: $PASS passed, $FAIL failed"
rm -rf "$TR"
[ "$FAIL" = 0 ]
