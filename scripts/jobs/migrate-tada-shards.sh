#!/usr/bin/env bash
# One-shot, idempotent migration of the flat tada backlog into date shards
# (designs/date-sharded-tada.md § 5, stage 3).
#
#   migrate-tada-shards.sh [--dry-run] [--archive <ref>] <journal-clone>
#
# Every flat jobs/tada/<base>.md moves to jobs/tada/<yyyy>/<mm>/<dd>/<base>.md,
# dated by the OLDEST commit that added that exact path (so a base that drained
# and re-completed keeps its original date). Run it in a throwaway journal2
# clone, never the deployed journal worktree.
#
# History truncation: when the oldest add commit is a parentless root (the
# journal was re-rooted, e.g. 2026-09-23), that date is the truncation date, not
# the completion date. With --archive <ref> (the preserved pre-truncation
# branch, fetched into the clone) the date is looked up in the archive's history
# instead. A path whose add commit still cannot be found goes to
# jobs/tada/undated/<base>.md: never skipped, never guessed.
#
# The whole set lands as ONE commit pushed with a rebase-CAS retry loop; a lost
# race re-syncs to origin/journal2 and recomputes (already-sharded entries are
# not inputs, so a re-run is a no-op once the flat level is empty).
set -euo pipefail

dry=0 archive=""
while [ $# -gt 0 ]; do
  case "$1" in
    --dry-run) dry=1; shift ;;
    --archive) archive="$2"; shift 2 ;;
    --) shift; break ;;
    -*) echo "unknown flag: $1" >&2; exit 2 ;;
    *) break ;;
  esac
done
[ $# -eq 1 ] || { echo "usage: $0 [--dry-run] [--archive <ref>] <journal-clone>" >&2; exit 2; }
J="$1"
TADA=jobs/tada
work="$(mktemp -d)"; trap 'rm -rf "$work"' EXIT

# Emit "<path>\t<yyyy/mm/dd>\t<sha>" for the oldest add of each tada path on <rev>.
oldest_adds() {
  git -C "$J" log --no-renames --diff-filter=A --name-only \
      --format='@%H %cd' --date=format:%Y/%m/%d "$1" -- "$TADA/" \
    | awk '/^@/ { split(substr($0, 2), a, " "); sha=a[1]; d=a[2]; next }
           NF   { last[$0] = d "\t" sha }
           END  { for (p in last) print p "\t" last[p] }'
}

migrate_once() {  # -> prints the number of flat entries moved
  local roots n=0 undated=0 p base d sha dest
  find "$J/$TADA" -maxdepth 1 -type f -name '*.md' -printf "$TADA/%f\n" | sort > "$work/flat"
  if [ ! -s "$work/flat" ]; then echo 0; return 0; fi
  oldest_adds HEAD > "$work/head"
  : > "$work/arch"; [ -n "$archive" ] && oldest_adds "$archive" > "$work/arch"
  roots=" $(git -C "$J" rev-list --max-parents=0 HEAD | tr '\n' ' ') "
  : > "$work/undated"
  while IFS= read -r p; do
    base="${p##*/}"
    d="" sha=""
    IFS=$'\t' read -r _ d sha < <(grep -F -m1 "$p"$'\t' "$work/head" || true)
    if [ -n "$sha" ] && [[ "$roots" == *" $sha "* ]]; then
      # Added by a re-rooting commit: its date is not the completion date.
      d=""; IFS=$'\t' read -r _ d _ < <(grep -F -m1 "$p"$'\t' "$work/arch" || true)
    fi
    if [ -n "$d" ]; then dest="$TADA/$d/$base"; else dest="$TADA/undated/$base"; fi
    if [ -e "$J/$dest" ]; then
      # Same base already at that exact shard: keep the sharded copy only if
      # it is byte-identical, otherwise park the flat one in undated/.
      if cmp -s "$J/$p" "$J/$dest"; then
        [ "$dry" = 1 ] || git -C "$J" rm -q -- "$p"
        n=$((n + 1)); continue
      fi
      dest="$TADA/undated/$base"
      [ -e "$J/$dest" ] && { echo "collision: $p -> $dest exists" >&2; return 1; }
    fi
    case "$dest" in "$TADA/undated/"*) undated=$((undated + 1)); echo "$p" >> "$work/undated" ;; esac
    if [ "$dry" = 1 ]; then printf '%s -> %s\n' "$p" "$dest" >&2
    else mkdir -p "$J/$(dirname "$dest")"; mv "$J/$p" "$J/$dest"; fi
    n=$((n + 1))
  done < "$work/flat"
  [ -s "$work/undated" ] && { echo "undated ($undated):" >&2; sed 's/^/  /' "$work/undated" >&2; }
  echo "$n"
}

for attempt in $(seq 1 20); do
  git -C "$J" fetch -q origin journal2
  git -C "$J" reset -q --hard origin/journal2
  moved="$(migrate_once)"
  if [ "$moved" = 0 ]; then echo "migrate-tada-shards: no flat entries remain"; exit 0; fi
  if [ "$dry" = 1 ]; then echo "migrate-tada-shards: dry run, would move $moved"; exit 0; fi
  git -C "$J" add -A -- "$TADA"
  git -C "$J" commit -q -m "journal: date-shard $moved flat tada report(s) (stage 3 migration)"
  if git -C "$J" push -q origin HEAD:journal2; then
    echo "migrate-tada-shards: moved $moved in $(git -C "$J" rev-parse --short HEAD)"
    continue  # re-run: repeat until the flat level is empty
  fi
  echo "migrate-tada-shards: push lost the race (attempt $attempt), re-syncing" >&2
  sleep $((RANDOM % 5 + 1))
done
echo "migrate-tada-shards: gave up after 20 attempts" >&2
exit 1
