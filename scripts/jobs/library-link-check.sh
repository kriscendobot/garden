#!/bin/bash
# library-link-check.sh — deterministic section-link integrity resolver for the
# cross-cutting reference library (`journal/library/`).
#
# Resolving "does this section/source/README link target an existing committed
# file" is pure graph resolution, not a judgment call, so it lives here in plain
# code rather than inside the scholar LLM. Two callers share this one resolver:
#
#   - The POST-INGEST GATE (--changed): a scholar runs this before reporting an
#     ingest complete, scoped to the source clusters the ingest touched. A row
#     that points at a file the ingest never wrote (the 2026-06-27 missing
#     `kind: index` parent: job `ingest-ocap-kernel`, commit 069d42b1) fails the
#     ingest loudly at write time instead of lurking until a future scan.
#   - The STANDING SCAN (--all): a periodic checker syncs the library to the
#     current origin/journal2 tip and validates every link. It CLASSIFIES each
#     dangling link by its source file: a must-resolve navigation/index/
#     source-table link (the same set --nav walks) fails the run; a verbatim
#     leaf-section-body link is ADVISORY — reported as a separate informational
#     count but NOT gating. That keeps the standing red signal actionable instead
#     of saturating on the ~166 upstream-verbatim leaf-body links that dangle
#     every cycle by construction. (Sibling job
#     improve-deterministic-section-link-integrity-scan owns the sync-tip-first
#     wrapper; it calls `library-link-check.sh --all`.)
#
# Axes walked: source/topic/concept/role -> section markdown links, the
# `sections/README.md` backstop rows, AND the source-page/README -> kind:index
# parent axis that the keyword / wikilink / markdown-anchor scans missed. A
# `kind: index` parent section file shares the source-slug basename
# (`sections/<source-slug>.md`); its children are `sections/<source-slug>--*.md`.
#
# Exit: 0 = every checked link resolves (in --all, also when ONLY advisory
#           leaf-section-body links dangle; in --changed, also when ONLY
#           pre-existing danglers remain — links that already dangled at
#           $BASE_REF on rows the change never touched); 1 = at least one dangling
#           target (in --all, a must-resolve navigation/index/source-table link;
#           in --changed, a NEWLY-INTRODUCED dangler absent at $BASE_REF); 2 =
#           usage / setup error.
#
# This script makes NO writes and NO network calls. It is safe to run anywhere.

set -uo pipefail

usage() {
  cat >&2 <<'USAGE'
library-link-check.sh — resolve library section links against the working tree.

Scope (exactly one required):
  --all                    check every markdown link in the whole library, but
                           CLASSIFY each dangling link by its source file: a
                           dangling link on a navigation/index/source-table
                           surface (the --nav set) is MUST-RESOLVE and fails the
                           run; a dangling link in a verbatim leaf section body is
                           ADVISORY — tallied and reported separately, NOT gating.
                           Exit stays 0 unless a must-resolve link dangles.
  --nav                    check only navigation surfaces: concepts/topics/
                           sources/roles index pages, sections/README.md, and the
                           library README.md. Excludes leaf section bodies (which
                           carry verbatim-upstream links). The scope a standing
                           tip-synced scan uses (see library-link-scan.sh).
  --changed [<base-ref>]   GATE mode: check the source clusters touched since
                           <base-ref> (default origin/journal2) plus the working
                           tree. Catches a row pointing at a file the change
                           never wrote (the missing-parent-index defect). A
                           dangling link that ALREADY dangled at <base-ref> (a
                           pre-existing dangler on a shared-index row this change
                           never touched) is reported [pre-existing] and does NOT
                           fail the gate; exit fires only on NEWLY-INTRODUCED
                           danglers. Falls back to whole-file gating when
                           <base-ref> is unavailable.
  --source-slug <slug>     check one source cluster: sources/<slug>.md, the
                           kind:index parent sections/<slug>.md, that source's
                           sections/README.md block, and all children.
  --files <file>...        check the markdown links in the named library files
                           (paths relative to --library, or absolute).

Options:
  --library <dir>          library root. Default: $GARDEN_GARDENER_CLONE/library,
                           else $GARDEN_ROOT/journal/library, else ./library.
  --wikilinks              also resolve [[concept]] wikilinks to concepts/<slug>.md.
  --no-require-tracked     accept an on-disk but git-untracked target. Default is
                           to treat untracked (would-not-be-committed) as dangling.
  --quiet                  print only the dangling summary, not per-link OK lines.
  -h, --help               this help.
USAGE
}

