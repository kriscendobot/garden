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
#      the transient buckets narrow the die, they never swallow a real bug; and no
#      cooldown is latched for it
#   L. transient network loss → exit 0, no job, and THIS tick atomically latches the
#      host-wide gh-api cooldown and owns its single WARN
#   M. a live host-wide latch → the next tick skips SILENTLY: the source is never
#      invoked, nothing is logged, no job is posted (even with a red tip queued)
#   N. a live GraphQL-only latch does not silence the REST-only Pages source; an
#      outage under it opens the host-wide latch (this tick owns the warning)
#   O. a primary-quota refusal latches for the full quota window, not the 300s blip
#   P. an expired latch is reaped and the tick runs normally (posts the red tip)
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

# Each case's host-shared gh-api cooldown lives under its own state dir, so a latch
# opened by one case can never silence another (or the live host's watchers).
run_pw() {  # run_pw <state> <bare> <fixture>
  env GARDEN_STATE="$1" JOURNAL_REMOTE="$2" JOURNAL_BRANCH="$BRANCH" \
      GARDEN_API_COOLDOWN_DIR="$1/gh-api-cooldown" \
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
       GARDEN_API_COOLDOWN_DIR="$TR/state-h/gh-api-cooldown" \
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
       GARDEN_API_COOLDOWN_DIR="$TR/state-i/gh-api-cooldown" \
       GARDEN_GARDEN_REPO="$REPO" \
       GARDEN_PAGES_SOURCE="$HTMLSTUB" \
       GARDEN_PAGES_AUTH_RETRY_SLEEP=0 \
       GARDEN_PAGES_POST="$JOBS/post-job.sh" \
       "$JOBS/pages-watcher.sh" >/dev/null 2>&1; then rc_i=0; else rc_i=$?; fi
[ "$rc_i" -eq 0 ] && ok "tick exited 0 (absorbed the HTML/decoder blip; did not die)" || bad "tick died (rc=$rc_i) on a transient HTML page instead of skipping"
[ "$(todo_count "$BARE_I")" -eq 0 ] && ok "no job posted on a skipped tick" || bad "unexpected job posted ($(todo_count "$BARE_I")) on the HTML skip"
[ "$(sed -n 2p "$TR/state-i/gh-api-cooldown/marker" 2>/dev/null)" = "pages:$REPO" ] \
  && ok "the HTML blip latched the host-wide gh-api cooldown" || bad "HTML blip did not latch the shared cooldown"

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
       GARDEN_API_COOLDOWN_DIR="$TR/state-j/gh-api-cooldown" \
       GARDEN_GARDEN_REPO="$REPO" \
       GARDEN_PAGES_SOURCE="$S404" \
       GARDEN_PAGES_AUTH_RETRY_SLEEP=0 \
       GARDEN_PAGES_POST="$JOBS/post-job.sh" \
       "$JOBS/pages-watcher.sh" >/dev/null 2>&1; then rc_j=0; else rc_j=$?; fi
[ "$rc_j" -ne 0 ] && ok "tick died loud (rc=$rc_j) on a structural 404 — never guessed a state" || bad "structural 404 was swallowed (rc=0) instead of dying loud"
[ "$(todo_count "$BARE_J")" -eq 0 ] && ok "no job posted on a structural failure" || bad "unexpected job posted ($(todo_count "$BARE_J")) on the structural die"
[ ! -e "$TR/state-j/gh-api-cooldown/marker" ] && ok "a structural failure latches no cooldown" || bad "structural 404 latched the shared cooldown"

# ============================================================================
hr; echo "L — transient network loss → latch the host-wide cooldown, own its WARN"; hr
# Counting stub: logs each invocation, then emits the configured stderr/rc or the
# fixture. Lets M/N prove the source was (or was not) reached at all.
CSTUB="$TR/pages-count-stub.sh"
cat > "$CSTUB" <<'EOF'
#!/bin/bash
echo call >> "${PAGES_CALLS:?set PAGES_CALLS}"
if [ -n "${PAGES_ERR:-}" ]; then echo "$PAGES_ERR" >&2; exit 1; fi
cat "${PAGES_FIXTURE:?set PAGES_FIXTURE}"
EOF
chmod +x "$CSTUB"
NETERR='gh: error connecting to api.github.com
check your internet connection or https://githubstatus.com'
run_cs() {  # run_cs <state> <bare> <fixture> <calls-file> <log-file> [stderr-text] -> rc
  env GARDEN_STATE="$1" JOURNAL_REMOTE="$2" JOURNAL_BRANCH="$BRANCH" \
      GARDEN_API_COOLDOWN_DIR="$1/gh-api-cooldown" \
      GARDEN_GARDEN_REPO="$REPO" GARDEN_PAGES_AUTH_RETRY_SLEEP=0 \
      GARDEN_PAGES_SOURCE="$CSTUB" PAGES_FIXTURE="$3" PAGES_CALLS="$4" PAGES_ERR="${6:-}" \
      GARDEN_PAGES_POST="$JOBS/post-job.sh" \
      "$JOBS/pages-watcher.sh" >"$5" 2>&1
}
calls() { [ -f "$1" ] && wc -l < "$1" | tr -d ' ' || echo 0; }
BARE_L="$TR/l.git"; seed_bare "$BARE_L"
FIX_L="$TR/fix-l.tsv"; runline 1000 completed failure 1a1a1a1a1a1a9999 > "$FIX_L"
ST_L="$TR/state-l"; CALLS_L="$TR/l-calls"; LOG_L="$TR/l.log"
if run_cs "$ST_L" "$BARE_L" "$FIX_L" "$CALLS_L" "$LOG_L" "$NETERR"; then rc_l=0; else rc_l=$?; fi
[ "$rc_l" -eq 0 ] && ok "network loss skipped the tick (rc 0)" || bad "network loss exited rc=$rc_l"
[ "$(todo_count "$BARE_L")" -eq 0 ] && ok "no job posted on network loss (fail closed)" || bad "job posted on network loss"
M_L="$ST_L/gh-api-cooldown/marker"
exp_l="$(sed -n 1p "$M_L" 2>/dev/null || echo 0)"; now_l="$(date +%s)"
[ "$(sed -n 2p "$M_L" 2>/dev/null)" = "pages:$REPO:net" ] && ok "latched host-wide marker tagged pages:$REPO:net" || bad "no pages-owned latch (marker: $(cat "$M_L" 2>/dev/null))"
[ "$exp_l" -gt "$now_l" ] && [ "$exp_l" -le $((now_l + 300)) ] && ok "latch is the short default window" || bad "unexpected latch expiry $exp_l (now $now_l)"
[ "$(grep -c 'cooling all gh-api watchers' "$LOG_L")" -eq 1 ] && ok "this tick owns exactly one cooldown WARN" || bad "expected one owner WARN: $(cat "$LOG_L")"
[ ! -e "$ST_L/gh-api-cooldown/marker-graphql" ] && ok "no GraphQL-only marker written" || bad "wrote a graphql marker"

# ============================================================================
hr; echo "M — live latch → silent skip: source never invoked, nothing logged, no job"; hr
FIX_M="$TR/fix-m.tsv"; runline 1001 completed failure 2b2b2b2b2b2b8888 > "$FIX_M"
CALLS_M="$TR/m-calls"; LOG_M="$TR/m.log"
if run_cs "$ST_L" "$BARE_L" "$FIX_M" "$CALLS_M" "$LOG_M"; then rc_m=0; else rc_m=$?; fi
[ "$rc_m" -eq 0 ] && ok "skipped tick exited 0" || bad "skipped tick exited rc=$rc_m"
[ "$(calls "$CALLS_M")" -eq 0 ] && ok "source NOT invoked under the live latch" || bad "source invoked $(calls "$CALLS_M")x under a live latch"
[ ! -s "$LOG_M" ] && ok "skip was silent (no log line)" || bad "skip logged: $(cat "$LOG_M")"
[ "$(todo_count "$BARE_L")" -eq 0 ] && ok "no job posted during the latch (red tip waits for the window)" || bad "job posted during a live latch"
[ "$(sed -n 1p "$M_L")" = "$exp_l" ] && ok "observer never extended the window" || bad "latch expiry moved under an observer"

# ============================================================================
hr; echo "N — a GraphQL-only latch does not silence the REST Pages source"; hr
BARE_N="$TR/n.git"; seed_bare "$BARE_N"
ST_N="$TR/state-n"; mkdir -p "$ST_N/gh-api-cooldown"
printf '%s\nci:sibling:rollup\n' "$(( $(date +%s) + 3600 ))" > "$ST_N/gh-api-cooldown/marker-graphql"
CALLS_N="$TR/n-calls"; LOG_N="$TR/n.log"
if run_cs "$ST_N" "$BARE_N" "$FIX_L" "$CALLS_N" "$LOG_N" "$NETERR"; then rc_n=0; else rc_n=$?; fi
[ "$rc_n" -eq 0 ] && [ "$(calls "$CALLS_N")" -eq 1 ] && ok "source ran despite the GraphQL-only latch" || bad "rc=$rc_n calls=$(calls "$CALLS_N")"
[ "$(sed -n 2p "$ST_N/gh-api-cooldown/marker" 2>/dev/null)" = "pages:$REPO:net" ] \
  && grep -q 'cooling all gh-api watchers' "$LOG_N" \
  && ok "outage opened the host-wide latch and this tick owned the WARN" || bad "host-wide latch/WARN missing: $(cat "$LOG_N")"

# ============================================================================
hr; echo "O — primary-quota refusal → latched for the full quota window"; hr
BARE_O="$TR/o.git"; seed_bare "$BARE_O"
ST_O="$TR/state-o"; CALLS_O="$TR/o-calls"; LOG_O="$TR/o.log"
if run_cs "$ST_O" "$BARE_O" "$FIX_L" "$CALLS_O" "$LOG_O" "gh: API rate limit exceeded for user ID 1. (HTTP 403)"; then rc_o=0; else rc_o=$?; fi
exp_o="$(sed -n 1p "$ST_O/gh-api-cooldown/marker" 2>/dev/null || echo 0)"; now_o="$(date +%s)"
[ "$rc_o" -eq 0 ] && [ "$exp_o" -gt $((now_o + 900)) ] && ok "primary quota latched beyond the short clamp (expiry +$((exp_o - now_o))s)" || bad "rc=$rc_o expiry=$exp_o now=$now_o log: $(cat "$LOG_O")"
[ "$(sed -n 2p "$ST_O/gh-api-cooldown/marker" 2>/dev/null)" = "pages:$REPO:primary-quota" ] && ok "latch tagged primary-quota" || bad "tag: $(sed -n 2p "$ST_O/gh-api-cooldown/marker" 2>/dev/null)"

# ============================================================================
hr; echo "P — an expired latch is reaped; the tick runs and posts the red tip"; hr
BARE_P="$TR/p.git"; seed_bare "$BARE_P"
ST_P="$TR/state-p"; mkdir -p "$ST_P/gh-api-cooldown"
printf '%s\npages:%s:net\n' "$(( $(date +%s) - 5 ))" "$REPO" > "$ST_P/gh-api-cooldown/marker"
FIX_P="$TR/fix-p.tsv"; runline 1002 completed failure 3c3c3c3c3c3c7777 > "$FIX_P"
CALLS_P="$TR/p-calls"; LOG_P="$TR/p.log"
if run_cs "$ST_P" "$BARE_P" "$FIX_P" "$CALLS_P" "$LOG_P"; then rc_p=0; else rc_p=$?; fi
[ "$rc_p" -eq 0 ] && board_has "$BARE_P" "garden-pages-3c3c3c3c3c3c-shepherd" && ok "expired latch did not block; shepherd posted" || bad "rc=$rc_p; log: $(cat "$LOG_P")"
[ ! -e "$ST_P/gh-api-cooldown/marker" ] && ok "expired marker reaped" || bad "expired marker survived"

# ============================================================================
hr; echo "K — CGROUP STRAGGLER SWEEP — escaped helpers felled on a CLEAN exit"; hr
# Stragglers in their OWN sessions stand in for gh-forked git credential helpers that
# escaped the source's process group (the 2026-09-26 left-over-git leak); the test-only
# GARDEN_PAGES_CGROUP_PROCS_FILE fixture lists them, and the EXIT-path sweep must have
# felled them by the time the watcher returns.
proc_running() {  # rc 0 iff <pid> is alive and not a zombie
  local st
  kill -0 "$1" 2>/dev/null || return 1
  st="$(awk '{ s=$0; sub(/^.*\) /,"",s); print substr(s,1,1) }' "/proc/$1/stat" 2>/dev/null || echo Z)"
  [ "$st" != Z ]
}
CGPROCS="$TR/cgroup.procs"; S1PID="$TR/s1.pid"; S2PID="$TR/s2.pid"; rm -f "$S1PID" "$S2PID"
( setsid bash -c 'echo $$ > "'"$S1PID"'"; exec sleep 600' & )
( setsid bash -c 'echo $$ > "'"$S2PID"'"; exec sleep 600' & )
for _ in $(seq 1 100); do [ -s "$S1PID" ] && [ -s "$S2PID" ] && break || sleep 0.1; done
SPID1="$(cat "$S1PID" 2>/dev/null || true)"; SPID2="$(cat "$S2PID" 2>/dev/null || true)"
printf '%s\n%s\n' "$SPID1" "$SPID2" > "$CGPROCS"
proc_running "$SPID1" && proc_running "$SPID2" \
  && ok "cgroup stragglers alive pre-sweep" || bad "straggler children never started ('$SPID1' '$SPID2')"
BARE_CG="$TR/cg-s.git"; seed_bare "$BARE_CG"; FIX_CG="$TR/fix-cg.tsv"; : > "$FIX_CG"
GARDEN_TEST=1 GARDEN_PAGES_CGROUP_PROCS_FILE="$CGPROCS" run_pw "$TR/state-cg-s" "$BARE_CG" "$FIX_CG" || true
if ! proc_running "$SPID1" && ! proc_running "$SPID2"; then
  ok "both cgroup stragglers felled and gone once the watcher exited"
else
  bad "cgroup straggler still running after the watcher exited"
  kill -KILL "$SPID1" "$SPID2" 2>/dev/null || true
fi

# K2 — a straggler that forks AFTER a zero-read must still be felled: the fixture
# cgroup.procs is a FIFO whose first read is empty and whose later reads list a
# straggler forked just after it; a single-zero-read sweep would leave it alive.
LATE_PROCS="$TR/cgroup-late.procs"; LATE_PID="$TR/late.pid"; rm -f "$LATE_PROCS" "$LATE_PID"
mkfifo "$LATE_PROCS"
(
  : > "$LATE_PROCS"
  sleep 0.05
  ( setsid bash -c 'echo $$ > "'"$LATE_PID"'"; exec sleep 600' & )
  for _ in $(seq 1 100); do [ -s "$LATE_PID" ] && break; sleep 0.01; done
  while :; do cat "$LATE_PID" > "$LATE_PROCS"; sleep 0.02; done
) &
LATE_SERVER=$!
BARE_CG2="$TR/cg-s2.git"; seed_bare "$BARE_CG2"
GARDEN_TEST=1 GARDEN_PAGES_CGROUP_PROCS_FILE="$LATE_PROCS" run_pw "$TR/state-cg-s2" "$BARE_CG2" "$FIX_CG" || true
LATE_SPID="$(cat "$LATE_PID" 2>/dev/null || true)"
kill "$LATE_SERVER" 2>/dev/null || true; wait "$LATE_SERVER" 2>/dev/null || true
if [ -z "$LATE_SPID" ]; then
  bad "late straggler never forked (the sweep never came back for a second read)"
elif ! proc_running "$LATE_SPID"; then
  ok "straggler forked after the first zero-read felled once the watcher exited"
else
  bad "late straggler $LATE_SPID survived the watcher exit (sweep stopped on a single zero-read)"
  kill -KILL "$LATE_SPID" 2>/dev/null || true
fi

# ============================================================================
hr
echo "pages-watcher-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
