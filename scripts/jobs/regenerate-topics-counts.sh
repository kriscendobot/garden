#!/bin/bash
# regenerate-topics-counts.sh — deterministically reconcile the per-topic
# Sections-count column in `library/topics/README.md`'s Index table with the
# committed corpus, and land it through the producer clone (the
# land-journal-edit.sh sync+CAS path). A sibling of
# regenerate-sections-index.sh, sharing its contract exactly.
#
# WHY THIS EXISTS. `library/topics/README.md` opens with an `## Index` table
# whose last column is a per-topic count of section rows. That number was
# hand-maintained, so it drifted silently every scholar cycle: a cycle that
# files three new sections under `testing` must remember to bump `testing`'s
# Index count by three, by hand, across a 30-row table. It did not. Two
# independent 2026-06-28 cycles (results 173121Z and 174820Z) each had to
# hand-correct multi-dozen-row count drift, and both flagged the need for
# exactly this deterministic reconciliation. Whole-corpus hand-recounting is the
# same "impractical and risky" judgment call that regenerate-sections-index.sh
# was created to eliminate. This script makes the count a PURE PROJECTION of the
# committed corpus, so the Index stays a usable signal rather than decorative.
#
# WHAT IT REGENERATES. The README has three parts; only the COUNT COLUMN of the
# middle is touched:
#   1. PREAMBLE — the `# Topics` title + intro through the `## Index` header and
#      the table's header + separator rows. Preserved verbatim.
#   2. INDEX TABLE — for each `| [topic](topic.md) | abstract | N |` data row,
#      the last column N is REPLACED with the authoritative count: the number of
#      section data rows (`| [...` lines under the `## Sections` heading) in that
#      topic page (`library/topics/<topic>.md`). The first two columns (link +
#      abstract) are preserved BYTE-FOR-BYTE — an abstract may contain an escaped
#      pipe (`\|`), so the rewrite keys off the ` | ` cell separator, which an
#      escaped pipe never produces. A row whose committed count is the literal
#      `(meta)` (e.g. `spec-to-implementation`, `references`) is a NON-COUNTABLE
#      taxonomy axis; it is passed through verbatim and never recounted.
#   3. TAIL — everything from the heading that follows the Index table
#      (`## Seed-but-not-yet-populated topics`) through EOF. Hand-curated;
#      preserved verbatim.
#
# The `## Index` header is the splice anchor; the Index table ends at the next
# `## ` heading. If the anchor is missing the script refuses (exit 2) rather than
# risk clobbering hand-authored content.
#
# COMPLETENESS. The only failure the generator reports is a MISSING topic page:
# a non-`(meta)` Index row whose `library/topics/<topic>.md` does not exist, so
# its count cannot be projected. In --check / --land this FAILS the run (exit 1):
# the Index would carry an uncountable row. Write the missing topic page (or
# correct/`(meta)`-tag the row) and re-run.
#
# USAGE
#   regenerate-topics-counts.sh --print [--library DIR]
#       Emit the fully reconciled README to stdout. No network, no write.
#   regenerate-topics-counts.sh --check [--library DIR]
#       Reconcile and diff against the committed README in DIR. Exit 0 if the
#       counts are already current (the generator is idempotent), 1 if they would
#       change (the Index is stale — run --land), 2 on setup error. CI-style.
#   regenerate-topics-counts.sh --land
#       Sync a dedicated journal2 clone to the current origin/journal2 tip,
#       reconcile against it, and land the new README via land-journal-edit.sh
#       (producer-clone sync + CAS push + silent-loss guard). Idempotent: lands
#       nothing when the counts are already current. This is the form the
#       scholar/library landing gate calls alongside the sections-index regen.
#   regenerate-topics-counts.sh -h | --help
#
#   Default (no args): --land.
#
# EXIT CODES
#   0  --print emitted / --check found the counts current / --land landed (or
#      no-op because already current)
#   1  --check found the counts stale / a missing-topic-page completeness failure
#      / a land that could not complete after retries
#   2  usage / setup error / a missing splice anchor
#   75 EX_TEMPFAIL: transient connectivity outage during the --land tip sync
#      (from sync_clone); the caller skips this tick and retries next cadence.
#
# CONFIG (overridable; tests point these at a throwaway journal)
#   GARDEN_TOPICS_COUNTS_CLONE  the dedicated read-only clone --land syncs to tip
#                               (default $GARDEN_STATE/regenerate-topics-counts/
#                               journal), kept OUTSIDE any reset-prone worktree
#                               exactly like regenerate-sections-index.sh's.