# --- argument parse ----------------------------------------------------------
SCOPE=""
BASE_REF="origin/journal2"
SOURCE_SLUG=""
LIBRARY=""
WIKILINKS=0
REQUIRE_TRACKED=1
QUIET=0
declare -a FILES_ARG=()

while [ $# -gt 0 ]; do
  case "$1" in
    --all) SCOPE="all"; shift ;;
    --nav) SCOPE="nav"; shift ;;
    --changed)
      SCOPE="changed"; shift
      if [ $# -gt 0 ] && [ "${1#--}" = "$1" ]; then BASE_REF="$1"; shift; fi
      ;;
    --source-slug) SCOPE="source-slug"; SOURCE_SLUG="${2:?--source-slug needs a slug}"; shift 2 ;;
    --files)
      SCOPE="files"; shift
      while [ $# -gt 0 ] && [ "${1#--}" = "$1" ]; do FILES_ARG+=("$1"); shift; done
      ;;
    --library) LIBRARY="${2:?--library needs a dir}"; shift 2 ;;
    --wikilinks) WIKILINKS=1; shift ;;
    --no-require-tracked) REQUIRE_TRACKED=0; shift ;;
    --quiet) QUIET=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "library-link-check: unknown argument: $1" >&2; usage; exit 2 ;;
  esac
done

[ -n "$SCOPE" ] || { echo "library-link-check: a scope is required" >&2; usage; exit 2; }

# --- locate the library root -------------------------------------------------
if [ -z "$LIBRARY" ]; then
  if [ -n "${GARDEN_GARDENER_CLONE:-}" ] && [ -d "${GARDEN_GARDENER_CLONE}/library" ]; then
    LIBRARY="${GARDEN_GARDENER_CLONE}/library"
  elif [ -n "${GARDEN_ROOT:-}" ] && [ -d "${GARDEN_ROOT}/journal/library" ]; then
    LIBRARY="${GARDEN_ROOT}/journal/library"
  elif [ -d "./library" ]; then
    LIBRARY="./library"
  else
    echo "library-link-check: cannot locate the library; pass --library <dir>" >&2
    exit 2
  fi
fi
LIBRARY="$(cd "$LIBRARY" 2>/dev/null && pwd)" || { echo "library-link-check: no such library dir" >&2; exit 2; }
[ -d "$LIBRARY/sections" ] || { echo "library-link-check: $LIBRARY has no sections/ — not a library root" >&2; exit 2; }

# Git toplevel for tracked-ness checks and the --changed diff. Tolerate a
# non-git library (tests, ad-hoc copies): tracked-ness checks degrade to
# on-disk-existence with a one-line warning.
GIT_ROOT="$(git -C "$LIBRARY" rev-parse --show-toplevel 2>/dev/null || true)"
if [ -z "$GIT_ROOT" ] && [ "$REQUIRE_TRACKED" = 1 ]; then
  echo "library-link-check: $LIBRARY is not in a git repo; --require-tracked degraded to on-disk existence" >&2
  REQUIRE_TRACKED=0
fi

# Library path relative to the git toplevel — used to scope the --changed diff
# and, in the --changed pre-existing-dangler test, to reconstruct a target/
# referrer's path at $BASE_REF. Empty when the library is not in a git repo.
libpfx=""
[ -n "$GIT_ROOT" ] && libpfx="$(realpath --relative-to="$GIT_ROOT" "$LIBRARY" 2>/dev/null || true)"

