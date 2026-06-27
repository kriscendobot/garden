#!/bin/bash
# land-journal-edit.sh — land a single journal2 *content-file* edit through the
# isolated producer clone, with the CAS retry/backoff loop and silent-loss guard
# every other producer already uses.
#
# WHY THIS EXISTS. On 2026-06-27 a gardener wearing the scholar role landed a
# library content edit by rebasing the LIVE `/home/kris/journal` worktree
# (`entries/2026/06/27/095956Z-result-scholar-e213f5.md`). That worktree can be
# arbitrarily stale and is full of a peer's uncommitted WIP, so the rebase
# replayed ~80 already-upstream commits into a destructive conflict that had to
# be aborted and re-landed against a fresh worktree. "Which tree do I land this
# in, and how do I push it safely?" is pure producer-clone discipline, not a
# judgment call — so it belongs in a script, exactly like journal-entry.sh
# already encodes it for append-only entries, and exactly like library-link-
# check.sh encodes the read-side "sync the committed tip, never touch the live
# worktree" guarantee.
#
# WHAT IT DOES. Given a journal2-relative content path under an allowlisted
# editable tree (library/ or projects/ by default) and a new file body (from a
# body-file argument or stdin), it:
#   1. refuses any path outside the allowlisted trees, and refuses to operate on
#      the live $GARDEN_ROOT/journal worktree (the read-side guarantee, mirrored);
#   2. inside the isolated ${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}
#      clone, runs sync_clone (fetch + hard-reset to origin/journal2 tip) so the
#      edit always lands on the CURRENT committed tip, never an in-context-stale
#      snapshot;
#   3. writes the file, `git add`s it, and commit_and_push with the CAS
#      retry/backoff loop and _verify_pushed silent-loss guard from common.sh.
#
# This is the ONLY sanctioned way for a gardener (scholar, librarian, or any role
# applying a library-lookup writeback) to land a library/projects content edit.
# Do NOT hand-`git` against the live worktree; that is the hazard this removes.
#
# WHOLE-FILE SEMANTICS. The body REPLACES the file's whole content at the tip
# (it is not a patch). For a wholesale edit — a rewritten concept page, a new
# section file, added frontmatter — that is exactly right. For an APPEND to a
# shared index (library/keywords.md, a README row), read the file at the current
# tip and pass tip-content-plus-your-line as the body, so the land does not drop
# a sibling's row; the CAS loop re-runs on a rejected push, and a rare concurrent
# append the loop cannot see is caught by the scholar's next index-integrity pass.
#
# USAGE
#   land-journal-edit.sh <journal2-relative-path> [<body-file>]
#     body from <body-file>, else from stdin. The path is relative to the
#     journal2 root and must live under an allowlisted tree (see ALLOWLIST).
#   land-journal-edit.sh -h | --help
#
# Examples
#   land-journal-edit.sh library/keywords.md < new-keywords.md
#   printf '%s\n' "$BODY" | land-journal-edit.sh library/concepts/pinchtab.md
#
# EXIT CODES
#   0  the edit landed on origin/journal2 (verified reachable)
#   1  could not land after the bounded retries
#   2  usage error / disallowed path / live-worktree refusal
#   75 EX_TEMPFAIL: transient connectivity outage during a tip sync (from
#      sync_clone) — caller skips this tick and retries next cadence
#
# CONFIG (overridable; tests point these at a throwaway journal)
#   GARDEN_PRODUCER_CLONE   the isolated clone to land through
#   GARDEN_EDITABLE_TREES   space-separated allowlist of top-level editable
#                           trees (default: "library projects")
#   GARDEN_ROLE             recorded in the commit message (default: gardener)

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="land-journal-edit"

require_tools git

# Usage / disallowed-path / live-worktree refusals exit 2 (see EXIT CODES), kept
# distinct from die's generic exit 1 (a failed land after retries).
refuse() { log "FATAL: $*"; exit 2; }