set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG="regenerate-topics-counts"

require_tools git awk sort diff

usage() {
  awk 'NR>1 && /^#/{sub(/^# ?/,"");print;next} NR>1{exit}' "$0"
}

# --- splice anchor (literal, stable) -----------------------------------------
ANCHOR_INDEX='## Index'

# locate_library — mirror regenerate-sections-index.sh's resolution order so the
# same DIR conventions hold across the library tooling, but key on topics/.
locate_library() {
  local lib="$1"
  if [ -z "$lib" ]; then
    if   [ -n "${GARDEN_GARDENER_CLONE:-}" ] && [ -d "${GARDEN_GARDENER_CLONE}/library" ]; then lib="${GARDEN_GARDENER_CLONE}/library"
    elif [ -n "${GARDEN_ROOT:-}" ] && [ -d "${GARDEN_ROOT}/journal/library" ];            then lib="${GARDEN_ROOT}/journal/library"
    elif [ -d "./library" ];                                                              then lib="./library"
    else echo "regenerate-topics-counts: cannot locate the library; pass --library <dir>" >&2; exit 2
    fi
  fi
  lib="$(cd "$lib" 2>/dev/null && pwd)" || { echo "regenerate-topics-counts: no such library dir" >&2; exit 2; }
  [ -d "$lib/topics" ] || {
    echo "regenerate-topics-counts: $lib has no topics/ — not a library root" >&2; exit 2; }
  printf '%s' "$lib"
}

# count_topic_rows <topicfile> — the authoritative per-topic count: the number of
# section data rows (`| [...` lines) under the topic page's `## Sections` heading,
# stopping at the next `## ` heading (commonly `## See also`). Blank lines inside
# the table do not interrupt the count. Pure awk; no network.
count_topic_rows() {
  awk '
    /^## Sections[[:space:]]*$/ { insec=1; next }
    insec && /^## /             { insec=0 }
    insec && /^\| \[/           { n++ }
    END { print n+0 }
  ' "$1"
}

# --- the generator -----------------------------------------------------------
# generate_index <library> — emit the reconciled README to stdout. Diagnostics go
# to stderr; a returned 1 means a MISSING topic page was found, 2 a setup/anchor
# error.
generate_index() {
  local LIB="$1"
  local TOPDIR="$LIB/topics"
  local readme="$TOPDIR/README.md"
  [ -f "$readme" ] || { echo "regenerate-topics-counts: no $readme to reconcile" >&2; return 2; }

  if ! grep -qxF "$ANCHOR_INDEX" "$readme"; then
    echo "regenerate-topics-counts: missing INDEX anchor in $readme:" >&2
    echo "  $ANCHOR_INDEX" >&2; return 2
  fi

  local missing_tmp; missing_tmp="$(mktemp)"
  local in_index=0 line body col1 tgt slug trimmed rest curcount prefix newcount
  # Stream the file: rewrite only the count column of Index data rows; everything
  # else (preamble, table header/separator, tail) passes through verbatim.
  while IFS= read -r line || [ -n "$line" ]; do
    if [ "$in_index" -eq 0 ]; then
      printf '%s\n' "$line"
      [ "$line" = "$ANCHOR_INDEX" ] && in_index=1
      continue
    fi
    # In the Index section. A new `## ` heading ends it.
    case "$line" in
      '## '*) in_index=0; printf '%s\n' "$line"; continue ;;
    esac
    # Only `| [topic](...)` data rows are rewritten; header/separator/blank pass.
    case "$line" in
      '| ['*) : ;;
      *) printf '%s\n' "$line"; continue ;;
    esac

    body="${line#| }"
    col1="${body%% | *}"                       # first cell: [topic](topic.md)
    tgt="${col1##*](}"; tgt="${tgt%%)*}"       # link target: topic.md
    slug="${tgt%.md}"

    # Strip trailing whitespace, then the trailing `|`, to isolate the last cell.
    trimmed="${line%"${line##*[![:space:]]}"}"  # rstrip whitespace
    rest="${trimmed%|}"
    rest="${rest%"${rest##*[![:space:]]}"}"     # rstrip again (drop space before |)
    curcount="${rest##* | }"                     # current count cell

    # A `(meta)` axis is non-countable: pass the row through verbatim.
    if [ "$curcount" = '(meta)' ]; then
      printf '%s\n' "$line"; continue
    fi

    if [ ! -f "$TOPDIR/$slug.md" ]; then
      printf '%s\n' "$slug" >> "$missing_tmp"
      printf '%s\n' "$line"; continue          # leave the row; the run will fail
    fi
    newcount="$(count_topic_rows "$TOPDIR/$slug.md")"
    prefix="${rest% | *}"                        # everything up to the count cell
    printf '%s | %s |\n' "$prefix" "$newcount"
  done < "$readme"

  local rc=0
  if [ -s "$missing_tmp" ]; then
    rc=1
    echo "regenerate-topics-counts: MISSING FAIL — $(wc -l < "$missing_tmp" | tr -d ' ') Index row(s) name a topic page that does not exist:" >&2
    sed 's#^#  MISSING topics/#; s#$#.md#' "$missing_tmp" >&2
    echo "  Write the missing topic page or correct/(meta)-tag the row, then re-run." >&2
  fi
  rm -f "$missing_tmp"
  return $rc
}

# --- argument parse ----------------------------------------------------------
MODE="land"
LIBRARY=""
case "${1:-}" in
  -h|--help) usage; exit 0 ;;
