#!/bin/bash
# cursor-outage-cooldown-test.sh — guard the host-shared journal-read outage cooldown
# that suppresses the cursor-get thundering herd.
#
# Every per-repo triager/comment/mention/issue-inbox watcher opens each tick with a
# cursor-get.sh that sync_clone's the shared journal clone. On a journal-connectivity
# outage a bare read burns a fetch timeout and warns — once per repo per watcher-kind.
# cursor-get now latches the first observed outage into a HOST-WIDE cooldown so sibling
# reads report temporary-unavailable (GARDEN_OFFLINE_RC) immediately, WITHOUT re-fetching
# or re-warning, and drops the latch the moment a real read succeeds. Loud
# structural/authentication failures (a non-offline `die`) must stay loud.
#
# Two layers under test: the common.sh cooldown helpers (host-wide resolution, atomic
# single-latch, observer-never-extends, clear, expiry) and cursor-get.sh's end-to-end
# behavior (short-circuit on a live latch, latch-on-detection, correlated ambiguous
# rc=1 classification, re-raise-loud boundaries, clear).

set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS + 1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL + 1)); }

unset GARDEN_JOURNAL_OUTAGE_DIR GARDEN_JOURNAL_OUTAGE_MARKER GARDEN_JOURNAL_OUTAGE_LOCK
TR="$(mktemp -d "${TMPDIR:-/tmp}/cursor-outage.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
ROOT="$TR/rendered-root"
mkdir -p "$ROOT"
MARKER="$ROOT/.garden-state/journal-outage-cooldown/marker"

# ---------------------------------------------------------------------------
# Layer 1: the common.sh cooldown helpers.
# ---------------------------------------------------------------------------
run_common() {  # run_common <state-namespace> <shell-body>
  # shellcheck disable=SC2016
  env GARDEN_ROOT="$ROOT" GARDEN_STATE="$TR/state/$1" GARDEN_JOURNAL_OUTAGE_COOLDOWN_SECS=120 \
    bash -c 'source "$1"; eval "$2"' _ "$JOBS/common.sh" "$2"
}

echo "SUBTEST 1 — cooldown helpers"
# A detector in one service namespace publishes into the host root, not its own STATE;
# a sibling namespace sees the same live latch.
run_common ci 'start_journal_outage_cooldown "ci:first"'
[ -s "$MARKER" ] && ok "detector latches below the shared GARDEN_ROOT" \
  || bad "detector did not write $MARKER"
[ ! -e "$TR/state/ci/journal-outage-cooldown/marker" ] \
  && ok "latch is not stranded in the invocation-local GARDEN_STATE" \
  || bad "latch leaked into an invocation-local state namespace"
run_common comment 'journal_outage_active' \
  && ok "a sibling watcher namespace sees the host latch" \
  || bad "a sibling watcher namespace missed the host latch"

# An observer must NOT extend a live window (a short blip cannot become an unbounded
# blackout): the expiry the first detector wrote survives an active() probe.
before="$(sed -n '1p' "$MARKER")"
run_common comment 'journal_outage_active' >/dev/null
after="$(sed -n '1p' "$MARKER")"
[ "$before" = "$after" ] && ok "an observer never extends the live window" \
  || bad "observer moved the expiry ($before -> $after)"

# clear drops the latch (recovery is immediate, not window-bound).
run_common ci 'clear_journal_outage_cooldown'
[ ! -e "$MARKER" ] && ok "clear_journal_outage_cooldown drops the latch" \
  || bad "latch survived a clear"

# Concurrent detectors: exactly one opens the window; the marker survives.
RESULTS="$TR/results"; mkdir -p "$RESULTS"
for n in 1 2 3 4 5 6 7 8; do
  (
    if run_common "race-$n" "start_journal_outage_cooldown race-$n"; then
      printf 'opened\n' > "$RESULTS/$n"
    else
      printf 'observed\n' > "$RESULTS/$n"
    fi
  ) &
done
wait
opened="$(grep -l '^opened$' "$RESULTS"/* | wc -l)"
[ "$opened" -eq 1 ] && ok "eight concurrent detectors produce one latch-opening transition" \
  || bad "concurrent detectors produced $opened latch-opening transitions"
[ -s "$MARKER" ] && ok "the shared marker survives all concurrent detectors" \
  || bad "the shared marker disappeared after concurrent detectors"

