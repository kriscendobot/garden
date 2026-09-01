#!/bin/bash
# regenerate-sections-index.sh — deterministically rebuild the auto-generated
# `library/sections/README.md` flat index from the committed library, and land
# it through the producer clone (the land-journal-edit.sh sync+CAS path).
#
# WHY THIS EXISTS. `library/sections/README.md` is a ~3 MB, 5500+-entry
# auto-generated flat index of every section file. `library-link-check.sh`
# treats its `### <source-slug>` blocks as a must-resolve navigation backstop,
# yet nothing regenerated it — scholars handled it by hand, inconsistently. The
# 2026-06-28 erights ingest is the proof: one scholar SKIPPED it ("a
# regeneration pass will pick up the new sections", entry 155751Z) and another
# HAND-EDITED it (+5 `###` blocks, entry 161137Z). Whole-file hand-editing a
# 5500-entry generated file is exactly the "impractical and risky" judgment call
# that belongs in a script, like land-journal-edit.sh and library-link-check.sh
# already encode the rest of the library landing discipline. This script makes
# the index a pure projection of the committed corpus, so the backstop is never
# left stale and no agent ever whole-file-replaces it by hand.
#
# WHAT IT GENERATES. The README has three parts; only the MIDDLE is regenerated:
#   1. PREAMBLE  — the `# Sections` title + intro through the
#      `## Current sections (auto-generated index, alphabetical by source)`
#      header. Preserved verbatim from the committed file.
#   2. AUTO-INDEX — REGENERATED. A `Total section files: N (P parent indexes +
#      C children).` line, then one `### <source-slug>` block per source-slug
#      (alphabetical). The index is SECTION-FILE-DRIVEN so it is complete by
#      construction — every `sections/*.md` appears exactly once:
#        * A `kind: index` section file's CHILDREN are the targets in its
#          `Sections:` block; a child nests under its parent (sorted by
#          filename), rendered with the title the parent gave it.
#        * Every other section file (and every index parent) is a TOP-LEVEL
#          entry. Its source-slug is the longest `--`-delimited prefix that is
#          a committed `sources/<slug>.md` page, else the filename with its last
#          `--<segment>` stripped. Top-level entries are grouped by source-slug
#          and, within a block, sorted by filename; a `kind: index` entry is
#          rendered `(index)` with its children nested under it.
#      The committed `sources/*.md` pages supply the source-slug vocabulary the
#      grouping prefers; the `kind: index` parents supply the child lists —
#      exactly the surfaces library-link-check.sh resolves.
#   3. HISTORICAL INGEST LOG — the `## Historical ingest log (preserved for
#      chronological context)` section through EOF. HAND-CURATED narrative;
#      preserved verbatim. The regenerator NEVER rewrites it.
#
# The two `## ` headers are the splice anchors. If either is missing the script
# refuses rather than risk clobbering hand-authored content.
#
# COMPLETENESS. Because every section file is grouped (a source-slug always
# resolves) the index is complete by construction; the only failure the
# generator can report is a DANGLING child target — a `kind: index` parent's
# `Sections:` block listing a child file that does not exist. In --check /
# --land a dangling child FAILS the run (exit 1): it would put a must-resolve
# dangling link in the backstop. Write the missing child or correct the
# parent's `Sections:` row (the same defect class library-link-check.sh
# --changed catches) and re-run.
#
# USAGE
#   regenerate-sections-index.sh --print [--library DIR]
#       Emit the fully regenerated README to stdout. No network, no write.
#   regenerate-sections-index.sh --check [--library DIR]
#       Regenerate and diff against the committed README in DIR. Exit 0 if the
#       index is already current (the regenerator is idempotent), 1 if it would
#       change (the backstop is stale — run --land), 2 on setup error. CI-style.
#   regenerate-sections-index.sh --land
#       Sync a dedicated journal2 clone to the current origin/journal2 tip,
#       regenerate against it, and land the new README via land-journal-edit.sh
#       (producer-clone sync + CAS push + silent-loss guard). Idempotent: lands
#       nothing when the index is already current. This is the form the
#       scholar/library landing gate calls as its final step.
#   regenerate-sections-index.sh -h | --help
#
#   Default (no args): --land.
#
# EXIT CODES
#   0  --print emitted / --check found the index current / --land landed (or
#      no-op because already current)
#   1  --check found the index stale / a completeness failure (orphan or
#      dangling target) / a land that could not complete after retries
#   2  usage / setup error / a missing splice anchor
#   75 EX_TEMPFAIL: transient connectivity outage during the --land tip sync
#      (from sync_clone); the caller skips this tick and retries next cadence.
#
# CONFIG (overridable; tests point these at a throwaway journal)
#   GARDEN_SECTIONS_INDEX_CLONE  the dedicated read-only clone --land syncs to
#                                tip (default $GARDEN_STATE/regenerate-sections-
#                                index/journal), kept OUTSIDE any reset-prone
#                                worktree exactly like library-link-scan.sh's.

