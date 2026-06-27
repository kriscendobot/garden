#!/bin/bash
# library-link-scan.sh — the standing, tip-synced section-link-integrity scan.
#
# This is the thin SYNC wrapper around the shared resolver library-link-check.sh.
# The resolver is pure graph resolution ("does this link target a committed
# file"); it makes no network calls and is safe to run anywhere. This wrapper
# adds the one thing a STANDING scan needs and an in-context LLM scan kept getting
# wrong: it resolves against the CURRENT shared tip, never a stale snapshot.
#
# WHY IT EXISTS. On 2026-06-27 the section-link scan ran inside the scholar LLM on
# an empty-inbox cycle, off an origin/journal2 snapshot ~80 commits behind the
# peer-advanced tip. Section files a peer had ALREADY committed read as "missing",
# so the scan manufactured three false-positive "dangling" links and the agent
# made two wrong repoint edits that had to be reverted
# (`090317Z-result-scholar-99178f92.md` § "Stale-data false positives").
#
# THE TWO LESSONS, ENCODED HERE IN CODE (not re-taught in roles/scholar/AGENT.md
# or skills/library-lookup/SKILL.md):
#
#   1. SYNC THE TIP FIRST. Every run fetch+hard-resets a dedicated read-only clone
#      to the current origin/journal2 tip BEFORE resolving a single link
#      (ensure_clone + sync_clone). No scan ever runs off an in-context-stale
#      snapshot, and the live journal worktree (full of a peer's uncommitted WIP)
#      is never touched: we resolve against the shared, committed tip, which is
#      exactly what "an existing committed file" means.
#
#   2. RE-VERIFY EACH TARGET AT THE MOMENT OF EDIT. Because this wrapper always
#      syncs-tip-first, RE-RUNNING it after a batch of repairs re-verifies against
#      the LATEST tip and catches any peer advance that happened mid-repair.
#      Before committing a single repoint, confirm the new target exists at the
#      current tip with `--exists <library-relative-path>`. The discipline lives
#      in the tool, so it cannot be forgotten.
#
# WHAT IT WALKS. It delegates to `library-link-check.sh --nav`, which resolves
# every link on the scholar-authored navigation surfaces — source/topic/concept/
# role index pages, the sections/README.md backstop, AND the source/README ->
# parent-index axis the keyword/wikilink scans missed — and excludes leaf section
# bodies, inline-code-span quotations, and heading-line narrative (so the output
# is genuinely-dangling links, not upstream-verbatim noise).
#
# USAGE
#   library-link-scan.sh                  sync tip, scan navigation surfaces, emit
#                                         the genuinely-dangling links for repair.
#   library-link-scan.sh --all            sync tip, scan EVERY library link
#                                         (noisier: includes leaf-body upstream
#                                         links). Default is --nav.
#   library-link-scan.sh --exists <path>  sync tip, report whether one library
#                                         path exists at the committed tip; the
#                                         re-verify-before-you-repoint primitive.
#                                         <path> is relative to library/ (a
#                                         leading `library/` is accepted).
#   library-link-scan.sh -- <args...>     sync tip, then pass <args> straight to
#                                         library-link-check.sh against the synced
#                                         clone (escape hatch for --source-slug
#                                         etc.).
#   library-link-scan.sh -h | --help
#
# EXIT CODES
#   0  clean scan (no dangling links) / `--exists` target present
#   1  dangling links found / `--exists` target absent
#   2  usage / setup error
#   75 EX_TEMPFAIL: transient connectivity outage during the tip sync (from
#      sync_clone); caller skips this tick and retries next cadence.
#
# STATE. A dedicated read-only journal clone at $GARDEN_LIBCHECK_CLONE (default
# $GARDEN_STATE/library-link-check/journal), kept OUTSIDE any reset-prone worktree.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="library-link-scan"

CORE="$HERE/library-link-check.sh"
[ -x "$CORE" ] || die "shared resolver not found/executable: $CORE"

DIR="${GARDEN_LIBCHECK_CLONE:-$GARDEN_STATE/library-link-check/journal}"

# sync the dedicated clone to the current origin/journal2 tip (may exit 75).
sync_tip() {
  ensure_clone "$DIR"
  sync_clone "$DIR"
  LIB="$DIR/library"
  [ -d "$LIB" ] || die "no library/ in the synced clone at $DIR (tip has no library tree?)"
  TIP="$(git -C "$DIR" rev-parse --short HEAD 2>/dev/null || echo '?')"
}

case "${1:-}" in
  -h|--help)
    awk 'NR>1 && /^#/{sub(/^# ?/,"");print;next} NR>1{exit}' "$0"
    exit 0 ;;

  --exists)
    want="${2:-}"
    case "$want" in -*|'') die "usage: library-link-scan.sh --exists <library-relative-path>";; esac
    sync_tip
    want="${want#library/}"
    if [ -e "$LIB/$want" ]; then
      log "tip $TIP: library/$want EXISTS"
      exit 0
    fi
    log "tip $TIP: library/$want MISSING"
    exit 1 ;;

  --)
    shift
    sync_tip
    log "scanning at origin/$JOURNAL_BRANCH tip $TIP (passthrough: $*)"
    exec "$CORE" "$@" --library "$LIB" ;;

  --all)
    sync_tip
    log "scanning ALL library links at origin/$JOURNAL_BRANCH tip $TIP ..."
    # --quiet: a standing scan emits ONLY the genuinely-dangling links (+ summary),
    # not a per-link OK line for every one of the library's ~10k resolved links.
    exec "$CORE" --all --library "$LIB" --quiet ;;

  ''|--nav)
    sync_tip
    log "scanning navigation surfaces at origin/$JOURNAL_BRANCH tip $TIP ..."
    exec "$CORE" --nav --library "$LIB" --quiet ;;

  *)
    die "unknown argument '$1' (try --help)" ;;
esac
