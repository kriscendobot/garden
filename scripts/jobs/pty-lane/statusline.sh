#!/bin/bash
# pty-lane/statusline.sh — the statusLine side channel for the experimental pty lane.
#
# Claude Code hands the model's runtime a REAL context-window measurement in exactly
# one place: the JSON blob it pipes to the configured `statusLine` command on stdin,
# carrying `.context_window.{used_percentage,total_input_tokens,total_output_tokens,
# context_window_size}` and `.session_id`. That channel exists ONLY in an interactive
# TUI session (it is absent under `claude -p`), which is why the pty lane encloses the
# session in a pseudo-terminal (see pty-lane/run.py). This script is the "(1) print the
# line AND persist the figures" half of the FUDCo trick
# (https://gist.github.com/FUDCo/8aeb2b0c60bd871c2e3b1d5f99b89631); pty-context-read.sh
# is the reader half.
#
# Two outputs:
#   * stdout: a one-line status string Claude renders in the TUI (write-only to the term).
#   * a per-job STATE FILE the agent (or a hook/skill) can read back:
#       $GARDEN_STATE/pty-context/<GARDEN_JOB_BASE>.env
#
# Keyed on $GARDEN_JOB_BASE (exported through the worker spine) so the ~20 concurrent
# gardeners on a host each write their OWN file and never clobber a peer's. Sited under
# $GARDEN_STATE, never the repo (an in-tree file rewritten on every status refresh would
# dirty `git status` continuously). run.sh removes the file on completion; a leftover is
# detectable as stale via the timestamp (requirement 3), so an unpruned file is a wrong
# figure a reader rejects, not a silent lie.
#
# Invoked by Claude as `bash <this script>` (NOT the bare path): garden /tmp — and any
# noexec mount a state dir might land on — would otherwise fail the exec with rc=126.
# It must never fail the host session: every branch is defensive and it always prints
# *something* and exits 0.
set +e

state_root="${GARDEN_STATE:-${TMPDIR:-/tmp}/garden-state}"
base="${GARDEN_JOB_BASE:-unknown}"
dir="$state_root/pty-context"
mkdir -p "$dir" 2>/dev/null

input="$(cat)"

# Field extraction: prefer jq, fall back to a tiny python, so a host missing jq still
# persists figures. `// empty` leaves a field blank rather than the literal "null".
read_field() { # <jq-path>
  if command -v jq >/dev/null 2>&1; then
    printf '%s' "$input" | jq -r "$1 // empty" 2>/dev/null
  else
    printf '%s' "$input" | python3 -c 'import sys,json,functools
try: d=json.load(sys.stdin)
except Exception: sys.exit(0)
p=sys.argv[1].lstrip(".").split(".")
v=functools.reduce(lambda a,k: (a or {}).get(k) if isinstance(a,dict) else None, p, d)
print("" if v is None else v)' "$1" 2>/dev/null
  fi
}

pct="$(read_field '.context_window.used_percentage')"
inp="$(read_field '.context_window.total_input_tokens')"
outp="$(read_field '.context_window.total_output_tokens')"
size="$(read_field '.context_window.context_window_size')"
remain="$(read_field '.context_window.remaining_percentage')"
sid="$(read_field '.session_id')"
model="$(read_field '.model.display_name')"

# Atomic write (write-temp-then-rename) so a reader never sees a half-written file even
# though this fires several times a second. Temp carries $$ so concurrent refreshes of
# the SAME session (should not overlap, but be safe) do not stomp each other's temp.
f="$dir/$base.env"
tmp="$f.$$.tmp"
{
  echo "job_base=$base"
  echo "session_id=$sid"
  echo "epoch=$(date +%s)"
  echo "iso=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "used_percentage=$pct"
  echo "remaining_percentage=$remain"
  echo "input_tokens=$inp"
  echo "output_tokens=$outp"
  echo "context_window_size=$size"
  echo "model=$model"
} > "$tmp" 2>/dev/null && mv -f "$tmp" "$f" 2>/dev/null
rm -f "$tmp" 2>/dev/null

# The rendered line (write-only to the terminal). Keep it short and honest.
printf 'ctx %s%% · in %s out %s · job %s' "${pct:-?}" "${inp:-?}" "${outp:-?}" "$base"
exit 0