# An expired window is NOT active, and re-opens cleanly.
run_common ci 'clear_journal_outage_cooldown'
# Hand-write an already-expired marker, then probe: active() must reap it and say no.
mkdir -p "$(dirname "$MARKER")"; printf '1\nstale\n' > "$MARKER"
run_common comment 'journal_outage_active' \
  && bad "an expired window was reported active" \
  || ok "an expired window is not active (and is reaped)"
[ ! -e "$MARKER" ] && ok "active() reaps the expired marker" || bad "expired marker not reaped"

# Disabled (0 = escape hatch): never active, and start reports 'owns the warning' so a
# disabled cooldown still surfaces the outage per detector (suppression OFF).
env GARDEN_ROOT="$ROOT" GARDEN_STATE="$TR/state/off" GARDEN_JOURNAL_OUTAGE_COOLDOWN_SECS=0 \
  bash -c 'source "$1"; journal_outage_active' _ "$JOBS/common.sh" \
  && bad "a disabled cooldown was reported active" \
  || ok "a disabled cooldown is never active"

# ---------------------------------------------------------------------------
# Layer 2: cursor-get.sh end-to-end.
# ---------------------------------------------------------------------------
echo "SUBTEST 2 — cursor-get.sh"
: "${GARDEN_OFFLINE_RC:=75}"
KEY="activity/test-slug"

# A real local journal bare repo + clone for the healthy path.
BARE="$TR/journal.git"
SEED="$TR/seed"
git init -q "$SEED"
git -C "$SEED" checkout -q -b journal2
git -C "$SEED" config user.email t@t; git -C "$SEED" config user.name t
mkdir -p "$SEED/cursors/activity"
printf 'last_sha: healthy-sha\n' > "$SEED/cursors/$KEY"
git -C "$SEED" add -A; git -C "$SEED" commit -q -m seed
git init --bare -q "$BARE"
git -C "$SEED" push -q "$BARE" journal2

CLONE="$TR/clone"   # cursor-get's clone dir (GARDEN_CURSOR_CLONE)
run_cursor() {  # run_cursor <state-ns> [extra env KEY=VAL ...] ; args after '--' go to cursor-get
  local ns="$1"; shift
  local -a envs=()
  while [ "$#" -gt 0 ] && [ "$1" != "--" ]; do envs+=("$1"); shift; done
  [ "${1:-}" = "--" ] && shift
  env GARDEN_ROOT="$ROOT" GARDEN_STATE="$TR/state/$ns" JOURNAL_REMOTE="$BARE" \
    GARDEN_CURSOR_CLONE="$CLONE" GARDEN_JOURNAL_OUTAGE_COOLDOWN_SECS=120 \
    GARDEN_FETCH_RETRIES=1 ${envs[@]+"${envs[@]}"} bash "$JOBS/cursor-get.sh" "${1:-$KEY}"
}

rm -f "$MARKER"
# (a) healthy read returns content and leaves NO latch.
out="$(run_cursor h 2>/dev/null)"; rc=0
printf '%s' "$out" | grep -q 'last_sha: healthy-sha' \
  && ok "healthy cursor-get returns the cursor content" \
  || bad "healthy read missing content (got: $out)"
[ ! -e "$MARKER" ] && ok "a healthy read leaves no outage latch" || bad "healthy read latched an outage"

# (b) offline detection LATCHES and returns GARDEN_OFFLINE_RC, via an injected fetch that
#     prints a known offline signature. The clone already exists so ensure_clone is a no-op.
rm -f "$MARKER"
FETCH_OFFLINE="$TR/fetch-offline.sh"
cat > "$FETCH_OFFLINE" <<'EOF'
#!/bin/bash
echo "fatal: unable to access: Could not resolve host: github.com" >&2
exit 128
EOF
chmod +x "$FETCH_OFFLINE"
rc=0; out="$(run_cursor o GARDEN_FETCH_CMD="$FETCH_OFFLINE" -- 2>/dev/null)" || rc=$?
[ "$rc" -eq "$GARDEN_OFFLINE_RC" ] \
  && ok "an offline journal makes cursor-get exit GARDEN_OFFLINE_RC ($rc)" \
  || bad "offline cursor-get exited $rc, expected $GARDEN_OFFLINE_RC"
[ -z "$out" ] && ok "offline cursor-get emits no cursor content" || bad "offline read emitted '$out'"
[ -e "$MARKER" ] && ok "the first offline read latches the host cooldown" \
  || bad "offline read did not latch the cooldown"

