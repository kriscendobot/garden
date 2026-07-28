#!/bin/bash
# pages-watcher-test.sh — validate the GitHub-Pages-build watcher on throwaway
# fixtures, with no GitHub. The Pages-run SOURCE is stubbed deterministically; the
# newest-run selection, the completed/in-progress/green/red mapping, the head-SHA
# basename, and the idempotency all run for real against a throwaway journal.
#
# Asserts:
#   A. newest run completed+failure → exactly one garden-pages-<sha>-shepherd job
#   B. re-poll of the same red tip → idempotent (still exactly one, no duplicate)
#   C. newest run completed+success → no job (site deploy healthy)
#   D. newest run in_progress → no job (back off; a red predecessor may be superseded)
#   E. no Pages runs reported → no job
#   F. newest run red but a shepherd already exists for that SHA → idempotent skip
#   G. a red tip on a DIFFERENT SHA → a distinct job (basename keys on the head SHA)
#   H. source emits a transient HTTP 401 once then a valid TSV → the tick RETRIES and
#      recovers (posts the job, exits 0) instead of dying on the first 401
#   I. source serves an HTML/decoder page (GitHub overloaded, 5xx) → clean exit-0 skip,
#      no die, no job (the gh-api transient bucket, matched via common.sh's shared set)
#   J. source fails structurally (a real 404) → still dies loud (nonzero), no job —
#      the transient buckets narrow the die, they never swallow a real bug
#
# Usage: pages-watcher-test.sh
set -euo pipefail
# Explicit positive test-context sentinel: protects this standalone suite even when
# invoked outside the test-tree entrypoint heuristic.
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
BRANCH=journal2
TR=/home/kris/.garden-pagesw-test
REPO=kriskowal/garden
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet GARDEN_*/JOURNAL_* so a live gardener running this test cannot
# splice the real journal under the fixture (the run-test.sh isolation rationale).
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_)' || true) 2>/dev/null || true

rm -rf "$TR"; mkdir -p "$TR"
git_id=(-c user.name=test -c user.email=test@localhost)

seed_bare() {  # seed_bare <bare-path>
  local bare="$1" seed; seed="$(mktemp -d "$TR/seed.XXXXXX")"
  git init -q --bare "$bare"
  git init -q "$seed"; git -C "$seed" checkout -q -b "$BRANCH"
  ( cd "$seed"
    mkdir -p jobs/plan jobs/todo jobs/doin jobs/tada work
    for d in jobs/plan jobs/todo jobs/doin jobs/tada work; do touch "$d/.gitkeep"; done )
  git -C "$seed" add -A; git -C "$seed" "${git_id[@]}" commit -q -m seed
  git -C "$seed" remote add origin "$bare"; git -C "$seed" push -q -u origin "$BRANCH"
  rm -rf "$seed"
}

# --- deterministic run source stub ------------------------------------------
# Emit the fixture verbatim (ignores repo/workflow); the watcher reads the first line.
SRCSTUB="$TR/pages-source-stub.sh"
cat > "$SRCSTUB" <<'EOF'
#!/bin/bash
cat "${PAGES_FIXTURE:?set PAGES_FIXTURE}"
EOF
chmod +x "$SRCSTUB"

# fixture line: databaseId \t status \t conclusion \t headSha \t url
runline() { printf '%s\t%s\t%s\t%s\t%s\n' "$1" "$2" "$3" "$4" "https://x/$1"; }

board_has() {  # board_has <bare> <base>  -> 0 if job present in plan/todo/doin/tada
  local v; v="$(mktemp -d "$TR/bv.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$1" "$v" 2>/dev/null
  local rc=1 s
  for s in plan todo doin tada; do [ -e "$v/jobs/$s/$2.md" ] && rc=0; done
  rm -rf "$v"; return $rc
}
todo_count() {  # todo_count <bare>  -> non-gitkeep entries in jobs/todo
  local v n; v="$(mktemp -d "$TR/tc.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$1" "$v" 2>/dev/null
  n=$(ls -1 "$v/jobs/todo" | grep -vxc '.gitkeep' || true); rm -rf "$v"; printf '%s' "$n"
}

