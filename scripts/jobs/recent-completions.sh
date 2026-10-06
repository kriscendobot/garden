#!/bin/bash
# recent-completions.sh — list recently completed jobs, newest first.
#
# The human-facing recent-completions affordance of the date-sharded tada layout
# (designs/date-sharded-tada.md): it reads only the last N UTC day shards under
# jobs/tada/<yyyy>/<mm>/<dd>/ through common.sh's tada_recent, never the whole
# tree. Read-only: it runs no git, so pointing it at the journal worktree is safe.
#
# Usage: recent-completions.sh [--days N] [--limit N] [--paths] [--dir <journal>]
#   --days   window of UTC day shards, today included (default 1).
#   --limit  stop after N entries (default: all in the window).
#   --paths  print journal-relative report paths instead of `<date> <base>`.
#   --dir    journal checkout to read (default $GARDEN_ROOT/journal).

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$HERE/common.sh"

days=1 limit='' paths=0 dir="$GARDEN_ROOT/journal"
while [ $# -gt 0 ]; do
  case "$1" in
    --days)  days="${2:?}"; shift 2 ;;
    --limit) limit="${2:?}"; shift 2 ;;
    --paths) paths=1; shift ;;
    --dir)   dir="${2:?}"; shift 2 ;;
    -h|--help) sed -n '2,13p' "${BASH_SOURCE[0]}"; exit 0 ;;
    *) die "unknown argument: $1" ;;
  esac
done
case "$days" in ''|*[!0-9]*) die "--days must be a non-negative integer (got '$days')" ;; esac
case "$limit" in *[!0-9]*) die "--limit must be a non-negative integer (got '$limit')" ;; esac

n=0
while IFS= read -r rel; do
  [ -n "$rel" ] || continue
  if [ -n "$limit" ] && [ "$n" -ge "$limit" ]; then break; fi
  n=$((n + 1))
  if [ "$paths" = 1 ]; then
    printf '%s\n' "$rel"
  else
    shard="${rel#"$JOBS_TADA/"}"; shard="${shard%/*}"
    printf '%s %s\n' "${shard//\//-}" "$(basename "$rel" .md)"
  fi
done < <(tada_recent "$dir" "$days")
