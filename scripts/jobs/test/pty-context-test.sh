#!/bin/bash
# pty-context-test.sh — hermetic coverage for the pty lane's introspection LEAF
# components: the statusLine persister (pty-lane/statusline.sh) and the reader
# (pty-context-read.sh). These are the halves a gardener actually touches; they are
# pure (JSON in → state file → figure out) and need no real `claude`, so this test
# drives them directly on a throwaway $GARDEN_STATE.
#
# What it pins:
#   1. PERSIST — feeding statusline.sh the exact JSON shape Claude pipes to a
#      statusLine command writes a per-job state file keyed on $GARDEN_JOB_BASE
#      under $GARDEN_STATE, mapping .context_window.* and .session_id correctly, and
#      the rendered stdout line carries the percentage.
#   2. KEYING — two different job bases write two DIFFERENT files (no clobber).
#   3. FRESH — the reader returns the figure (exit 0) for a just-written file, and
#      --format percent / json emit the expected projections.
#   4. STALE — a figure older than the freshness window is refused (exit 3).
#   5. OWNER MISMATCH — a file whose job_base != the requested base is refused
#      (exit 3) even within the age window.
#   6. ABSENT — no state file yields exit 2.
#   7. NO-JQ FALLBACK — statusline.sh still persists figures with jq hidden from PATH.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
SL="$JOBS/pty-lane/statusline.sh"
RD="$JOBS/pty-context-read.sh"

TR="$(mktemp -d "${TMPDIR:-/tmp}/pty-context-test.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
export GARDEN_STATE="$TR/state"

pass=0; fail=0
ok()   { printf '  PASS: %s\n' "$1"; pass=$((pass+1)); }
bad()  { printf '  FAIL: %s\n' "$1"; fail=$((fail+1)); }
check(){ if [ "$2" = "$3" ]; then ok "$1"; else bad "$1 (got '$2' want '$3')"; fi; }

json() { # <sid> <pct> <in> <out>
  printf '{"session_id":"%s","model":{"display_name":"Opus 4.8"},"context_window":{"total_input_tokens":%s,"total_output_tokens":%s,"context_window_size":1000000,"used_percentage":%s,"remaining_percentage":10}}' \
    "$1" "$3" "$4" "$2"
}

# 1) PERSIST + rendered line
rendered="$(json sid-a 78 742000 38000 | GARDEN_JOB_BASE=job-a bash "$SL")"
f="$GARDEN_STATE/pty-context/job-a.env"
[ -f "$f" ] && ok "persist: state file created" || bad "persist: no state file"
check "persist: used_percentage mapped" "$(sed -n 's/^used_percentage=//p' "$f")" "78"
check "persist: input_tokens mapped"    "$(sed -n 's/^input_tokens=//p' "$f")" "742000"
check "persist: output_tokens mapped"   "$(sed -n 's/^output_tokens=//p' "$f")" "38000"
check "persist: session_id mapped"      "$(sed -n 's/^session_id=//p' "$f")" "sid-a"
check "persist: job_base is owner"      "$(sed -n 's/^job_base=//p' "$f")" "job-a"
case "$rendered" in *"78%"*) ok "persist: rendered line carries percentage" ;; *) bad "persist: rendered line missing percentage ($rendered)" ;; esac

# 2) KEYING — a second base gets its own file
json sid-b 50 100 200 | GARDEN_JOB_BASE=job-b bash "$SL" >/dev/null
[ -f "$GARDEN_STATE/pty-context/job-b.env" ] && [ -f "$GARDEN_STATE/pty-context/job-a.env" ] \
  && ok "keying: two bases -> two files" || bad "keying: files clobbered"
check "keying: job-a untouched by job-b write" "$(sed -n 's/^used_percentage=//p' "$GARDEN_STATE/pty-context/job-a.env")" "78"

# 3) FRESH
rc=0; out="$(bash "$RD" job-a --format percent)" || rc=$?
check "fresh: reader exit 0" "$rc" "0"
check "fresh: percent projection" "$out" "78"
bash "$RD" job-a --format json | grep -q '"used_percentage":"78"' && ok "fresh: json projection" || bad "fresh: json projection"

# 4) STALE — tight window
rc=0; GARDEN_PTY_CONTEXT_MAX_AGE=-1 bash "$RD" job-a >/dev/null 2>&1 || rc=$?
check "stale: refused with exit 3" "$rc" "3"

# 5) OWNER MISMATCH — copy job-a's file under an impostor name
cp "$GARDEN_STATE/pty-context/job-a.env" "$GARDEN_STATE/pty-context/impostor.env"
rc=0; GARDEN_PTY_CONTEXT_MAX_AGE=99999 bash "$RD" impostor >/dev/null 2>&1 || rc=$?
check "owner-mismatch: refused with exit 3" "$rc" "3"

# 6) ABSENT
rc=0; bash "$RD" no-such-base >/dev/null 2>&1 || rc=$?
check "absent: exit 2" "$rc" "2"

# 7) NO-JQ FALLBACK — hide jq, statusline.sh must still persist via python
nojq="$TR/nojq-bin"; mkdir -p "$nojq"
for b in bash sed date mkdir mv rm cat python3 printf; do ln -sf "$(command -v "$b")" "$nojq/$b" 2>/dev/null || true; done
json sid-c 33 5 7 | PATH="$nojq" GARDEN_JOB_BASE=job-c GARDEN_STATE="$GARDEN_STATE" bash "$SL" >/dev/null 2>&1 || true
check "no-jq: used_percentage still mapped" "$(sed -n 's/^used_percentage=//p' "$GARDEN_STATE/pty-context/job-c.env" 2>/dev/null)" "33"

printf '\npty-context-test: %d passed, %d failed\n' "$pass" "$fail"
[ "$fail" -eq 0 ]