esac
while [ $# -gt 0 ]; do
  case "$1" in
    --print) MODE="print"; shift ;;
    --check) MODE="check"; shift ;;
    --land)  MODE="land";  shift ;;
    --library) LIBRARY="${2:?--library needs a dir}"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "regenerate-topics-counts: unknown argument: $1" >&2; usage >&2; exit 2 ;;
  esac
done

case "$MODE" in
  print)
    LIB="$(locate_library "$LIBRARY")"
    out="$(generate_index "$LIB")"; rc=$?
    [ "$rc" = 2 ] && exit 2
    printf '%s\n' "$out"
    exit "$rc" ;;

  check)
    LIB="$(locate_library "$LIBRARY")"
    out="$(generate_index "$LIB")"; rc=$?
    [ "$rc" = 2 ] && exit 2
    if diff -q <(printf '%s\n' "$out") "$LIB/topics/README.md" >/dev/null 2>&1; then
      log "topics index counts are current (generator is idempotent)"
      exit "$rc"           # 0 unless a completeness failure was reported
    fi
    log "topics index counts are STALE — reconciliation would change them; run --land."
    diff "$LIB/topics/README.md" <(printf '%s\n' "$out") | grep -cE '^[<>]' \
      | awk '{print "  "$1" changed line(s) between the committed counts and a fresh reconciliation"}' >&2 || true
    exit 1 ;;

  land)
    # Sync a dedicated clone to tip, reconcile against it, and land via the
    # producer-clone sync+CAS lander. Tip-sync discipline per regenerate-sections-index.sh.
    DIR="${GARDEN_TOPICS_COUNTS_CLONE:-$GARDEN_STATE/regenerate-topics-counts/journal}"
    ensure_clone "$DIR"
    sync_clone "$DIR"                          # may exit 75 on a transient outage
    LIB="$DIR/library"
    [ -d "$LIB/topics" ] || die "no library/topics in the synced clone at $DIR"
    TIP="$(git -C "$DIR" rev-parse --short HEAD 2>/dev/null || echo '?')"
    out="$(generate_index "$LIB")"; rc=$?
    [ "$rc" = 2 ] && exit 2
    if [ "$rc" -ne 0 ]; then
      die "refusing to land an incomplete index (see MISSING above); fix the corpus and re-run"
    fi
    if diff -q <(printf '%s\n' "$out") "$LIB/topics/README.md" >/dev/null 2>&1; then
      log "tip $TIP: topics index counts already current; nothing to land"
      exit 0
    fi
    log "tip $TIP: reconciled topics index counts differ; landing via land-journal-edit.sh"
    BASE_BLOB="$(git -C "$DIR" rev-parse HEAD:library/topics/README.md)"
    printf '%s\n' "$out" | GARDEN_ROLE="${GARDEN_ROLE:-scholar}" "$HERE/land-journal-edit.sh" --base-blob "$BASE_BLOB" library/topics/README.md
    ;;
esac
