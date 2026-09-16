#!/bin/bash
# ownership-map-signal.sh — deterministic (no-LLM) sensor for a design that spans
# MULTIPLE architectural layers/components without a coherent ownership map. It is
# the durable review-cycle sensor for the architectural-boundary-ownership review-
# miss cluster (review-misses/clusters/architectural-boundary-ownership.md;
# grounding endojs/endo-but-for-bots#1018, whose design put an engine-side
# `CrankOutcome` at the Ironhorse `Machine` seam while the transcript/embargo/commit
# responsibilities belonged to the Slot Machine supervisor, and six design-panel
# rounds never assembled the ownership map that would have shown the conflict).
#
# A design that names several layers must state, before review, WHO OWNS each of:
# durable state, commit/discard authority, restart/replay, and execution
# classification — the ownership map artifact defined in skills/ownership-map.
# This sensor does NOT judge the map (that stays with the decomplector seat): it
# runs plain code first, detects the multi-layer signal in the design text, reports
# whether an ownership-map section is present, and lists NAME candidates that fuse an
# outer-layer lifecycle concept onto an inner result/mechanism type (the
# `CrankOutcome` shape). A hit fires the decomplector's ownership-map lens over that
# evidence; the verdict stays the seat's.
#
# Mirrors the discipline of related-design-state.sh (deterministic pre-pass that
# FIRES a seat's lens toward review, never silently infers "clean") and
# detect-banners.sh (favors false positives; the juror makes the semantic call).
#
# Input, two forms:
#   ownership-map-signal.sh <worktree> [--base REF] [--evidence-file F]
#       Scan the ADDED lines of changed design docs (designs/*.md, */designs/*.md,
#       DESIGN*.md) between <base> (default HEAD~1) and HEAD. This is how a design-
#       only PR is reviewed: the design is added, so the added lines are its text.
#   ownership-map-signal.sh --files <f1> [f2 ...] [--evidence-file F]
#       Scan the full content of the named files (used by the relitigation test and
#       any caller with an explicit design file in hand).
#
# Output (stdout, grep-able AND human-readable):
#   ownership-map layers=<n> groups=[engine,supervisor,persistence,lifecycle] \
#     map_present=<yes|no> fused_candidates=[CrankOutcome, ...]
#   ownership-map-verdict=<attention|clear|undetermined>
# When --evidence-file is given AND the verdict is `attention`, the seat-facing
# evidence paragraph is written there (empty file on clear/undetermined).
#
# Exit status:
#   10 attention   — the design names >=2 distinct layers; reconstruct the map
#    0 clear       — fewer than 2 layers; no cross-boundary ownership map is owed
#    3 undetermined— no readable design content (missing base, no design files);
#                    surfaced, NEVER treated as clear (fail toward review)
#    2 usage error

set -uo pipefail

log() { echo "ownership-map-signal: $*" >&2; }
die() { log "$*"; exit 2; }

# --- argument parsing --------------------------------------------------------
mode="" wt="" base="HEAD~1" evidence_file=""
files=()
case "${1:-}" in
  "" ) die "usage: ownership-map-signal.sh <worktree> [--base REF] [--evidence-file F] | --files <f...>";;
  --files) mode="files"; shift;;
  -*)      die "first argument must be a worktree or --files (got '$1')";;
  *)       mode="worktree"; wt="$1"; shift;;
esac
while [ $# -gt 0 ]; do
  case "$1" in
    --base)          base="${2:?--base needs a ref}"; shift 2;;
    --evidence-file) evidence_file="${2:?--evidence-file needs a path}"; shift 2;;
    --files)         die "--files must be the first argument";;
    --*)             die "unknown option: '$1'";;
    *)               [ "$mode" = files ] && { files+=("$1"); shift; } || die "unexpected argument: '$1'";;
  esac
done
[ -n "$evidence_file" ] && : > "$evidence_file"

