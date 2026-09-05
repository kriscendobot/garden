#!/bin/bash
# pty-context-read.sh — the READER half of the experimental pty context-introspection
# lane. A gardener running under `lane: pty` (see designs/pty-context-introspection-lane.md)
# has its live context-window figure persisted to a per-job state file by
# pty-lane/statusline.sh; this script reads THIS job's figure back and prints it, or
# reports it absent/stale.
#
# Contract (deliberately narrow):
#   Usage:  pty-context-read.sh [job-base] [--format env|percent|json]
#           job-base defaults to $GARDEN_JOB_BASE (the lane discriminator the spine
#           exports). --format percent prints just the used_percentage integer (handy
#           in a shell test); env (default) prints the whole record; json emits an
#           object.
#   Exit:   0 = a FRESH figure was found and printed.
#           2 = no figure (no state file) — the lane is off, or the status line has not
#               fired yet. Treat the figure as ABSENT.
#           3 = a state file exists but is STALE (older than the freshness window) or
#               belongs to a different session — its number is NOT trustworthy; treat as
#               absent. This is requirement 3: a reader that cannot prove freshness must
#               not trust the figure.
#
# Freshness: the state file carries `epoch=` (unix seconds of the last status refresh)
# and `job_base=`/`session_id=`. A figure is fresh iff its job_base matches AND its epoch
# is within GARDEN_PTY_CONTEXT_MAX_AGE seconds (default 120). The status line refreshes
# every few seconds while a session is live, so a figure older than a couple of minutes
# means the session ended (or wedged) and the number is a leftover, not "now".
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
state_root="${GARDEN_STATE:-$(cd "$HERE/../.." && pwd)/.garden-state}"
max_age="${GARDEN_PTY_CONTEXT_MAX_AGE:-120}"

base=""
format="env"
while [ $# -gt 0 ]; do
  case "$1" in
    --format) format="${2:-env}"; shift 2 ;;
    --format=*) format="${1#--format=}"; shift ;;
    -*) echo "unknown option: $1" >&2; exit 64 ;;
    *) base="$1"; shift ;;
  esac
done
base="${base:-${GARDEN_JOB_BASE:-}}"
[ -n "$base" ] || { echo "no job base (pass one or export GARDEN_JOB_BASE)" >&2; exit 64; }

f="$state_root/pty-context/$base.env"
[ -f "$f" ] || { echo "pty-context: no figure for '$base' (lane off or status line not yet fired)" >&2; exit 2; }

# shellcheck disable=SC1090
job_base=""; session_id=""; epoch=""; iso=""; used_percentage=""; remaining_percentage=""
input_tokens=""; output_tokens=""; context_window_size=""; model=""
while IFS='=' read -r k v; do
  case "$k" in
    job_base|session_id|epoch|iso|used_percentage|remaining_percentage|input_tokens|output_tokens|context_window_size|model)
      printf -v "$k" '%s' "$v" ;;
  esac
done < "$f"

now="$(date +%s)"
age=$(( now - ${epoch:-0} ))
if [ "$job_base" != "$base" ] || [ "${epoch:-0}" -le 0 ] || [ "$age" -gt "$max_age" ]; then
  echo "pty-context: figure for '$base' is STALE (age=${age}s > ${max_age}s or owner mismatch); treating as absent" >&2
  exit 3
fi

case "$format" in
  percent) printf '%s\n' "${used_percentage:-}" ;;
  json)
    printf '{"job_base":"%s","session_id":"%s","epoch":%s,"iso":"%s","age_seconds":%s,"used_percentage":"%s","remaining_percentage":"%s","input_tokens":"%s","output_tokens":"%s","context_window_size":"%s","model":"%s"}\n' \
      "$job_base" "$session_id" "${epoch:-0}" "$iso" "$age" "$used_percentage" "$remaining_percentage" "$input_tokens" "$output_tokens" "$context_window_size" "$model" ;;
  env|*)
    cat "$f"
    printf 'age_seconds=%s\n' "$age" ;;
esac
