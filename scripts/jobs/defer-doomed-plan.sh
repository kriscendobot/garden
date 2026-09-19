#!/bin/bash
# defer-doomed-plan.sh — return held doom jobs to the foreman's paced queue.
#
# Usage: defer-doomed-plan.sh [--dry-run]
#
# Reclassifies every plan job that is BOTH gate=go-ahead and marked doomed
# (including the legacy poisoned spelling) as gate=deferred.  The reaper's
# failure metadata stays intact as history; promote-plan.sh consumes the whole
# plan frontmatter when the foreman eventually admits the job.
#
# This is deliberately a batch CAS.  A large outage can doom hundreds of jobs;
# one commit makes the maintainer's queue-wide disposition atomic and avoids one
# journal push race per job.  Jobs that leave plan/, change gate, or lose their
# doom marker during a rejected-push retry are re-evaluated from the fresh tip.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG="defer-doomed-plan"

dry_run=0
case "${1:-}" in
  --dry-run) dry_run=1; shift ;;
esac
[ "$#" -eq 0 ] || die "usage: defer-doomed-plan.sh [--dry-run]"

DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
ensure_clone "$DIR"

is_held_doom() {
  local file="$1"
  [ "$(plan_gate "$file")" = go-ahead ] \
    && grep -qxE 'doomed: true|poisoned: true' "$file"
}

rewrite_gate_deferred() {
  local file="$1" tmp="$1.tmp.$$"
  awk '
    NR == 1 && $0 == "---" { frontmatter=1 }
    frontmatter && /^gate:[[:space:]]*/ { print "gate: deferred"; next }
    frontmatter && NR > 1 && $0 == "---" { frontmatter=0 }
    { print }
  ' "$file" > "$tmp"
  mv "$tmp" "$file"
}

if [ "$dry_run" -eq 1 ]; then
  sync_clone "$DIR"
  count=0
  for file in "$DIR/$JOBS_PLAN"/*.md; do
    [ -e "$file" ] || continue
    if is_held_doom "$file"; then
      printf '%s\n' "$(basename "$file" .md)"
      count=$((count + 1))
    fi
  done
  clone_unlock "$DIR"
  log "dry run: $count doomed go-ahead plan job(s) would become deferred"
  exit 0
fi

for attempt in $(seq 1 "${GARDEN_POST_ATTEMPTS:-50}"); do
  sync_clone "$DIR"
  changed=0
  for file in "$DIR/$JOBS_PLAN"/*.md; do
    [ -e "$file" ] || continue
    is_held_doom "$file" || continue
    rewrite_gate_deferred "$file"
    git -C "$DIR" add "${file#"$DIR/"}"
    changed=$((changed + 1))
  done

  if [ "$changed" -eq 0 ]; then
    clone_unlock "$DIR"
    log "no doomed go-ahead plan jobs remain; nothing to do"
    exit 0
  fi

  if commit_and_push "$DIR" "plan: return $changed doomed jobs to deferred queue"; then
    log "returned $changed doomed plan job(s) to the foreman's deferred queue"
    exit 0
  fi
  log "lost journal push race while deferring doomed jobs; retrying ($attempt/${GARDEN_POST_ATTEMPTS:-50})"
  backoff "$attempt"
done

die "could not defer doomed plan jobs after ${GARDEN_POST_ATTEMPTS:-50} attempts"