# --- gather the design text to scan -----------------------------------------
# TEXT is the concatenated content under inspection. In worktree mode it is the
# ADDED lines of changed design docs (diff-consistent with what the panel reviews);
# in files mode it is the full content of the named files.
TEXT=""
if [ "$mode" = worktree ]; then
  [ -d "$wt" ] || { log "worktree '$wt' is not a directory"; exit 3; }
  if ! git -C "$wt" rev-parse --verify --quiet "$base^{commit}" >/dev/null 2>&1; then
    log "base '$base' does not resolve in $wt — cannot isolate added design text"
    printf 'ownership-map layers=0 groups=[] map_present=no fused_candidates=[]\n'
    printf 'ownership-map-verdict=undetermined\n'
    exit 3
  fi
  # Added lines (leading '+', not the '+++' header) of changed design docs only.
  TEXT="$(git -C "$wt" diff "$base...HEAD" -- 2>/dev/null | awk '
    /^\+\+\+ /{
      path=$0; sub(/^\+\+\+ b\//,"",path); sub(/^\+\+\+ /,"",path)
      isdesign = (path ~ /(^|\/)designs\/[^/]*\.md$/ || path ~ /(^|\/)DESIGN[^/]*\.md$/)
      next
    }
    isdesign && /^\+/ && !/^\+\+\+ / { print substr($0,2) }
  ')"
else
  [ "${#files[@]}" -gt 0 ] || die "--files needs at least one path"
  for f in "${files[@]}"; do
    if [ -r "$f" ]; then TEXT="$TEXT"$'\n'"$(cat "$f")"; else log "file not readable: $f"; fi
  done
fi

if [ -z "${TEXT//[$'\n\t ']/}" ]; then
  log "no design text to scan"
  printf 'ownership-map layers=0 groups=[] map_present=no fused_candidates=[]\n'
  printf 'ownership-map-verdict=undetermined\n'
  exit 3
fi

# --- the four architectural-layer signal groups ------------------------------
# Each group is one layer/component; a group "matches" when any of its patterns
# appears in the design text. Two or more distinct groups => the design spans a
# boundary and owes an ownership map. Patterns are case-insensitive; each token
# lives in exactly one group so the layer count is not double-charged.
# Here-strings, never `printf ... | grep -q`: under `set -o pipefail` a grep -q that
# exits early on a match SIGPIPEs the upstream printf, and the pipeline then reports
# printf's 141 — a match would read as "no match". A here-string has no upstream
# process to signal, so the test reflects grep's own status.
group_pattern() {  # group_pattern <group> -> the alternation regex for that layer
  case "$1" in
    engine)      echo 'engine|interpreter|\bVM\b|bytecode|opcode|evaluat|run to quiescence|quiescen|instruction stream';;
    supervisor)  echo 'supervisor|\bhost\b|kernel|\bdaemon\b|\bMachine\b|Slot Machine|coordinator|scheduler|orchestrat';;
    persistence) echo 'snapshot|transcript|persist|durable|write-ahead|\bWAL\b|SQLite|checkpoint|heap join|serializ|\bstore\b|database';;
    lifecycle)   echo '\bcrank\b|commit|discard|embargo|\breplay\b|restart|rollback|\bretry\b|release-or-discard|lifecycle|abort';;
  esac
}
matched=()
for g in engine supervisor persistence lifecycle; do
  if grep -qiE "$(group_pattern "$g")" <<<"$TEXT"; then matched+=("$g"); fi
done
layers=${#matched[@]}

# --- ownership-map section present? ------------------------------------------
# A heading line (markdown ATX) whose text mentions ownership. The artifact skill
# names the canonical heading `## Ownership map`; match `ownership` in any heading
# so a design that titles it differently still counts.
map_present=no
if grep -qiE '^#{1,6}[[:space:]].*ownership' <<<"$TEXT"; then map_present=yes; fi

# --- fused-name candidates ---------------------------------------------------
# Identifiers that fuse an OUTER-layer lifecycle concept (Crank, Commit, Snapshot,
# ...) onto an INNER result/mechanism type (Outcome, Result, Status, ...). This is
# the `CrankOutcome` shape: a crank-lifecycle concept named on the engine's result
# type. Deterministic candidate surfacing only — the seat decides whether the name
# actually imports an outer concept into the inner layer.
fused_re='(Crank|Commit|Transaction|Snapshot|Replay|Embargo|Durable|Persist|Checkpoint|Rollback|Lifecycle)(Outcome|Result|Status|Value|Handle|Context|State|Report|Return|Kind)'
fused="$(grep -oE "$fused_re" <<<"$TEXT" | sort -u | paste -sd', ' -)"

# `flag` is the heuristic suspected-boundary-violation signal — evidence for the
# seat, NOT a verdict (the decomplector still decides): a multi-layer design owes an
# explicit ownership map, so a MISSING map is worth flagging, as is any fused
# outer-into-inner name candidate. A multi-layer design that carries an explicit map
# AND surfaces no fused name is `flag=no`: the check does not manufacture a failure
# from merely naming several layers.
flag=no
if [ "$layers" -ge 2 ] && { [ "$map_present" = no ] || [ -n "$fused" ]; }; then flag=yes; fi

groups_csv="$(printf '%s' "${matched[*]:-}" | tr ' ' ',')"
printf 'ownership-map layers=%s groups=[%s] map_present=%s fused_candidates=[%s] flag=%s\n' \
  "$layers" "$groups_csv" "$map_present" "$fused" "$flag"

if [ "$layers" -ge 2 ]; then
  printf 'ownership-map-verdict=attention\n'
  if [ -n "$evidence_file" ]; then
    {
      printf 'The design spans %s architectural layers (%s). ' "$layers" "$groups_csv"
      printf 'Reconstruct its ownership map (skills/ownership-map) across every boundary and challenge it: '
      printf 'for each layer say who owns (1) durable/persistent state, (2) the commit/discard decision, '
      printf '(3) restart/replay, and (4) execution classification. '
      if [ "$map_present" = no ]; then
        printf 'The design carries NO explicit ownership-map section, so those assignments are only implicit in prose — derive them and flag any left ambiguous across the boundary. '
      else
        printf 'The design DOES carry an ownership-map section — confirm it is coherent and that no responsibility is claimed by two layers; do NOT flag it merely for naming multiple layers. '
      fi
      if [ -n "$fused" ]; then
        printf 'Name candidates that may import an outer-layer lifecycle concept into the inner mechanism: %s. ' "$fused"
        printf 'Decide for each whether the name assigns an outer-layer (commit/crank/persistence) concept to an inner engine/mechanism type that only evaluates and runs to quiescence.'
      else
        printf 'No fused outer-into-inner name candidates were detected by pattern; still check that no inner-layer type is named for an outer-layer lifecycle concept.'
      fi
      printf '\n'
    } > "$evidence_file"
  fi
  exit 10
fi

printf 'ownership-map-verdict=clear\n'
exit 0
