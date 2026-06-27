#!/bin/bash
# library-source-drift-scan-test.sh — coverage for the tip-synced per-source
# freshness scan (library-source-drift-scan.sh).
#
# The scan moves per-source freshness auditing off the chance-encounter scholar
# and onto a deterministic, tip-synced, OFFLINE scan: it reads the committed
# library/sources/README.md at the current origin/journal2 tip, resolves each
# pinned source path's latest commit from the LOCAL bare clone clone-keeper keeps
# fresh, and posts a scholar-refresh-<slug> job for every source whose recorded
# file-commit has drifted past upstream. This test pins: tip-fresh parsing, the
# drift-vs-current prefix comparison, idempotent posting, the skip-and-log of a
# row whose repo has no local bare clone, and the never-reach-the-network promise.
#
# Hermetic: a throwaway bare journal2 origin with a tiny library/sources fixture,
# plus a throwaway bare "upstream" clone standing in for worktrees/<owner>-<repo>.git.
# No real garden, journal, or network is touched.
#
# Usage: library-source-drift-scan-test.sh
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
SCAN="$JOBS/library-source-drift-scan.sh"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env so a live gardener invoking this test cannot splice its
# own GARDEN_*/JOURNAL_* state underneath the fixture (mirrors library-link-scan-test.sh).
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true

TR=/home/kris/.garden-source-drift-test
BARE="$TR/origin.git"            # the journal2 board origin
STATE="$TR/state"
UP="$TR/up.git"                  # throwaway upstream repo
CLONE="$TR/worktrees/acme-widget.git"  # the local bare clone the scan resolves against
git_id=(-c user.name=test -c user.email=test@localhost)

# Two upstream paths: one we will leave pinned (current), one we will advance
# (drift). $SHA_CURRENT / $SHA_DRIFT_OLD / $SHA_DRIFT_NEW are filled by build_upstream.
build_upstream() {
  rm -rf "$UP" "$CLONE"; mkdir -p "$TR/worktrees"
  git init -q --bare "$UP"
  local SEED="$TR/upseed"; rm -rf "$SEED"; git init -q "$SEED"
  git -C "$SEED" checkout -q -b master
  mkdir -p "$SEED/src"
  printf 'current v1\n' > "$SEED/src/stable.js"
  printf 'drift v1\n'   > "$SEED/src/moving.js"
  git -C "$SEED" add -A; git -C "$SEED" "${git_id[@]}" commit -q -m c1
  SHA_CURRENT="$(git -C "$SEED" log -1 --format=%H -- src/stable.js)"
  SHA_DRIFT_OLD="$(git -C "$SEED" log -1 --format=%H -- src/moving.js)"
  git -C "$SEED" remote add origin "$UP"; git -C "$SEED" push -q -u origin master
  # The local bare clone the scan reads (HEAD -> master, as a real bare clone).
  git clone -q --bare "$UP" "$CLONE"
  rm -rf "$SEED"
}

# Advance src/moving.js upstream AND fast-forward the local bare clone (as
# clone-keeper would), so the recorded sha now drifts behind the bare clone tip.
advance_moving() {
  local SEED="$TR/upseed2"; rm -rf "$SEED"
  git clone -q --branch master "$UP" "$SEED"
  printf 'drift v2\n' > "$SEED/src/moving.js"
  git -C "$SEED" add -A; git -C "$SEED" "${git_id[@]}" commit -q -m c2
  git -C "$SEED" push -q origin master
  SHA_DRIFT_NEW="$(git -C "$SEED" log -1 --format=%H -- src/moving.js)"
  rm -rf "$SEED"
  git -C "$CLONE" fetch -q origin master:master
}