set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG="regenerate-sections-index"

require_tools git awk sort diff

usage() {
  awk 'NR>1 && /^#/{sub(/^# ?/,"");print;next} NR>1{exit}' "$0"
}

# --- splice anchors (literal, stable) ----------------------------------------
ANCHOR_INDEX='## Current sections (auto-generated index, alphabetical by source)'
ANCHOR_LOG='## Historical ingest log (preserved for chronological context)'

# locate_library — mirror library-link-check.sh's resolution order so the same
# DIR conventions hold across the library tooling.
locate_library() {
  local lib="$1"
  if [ -z "$lib" ]; then
    if   [ -n "${GARDEN_GARDENER_CLONE:-}" ] && [ -d "${GARDEN_GARDENER_CLONE}/library" ]; then lib="${GARDEN_GARDENER_CLONE}/library"
    elif [ -n "${GARDEN_ROOT:-}" ] && [ -d "${GARDEN_ROOT}/journal/library" ];            then lib="${GARDEN_ROOT}/journal/library"
    elif [ -d "./library" ];                                                              then lib="./library"
    else echo "regenerate-sections-index: cannot locate the library; pass --library <dir>" >&2; exit 2
    fi
  fi
  lib="$(cd "$lib" 2>/dev/null && pwd)" || { echo "regenerate-sections-index: no such library dir" >&2; exit 2; }
  [ -d "$lib/sections" ] && [ -d "$lib/sources" ] || {
    echo "regenerate-sections-index: $lib has no sections/ + sources/ — not a library root" >&2; exit 2; }
  printf '%s' "$lib"
}

# --- per-file extractors (pure awk; no network) ------------------------------

