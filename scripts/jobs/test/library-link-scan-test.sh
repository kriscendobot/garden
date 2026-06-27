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
             GARDEN_LIBCHECK_CLONE="$STATE/libcheck/journal" \
             bash "$SCAN" "$@" 2>&1)"
  RC=$?
}

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
hr
echo "RESULTS: $PASS passed, $FAIL failed"
rm -rf "$TR"
[ "$FAIL" = 0 ]
