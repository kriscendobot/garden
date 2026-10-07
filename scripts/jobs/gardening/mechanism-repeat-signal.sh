#!/bin/bash
# mechanism-repeat-signal.sh — deterministic repeat-finding sensor for the panel.
#
# When the two most recent prior panel rounds on a PR both raised must-fix findings
# that name the SAME mechanism (a source file, a backticked identifier, or a design
# section), the next round should ask whether that mechanism is needed at all,
# not run another patch round. This script finds that overlap; panel.sh forces the
# decomplector with the evidence (roles/jurors/decomplector/AGENT.md § Repeated
# must-fix on one mechanism).
#
# Review-miss cluster `design-bespoke-mechanism-over-existing-path`
# (endojs/endo-but-for-bots #1226, #1407): six design-panel rounds on #1226 hardened
# a per-guest socket and a derive-prune-pin tool catalog, and six code-panel rounds
# on #1407 patched the re-introduced socket's lifecycle. Each later round named the
# same files or sections as the round before it.
#
# Usage:
#   mechanism-repeat-signal.sh <worktree> [--store-dir D] [--rundir R --current-round N]
#                              [--evidence-file F]
#     --store-dir  the durable panel-runs/<slug> directory of compact records
#                  (one or more `## Round k — head \`sha\`` sections each).
#     --rundir     an in-process classic panel run dir (round-K.<seat>.md blocks
#                  and round-K.head) for rounds K < --current-round.
# Rounds are ordered by the committer time of their reviewed head in <worktree>;
# a round whose head does not resolve there is skipped, and a round reviewing the
# current HEAD is excluded (it is the round about to run).
#
# Exit: 10 = attention (overlap; evidence written), 0 = clear. Fail-open: any
# missing input is "clear". Titles are LLM-authored text about an untrusted diff,
# so keys are reduced to [A-Za-z0-9_.-] and spaces before they reach evidence.
set -uo pipefail

wt="${1:?usage: mechanism-repeat-signal.sh <worktree> [options]}"; shift
store="" rundir="" current=0 evidence=""
while [ $# -gt 0 ]; do
  case "$1" in
    --store-dir) store="${2:-}"; shift 2 ;;
    --rundir) rundir="${2:-}"; shift 2 ;;
    --current-round) current="${2:-0}"; shift 2 ;;
    --evidence-file) evidence="${2:-}"; shift 2 ;;
    *) echo "mechanism-repeat-signal: unknown argument $1" >&2; exit 2 ;;
  esac
done

# Seats whose findings are about prose or presentation, not mechanism.
COSMETIC=" orthographer thesaurus pruner copyeditor pedant stylist novice scribe "

work="$(mktemp -d "${TMPDIR:-/tmp}/mech-repeat.XXXXXX")"
trap 'rm -rf "$work"' EXIT
current_head="$(git -C "$wt" rev-parse HEAD 2>/dev/null || true)"

# add_round <head> <lines-file>: index a prior round by its head's commit time.
n=0
add_round() {
  local head="$1" lines="$2" full ts
  full="$(git -C "$wt" rev-parse --verify --quiet "$head^{commit}" 2>/dev/null)" || return 0
  [ -n "$full" ] || return 0
  [ "$full" = "$current_head" ] && return 0
  ts="$(git -C "$wt" log -1 --format=%ct "$full" 2>/dev/null)" || return 0
  n=$((n + 1))
  cat "$lines" >> "$work/round.$full"
  printf '%s %s\n' "$ts" "$full" >> "$work/index"
}

# Durable records: split each record into its round sections.
if [ -n "$store" ] && [ -d "$store" ]; then
  for rec in "$store"/*.md; do
    [ -e "$rec" ] || continue
    awk -v dir="$work" '
      /^## Round [0-9]+ — head `[0-9a-f]+`/ {
        h = $0; sub(/.*head `/, "", h); sub(/`.*/, "", h); k++
        out = dir "/rec." k "." h; printf "" > out; next }
      out != "" && /^- / { print > out }
    ' "$rec"
    for sec in "$work"/rec.*; do
      [ -e "$sec" ] || continue
      add_round "${sec##*.}" "$sec"
      rm -f "$sec"
    done
  done