# --changed baseline availability. When a dangling link is found under --changed,
# we test whether the SAME referrer->target link already dangled at $BASE_REF; if
# so it is a PRE-EXISTING dangler on a row this change never touched (every ingest
# appends rows to shared index files like sources/README.md, so whole-file
# checking re-surfaces long-lived danglers the scholar did not introduce), and it
# is reported advisory rather than gating. That test needs $BASE_REF resolvable;
# when it is not (shallow clone, unknown ref) we cannot separate pre-existing from
# newly-introduced, so we preserve today's whole-file behavior and gate on every
# dangler.
BASE_AVAILABLE=0
if [ "$SCOPE" = changed ] && [ -n "$GIT_ROOT" ] \
   && git -C "$GIT_ROOT" rev-parse --verify --quiet "$BASE_REF" >/dev/null 2>&1; then
  BASE_AVAILABLE=1
fi

# --- whole-library staleness guard (--all / --nav only) ----------------------
# The validating whole-library scopes are meaningful only against the
# origin/journal2 tip. The default --library resolver can land on the long-lived,
# arbitrarily-stale live worktree ($GARDEN_ROOT/journal/library); a scan there
# that is merely BEHIND the tip emits phantom must-resolve FAILs for files the
# stale worktree simply has not pulled yet (the 2026-06-27 scholar incident:
# "FAIL — 12 must-resolve dangling links" only because the worktree lacked commit
# 9840fa1db, the endoclaw fix). Refuse to run a validating scan against a behind
# worktree and name library-link-scan.sh — the wrapper that fetch+resets a
# dedicated clone to tip — as the correct tool. This is a NO-NETWORK check: it
# compares HEAD only against the ALREADY-FETCHED local origin/journal2 ref, so the
# "NO writes and NO network calls" invariant holds. --changed/--source-slug/--files
# run against the producer's own fresh clone or are explicitly scoped, so they are
# left unaffected.
if { [ "$SCOPE" = all ] || [ "$SCOPE" = nav ]; } && [ -n "$GIT_ROOT" ]; then
  if git -C "$GIT_ROOT" rev-parse --verify --quiet origin/journal2 >/dev/null 2>&1; then
    if ! git -C "$GIT_ROOT" merge-base --is-ancestor origin/journal2 HEAD 2>/dev/null; then
      head_sha="$(git -C "$GIT_ROOT" rev-parse --short HEAD 2>/dev/null)"
      tip_sha="$(git -C "$GIT_ROOT" rev-parse --short origin/journal2 2>/dev/null)"
      echo "library-link-check: SETUP ERROR — a --$SCOPE validating scan was pointed at a STALE worktree" >&2
      echo "  $GIT_ROOT" >&2
      echo "  (HEAD $head_sha is behind local origin/journal2 $tip_sha). A whole-library scan there" >&2
      echo "  produces phantom must-resolve FAILs for files the tip has but this worktree lacks." >&2
      echo "  Run library-link-scan.sh instead — it fetch+resets a dedicated clone to the tip before" >&2
      echo "  scanning. Do not point --library at the long-lived live worktree for --all/--nav." >&2
      exit 2
    fi
  fi
fi

# --- tracked-file cache (one git call, not one per target) -------------------
# A set of library-relative paths that git tracks or has staged for add.
declare -A TRACKED=()
if [ "$REQUIRE_TRACKED" = 1 ]; then
  while IFS= read -r rel; do
    [ -n "$rel" ] && TRACKED["$rel"]=1
  done < <(git -C "$GIT_ROOT" ls-files -- "$LIBRARY" 2>/dev/null \
             | sed "s#^$(realpath --relative-to="$GIT_ROOT" "$LIBRARY")/##")
fi