# (c) HERD SUPPRESSION: with the latch live, a sibling read short-circuits — it exits
#     GARDEN_OFFLINE_RC WITHOUT ever invoking the fetch (proven by a sentinel the fetch
#     cmd would drop if called).
SENTINEL="$TR/fetch-was-called"
FETCH_TRIP="$TR/fetch-trip.sh"
cat > "$FETCH_TRIP" <<EOF
#!/bin/bash
touch "$SENTINEL"
echo "fatal: unable to access: Could not resolve host: github.com" >&2
exit 128
EOF
chmod +x "$FETCH_TRIP"
rm -f "$SENTINEL"
rc=0; out="$(run_cursor s GARDEN_FETCH_CMD="$FETCH_TRIP" -- 2>/dev/null)" || rc=$?
[ "$rc" -eq "$GARDEN_OFFLINE_RC" ] \
  && ok "a latched sibling read reports temporary-unavailable ($rc)" \
  || bad "latched sibling read exited $rc, expected $GARDEN_OFFLINE_RC"
[ ! -e "$SENTINEL" ] \
  && ok "a latched sibling read skips the fetch entirely (herd suppressed)" \
  || bad "a latched read still performed a fetch"

# (d) recovery is WINDOW-BOUNDED: once the window expires, the next read reaps the marker
#     and reads through (a live window keeps short-circuiting — that IS the suppression).
#     Hand-write an EXPIRED marker, then a healthy read must return content and leave none.
mkdir -p "$(dirname "$MARKER")"; printf '1\nstale\n' > "$MARKER"
rc=0; out="$(run_cursor r 2>/dev/null)" || rc=$?
printf '%s' "$out" | grep -q 'last_sha: healthy-sha' \
  && ok "an expired window lets the next read read through" || bad "recovered read missing content"
[ ! -e "$MARKER" ] && ok "the expired latch is gone after the recovered read" \
  || bad "the expired latch survived the recovered read"

# (d2) clear-on-success belt-and-suspenders: a LIVE marker while the cooldown is toggled
#      OFF (secs=0) is dropped on the next successful read (the case expiry-reap can't cover).
now="$(date +%s)"; printf '%s\ntoggled-off\n' "$((now + 999))" > "$MARKER"
rc=0; out="$(run_cursor c GARDEN_JOURNAL_OUTAGE_COOLDOWN_SECS=0 2>/dev/null)" || rc=$?
printf '%s' "$out" | grep -q 'last_sha: healthy-sha' \
  && ok "a disabled-cooldown read reads through a live marker" || bad "disabled-cooldown read missing content"
[ ! -e "$MARKER" ] && ok "a successful read clears a stale live marker when cooldown is off" \
  || bad "clear_journal_outage_cooldown did not drop the stale live marker"

# (e) A git transport can return a bare rc=1 without a stable offline signature. When
#     several cursor readers hit that shape together, the first one must open ONE
#     temporary-outage episode and every sibling must return the quiet skip rc.
rm -f "$MARKER"
FETCH_AMBIGUOUS="$TR/fetch-ambiguous.sh"
cat > "$FETCH_AMBIGUOUS" <<'EOF'
#!/bin/bash
echo "fatal: remote end hung up unexpectedly" >&2
exit 1
EOF
chmod +x "$FETCH_AMBIGUOUS"
AMB_RESULTS="$TR/ambiguous-results"; mkdir -p "$AMB_RESULTS"
for n in 1 2 3 4 5 6; do
  (
    rc=0
    run_cursor "amb-$n" GARDEN_FETCH_CMD="$FETCH_AMBIGUOUS" \
      GARDEN_OFFLINE_SIGNATURES='ZZZ_NEVER_MATCH' -- \
      >"$AMB_RESULTS/$n.out" 2>"$AMB_RESULTS/$n.err" || rc=$?
    printf '%s\n' "$rc" > "$AMB_RESULTS/$n.rc"
  ) &
done
wait
bad_rc="$(awk -v expected="$GARDEN_OFFLINE_RC" 'FNR == 1 && $0 != expected { n++ } END { print n+0 }' "$AMB_RESULTS"/*.rc)"
[ "$bad_rc" -eq 0 ] \
  && ok "six simultaneous ambiguous rc=1 fetch failures all become temporary-unavailable" \
  || bad "$bad_rc simultaneous ambiguous failures did not return $GARDEN_OFFLINE_RC"
