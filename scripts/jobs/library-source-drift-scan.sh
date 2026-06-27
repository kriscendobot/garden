#!/bin/bash
# library-source-drift-scan.sh — the standing, tip-synced per-source freshness scan.
#
# This is the SOURCE-DRIFT analogue of library-link-scan.sh. Where that wrapper
# moved tip-stale section-LINK auditing off the in-context scholar and onto a
# deterministic, tip-synced scan, this one moves per-source FRESHNESS auditing off
# the scholar the same way. Today the scholar only notices that an ingested source
# has drifted past its recorded upstream commit when an empty-inbox cycle happens
# to touch the 2–4 sources that cycle's work brushes against; the rest of the
# corpus silently rots. This scan audits the WHOLE corpus on a cadence and posts a
# refresh job for every drifted source, so freshness no longer depends on a
# chance encounter.
#
# WHAT IT DOES, each tick:
#
#   1. SYNC THE TIP FIRST. Fetch + hard-reset a dedicated read-only journal2 clone
#      to the current origin/journal2 tip BEFORE reading a single row (ensure_clone
#      + sync_clone). The live journal/ worktree — full of a peer's uncommitted WIP
#      — is NEVER touched; we read the shared, committed README at the tip, exactly
#      the discipline library-link-scan.sh encodes (and for the same 2026-06-27
#      stale-snapshot reason).
#
#   2. PARSE THE SOURCE ROWS. From library/sources/README.md, every row that
#      records an inline `file-commit `<sha>`` yields a (source-slug, source-repo,
#      source-path, recorded-sha) tuple. Rows WITHOUT an inline file-commit (the
#      multi-file `{N files}` aggregates, and repo-source rows whose commit lives in
#      the slug file) carry no recorded sha to compare against, so they are skipped
#      by construction — this scan only audits rows that pin a single path to a
#      single commit.
#
#   3. RESOLVE + COMPARE, OFFLINE. For each row whose repo has a local bare clone
#      under worktrees/<owner>-<repo>.git, resolve the path's latest upstream commit
#      with `git -C <bare> log -1 --format=%H -- <path>` and compare it to the
#      recorded sha (a prefix match, since file-commit is recorded abbreviated). The
#      bare clones are the ones clone-keeper.sh already keeps fast-forward-fresh, so
#      this scan reuses fresh local history and NEVER reaches the network. A row
#      whose repo has NO local bare clone (e.g. MetaMask/ocap-kernel) is skipped and
#      logged — the scan never fails on a missing clone and never fetches one.
#
#   4. POST A REFRESH PER DRIFT. For each drifted source, idempotently post a
#      `scholar-refresh-<source-slug>` job (low priority) via post-job.sh. post-job
#      is idempotent across the whole lifecycle (todo/doin/tada), so an already-open
#      or in-flight refresh for that slug is never duplicated; a cheap pre-check
#      against the synced clone skips the post entirely when one is already present.
#
# This does not widen scope: it only reads already-ingested upstream repos from
# local bare clones (read-only) and posts jobs onto the board. No agoric-sdk, no
# network, no live-worktree mutation.
#
# USAGE
#   library-source-drift-scan.sh            sync tip, audit every pinned source,
#                                           post a scholar-refresh job per drift.
#   library-source-drift-scan.sh --dry-run  sync tip and audit, but post nothing;
#                                           print the drift report. Exit 1 if any
#                                           drift was found, 0 if the corpus is
#                                           current (a CI-style freshness check).
#   library-source-drift-scan.sh -h|--help
#
# EXIT CODES
#   0  scan completed (drifts, if any, were posted) / --dry-run found no drift
#   1  --dry-run found at least one drifted source
#   2  usage / setup error
#   75 EX_TEMPFAIL: transient connectivity outage during the tip sync (from
#      sync_clone); the caller skips this tick and retries next cadence.
#
# STATE. A dedicated read-only journal2 clone at $GARDEN_LIBSOURCE_CLONE (default
# $GARDEN_STATE/library-source-drift-scan/journal), kept OUTSIDE any reset-prone
# worktree, exactly like library-link-scan.sh's clone.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="library-source-drift-scan"

require_tools git awk

DRYRUN=0
case "${1:-}" in
  -h|--help)
    awk 'NR>1 && /^#/{sub(/^# ?/,"");print;next} NR>1{exit}' "$0"
    exit 0 ;;
  --dry-run) DRYRUN=1 ;;
  '') : ;;
  *) die "unknown argument '$1' (try --help)" ;;
esac

DIR="${GARDEN_LIBSOURCE_CLONE:-$GARDEN_STATE/library-source-drift-scan/journal}"
POST_JOB="$HERE/post-job.sh"

# Sync the dedicated clone to the current origin/journal2 tip (may exit 75).
ensure_clone "$DIR"
sync_clone "$DIR"
README="$DIR/library/sources/README.md"
[ -f "$README" ] || die "no library/sources/README.md in the synced clone at $DIR (tip has no source index?)"
TIP="$(git -C "$DIR" rev-parse --short HEAD 2>/dev/null || echo '?')"
log "scanning library/sources at origin/$JOURNAL_BRANCH tip $TIP ${DRYRUN:+ }$([ "$DRYRUN" = 1 ] && echo '(dry-run)')"

