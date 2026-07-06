#!/bin/bash
# scholar-staging-clone.sh — provision a scholar's (or any library-writeback
# role's) staging area as an ISOLATED, FRESH, commit-capable clone of the real
# origin/journal2 tip, and print its path. The sanctioned answer to "which tree
# do I stage my multi-file library/project edit in?" — the read/stage-side
# complement to land-journal-edit.sh's write-side discipline.
#
# WHY THIS EXISTS. On 2026-07-06 (result 122730Z-result-gardener-24c28b) a scholar
# based its staging clone on the DEPLOYED $GARDEN_ROOT/journal worktree's *local*
# journal2 branch, which lags the real origin/journal2. Cycle-2's already-landed
# index rows therefore looked unwritten and triggered a false "indexes unwritten"
# investigation. That same hand-rolled staging clone had NO git identity, so the
# in-clone commit failed until the garden bot identity was copied in by hand. This
# is the second occurrence of the "stage against a stale/wrong tree" class; the
# first (2026-06-27) is already memorialized in land-journal-edit.sh, which fixed
# only the LAND side. This script fixes the STAGE side the same way: pure script
# discipline, not a per-cycle judgment call.
#
# WHAT IT DOES. Given a destination dir (positional arg, else $GARDEN_SCHOLAR_
# STAGING_CLONE, else $GARDEN_STATE/scholar-staging/journal), it:
#   1. refuses to operate on the live $GARDEN_ROOT/journal read worktree (the same
#      read/land-side guarantee land-journal-edit.sh enforces): staging there
#      dirties the tree the journal-worktree-keeper must keep clean AND stages
#      against the stale local branch — exactly the hazard this removes;
#   2. ensure_clone: clone (or reuse) a single-branch journal2 clone at the dest
#      and seed user.name/user.email from the garden bot config (common.sh:1159),
#      so the in-clone commit can never fail for want of an identity;
#   3. sync_clone: fetch + hard-reset to the CURRENT origin/journal2 tip, so the
#      staging tree is fresh — never the deployed worktree's lagging branch.
# It then prints the ready staging path on stdout and exits 0. Author your
# section/source/topic files under that path, then land each through
# land-journal-edit.sh.
#
# USAGE
#   scholar-staging-clone.sh [<dest-dir>]
#   scholar-staging-clone.sh -h | --help
#
# Examples
#   staging="$(scholar-staging-clone.sh)"          # default staging path
#   staging="$(scholar-staging-clone.sh /tmp/x)"   # explicit path
#
# EXIT CODES
#   0  the staging clone is ready and fresh; its path is on stdout
#   2  usage error / live-worktree refusal
#   75 EX_TEMPFAIL: transient connectivity outage during the tip sync (from
#      sync_clone) — caller skips this tick and retries next cadence
#
# CONFIG (overridable; tests point these at a throwaway journal)
#   GARDEN_SCHOLAR_STAGING_CLONE   the staging clone path (default:
#                                  $GARDEN_STATE/scholar-staging/journal)

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="scholar-staging-clone"

require_tools git

# Usage / live-worktree refusals exit 2, kept distinct from die's generic exit 1.
refuse() { log "FATAL: $*"; exit 2; }

usage() {
  awk 'NR>1 && /^#/{sub(/^# ?/,"");print;next} NR>1{exit}' "$0"
}

case "${1:-}" in
  -h|--help) usage; exit 0 ;;
esac

DIR="${1:-${GARDEN_SCHOLAR_STAGING_CLONE:-$GARDEN_STATE/scholar-staging/journal}}"

# --- live-worktree refusal (mirror land-journal-edit.sh) --------------------
# Staging in the deployed $GARDEN_ROOT/journal read worktree is the exact hazard
# this script removes: it dirties the tree the journal-worktree-keeper must keep
# clean AND stages against that worktree's STALE local journal2 branch. Refuse it
# even if an operator points the dest there.
live_abs="$(cd "$GARDEN_ROOT/journal" 2>/dev/null && pwd || printf '%s' "$GARDEN_ROOT/journal")"
dir_abs="$(cd "$DIR" 2>/dev/null && pwd || printf '%s' "$DIR")"
[ "$dir_abs" = "$live_abs" ] && refuse "refusing to stage in the live worktree ($live_abs); stage in an isolated clone that tracks origin/$JOURNAL_BRANCH, not the deployed read worktree's branch"

ensure_clone "$DIR"    # clone/reuse + seed bot identity (commit-capable)
sync_clone "$DIR"      # fetch + hard-reset to origin/journal2 tip (may exit 75)

# Re-resolve the absolute path now that the clone exists (a relative or not-yet-
# created dest could not resolve before ensure_clone), so the emitted path is
# always absolute and directly usable by the caller.
ready_abs="$(cd "$DIR" && pwd)"
log "staging clone ready at $ready_abs (origin/$JOURNAL_BRANCH tip)"
# The ready staging path is the script's product; emit it as the ONLY stdout line.
printf '%s\n' "$ready_abs"