# is_committed <abs-path> -> 0 if the target resolves to a committed/staged file.
is_committed() {
  local abs="$1"
  [ -f "$abs" ] || return 1
  if [ "$REQUIRE_TRACKED" = 1 ]; then
    local rel; rel="$(realpath --relative-to="$LIBRARY" "$abs" 2>/dev/null)"
    [ -n "${TRACKED[$rel]:-}" ] && return 0
    # Staged additions not yet in the cached ls-files snapshot: ask git directly.
    git -C "$GIT_ROOT" ls-files --error-unmatch -- "$abs" >/dev/null 2>&1 && return 0
    return 2   # exists on disk but untracked -> would not be committed/pushed
  fi
  return 0
}

# --- link extraction ---------------------------------------------------------
# Emit one target path per line for every markdown link in <file> whose target
# is a relative *.md path (skipping URLs, mailto, pure anchors). With --wikilinks,
# also emit concepts/<slug>.md for each [[wikilink]].
#
# Two link shapes are NOT navigation and are filtered out before extraction, so a
# quotation is never mistaken for a live link (the residual false-positive class a
# whole-library scan hits in scholar-authored prose):
#   * a link inside an inline-code span (`[a](b.md)` quoted in backticks) — these
#     appear in source-page abstracts that quote an upstream link snippet.
#   * a link on a markdown heading line (^#{1,6} ) — the auto-generated
#     sections/README.md embeds quoted upstream links inside its `### From <src>
#     (...narrative...)` section-abstract headings. Headings are titles.
# Both are removed by an awk pre-pass: drop heading lines, blank inline-code spans.
extract_targets() {
  local file="$1"
  local cleaned
  cleaned="$(awk '
    /^[ \t]*#{1,6}[ \t]/ { next }      # drop heading lines (narrative titles)
    { gsub(/`[^`]*`/, ""); print }     # blank inline-code spans (quoted links)
  ' "$file" 2>/dev/null)"
  # Inline markdown links: ](target) where target is a relative .md (with
  # optional #anchor). grep -oP keeps the captured group only.
  printf '%s\n' "$cleaned" \
    | grep -oP '\]\(\K[^)]+(?=\))' 2>/dev/null \
    | sed 's/#.*$//' \
    | grep -E '\.md$' \
    | grep -Ev '://|^mailto:' || true
  if [ "$WIKILINKS" = 1 ]; then
    printf '%s\n' "$cleaned" \
      | grep -oP '\[\[\K[^]]+(?=\]\])' 2>/dev/null \
      | sed 's/|.*$//; s/#.*$//' \
      | sed 's#^#concepts/#; s#$#.md#' || true
  fi
}

# --- the dangling accumulator ------------------------------------------------
DANGLING=0               # newly-introduced dangling (gates every non-all scope)
MUST_DANGLING=0          # --all: dangling on a must-resolve (navigation) surface
ADVISORY_DANGLING=0      # --all: dangling in a verbatim leaf section body
CHANGED_ADVISORY=0       # --changed: pre-existing dangler (already dangled at base)
declare -A REPORTED=()   # dedupe (referrer -> target) pairs

# is_nav_file <abs-path> -> 0 if the file is a MUST-RESOLVE navigation surface
# (exactly the set --nav walks): the scholar-authored concepts/topics/sources/
# roles index pages, the sections/README.md backstop, and the library README.md.
# Everything else is ADVISORY — the leaf section bodies sections/<slug>--*.md
# (which carry verbatim-upstream links the library does not own) and the
# kind:index parents sections/<slug>.md (whose every child is redundantly listed
# by its source page and the sections/README.md block, both must-resolve, so a
# genuinely-missing child is still caught on a gating surface).
is_nav_file() {
  local rel; rel="$(realpath --relative-to="$LIBRARY" "$1" 2>/dev/null || echo "$1")"
  case "$rel" in
    concepts/*|topics/*|sources/*|roles/*) return 0 ;;
    sections/README.md|README.md)          return 0 ;;
    *)                                      return 1 ;;
  esac
}

# link_preexisting_dangler <referrer_rel> <target> <abs>
# --changed only. Return 0 iff the SAME referrer->target link ALREADY existed and
# dangled at $BASE_REF — a pre-existing dangler on a row this change never touched,
# to be reported advisory rather than gating. Return non-zero (gate on it) when the
# link is newly introduced: the referrer did not exist at base, the referrer did
# not carry this exact link at base, or the target DID resolve to a committed file
# at base (so a now-broken link is breakage this change introduced). Pure git
# object reads against the already-present $BASE_REF; no network.
link_preexisting_dangler() {
  local referrer_rel="$1" target="$2" abs="$3"
  [ "$BASE_AVAILABLE" = 1 ] || return 1
  # Reconstruct the referrer's path at base and read its base content. A referrer
  # absent at base (or one whose rel path escapes the library, e.g. a mktemp block
  # whose logical referrer was not supplied) makes the link newly-introduced.
  case "$referrer_rel" in ../*|/*) return 1 ;; esac
  local base_content
  base_content="$(git -C "$GIT_ROOT" show "$BASE_REF:$libpfx/$referrer_rel" 2>/dev/null)" || return 1
  # Did the referrer carry this exact link target at base? Extract with the same
  # normalization used on the current file so the target strings are comparable.
  local btmp; btmp="$(mktemp)"; printf '%s\n' "$base_content" > "$btmp"
  local had_link=1
  extract_targets "$btmp" | grep -Fxq -- "$target" && had_link=0
  rm -f "$btmp"
  [ "$had_link" = 0 ] || return 1
  # Did the target resolve to a committed file at base? If it existed at base and
  # is gone now, the change removed it — newly-introduced breakage, gate on it.
  local tgt_rel; tgt_rel="$(realpath --relative-to="$LIBRARY" "$abs" 2>/dev/null)" || return 1
  case "$tgt_rel" in ../*|/*) return 1 ;; esac
  git -C "$GIT_ROOT" cat-file -e "$BASE_REF:$libpfx/$tgt_rel" 2>/dev/null && return 1
  return 0   # link present at base AND target absent at base -> pre-existing dangler
}

# check_links_in <file> [<link-base-dir>] [<logical-referrer-rel>]
# Resolve every link in <file>. Wikilink targets resolve relative to LIBRARY;
# markdown targets resolve relative to <link-base-dir> (the file's own dir). The
# optional <logical-referrer-rel> is the library-relative path to report and to
# use for the --changed base-ref lookup when <file> is a synthesized scratch file
# (e.g. a sections/README.md block written to a mktemp), so the base test can find
# the real referrer's history instead of the temp path.
check_links_in() {
  local file="$1" base_dir="${2:-}" logical_ref="${3:-}"
  [ -f "$file" ] || return 0
  [ -n "$base_dir" ] || base_dir="$(dirname "$file")"
  local rel_referrer
  if [ -n "$logical_ref" ]; then
    rel_referrer="$logical_ref"
  else
    rel_referrer="$(realpath --relative-to="$LIBRARY" "$file" 2>/dev/null || echo "$file")"
  fi
  local target abs status key
  while IFS= read -r target; do
    [ -n "$target" ] || continue
    case "$target" in
      concepts/*) abs="$(realpath -m "$LIBRARY/$target" 2>/dev/null)" ;;   # wikilink
      *)          abs="$(realpath -m "$base_dir/$target" 2>/dev/null)" ;;  # markdown link
    esac
    # A target that resolves OUTSIDE the library root is out of scope, not
    # dangling: the resolver validates intra-library links, and a cross-tree
    # pointer (`../../../skills/foo/SKILL.md` into the garden's main2 tree) is not
    # the library's to judge. Skipping it is what keeps a navigation-surface scan
    # from flagging legitimate cross-tree references.
    case "$abs" in
      "$LIBRARY"|"$LIBRARY"/*) ;;
      *) [ "$QUIET" = 1 ] || echo "  skip     $rel_referrer -> $target (outside library; not validated)"; continue ;;
    esac
    key="$rel_referrer|$target"
    [ -n "${REPORTED[$key]:-}" ] && continue
    is_committed "$abs"; status=$?
    if [ "$status" = 0 ]; then
      [ "$QUIET" = 1 ] || echo "  ok       $rel_referrer -> $target"
    else
      REPORTED["$key"]=1
      # In --changed, a dangling link that already existed and dangled at
      # $BASE_REF is a PRE-EXISTING dangler on a row this change never touched
      # (shared index files accrue a row every ingest, so whole-file checking
      # re-surfaces long-lived danglers). Classify it advisory: report it, but do
      # NOT add to the gating DANGLING count. Gate only on danglers absent at base.
      local cls_suffix=""
      if [ "$SCOPE" = changed ] && link_preexisting_dangler "$rel_referrer" "$target" "$abs"; then
        CHANGED_ADVISORY=$((CHANGED_ADVISORY + 1)); cls_suffix=" [pre-existing]"
      else
        DANGLING=$((DANGLING + 1))
      fi
      # In --all, classify the SOURCE file so the verdict can gate on the
      # must-resolve set only and report advisory leaf-body links separately.
      if [ "$SCOPE" = all ]; then
        if is_nav_file "$file"; then
          MUST_DANGLING=$((MUST_DANGLING + 1)); cls_suffix=" [must-resolve]"
        else
          ADVISORY_DANGLING=$((ADVISORY_DANGLING + 1)); cls_suffix=" [advisory]"
        fi
      fi
      # "did you mean" hint: a dangling <name>.md link whose basename does not
      # resolve as a sibling-section file but whose source page sources/<name>.md
      # DOES resolve to a committed file is almost certainly a source-page target
      # mis-written as a sibling section (the 2026-06-28 KernelQueue.ts parent-index
      # footgun: a See-also linked `<slug>.md` as a sibling when the real target was
      # the source page). Pure graph resolution off TRACKED + LIBRARY, so it belongs
      # here in code. The src_cand != abs guard avoids suggesting a link back to
      # itself when the referrer already (correctly-shaped but dangling) points at
      # ../sources/<name>.md.
      local hint="" tgt_base src_cand
      tgt_base="$(basename "$target")"
      src_cand="$(realpath -m "$LIBRARY/sources/$tgt_base" 2>/dev/null)"
      if [ "$src_cand" != "$abs" ] && is_committed "$src_cand"; then
        hint=" — did you mean ../sources/$tgt_base?"
      fi
      if [ "$status" = 2 ]; then
        echo "  DANGLING $rel_referrer -> $target$cls_suffix (exists on disk but git-untracked; would not be committed)$hint"
      else
        echo "  DANGLING $rel_referrer -> $target$cls_suffix (no such committed file)$hint"
      fi
    fi
  done < <(extract_targets "$file")
}

# --- README block extraction -------------------------------------------------
# Print the sections/README.md block under "### <slug>" up to the next "### " or
# "## " header. The block carries the (index) parent row and the child rows.
readme_block() {
  local slug="$1" readme="$LIBRARY/sections/README.md"
  [ -f "$readme" ] || return 0
  awk -v slug="$slug" '
    $0 == "### " slug { inblk=1; print; next }
    inblk && /^#### / { print; next }
    inblk && /^### / { exit }
    inblk && /^## / { exit }
    inblk { print }
  ' "$readme"
}

# check_source_cluster <slug>
# Validate the full cluster for one source: the source page, the kind:index
# parent, that source's README block, and every changed child's own links. The
# README block is the axis that catches an omitted parent index.
check_source_cluster() {
  local slug="$1"
  local src="$LIBRARY/sources/$slug.md"
  local parent="$LIBRARY/sections/$slug.md"
  [ "$QUIET" = 1 ] || echo "cluster: $slug"
  # Source page -> children.
  check_links_in "$src"
  # kind:index parent -> children (its absence is caught via the README block).
  check_links_in "$parent"
  # README block -> parent + children. Links resolve relative to sections/.
  local blk; blk="$(readme_block "$slug")"
  if [ -n "$blk" ]; then
    local tmp; tmp="$(mktemp)"
    printf '%s\n' "$blk" > "$tmp"
    # The block is a scratch slice of sections/README.md; pass that as the logical
    # referrer so reporting and the --changed base-ref test key off the real file.
    check_links_in "$tmp" "$LIBRARY/sections" "sections/README.md"
    rm -f "$tmp"
  fi
}

# --- map a changed library file to its owning source-slug --------------------
# A source page maps to its own basename. A section file maps to the source page
# that links to it (unambiguous: every section file is listed by exactly one
# source page). Source-slugs themselves contain "--", so never split on it.
slug_for_file() {
  local f="$1" base
  base="$(basename "$f")"
  case "$f" in
    */sources/*) echo "${base%.md}"; return 0 ;;
  esac
  case "$f" in
    */sections/*)
      # Find the source page that references this section file.
      local owner
      owner="$(grep -ilE "\\]\\(\\.\\./sections/${base//./\\.}\\)" "$LIBRARY"/sources/*.md 2>/dev/null | head -n1)"
      if [ -n "$owner" ]; then basename "$owner" .md; return 0; fi
      # A kind:index parent (sections/<slug>.md) is itself named for the slug.
      echo "${base%.md}"; return 0
      ;;
  esac
  return 1
}

# --- build the file/cluster work list per scope ------------------------------
case "$SCOPE" in
  all)
    [ "$QUIET" = 1 ] || echo "scope: --all ($LIBRARY)"
    while IFS= read -r f; do check_links_in "$f"; done \
      < <(find "$LIBRARY" -type f -name '*.md' | sort)
    ;;

  nav)
    # Navigation surfaces only: the scholar-AUTHORED index pages (concepts,
    # topics, sources, roles), the sections/README.md backstop, and the library
    # root README.md. Leaf section bodies under sections/<source>--<section>.md
    # are link TARGETS, not navigation SOURCES — they carry verbatim-upstream
    # relative links that are not the library's to resolve, so they are excluded.
    # This is the scope a standing tip-synced scan wants: it isolates the
    # genuinely-dangling navigation links the keyword/wikilink scans missed.
    [ "$QUIET" = 1 ] || echo "scope: --nav ($LIBRARY)"
    while IFS= read -r f; do check_links_in "$f"; done < <(
      {
        find "$LIBRARY/concepts" "$LIBRARY/topics" "$LIBRARY/sources" "$LIBRARY/roles" \
             -type f -name '*.md' 2>/dev/null
        [ -f "$LIBRARY/sections/README.md" ] && echo "$LIBRARY/sections/README.md"
        [ -f "$LIBRARY/README.md" ]          && echo "$LIBRARY/README.md"
      } | sort
    )
    ;;

  source-slug)
    [ "$QUIET" = 1 ] || echo "scope: --source-slug $SOURCE_SLUG"
    check_source_cluster "$SOURCE_SLUG"
    ;;

  files)
    [ "${#FILES_ARG[@]}" -gt 0 ] || { echo "library-link-check: --files needs at least one file" >&2; exit 2; }
    [ "$QUIET" = 1 ] || echo "scope: --files (${#FILES_ARG[@]})"
    for f in "${FILES_ARG[@]}"; do
      case "$f" in /*) : ;; *) f="$LIBRARY/$f" ;; esac
      check_links_in "$f"
    done
    ;;

  changed)
    if [ -z "$GIT_ROOT" ]; then
      echo "library-link-check: --changed needs a git library; pass --library a git worktree" >&2
      exit 2
    fi
    [ "$QUIET" = 1 ] || echo "scope: --changed since $BASE_REF ($LIBRARY)"
    # Union of: committed-since-base, staged, unstaged, and untracked — under library/.
    # (libpfx is computed once up front, near the git-root setup.)
    declare -A SLUGS=()
    while IFS= read -r rel; do
      [ -n "$rel" ] || continue
      case "$rel" in *.md) : ;; *) continue ;; esac
      abs="$GIT_ROOT/$rel"
      s="$(slug_for_file "$abs")" || continue
      [ -n "$s" ] && SLUGS["$s"]=1
    done < <(
      {
        git -C "$GIT_ROOT" diff --name-only "$BASE_REF" -- "$libpfx" 2>/dev/null
        git -C "$GIT_ROOT" diff --name-only -- "$libpfx" 2>/dev/null
        git -C "$GIT_ROOT" diff --name-only --cached -- "$libpfx" 2>/dev/null
        git -C "$GIT_ROOT" ls-files --others --exclude-standard -- "$libpfx" 2>/dev/null
      } | sort -u
    )
    if [ "${#SLUGS[@]}" = 0 ]; then
      [ "$QUIET" = 1 ] || echo "  (no changed library source/section files since $BASE_REF)"
    fi
    for s in "${!SLUGS[@]}"; do check_source_cluster "$s"; done
    ;;
esac

# --- verdict -----------------------------------------------------------------
echo "----------------------------------------------------------------"
if [ "$SCOPE" = all ]; then
  # Classified verdict: gate ONLY on the must-resolve navigation/index/source-table
  # set; report the advisory leaf-section-body danglers as a separate informational
  # count. This is what keeps the standing --all scan's red signal actionable — it
  # goes red for genuine navigation breakage, not for the ~166 upstream-verbatim
  # leaf-body links that dangle every cycle by construction.
  if [ "$ADVISORY_DANGLING" -gt 0 ]; then
    echo "library-link-check: advisory — $ADVISORY_DANGLING dangling link(s) in verbatim"
    echo "leaf section bodies (upstream-verbatim; not the library's to resolve). Informational"
    echo "only; these do not affect the exit status."
  fi
  if [ "$MUST_DANGLING" -gt 0 ]; then
    echo "library-link-check: FAIL — $MUST_DANGLING must-resolve dangling link(s) on"
    echo "navigation/index/source-table surfaces; see the [must-resolve] DANGLING lines above."
    echo "Write the missing target file (commonly an omitted kind:index parent), or correct"
    echo "the navigation/index/source-table row, then re-run."
    exit 1
  fi
  if [ "$ADVISORY_DANGLING" -gt 0 ]; then
    echo "library-link-check: OK — every must-resolve navigation/index/source-table link resolves."
  else
    echo "library-link-check: OK — every checked link resolves to a committed file."
  fi
  exit 0
fi

if [ "$SCOPE" = changed ] && [ "$CHANGED_ADVISORY" -gt 0 ]; then
  echo "library-link-check: advisory — $CHANGED_ADVISORY pre-existing dangling link(s) that already"
  echo "dangled at $BASE_REF, on rows this change did not touch (shared index files accrue a row every"
  echo "ingest). Reported above with [pre-existing]; informational only, they do not affect exit status."
fi
if [ "$DANGLING" -gt 0 ]; then
  echo "library-link-check: FAIL — $DANGLING dangling link(s); see DANGLING lines above."
  echo "An ingest with a dangling section-table / README (index) row must not be"
  echo "reported complete: write the missing target file (commonly an omitted"
  echo "kind:index parent), or correct the row, then re-run."
  exit 1
fi
if [ "$SCOPE" = changed ] && [ "$CHANGED_ADVISORY" -gt 0 ]; then
  echo "library-link-check: OK — every newly-introduced link resolves to a committed file"
  echo "(pre-existing danglers reported above are advisory only)."
else
  echo "library-link-check: OK — every checked link resolves to a committed file."
fi
exit 0