run_pw() {  # run_pw <state> <bare> <fixture>
  env GARDEN_STATE="$1" JOURNAL_REMOTE="$2" JOURNAL_BRANCH="$BRANCH" \
      GARDEN_GARDEN_REPO="$REPO" \
      GARDEN_PAGES_SOURCE="$SRCSTUB" PAGES_FIXTURE="$3" \
      GARDEN_PAGES_POST="$JOBS/post-job.sh" \
      "$JOBS/pages-watcher.sh" >/dev/null 2>&1
}

# ============================================================================
hr; echo "A — newest run completed+failure → exactly one pages-shepherd job"; hr
BARE_A="$TR/a.git"; seed_bare "$BARE_A"
FIX_A="$TR/fix-a.tsv"
{ runline 900 completed failure deadbeefcafe1234 ; runline 899 completed success 1111111111111111 ; } > "$FIX_A"
run_pw "$TR/state-a" "$BARE_A" "$FIX_A"
board_has "$BARE_A" "garden-pages-deadbeefcafe-shepherd" && ok "posted garden-pages-deadbeefcafe-shepherd" || bad "shepherd job missing"
[ "$(todo_count "$BARE_A")" -eq 1 ] && ok "exactly one job posted" || bad "expected one job, got $(todo_count "$BARE_A")"

# ============================================================================
hr; echo "B — re-poll the same red tip → idempotent (no duplicate)"; hr
run_pw "$TR/state-a" "$BARE_A" "$FIX_A"
[ "$(todo_count "$BARE_A")" -eq 1 ] && ok "still exactly one on re-poll" || bad "job duplicated ($(todo_count "$BARE_A"))"

# ============================================================================
hr; echo "C — newest run completed+success → no job"; hr
BARE_C="$TR/c.git"; seed_bare "$BARE_C"
FIX_C="$TR/fix-c.tsv"
{ runline 800 completed success abcabcabcabc ; runline 799 completed failure deffeffeffef ; } > "$FIX_C"
run_pw "$TR/state-c" "$BARE_C" "$FIX_C"
[ "$(todo_count "$BARE_C")" -eq 0 ] && ok "no job when the tip deploy is green" || bad "posted a job for a green tip"

# ============================================================================
hr; echo "D — newest run in_progress → no job (back off)"; hr
BARE_D="$TR/d.git"; seed_bare "$BARE_D"
FIX_D="$TR/fix-d.tsv"
{ runline 700 in_progress "" cccccccccccc ; runline 699 completed failure dddddddddddd ; } > "$FIX_D"
run_pw "$TR/state-d" "$BARE_D" "$FIX_D"
[ "$(todo_count "$BARE_D")" -eq 0 ] && ok "no job while the tip is still building" || bad "posted a job for an in-progress tip"

# ============================================================================
hr; echo "E — no Pages runs reported → no job"; hr
BARE_E="$TR/e.git"; seed_bare "$BARE_E"
FIX_E="$TR/fix-e.tsv"; : > "$FIX_E"
run_pw "$TR/state-e" "$BARE_E" "$FIX_E"
[ "$(todo_count "$BARE_E")" -eq 0 ] && ok "no job when there are no runs" || bad "posted a job with no runs"