fi

# In-process classic rounds: must-fix seat blocks, bullets prefixed with the seat.
if [ -n "$rundir" ] && [ -d "$rundir" ] && [ "$current" -gt 1 ]; then
  for k in $(seq 1 $((current - 1))); do
    head="$(cat "$rundir/round-$k.head" 2>/dev/null || true)"
    [ -n "$head" ] || continue
    : > "$work/inproc.$k"
    for block in "$rundir"/round-"$k".*.md; do
      [ -e "$block" ] || continue
      seat="${block##*/round-$k.}"; seat="${seat%.md}"
      grep -iE 'verdict' "$block" 2>/dev/null | head -1 | grep -qiE 'request.change|must.fix' || continue
      grep -E '^[[:space:]]*([-*]|[0-9]+[.)])[[:space:]]+' "$block" \
        | sed -E "s/^[[:space:]]*([-*]|[0-9]+[.)])[[:space:]]+/- $seat: /" >> "$work/inproc.$k"
    done
    add_round "$head" "$work/inproc.$k"
  done
fi

[ -s "$work/index" ] || exit 0
sort -n "$work/index" | awk '!seen[$2]++' > "$work/ordered"
[ "$(wc -l < "$work/ordered")" -ge 2 ] || exit 0

# keys <round-file>: mechanism keys named by non-cosmetic must-fix findings.
keys() {
  while IFS= read -r line; do
    seat="$(printf '%s' "$line" | sed -nE 's/^- ([a-z-]+):.*/\1/p')"
    case "$COSMETIC" in *" $seat "*) continue ;; esac
    {
      # Backticked tokens: file paths reduce to their basename; .md files and
      # short or numeric tokens are dropped.
      printf '%s\n' "$line" | grep -oE '`[^`]+`' | tr -d '`' | sed -E 's/:[0-9,-]+$//; s#.*/##'
      # Bare source-file names.
      printf '%s\n' "$line" | grep -oE '[A-Za-z0-9_.-]+\.(js|mjs|cjs|ts|tsx|jsx|rs|go|py|c|h|sh)\b' | sed 's#.*/##'
      # Design sections: the first two words after a section sign.
      printf '%s\n' "$line" | grep -oE '§[[:space:]]*[*"]*[A-Za-z][A-Za-z -]*' \
        | sed -E 's/^§[[:space:]]*[*"]*//' | awk '{ print "§ " tolower($1) (NF > 1 ? " " tolower($2) : "") }'
    } | tr -c 'A-Za-z0-9_.§ \n-' ' ' | sed -E 's/[[:space:]]+$//' \
      | grep -vE '\.md$|^[0-9.]*$' | awk 'length($0) >= 4'
  done < "$1" | sort -u
}

prev2="$(tail -2 "$work/ordered" | head -1 | cut -d' ' -f2)"
prev1="$(tail -1 "$work/ordered" | cut -d' ' -f2)"
keys "$work/round.$prev2" > "$work/k2"
keys "$work/round.$prev1" > "$work/k1"
comm -12 "$work/k2" "$work/k1" > "$work/common"
[ -s "$work/common" ] || exit 0

if [ -n "$evidence" ]; then
  {
    printf 'The two most recent prior panel rounds (heads %s, %s) both raised must-fix\n' "${prev2:0:8}" "${prev1:0:8}"
    printf 'findings naming the same mechanism. Recurring keys:\n'
    sed 's/^/- /' "$work/common" | head -20
  } > "$evidence"
fi
echo "mechanism-repeat: attention ($(wc -l < "$work/common") recurring keys across ${prev2:0:8} and ${prev1:0:8})"
exit 10