# The trees a content edit may touch. library/ is the scholar's reference tree
# and the library-lookup writeback target; projects/ is the per-project context
# tree the scholar grows. Everything else (entries/ is append-only via
# journal-entry.sh; jobs/, msgs/, inbox/, schedules/, hosts/, bulletin.md are the
# board/bus/dashboard surfaces owned by their own scripts) is OUT of scope here.
: "${GARDEN_EDITABLE_TREES:=library projects}"

usage() {
  awk 'NR>1 && /^#/{sub(/^# ?/,"");print;next} NR>1{exit}' "$0"
}

case "${1:-}" in
  -h|--help) usage; exit 0 ;;
  ''|-*) usage >&2; refuse "usage: land-journal-edit.sh <journal2-relative-path> [body-file]" ;;
esac

rel="$1"
body_src="${2:-}"
role="${GARDEN_ROLE:-gardener}"

# --- path validation: confine to the allowlisted trees ----------------------
# Reject anything that could escape the allowlist: an absolute path, a `..`
# traversal component, or a first component not on the allowlist. This is a
# lexical check (no filesystem access) so it holds before the clone even exists.
case "$rel" in
  /*) refuse "refusing absolute path '$rel'; give a journal2-relative path under: $GARDEN_EDITABLE_TREES" ;;
esac
# Split on '/' and reject any empty or '.'/'..' component (no traversal, no
# trailing-slash directory write).
IFS='/' read -r -a _parts <<<"$rel"
for _p in "${_parts[@]}"; do
  case "$_p" in
    ''|.|..) refuse "refusing path '$rel' (empty, '.' or '..' component)";;
  esac
done
top="${_parts[0]}"
allowed=0
for t in $GARDEN_EDITABLE_TREES; do
  [ "$top" = "$t" ] && { allowed=1; break; }
done
[ "$allowed" -eq 1 ] || refuse "refusing path '$rel': top-level '$top' is not an allowlisted editable tree ($GARDEN_EDITABLE_TREES)"

# --- read the new body (body-file, else stdin) ------------------------------
if   [ -n "$body_src" ] && [ -f "$body_src" ]; then BODY="$(cat "$body_src")"
elif [ -n "$body_src" ];                       then refuse "body-file '$body_src' not found"
elif [ ! -t 0 ];                               then BODY="$(cat)"
else refuse "no body: pass a <body-file> or pipe the new file content on stdin"; fi

DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"

# --- live-worktree refusal (the read-side guarantee, mirrored) --------------
# library-link-check.sh promises it "never touches the live /home/kris/journal
# worktree (full of a peer's uncommitted WIP)". The write side must promise the
# same: this script lands through the isolated producer clone ONLY, never the
# live worktree. Even if an operator points GARDEN_PRODUCER_CLONE at it, refuse.
live_abs="$(cd "$GARDEN_ROOT/journal" 2>/dev/null && pwd || printf '%s' "$GARDEN_ROOT/journal")"
dir_abs="$(cd "$DIR" 2>/dev/null && pwd || printf '%s' "$DIR")"
[ "$dir_abs" = "$live_abs" ] && refuse "refusing to operate on the live worktree ($live_abs); land through the isolated producer clone, not the live tree"

ensure_clone "$DIR"

for attempt in $(seq 1 50); do
  sync_clone "$DIR"                         # fetch + hard-reset to origin/journal2 tip (may exit 75)
  mkdir -p "$DIR/$(dirname "$rel")"
  printf '%s\n' "$BODY" > "$DIR/$rel"
  git -C "$DIR" add "$rel"
  # Nothing staged (idempotent re-land of identical content): treat as success.
  if git -C "$DIR" diff --cached --quiet; then
    log "no change for $rel (already at origin/$JOURNAL_BRANCH tip)"; exit 0
  fi
  if commit_and_push "$DIR" "library-edit: $role wrote $rel on $GARDEN_HOST"; then
    log "landed $rel on origin/$JOURNAL_BRANCH"; exit 0
  fi
  backoff
done
die "could not land $rel after retries"