# ============================================================================
hr; echo "F — red tip but a shepherd already exists for that SHA → idempotent skip"; hr
BARE_F="$TR/f.git"; seed_bare "$BARE_F"
# Pre-seed a live shepherd for the SHA directly onto the board.
V="$(mktemp -d "$TR/pf.XXXXXX")"; git clone -q --single-branch --branch "$BRANCH" "$BARE_F" "$V"
mkdir -p "$V/jobs/todo"; printf '# pre-existing\n' > "$V/jobs/todo/garden-pages-facefeed0000-shepherd.md"
git -C "$V" add -A; git -C "$V" "${git_id[@]}" commit -q -m preseed; git -C "$V" push -q origin "$BRANCH"; rm -rf "$V"
FIX_F="$TR/fix-f.tsv"; runline 600 completed failure facefeed0000abc > "$FIX_F"
run_pw "$TR/state-f" "$BARE_F" "$FIX_F"
[ "$(todo_count "$BARE_F")" -eq 1 ] && ok "no duplicate (idempotent on pre-existing shepherd)" || bad "duplicated ($(todo_count "$BARE_F"))"

# ============================================================================
hr; echo "G — a red tip on a DIFFERENT SHA → a distinct job (basename keys on SHA)"; hr
BARE_G="$TR/g.git"; seed_bare "$BARE_G"
FIX_G1="$TR/fix-g1.tsv"; runline 500 completed failure aaaa11112222 > "$FIX_G1"
run_pw "$TR/state-g" "$BARE_G" "$FIX_G1"
FIX_G2="$TR/fix-g2.tsv"; runline 501 completed failure bbbb33334444 > "$FIX_G2"
run_pw "$TR/state-g" "$BARE_G" "$FIX_G2"
board_has "$BARE_G" "garden-pages-aaaa11112222-shepherd" \
  && board_has "$BARE_G" "garden-pages-bbbb33334444-shepherd" \
  && ok "each distinct red SHA got its own job" || bad "distinct-SHA jobs missing"
[ "$(todo_count "$BARE_G")" -eq 2 ] && ok "exactly two jobs for two distinct red SHAs" || bad "expected two, got $(todo_count "$BARE_G")"

# ============================================================================
hr; echo "H — transient 401 on first source call → retry recovers (no die, one job)"; hr
# Stub source: emit `HTTP 401: Bad credentials` (rc 1) on the FIRST call, then the
# valid fixture on every later call — the self-recovering rotation blip from the wild.
FLIP401="$TR/flip401-stub.sh"
cat > "$FLIP401" <<'EOF'
#!/bin/bash
c="${FLIP401_COUNTER:?set FLIP401_COUNTER}"
n=0; [ -f "$c" ] && n="$(cat "$c")"; n=$((n+1)); printf '%s' "$n" > "$c"
if [ "$n" -eq 1 ]; then
  echo "gh: HTTP 401: Bad credentials (https://api.github.com/repos/x/y/actions/workflows/303635685/runs)" >&2
  exit 1
fi
cat "${PAGES_FIXTURE:?set PAGES_FIXTURE}"
EOF
chmod +x "$FLIP401"
BARE_H="$TR/h.git"; seed_bare "$BARE_H"
FIX_H="$TR/fix-h.tsv"; runline 950 completed failure fee1deadbeef9876 > "$FIX_H"
CTR_H="$TR/h-counter"; : > "$CTR_H"
if env GARDEN_STATE="$TR/state-h" JOURNAL_REMOTE="$BARE_H" JOURNAL_BRANCH="$BRANCH" \
       GARDEN_GARDEN_REPO="$REPO" \
       GARDEN_PAGES_SOURCE="$FLIP401" PAGES_FIXTURE="$FIX_H" FLIP401_COUNTER="$CTR_H" \
       GARDEN_PAGES_AUTH_RETRY_SLEEP=0 \
       GARDEN_PAGES_POST="$JOBS/post-job.sh" \
       "$JOBS/pages-watcher.sh" >/dev/null 2>&1; then rc_h=0; else rc_h=$?; fi
