#!/bin/bash
# Shared, read-only statistics helpers for journal-contention-watch/probe.

jc_median_stream() {
  LC_ALL=C sort -n | awk '{ a[++n]=$1 } END {
    if (!n) { print "-"; exit }
    if (n % 2) printf "%.6f\n", a[(n+1)/2]
    else printf "%.6f\n", (a[n/2]+a[n/2+1])/2
  }'
}

# jc_numeric_stats <ring> <divisor>
# count, p50, p95, median, MAD, oldest-third median, newest-third median,
# maximum, first timestamp, last timestamp. Only the trailing configured window
# is considered. The recorder stores durations in microseconds, hence divisor.
jc_numeric_stats() {
  local ring="$1" divisor="${2:-1}" tmp sorted count p50i p95i
  local p50 p95 median mad third oldest newest maximum first_ts last_ts
  tmp="$(mktemp)"; sorted="$(mktemp)"
  { tail -n "${GARDEN_CONTENTION_WINDOW:-256}" "$ring" 2>/dev/null || true; } \
    | awk -v d="$divisor" '$1 ~ /^[0-9]+$/ && $2 ~ /^[0-9]+([.][0-9]+)?$/ { printf "%s %.9f\n", $1, $2/d }' > "$tmp"
  count="$(wc -l < "$tmp")"
  if [ "$count" -eq 0 ]; then
    rm -f "$tmp" "$sorted"
    printf '0\t-\t-\t-\t-\t-\t-\t-\t-\t-\n'
    return 0
  fi
  cut -d' ' -f2 "$tmp" | LC_ALL=C sort -n > "$sorted"
  p50i=$(( (count + 1) / 2 )); p95i=$(( (95 * count + 99) / 100 ))
  p50="$(sed -n "${p50i}p" "$sorted")"
  p95="$(sed -n "${p95i}p" "$sorted")"
  median="$(jc_median_stream < "$sorted")"
  mad="$(awk -v m="$median" '{ d=$1-m; if (d<0) d=-d; print d }' "$sorted" | jc_median_stream)"
  third=$(( count / 3 )); [ "$third" -gt 0 ] || third=1
  oldest="$(head -n "$third" "$tmp" | cut -d' ' -f2 | jc_median_stream)"
  newest="$(tail -n "$third" "$tmp" | cut -d' ' -f2 | jc_median_stream)"
  maximum="$(tail -1 "$sorted")"
  first_ts="$(head -1 "$tmp" | cut -d' ' -f1)"
  last_ts="$(tail -1 "$tmp" | cut -d' ' -f1)"
  printf '%s\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%.6f\t%s\t%s\n' \
    "$count" "$p50" "$p95" "$median" "$mad" "$oldest" "$newest" "$maximum" "$first_ts" "$last_ts"
  rm -f "$tmp" "$sorted"
}

jc_ring_count() {
  { tail -n "${GARDEN_CONTENTION_WINDOW:-256}" "$1" 2>/dev/null || true; } \
    | awk -v value="${2:-}" '$2 == value || value == "" { n++ } END { print n+0 }'
}

jc_trim_ring() {
  local ring="$1" max="${GARDEN_CONTENTION_RING:-512}" tmp count
  [ -f "$ring" ] || return 0
  count="$(wc -l < "$ring")"; [ "$count" -le "$max" ] && return 0
  tmp="${ring}.trim.$$"
  tail -n "$max" "$ring" > "$tmp" && mv -f "$tmp" "$ring"
}

jc_field() { sed -n "s/^$2: *//p" "$1" 2>/dev/null | head -1 || true; }

jc_clone_gitdir() {
  if [ -d "$1/.git" ]; then printf '%s/.git\n' "$1"
  elif [ -d "$1/objects" ] && [ -f "$1/HEAD" ]; then printf '%s\n' "$1"
  else return 1; fi
}

jc_clone_metrics() { # bytes packs gc-log(0/1)
  local clone="$1" gitdir bytes packs gc=0 objects size size_pack size_garbage
  gitdir="$(jc_clone_gitdir "$clone")" || { printf '0\t0\t0\n'; return 0; }
  # count-objects reads Git's object accounting without walking the checked-out
  # journal tree. A recursive du of a 105G clone is itself a multi-minute outage;
  # the incident-class bloat lives in loose/packed/garbage objects, all covered.
  objects="$(git -C "$clone" count-objects -v 2>/dev/null || true)"
  size="$(printf '%s\n' "$objects" | sed -n 's/^size: //p')"; size="${size:-0}"
  size_pack="$(printf '%s\n' "$objects" | sed -n 's/^size-pack: //p')"; size_pack="${size_pack:-0}"
  size_garbage="$(printf '%s\n' "$objects" | sed -n 's/^size-garbage: //p')"; size_garbage="${size_garbage:-0}"
  bytes=$(( (size + size_pack + size_garbage) * 1024 ))
  packs="$(printf '%s\n' "$objects" | sed -n 's/^packs: //p')"; packs="${packs:-0}"
  [ -e "$gitdir/gc.log" ] && gc=1
  printf '%s\t%s\t%s\n' "$bytes" "$packs" "$gc"
}

# Map recorder slugs back to per-instance clones once per checker/probe process.
# The hot recorder intentionally stores no path metadata; the reader pays one
# bounded discovery walk, not one walk per ring (which becomes quadratic).
declare -A JC_CLONE_BY_SLUG 2>/dev/null || true
JC_CLONE_INDEX_READY=0
JC_FOUND_CLONE=""
jc_build_clone_index() {
  local path slug remote
  [ "$JC_CLONE_INDEX_READY" -eq 0 ] || return 0
  JC_CLONE_INDEX_READY=1
  [ -d "$GARDEN_STATE" ] || return 0
  while IFS= read -r path; do
    path="${path%/.git}"
    remote="$(git -C "$path" config --get remote.origin.url 2>/dev/null || true)"
    # Only the garden journal's per-service clones are actuator targets. State
    # can also contain project repos (for example ironhorse-fuzz/project); two
    # remediators must never rename those. Tests use isolated fixture repos.
    if [ "${GARDEN_TEST:-0}" != 1 ] && ! is_production_journal_remote "$remote"; then continue; fi
    slug="$(contention_clone_slug "$path")"
    JC_CLONE_BY_SLUG["$slug"]="$path"
  done < <(find "$GARDEN_STATE" -maxdepth 8 -type d -name .git -prune 2>/dev/null)
}
jc_resolve_clone() {
  jc_build_clone_index
  JC_FOUND_CLONE="${JC_CLONE_BY_SLUG[$1]:-}"
  [ -n "$JC_FOUND_CLONE" ]
}
jc_find_clone() { # compatibility/output wrapper
  jc_resolve_clone "$1" || return 1
  printf '%s\n' "$JC_FOUND_CLONE"
}

jc_all_slugs() {
  local dir file slug
  for dir in "$GARDEN_CONTENTION_DIR"/*; do
    [ -d "$dir" ] || continue
    for file in "$dir"/*; do [ -f "$file" ] && basename "$file"; done
  done
  jc_build_clone_index
  for slug in "${!JC_CLONE_BY_SLUG[@]}"; do printf '%s\n' "$slug"; done
}