# classify_and_children <secfile> <basename> — single-pass reader. Emits one
# line `INDEX <basename>` if the file frontmatter carries `kind: index`, then one
# `CHILD <basename>\t<childbasename>\t<title>` line per `- [title](target.md)`
# row in the file's `Sections:` block (targets reduced to a bare basename). A
# non-index file emits nothing. Reading classification + child list in one awk
# pass keeps this to one process per file across the ~6k-file corpus.
classify_and_children() {
  awk -v parent="$2" '
    /^---[[:space:]]*$/ { fm++; next }
    fm==1 && /^kind:[[:space:]]*index[[:space:]]*$/ { isidx=1 }
    fm>=2 && !printed && isidx { print "INDEX " parent; printed=1 }
    fm>=2 && /^Sections:[[:space:]]*$/ { inblk=1; next }
    fm>=2 && inblk && /^[[:space:]]*-[[:space:]]*\[/ {
      # Split on the literal "](" separator (a markdown title never contains it,
      # and the target filename never contains "(" or ")"), so a title with its
      # own parentheses — "Routers ... (not dumb pipes)" — does not derail the
      # target extraction. sep = first "](" on the line.
      line=$0; sep=index(line, "](")
      if (sep==0) next
      title=substr(line, 1, sep-1); sub(/^[^[]*\[/, "", title)
      tgt=substr(line, sep+2);      sub(/\).*$/, "", tgt)
      sub(/#.*$/, "", tgt); sub(/^.*\//, "", tgt)
      print "CHILD " parent "\t" tgt "\t" title
      next
    }
    fm>=2 && inblk && /^[[:space:]]*$/ { next }
    fm>=2 && inblk && !/^[[:space:]]*-/ { inblk=0 }
    END { if (isidx && !printed) print "INDEX " parent }
  ' "$1"
}

# --- the generator -----------------------------------------------------------
# generate_auto_index <library> — emit parts 1+2+3 of the regenerated README to
# stdout. Diagnostics go to stderr; a returned 1 means a DANGLING child target
# was found, 2 a setup/anchor error.
generate_auto_index() {
  local LIB="$1"
  local SRCDIR="$LIB/sources" SECDIR="$LIB/sections"
  local readme="$SECDIR/README.md"
  [ -f "$readme" ] || { echo "regenerate-sections-index: no $readme to splice around" >&2; return 2; }

  # Preamble (through the AUTO-INDEX anchor) and tail (from the LOG anchor).
  if ! grep -qxF "$ANCHOR_INDEX" "$readme"; then
    echo "regenerate-sections-index: missing AUTO-INDEX anchor in $readme:" >&2
    echo "  $ANCHOR_INDEX" >&2; return 2
  fi
  if ! grep -qxF "$ANCHOR_LOG" "$readme"; then
    echo "regenerate-sections-index: missing HISTORICAL-LOG anchor in $readme:" >&2
    echo "  $ANCHOR_LOG" >&2; return 2
  fi
  local preamble tail
  preamble="$(awk -v a="$ANCHOR_INDEX" '{print} $0==a{exit}' "$readme")"
  tail="$(awk -v a="$ANCHOR_LOG" '$0==a{p=1} p{print}' "$readme")"

  # The full set of section files (basenames), README.md excluded, sorted.
  local all_tmp; all_tmp="$(mktemp)"
  ( cd "$SECDIR" && ls -1 ./*.md 2>/dev/null | sed 's#^\./##' | grep -vxF 'README.md' ) | LC_ALL=C sort > "$all_tmp"
  local total; total="$(wc -l < "$all_tmp" | tr -d ' ')"

  # The committed source-slug vocabulary (sources/<slug>.md basenames). The
  # grouping prefers the longest of these that prefixes a section filename.
  local -A SRCSLUG=()
  local s
  while IFS= read -r s; do
    s="${s##*/}"; s="${s%.md}"; [ "$s" = README ] && continue
    SRCSLUG["$s"]=1
  done < <(cd "$SRCDIR" && ls -1 ./*.md 2>/dev/null)

  # Single awk pass per file → classification + child lists. Build:
  #   ISIDX[basename]=1            for kind:index parents
  #   CHILDOF[childbasename]=parent (claimed children)
  #   CTITLE[childbasename]=title  (title the parent gave the child)
  #   per-parent ordered child list in $kids_tmp ("parent\tchild")
  local -A ISIDX=() CHILDOF=() CTITLE=()
  local kids_tmp; kids_tmp="$(mktemp)"
  local f line kind rest parent child title
  while IFS= read -r f; do
    while IFS= read -r line; do
      kind="${line%% *}"; rest="${line#* }"
      if [ "$kind" = INDEX ]; then
        ISIDX["$rest"]=1
      else  # CHILD: "parent\tchild\ttitle"
        parent="${rest%%$'\t'*}"; rest="${rest#*$'\t'}"
        child="${rest%%$'\t'*}";  title="${rest#*$'\t'}"
        [ -n "$child" ] || continue
        # First claim wins: a child listed twice by one parent, or claimed by two
        # parents, is rendered exactly once (the index lists every file once).
        [ -n "${CHILDOF[$child]:-}" ] && continue
        CHILDOF["$child"]="$parent"
        CTITLE["$child"]="$title"
        printf '%s\t%s\n' "$parent" "$child" >> "$kids_tmp"
      fi
    done < <(classify_and_children "$SECDIR/$f" "$f")
  done < "$all_tmp"
  local parents children
  parents="${#ISIDX[@]}"
  children=$(( total - parents ))

  # group_slug <stem> — longest committed source-slug prefix of the section
  # filename, else the filename with its last `--<segment>` stripped, else the
  # whole stem (a section file with no `--`, which should not occur).
  group_slug() {
    local cand="$1"
    while [ "$cand" != "${cand%--*}" ]; do
      cand="${cand%--*}"
      [ -n "${SRCSLUG[$cand]:-}" ] && { printf '%s' "$cand"; return; }
    done
    local stem="$1"
    if [ "$stem" != "${stem%--*}" ]; then printf '%s' "${stem%--*}"; else printf '%s' "$stem"; fi
  }

  # Top-level entries = section files not claimed as a child. Emit
  # "<slug>\t<basename>" for each, then sort by slug then filename to bucket.
  local top_tmp; top_tmp="$(mktemp)"
  local bn stem
  while IFS= read -r bn; do
    [ -n "${CHILDOF[$bn]:-}" ] && continue       # a child nests under its parent
    stem="${bn%.md}"
    printf '%s\t%s\n' "$(group_slug "$stem")" "$bn" >> "$top_tmp"
  done < "$all_tmp"
  LC_ALL=C sort -t$'\t' -k1,1 -k2,2 "$top_tmp" -o "$top_tmp"

  # Render the body: walk the sorted top-level list, opening a new `### <slug>`
  # block whenever the slug changes; nest a kind:index entry's children.
  local body_tmp dangling_tmp; body_tmp="$(mktemp)"; dangling_tmp="$(mktemp)"
  local cur="" slug t childbn ctitle
  while IFS=$'\t' read -r slug t; do
    if [ "$slug" != "$cur" ]; then
      [ -n "$cur" ] && printf '\n' >> "$body_tmp"
      printf '### %s\n\n' "$slug" >> "$body_tmp"
      cur="$slug"
    fi
    if [ -n "${ISIDX[$t]:-}" ]; then
      printf -- '- [%s](%s) (index)\n' "${t%.md}" "$t" >> "$body_tmp"
      # children of $t, sorted by child filename
      while IFS=$'\t' read -r childbn; do
        [ -n "$childbn" ] || continue
        if [ ! -f "$SECDIR/$childbn" ]; then
          printf '%s\t%s\n' "$t" "$childbn" >> "$dangling_tmp"; continue
        fi
        ctitle="${CTITLE[$childbn]:-${childbn%.md}}"
        printf -- '  - [%s](%s)\n' "$ctitle" "$childbn" >> "$body_tmp"
      done < <(awk -F'\t' -v p="$t" '$1==p{print $2}' "$kids_tmp" | LC_ALL=C sort)
    else
      printf -- '- [%s](%s)\n' "${t%.md}" "$t" >> "$body_tmp"
    fi
  done < "$top_tmp"
  [ -n "$cur" ] && printf '\n' >> "$body_tmp"

  # Assemble: preamble + count line + body + historical log.
  printf '%s\n' "$preamble"
  printf '\nTotal section files: %s (%s parent indexes + %s children).\n\n' "$total" "$parents" "$children"
  cat "$body_tmp"
  printf '%s\n' "$tail"

  # --- diagnostics (stderr) ---
  local rc=0
  if [ -s "$dangling_tmp" ]; then
    rc=1
    echo "regenerate-sections-index: DANGLING FAIL — $(wc -l < "$dangling_tmp" | tr -d ' ') kind:index child target(s) point at a missing file:" >&2
    sed 's/^/  DANGLING (/; s/\t/) -> /' "$dangling_tmp" >&2
    echo "  Write the missing child file or correct the parent's Sections: row, then re-run." >&2
  fi
  rm -f "$all_tmp" "$kids_tmp" "$top_tmp" "$body_tmp" "$dangling_tmp"
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
    *) echo "regenerate-sections-index: unknown argument: $1" >&2; usage >&2; exit 2 ;;
  esac
done

case "$MODE" in
  print)
    LIB="$(locate_library "$LIBRARY")"
    out="$(generate_auto_index "$LIB")"; rc=$?
    [ "$rc" = 2 ] && exit 2
    printf '%s\n' "$out"
    exit "$rc" ;;

  check)
    LIB="$(locate_library "$LIBRARY")"
    out="$(generate_auto_index "$LIB")"; rc=$?
    [ "$rc" = 2 ] && exit 2
    if diff -q <(printf '%s\n' "$out") "$LIB/sections/README.md" >/dev/null 2>&1; then
      log "sections index is current (regenerator is idempotent)"
      exit "$rc"           # 0 unless a completeness failure was reported
    fi
    log "sections index is STALE — regeneration would change it; run --land."
    diff "$LIB/sections/README.md" <(printf '%s\n' "$out") | grep -cE '^[<>]' \
      | awk '{print "  "$1" changed line(s) between the committed index and a fresh regeneration"}' >&2 || true
    exit 1 ;;

  land)
    # Sync a dedicated clone to tip, regenerate against it, and land via the
    # producer-clone sync+CAS lander. Tip-sync discipline per library-link-scan.sh.
    #
    # COMPOSE-AND-LAND RETRY. Two fleet instances run this timer at the same
    # minute, so the loser reads its BASE_BLOB from a tip the peer then advances
    # with the SAME deterministic projection (`git log`: d5d239a72c landing on
    # 52d8e8b650). land-journal-edit.sh's base-blob guard then refuses (exit 1)
    # — a real refusal, but NOT a genuine divergence: re-sync + re-compose
    # against the new tip, and the next pass normally finds the index already
    # current (the peer landed our projection) and exits 0. Only a conflict that
    # survives every attempt is a real non-idempotent divergence worth exiting
    # non-zero. We never pass --force: a genuine concurrent edit must not be
    # clobbered. The generator's own hard failures (missing library, rc=2 anchor
    # error, an incomplete/dangling index) still `die`/exit and are NOT swallowed
    # by the retry, which triggers only on the lander's conflict exit (rc=1).
    DIR="${GARDEN_SECTIONS_INDEX_CLONE:-$GARDEN_STATE/regenerate-sections-index/journal}"
    ensure_clone "$DIR"
    # Compose $out to a temp file ONCE per pass: reused for the current-check
    # diff and passed to the lander as its <body-file> argument. This kills two
    # SIGPIPEs the old `diff -q <(printf …)` + stdin-pipe pattern logged on every
    # stale/refused run — `diff -q` short-circuits at the first difference (and
    # the lander refuses before draining stdin), leaving `printf` writing into an
    # unread pipe and dying "printf: write error: Broken pipe" above the real
    # error. Cleaned up on exit alongside the generator's internal temps.
    out_tmp="$(mktemp)"
    trap 'rm -f "$out_tmp"' EXIT
    attempts="${GARDEN_SECTIONS_INDEX_LAND_ATTEMPTS:-4}"
    for attempt in $(seq 1 "$attempts"); do
      sync_clone "$DIR"                        # may exit 75 on a transient outage
      LIB="$DIR/library"
      [ -d "$LIB/sections" ] || die "no library/sections in the synced clone at $DIR"
      TIP="$(git -C "$DIR" rev-parse --short HEAD 2>/dev/null || echo '?')"
      generate_auto_index "$LIB" > "$out_tmp"; rc=$?
      [ "$rc" = 2 ] && exit 2                  # setup/anchor error: never retried
      if [ "$rc" -ne 0 ]; then
        die "refusing to land an incomplete index (see COMPLETENESS/DANGLING above); fix the corpus and re-run"
      fi
      if diff -q "$out_tmp" "$LIB/sections/README.md" >/dev/null 2>&1; then
        log "tip $TIP: sections index already current; nothing to land"
        exit 0
      fi
      log "tip $TIP: regenerated sections index differs; landing via land-journal-edit.sh (attempt $attempt/$attempts)"
      BASE_BLOB="$(git -C "$DIR" rev-parse HEAD:library/sections/README.md)"
      # Capture the lander's rc directly (this script runs without `set -e`); a
      # bare `if lander; then exit 0; fi` would report rc=0 for a FAILED lander,
      # since a condition-false `if` with no else succeeds.
      GARDEN_ROLE="${GARDEN_ROLE:-scholar}" "$HERE/land-journal-edit.sh" \
        --base-blob "$BASE_BLOB" library/sections/README.md "$out_tmp"; lrc=$?
      [ "$lrc" -eq 0 ] && exit 0
      # land-journal-edit.sh exit codes: 0 landed (handled above); 1 base-blob
      # conflict OR CAS contention exhausted — a peer advanced the tip, so
      # re-sync + re-compose (the retryable case); 2 usage/path/live-worktree
      # refusal — a hard misconfiguration retrying cannot fix; 75 transient
      # outage. Only rc=1 loops; the rest surface immediately.
      case "$lrc" in
        1)  log "tip $TIP: land refused (conflict/contention, rc=1); re-syncing and re-composing"
            backoff "$attempt" ;;
        2)  exit 2 ;;
        75) exit 75 ;;
        *)  die "land-journal-edit.sh failed unexpectedly (rc=$lrc)" ;;
      esac
    done
    die "sections index still conflicts after $attempts compose-and-land attempts — a genuine non-idempotent divergence; investigate rather than reaching for --force"
    ;;
esac