[ "$rc_h" -eq 0 ] && ok "tick exited 0 (recovered; did not die on the transient 401)" || bad "tick failed (rc=$rc_h) instead of recovering"
board_has "$BARE_H" "garden-pages-fee1deadbeef-shepherd" && ok "posted shepherd after the 401 retry recovered" || bad "shepherd job missing after retry"
[ "$(cat "$CTR_H")" -eq 2 ] && ok "source invoked exactly twice (one 401 + one success)" || bad "expected 2 source calls, got $(cat "$CTR_H")"

# ============================================================================
hr; echo "I — source serves an HTML/decoder page (GitHub overloaded) → clean skip, no die"; hr
# When GitHub is overloaded it serves an HTML error page instead of JSON; `gh run
# list … | jq` then fails rc=1 with the Go-decoder signature `invalid character '<'
# looking for beginning of value` — matching NEITHER is_transient_net_error NOR
# is_transient_auth_error. The watcher must ABSORB it (WARN + exit 0), never `die`
# into a systemd restart storm (mirrors mirror-closer-test.sh section K).
HTMLSTUB="$TR/pages-html-stub.sh"
cat > "$HTMLSTUB" <<'EOF'
#!/bin/bash
echo "gh: invalid character '<' looking for beginning of value" >&2
exit 1
EOF
chmod +x "$HTMLSTUB"
BARE_I="$TR/i.git"; seed_bare "$BARE_I"
if env GARDEN_STATE="$TR/state-i" JOURNAL_REMOTE="$BARE_I" JOURNAL_BRANCH="$BRANCH" \
       GARDEN_GARDEN_REPO="$REPO" \
       GARDEN_PAGES_SOURCE="$HTMLSTUB" \
       GARDEN_PAGES_AUTH_RETRY_SLEEP=0 \
       GARDEN_PAGES_POST="$JOBS/post-job.sh" \
       "$JOBS/pages-watcher.sh" >/dev/null 2>&1; then rc_i=0; else rc_i=$?; fi
[ "$rc_i" -eq 0 ] && ok "tick exited 0 (absorbed the HTML/decoder blip; did not die)" || bad "tick died (rc=$rc_i) on a transient HTML page instead of skipping"
[ "$(todo_count "$BARE_I")" -eq 0 ] && ok "no job posted on a skipped tick" || bad "unexpected job posted ($(todo_count "$BARE_I")) on the HTML skip"

# ============================================================================
hr; echo "J — source fails structurally (real 404) → loud die, unit failure preserved"; hr
# A genuinely structural failure (a real 404 on a malformed slug) matches none of the
# transient signatures and MUST still die loud (nonzero exit), so a real bug surfaces
# and "never guess a state" holds — the transient buckets narrow the die, not remove it.
S404="$TR/pages-404-stub.sh"
cat > "$S404" <<'EOF'
#!/bin/bash
echo "gh: HTTP 404: Not Found (https://api.github.com/repos/x/y/actions/workflows/nope/runs)" >&2
exit 1
EOF
chmod +x "$S404"
BARE_J="$TR/j.git"; seed_bare "$BARE_J"
if env GARDEN_STATE="$TR/state-j" JOURNAL_REMOTE="$BARE_J" JOURNAL_BRANCH="$BRANCH" \
       GARDEN_GARDEN_REPO="$REPO" \
       GARDEN_PAGES_SOURCE="$S404" \
       GARDEN_PAGES_AUTH_RETRY_SLEEP=0 \
       GARDEN_PAGES_POST="$JOBS/post-job.sh" \
       "$JOBS/pages-watcher.sh" >/dev/null 2>&1; then rc_j=0; else rc_j=$?; fi
[ "$rc_j" -ne 0 ] && ok "tick died loud (rc=$rc_j) on a structural 404 — never guessed a state" || bad "structural 404 was swallowed (rc=0) instead of dying loud"
[ "$(todo_count "$BARE_J")" -eq 0 ] && ok "no job posted on a structural failure" || bad "unexpected job posted ($(todo_count "$BARE_J")) on the structural die"

# ============================================================================
hr
echo "pages-watcher-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
