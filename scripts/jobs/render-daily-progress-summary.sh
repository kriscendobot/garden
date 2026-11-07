#!/bin/bash
# render-daily-progress-summary.sh — deterministic fixed-window journal digest.
#
# Usage: render-daily-progress-summary.sh <journal-dir> <window-start> <window-end> <output-path>
#
# This deliberately summarizes only entry metadata.  Journal bodies can contain
# untrusted external material; counts and relative source paths are sufficient
# factual progress reporting and make the render reproducible.
set -euo pipefail

dir="${1:?journal directory required}"
start="${2:?window start required}"
end="${3:?window end required}"
output="${4:?output path required}"

case "$output" in journal/periodicals/*/*.md) ;; *) echo "invalid periodical output: $output" >&2; exit 2;; esac
destination="${output#journal/}"
start_epoch="$(date -u -d "$start" +%s)"
end_epoch="$(date -u -d "$end" +%s)"
[ "$start_epoch" -lt "$end_epoch" ] || { echo "invalid empty/reversed window" >&2; exit 2; }

tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT

# Emit project, kind, and source for each entry in the half-open time window.
# `at:` is accepted for the older entry form; `ts:` is the current contract.
while IFS= read -r -d '' file; do
  stamp="$(sed -n 's/^\(ts\|at\):[[:space:]]*//p' "$file" | head -1)"
  [ -n "$stamp" ] || continue
  epoch="$(date -u -d "$stamp" +%s 2>/dev/null || true)"
  [ -n "$epoch" ] && [ "$epoch" -ge "$start_epoch" ] && [ "$epoch" -lt "$end_epoch" ] || continue
  project="$(sed -n 's/^project:[[:space:]]*//p' "$file" | head -1)"
  kind="$(sed -n 's/^kind:[[:space:]]*//p' "$file" | head -1)"
  [ -n "$project" ] || project="garden-meta"
  [ -n "$kind" ] || kind="unknown"
  printf '%s\t%s\t%s\n' "$project" "$kind" "${file#"$dir"/}" >> "$tmp"
done < <(find "$dir/entries" -type f -name '*.md' -print0 2>/dev/null | sort -z)

mkdir -p "$dir/$(dirname "$destination")"
if [ ! -s "$tmp" ]; then
  printf 'Nothing moved in the journal from %s to %s.\n' "$start" "$end" > "$dir/$destination"
  exit 0
fi

count="$(wc -l < "$tmp" | tr -d ' ')"
projects="$(cut -f1 "$tmp" | LC_ALL=C sort -u | wc -l | tr -d ' ')"
{
  printf '# Daily progress summary\n\n'
  printf 'Window: %s to %s. %s journal entries across %s project streams.\n' "$start" "$end" "$count" "$projects"
  while IFS= read -r project; do
    printf '\n## %s\n' "$project"
    while IFS= read -r kind; do
      mapfile -t sources < <(awk -F '\t' -v p="$project" -v k="$kind" '$1 == p && $2 == k { print $3 }' "$tmp" | LC_ALL=C sort)
      printf '\n### %s (%s)\n' "$kind" "${#sources[@]}"
      for source in "${sources[@]}"; do printf -- '- `%s`\n' "$source"; done
    done < <(awk -F '\t' -v p="$project" '$1 == p { print $2 }' "$tmp" | LC_ALL=C sort -u)
  done < <(cut -f1 "$tmp" | LC_ALL=C sort -u)
} > "$dir/$destination"
