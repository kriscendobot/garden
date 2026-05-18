#!/bin/bash
# complete-job.sh — transition a claimed job to `done/` or `abandoned/`.
#
# Usage:
#   complete-job.sh <claimed-path> <outcome> [--result-entry <path>] [--abandon-reason "<line>"]
#
# <claimed-path> is relative to the journal worktree (e.g. `jobs/claimed/...md`).
# <outcome> is `done` or `abandoned`.
#
# Output: the relative path of the resulting file under `done/` or `abandoned/`.

set -euo pipefail

if [ "$#" -lt 2 ]; then
  echo "usage: $0 <claimed-path> done|abandoned [--result-entry PATH] [--abandon-reason LINE]" >&2
  exit 64
fi

SOURCE=$1
OUTCOME=$2
shift 2

case "$OUTCOME" in
  done|abandoned) ;;
  *) echo "complete-job: outcome must be 'done' or 'abandoned' (got $OUTCOME)" >&2; exit 64;;
esac

case "$SOURCE" in
  jobs/claimed/*.md) ;;
  *) echo "complete-job: source must be under jobs/claimed/ (got $SOURCE)" >&2; exit 64;;
esac

RESULT_ENTRY=
ABANDON_REASON=
while [ "$#" -gt 0 ]; do
  case "$1" in
    --result-entry) RESULT_ENTRY=$2; shift 2;;
    --abandon-reason) ABANDON_REASON=$2; shift 2;;
    *) echo "complete-job: unknown option: $1" >&2; exit 64;;
  esac
done

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
GARDEN_ROOT=$(cd "$SCRIPT_DIR/../.." && pwd)
JRN="$GARDEN_ROOT/journal"

BASE=$(basename "$SOURCE")
# Strip the leading <claim-UTC>-- and prepend a fresh <complete-UTC>--.
SHORT=$(echo "$BASE" | awk -F-- '{print $5}')
COMPLETE_UTC=$(date -u +%Y%m%dT%H%M%SZ)
NEW_NAME="${COMPLETE_UTC}--${BASE#*--}"
DEST_REL="jobs/${OUTCOME}/${NEW_NAME}"

ISO=$(date -u +%Y-%m-%dT%H:%M:%SZ)

git -C "$JRN" fetch --quiet origin journal 2>/dev/null || true
git -C "$JRN" rebase origin/journal >/dev/null 2>&1 || { git -C "$JRN" rebase --abort >/dev/null 2>&1 || true; }

test -f "$JRN/$SOURCE" || { echo "complete-job: $SOURCE missing; cannot complete" >&2; exit 1; }

git -C "$JRN" mv "$SOURCE" "$DEST_REL" >/dev/null

{
  cat "$JRN/$DEST_REL"
  printf '\n# Completion stamp\n'
  printf 'completed_at: %s\n' "$ISO"
  printf 'outcome: %s\n' "$OUTCOME"
  [ -n "$RESULT_ENTRY" ] && printf 'result_entry: %s\n' "$RESULT_ENTRY"
  [ -n "$ABANDON_REASON" ] && printf 'abandon_reason: %s\n' "$ABANDON_REASON"
} > "$JRN/$DEST_REL.tmp" && mv "$JRN/$DEST_REL.tmp" "$JRN/$DEST_REL"

git -C "$JRN" add -A "$DEST_REL" "$SOURCE" >/dev/null
git -C "$JRN" commit -m "jobs: $OUTCOME $SHORT" >/dev/null

for i in 1 2 3 4 5; do
  if git -C "$JRN" push --quiet origin HEAD:journal 2>/dev/null; then
    break
  fi
  git -C "$JRN" fetch --quiet origin journal
  git -C "$JRN" rebase origin/journal >/dev/null 2>&1 || { git -C "$JRN" rebase --abort >/dev/null 2>&1 || true; sleep $((i*i)); }
done

echo "$DEST_REL"