# Seed the journal2 board with a sources README pinning both paths plus a row for
# a repo that has NO local clone (the skip-and-log case).
seed_board() {  # seed_board <stable-sha> <moving-sha>
  rm -rf "$TR/seed"; local SEED="$TR/seed"; git init -q "$SEED"
  git -C "$SEED" checkout -q -b journal2
  mkdir -p "$SEED/library/sources" "$SEED/jobs/todo" "$SEED/jobs/doin" "$SEED/jobs/tada"
  : > "$SEED/jobs/todo/.gitkeep"; : > "$SEED/jobs/doin/.gitkeep"; : > "$SEED/jobs/tada/.gitkeep"
  cat > "$SEED/library/sources/README.md" <<EOF
# Sources

| Source | Repo | File | Line range | Subject | Sections | Status |
|--------|------|------|------------|---------|----------|--------|
| [stable source](acme--src-stable-js.md) | acme/widget | src/stable.js | 1-9 | stable subject | 1 | current (file-commit \`${1:0:8}\`; ingest) |
| [moving source](acme--src-moving-js.md) | acme/widget | src/moving.js | 1-9 | moving subject | 1 | current (file-commit \`${2:0:8}\`; ingest) |
| [no-clone source](other--readme.md) | metamask/ocap-kernel | src/x.js | 1-9 | offsite | 1 | current (file-commit \`deadbeef\`; ingest) |
| [aggregate](acme--bundle.md) | acme/widget | src/{6 files} | n/a | aggregate, no inline commit | 6 | current (cycle 9 ingest — no file-commit) |
EOF
  git -C "$SEED" add -A; git -C "$SEED" "${git_id[@]}" commit -q -m seed
  git -C "$SEED" remote add origin "$BARE"; git -C "$SEED" push -q -u origin journal2
  rm -rf "$SEED"
}

setup_fixture() {  # setup_fixture [--drift]
  rm -rf "$TR"; mkdir -p "$TR"
  git init -q --bare "$BARE"
  build_upstream
  if [ "${1:-}" = "--drift" ]; then advance_moving; fi
  seed_board "$SHA_CURRENT" "$SHA_DRIFT_OLD"
}

# Read the committed jobs/todo set from the board origin (post-job pushed there).
board_todo() { git -C "$BARE" ls-tree -r --name-only journal2 -- jobs/todo 2>/dev/null; }

run_scan() {  # run_scan [args...] ; fills $OUT, $RC
  set +e
  OUT="$(env JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2 \
             GARDEN_STATE="$STATE" GARDEN_ROOT="$TR" \
             GARDEN_NO_MAINTAINER_ALERT=1 \
             GARDEN_LIBSOURCE_CLONE="$STATE/libsource/journal" \
             bash "$SCAN" "$@" 2>&1)"
  RC=$?
  set -e
}

# ============================================================================
hr; echo "STATIC — the wrapper parses (bash -n)"; hr
bash -n "$SCAN" && ok "library-source-drift-scan.sh parses" || bad "syntax error"

# ============================================================================
hr; echo "CURRENT — no source has drifted: nothing posted, exit 0"; hr
setup_fixture
run_scan
[ "$RC" -eq 0 ] && ok "exit 0 on a current corpus" || bad "exit $RC (want 0)"
[ -z "$(board_todo | grep -F scholar-refresh || true)" ] && ok "no refresh job posted when current" || bad "posted a refresh with no drift: $(board_todo)"
grep -q "drifted=0" <<<"$OUT" && ok "reported drifted=0" || bad "did not report drifted=0: $OUT"

# ============================================================================
hr; echo "SKIP+LOG — a row whose repo has no local bare clone is logged, not fetched"; hr
# (same current fixture) — metamask/ocap-kernel has no worktrees clone here.
grep -q "no local bare clone for metamask/ocap-kernel" <<<"$OUT" && ok "skip-and-logged the clone-less repo" || bad "did not skip-and-log the clone-less row: $OUT"
grep -q "no-local-clone=1" <<<"$OUT" && ok "counted exactly one no-local-clone row" || bad "no-local-clone count wrong: $OUT"

# ============================================================================
hr; echo "AGGREGATE — a row with no inline file-commit is never audited"; hr
# The 3 rows with an inline file-commit are audited (2 acme + 1 metamask); the
# `{6 files}` aggregate row, which records NO inline file-commit, is excluded.
grep -q "audited=3" <<<"$OUT" && ok "audited only the 3 inline-file-commit rows (aggregate excluded)" || bad "audited count wrong (want 3): $OUT"

# ============================================================================
hr; echo "DRIFT — moving.js advanced upstream: a scholar-refresh job is posted"; hr
setup_fixture --drift
run_scan
[ "$RC" -eq 0 ] && ok "exit 0 in posting mode even with drift" || bad "exit $RC (want 0)"
board_todo | grep -qF "scholar-refresh-acme--src-moving-js.md" && ok "posted scholar-refresh for the drifted source" || bad "did not post the drift refresh: $(board_todo)"
board_todo | grep -qF "scholar-refresh-acme--src-stable-js.md" && bad "posted a refresh for the still-current source" || ok "no refresh for the still-current source"
grep -q "DRIFT: acme--src-moving-js" <<<"$OUT" && ok "logged the drift" || bad "did not log the drift: $OUT"

# ============================================================================
hr; echo "IDEMPOTENT — re-running with the job already on the board posts nothing new"; hr
before="$(board_todo | grep -c scholar-refresh || true)"
run_scan
after="$(board_todo | grep -c scholar-refresh || true)"
[ "$before" = "$after" ] && ok "no duplicate refresh on re-run ($before == $after)" || bad "duplicated refresh job ($before -> $after)"
grep -q "refresh already in lifecycle" <<<"$OUT" && ok "pre-check skipped the already-present refresh" || bad "did not report the idempotent skip: $OUT"

# ============================================================================
hr; echo "DRY-RUN — reports drift and exits 1, but posts nothing"; hr
setup_fixture --drift
run_scan --dry-run
[ "$RC" -eq 1 ] && ok "dry-run exits 1 when drift exists" || bad "dry-run exit $RC (want 1)"
[ -z "$(board_todo | grep -F scholar-refresh || true)" ] && ok "dry-run posted nothing" || bad "dry-run posted a job: $(board_todo)"

# ============================================================================
hr; echo "DRY-RUN CLEAN — current corpus exits 0"; hr
setup_fixture
run_scan --dry-run
[ "$RC" -eq 0 ] && ok "dry-run exits 0 on a current corpus" || bad "dry-run exit $RC (want 0)"

# ============================================================================
hr
echo "library-source-drift-scan-test: $PASS passed, $FAIL failed"
rm -rf "$TR"
[ "$FAIL" -eq 0 ]