# Parse the source rows. Emit one TAB-separated (slug, repo, path, recorded-sha)
# line per row that pins a single path to an inline `file-commit `<sha>``. Rows
# without an inline file-commit, with a non-owner/name repo cell, or with a
# non-concrete path (spaces or `{N files}` aggregates) are skipped here.
parse_rows() {
  awk -F'|' '
    /^\| *\[/ {
      line = $0
      if (line !~ /file-commit `[0-9a-f]+`/) next
      match(line, /file-commit `[0-9a-f]+`/)
      sha = substr(line, RSTART, RLENGTH); gsub(/file-commit `|`/, "", sha)
      repo = $3; path = $4
      gsub(/^[ \t]+|[ \t]+$/, "", repo); gsub(/^[ \t]+|[ \t]+$/, "", path)
      if (repo !~ /^[^ \/]+\/[^ \/]+$/) next       # repo cell must be owner/name
      if (path == "" || path ~ /[ {}]/) next       # concrete single path only
      col1 = $2
      if (!match(col1, /\]\([^()]+\.md\)/)) next
      slug = substr(col1, RSTART, RLENGTH); gsub(/^\]\(|\)$/, "", slug); sub(/\.md$/, "", slug)
      if (slug == "") next
      printf "%s\t%s\t%s\t%s\n", slug, repo, path, sha
    }
  ' "$README"
}

# Is a scholar-refresh job for <slug> already anywhere in the board lifecycle of
# the synced clone? A cheap pre-check so we do not spawn post-job for a refresh
# that is already open/in-flight/done; post-job's own cross-lifecycle idempotency
# is the authoritative guard, this just avoids the noise.
refresh_present() {
  local base="scholar-refresh-$1"
  [ -e "$DIR/$JOBS_TODO/$base.md" ] || [ -e "$DIR/$JOBS_DOIN/$base.md" ] || [ -e "$DIR/$JOBS_TADA/$base.md" ]
}

post_refresh() {  # post_refresh <slug> <repo> <path> <recorded> <upstream>
  local slug="$1" repo="$2" path="$3" recorded="$4" upstream="$5"
  local base="scholar-refresh-$slug"
  printf '%s\n' \
"---
priority: low
posted_by: $GARDEN_TAG
source_slug: $slug
source_repo: $repo
source_path: $path
recorded_file_commit: $recorded
upstream_file_commit: ${upstream:-(absent)}
---
# Refresh drifted library source: $slug

The standing $GARDEN_TAG detected that the upstream file backing this ingested
source has advanced past the recorded \`file-commit\`.

- Source row + slug file: library/sources/$slug.md
- Upstream: $repo path \`$path\`
- Recorded file-commit: \`$recorded\`
- Current upstream commit for the path: \`${upstream:-(path absent — renamed or deleted upstream)}\`

Re-ingest / reconcile this source (refresh its section files, then update the
recorded file-commit in library/sources/README.md and the slug file). Low
priority: this is a freshness refresh, not a correctness gate." \
    | "$POST_JOB" "$base"
}

audited=0 current=0 drifted=0 posted=0 skipped_present=0 skipped_noclone=0 absent=0
declare -A SEEN_NOCLONE=()

while IFS=$'\t' read -r slug repo path recorded; do
  [ -n "$slug" ] || continue
  audited=$((audited+1))

  # Map owner/name -> the local bare clone, and skip-and-log (never network) when
  # there is none. De-dup the per-repo "no clone" log so 30 endo-less rows don't
  # print 30 identical lines.
  bare="$GARDEN_ROOT/worktrees/${repo/\//-}.git"
  if ! git -C "$bare" rev-parse --git-dir >/dev/null 2>&1; then
    if [ -z "${SEEN_NOCLONE[$repo]:-}" ]; then
      log "skip: no local bare clone for $repo at worktrees/${repo/\//-}.git (not fetched; never reaching the network)"
      SEEN_NOCLONE[$repo]=1
    fi
    skipped_noclone=$((skipped_noclone+1))
    continue
  fi

  upstream="$(git -C "$bare" log -1 --format=%H -- "$path" 2>/dev/null || true)"

  # Prefix match: file-commit is recorded abbreviated, so a current source has the
  # recorded sha as a prefix of the path's full upstream commit. An empty upstream
  # (path renamed/deleted) never prefix-matches a non-empty recorded sha, so it
  # falls through to the drift branch — which is correct: a vanished source needs
  # reconciliation too.
  case "$upstream" in
    "$recorded"*)
      current=$((current+1))
      continue ;;
  esac

  drifted=$((drifted+1))
  [ -z "$upstream" ] && absent=$((absent+1))
  log "DRIFT: $slug ($repo $path) recorded ${recorded} != upstream ${upstream:-<path absent>}"

  [ "$DRYRUN" = 1 ] && continue

  if refresh_present "$slug"; then
    log "  refresh already in lifecycle for $slug; skipping post"
    skipped_present=$((skipped_present+1))
    continue
  fi
  if post_refresh "$slug" "$repo" "$path" "$recorded" "$upstream"; then
    posted=$((posted+1))
  else
    log "  WARN: post of scholar-refresh-$slug failed; will retry next tick"
  fi
done < <(parse_rows)

log "audited=$audited current=$current drifted=$drifted (absent=$absent) posted=$posted refresh-already-present=$skipped_present no-local-clone=$skipped_noclone"

if [ "$DRYRUN" = 1 ] && [ "$drifted" -gt 0 ]; then
  exit 1
fi
exit 0
