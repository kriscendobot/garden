#!/bin/bash
# progress.sh - read-only progress and token-budget facts for one job.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"

base="${1:?usage: progress.sh <job-base>}"
case "$base" in -*|*/*|.*|'') die "illegal basename: '$base'" ;; esac
DIR="${GARDEN_PROGRESS_CLONE:-$GARDEN_STATE/progress/journal}"
ensure_clone "$DIR"
sync_clone "$DIR"

jf=""
for d in "$JOBS_DOIN" "$JOBS_TODO" "$JOBS_PLAN" "$JOBS_TADA"; do
  [ -f "$DIR/$d/$base.md" ] && { jf="$DIR/$d/$base.md"; location="$d"; break; }
done
[ -n "$jf" ] || { clone_unlock "$DIR"; die "job '$base' is not on the board"; }
claimed_at="$(sed -n 's/^  claimed_at:[[:space:]]*//p' "$jf" | tail -1)"
[ -n "$claimed_at" ] || claimed_at=-
verdict="$(job_progress_verdict "$DIR" "$base" "$jf" "$claimed_at")"
budget_epoch="$(plan_field "$jf" token-budget-epoch)"
output="$(usage_tokens_since "$DIR" "$base" "${budget_epoch:--}" output 2>/dev/null || true)"
billable="$(usage_tokens_since "$DIR" "$base" "${budget_epoch:--}" billable 2>/dev/null || true)"
budget="$(applied_token_budget "$jf")"
[ -n "$output" ] || output=unknown
[ -n "$billable" ] || billable=unknown
remaining=unknown
if [[ "$output" =~ ^[0-9]+$ ]]; then
  remaining=$((budget - output)); [ "$remaining" -ge 0 ] || remaining=0
fi
printf 'base: %s\nlocation: %s\nprogress: %s\ntoken_budget_epoch: %s\noutput_tokens_spent: %s\nbillable_tokens_spent: %s\ntoken_budget: %s\ntoken_budget_remaining: %s\n' \
  "$base" "$location" "$verdict" "${budget_epoch:-lifetime}" "$output" "$billable" "$budget" "$remaining"
clone_unlock "$DIR"