warnings="$(awk '/journal-read outage; latched host cooldown/ { n++ } END { print n+0 }' "$AMB_RESULTS"/*.err)"
[ "$warnings" -eq 1 ] \
  && ok "simultaneous rc=1 failures open exactly one warned outage episode" \
  || bad "simultaneous rc=1 failures emitted $warnings outage warnings (expected one)"
[ -e "$MARKER" ] && ok "an ambiguous rc=1 journal fetch latches the cooldown" \
  || bad "ambiguous rc=1 failures did not latch the cooldown"

# (f) LOUD authentication failure stays loud: even though journal_fetch wraps it in
#     the same bounded-retry line, its positive auth diagnostic excludes it from the
#     ambiguous-outage fallback. It is re-raised unchanged and never latches.
rm -f "$MARKER"
FETCH_AUTH="$TR/fetch-auth.sh"
cat > "$FETCH_AUTH" <<'EOF'
#!/bin/bash
echo "git@github.com: Permission denied (publickey)." >&2
exit 1
EOF
chmod +x "$FETCH_AUTH"
rc=0
out="$(run_cursor auth GARDEN_FETCH_CMD="$FETCH_AUTH" GARDEN_OFFLINE_SIGNATURES='ZZZ_NEVER_MATCH' -- 2>"$TR/auth.err")" || rc=$?
[ "$rc" -eq 1 ] \
  && ok "an authentication failure is re-raised loud (rc=1, not temporary-unavailable)" \
  || bad "an authentication failure was masked (rc=$rc)"
grep -qi 'Permission denied' "$TR/auth.err" \
  && ok "the loud authentication diagnostic is preserved" \
  || bad "the authentication diagnostic was swallowed"
[ ! -e "$MARKER" ] && ok "an authentication failure does not latch a cooldown" \
  || bad "an authentication failure latched a cooldown (would silence credential drift)"

# (g) A local repository failure wrapped in the same rc=1 fetch summary also stays
#     loud: the ambiguous fallback is explicitly bounded away from local state faults.
rm -f "$MARKER"
FETCH_LOCAL="$TR/fetch-local.sh"
cat > "$FETCH_LOCAL" <<'EOF'
#!/bin/bash
echo "fatal: not a git repository: .git" >&2
exit 1
EOF
chmod +x "$FETCH_LOCAL"
rc=0
out="$(run_cursor local-fetch GARDEN_FETCH_CMD="$FETCH_LOCAL" GARDEN_OFFLINE_SIGNATURES='ZZZ_NEVER_MATCH' -- 2>"$TR/local-fetch.err")" || rc=$?
[ "$rc" -eq 1 ] \
  && ok "a local repository failure is re-raised loud (rc=1)" \
  || bad "a local repository failure was masked (rc=$rc)"
grep -qi 'not a git repository' "$TR/local-fetch.err" \
  && ok "the local repository diagnostic is preserved" \
  || bad "the local repository diagnostic was swallowed"
[ ! -e "$MARKER" ] && ok "a local repository failure does not latch a cooldown" \
  || bad "a local repository failure latched a cooldown"

# (h) A genuinely local clone/configuration failure occurs before sync classification,
#     remains rc=1 + loud, and likewise cannot arm the shared outage latch.
rm -f "$MARKER"
LOCAL_CLONE="$TR/local-clone"; rm -rf "$LOCAL_CLONE"
rc=0
env GARDEN_ROOT="$ROOT" GARDEN_STATE="$TR/state/local" JOURNAL_REMOTE="$TR/no-such-journal.git" \
  GARDEN_CURSOR_CLONE="$LOCAL_CLONE" GARDEN_FETCH_RETRIES=1 \
  bash "$JOBS/cursor-get.sh" "$KEY" >"$TR/local.out" 2>"$TR/local.err" || rc=$?
[ "$rc" -eq 1 ] \
  && ok "a local clone/configuration failure stays loud (rc=1)" \
  || bad "a local clone/configuration failure was masked (rc=$rc)"
grep -q 'clone of .* failed' "$TR/local.err" \
  && ok "the local clone failure diagnostic is preserved" \
  || bad "the local clone diagnostic was swallowed"
[ ! -e "$MARKER" ] && ok "a local clone failure does not latch a cooldown" \
  || bad "a local clone failure latched a cooldown"

echo "TOTAL: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
