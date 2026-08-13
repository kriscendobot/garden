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
#   4. POST A REFRESH PER DRIFT, ONCE PER DRIFT — NOT ONCE PER SOURCE. For each
#      drifted source, post a `scholar-refresh-<source-slug>` job (low priority)
#      via post-job.sh, carrying a DIRECTIVE IDENTITY keyed on the drift itself:
#      (slug, recorded sha, upstream sha). The identity is what makes the scan
#      durable, and it is not optional decoration:
#
#        Without an identity, post-job.sh's basename dedup counts `tada/` — so the
#        FIRST refresh of a slug, once completed, sits in tada/ forever and
#        silently swallows every LATER drift of that source. The scan then logs
#        `DRIFT` and posts nothing, every tick, for the rest of time. That is not
#        hypothetical: `endo--packages-ses-src-error-assert-js` was refreshed
#        2026-06-27, drifted again 2026-06-29 (endojs/endo#3130, a behavioral
#        change to makeError/sanitizeError), and every tick from then to 2026-07-28
#        logged the drift and dropped it. Freshness for the whole pinned corpus
#        degraded to first-drift-only.
#
#      With an identity, post-job.sh stops counting tada/ for the basename and
#      defers to the `jobs/index/<hash>` map instead — which is keyed on the drift,
#      so a NEW drift of an already-refreshed source is a NEW directive and posts.
#      The two guards must move in lockstep, and do: refresh_live() below (the
#      cheap local pre-check) counts only plan/todo/doin, exactly the set post-job
#      still treats as blocking. Note the base is deliberately NOT made unique per
#      drift: keeping the fixed `scholar-refresh-<slug>` base means post-job's own
#      basename check remains the authoritative "at most ONE open refresh per
#      source" guard, so a source that drifts twice while its refresh is still
#      queued cannot spawn two agents re-ingesting the same slug.
#
#      A refresh for THIS EXACT drift that has already run to completion is
#      reported (refresh_settled) rather than re-posted: post-job would dedup it to
#      a silent no-op anyway, and naming it keeps `posted=` honest and surfaces the
#      one case that genuinely warrants a human look — a refresh that finished
#      without advancing the recorded file-commit.
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

# The directive identity of ONE drift: the source plus the exact transition it
# needs reconciled. Distinct drifts of the same source are distinct directives, so
# post-job.sh's identity index — not the fixed basename — is the re-see guard, and
# a COMPLETED refresh no longer suppresses the next drift (see § 4 above). Keying
# on the recorded sha as well as the upstream one means a refresh that only
# PARTIALLY advanced the row (recorded moves to some intermediate commit) yields a
# fresh identity next tick and is re-posted rather than considered settled.
drift_identity() {  # drift_identity <slug> <recorded> <upstream>
  printf 'library-source-drift:%s:%s..%s\n' "$1" "$2" "${3:-absent}"
}

# Is a scholar-refresh job for <slug> already LIVE on the board of the synced
# clone? A cheap pre-check so we do not spawn post-job for a refresh that is
# already parked/open/in-flight. It counts plan/todo/doin and DELIBERATELY NOT
# tada/: a completed refresh belongs to a PAST drift, and counting it is precisely
# the once-ever suppression documented in § 4. This set must stay identical to the
# one post-job.sh still treats as blocking for an identity-carrying post — the two
# guards are a pair, and relaxing only one leaves the other silently dropping.
refresh_live() {
  local base="scholar-refresh-$1"
  [ -e "$DIR/$JOBS_PLAN/$base.md" ] || [ -e "$DIR/$JOBS_TODO/$base.md" ] || [ -e "$DIR/$JOBS_DOIN/$base.md" ]
}

# Has a refresh for THIS EXACT drift already run to completion? Reads post-job's
# own identity index in the synced clone: an entry for our identity whose owning
# base has reached tada/. post-job would dedup such a re-post to a silent no-op
# (its identity dedup counts tada/ as live), so detecting it here keeps the posted=
# count honest and gives the condition a name — a refresh finished, yet the row
# still records the old file-commit, which wants a human or a scholar to look.
refresh_settled() {  # refresh_settled <identity>
  local id="$1" entry owner
  entry="$DIR/$JOBS_INDEX/$(job_id_hash "$id")"
  [ -f "$entry" ] || return 1
  # A hash collision between two distinct identities must never read as settled.
  [ "$(sed -n 's/^identity:[[:space:]]*//p' "$entry" | head -1)" = "$id" ] || return 1
  owner="$(sed -n 's/^base:[[:space:]]*//p' "$entry" | head -1)"
  [ -n "$owner" ] && tada_exists "$DIR" "$owner"
}

post_refresh() {  # post_refresh <slug> <repo> <path> <recorded> <upstream> <identity>
  local slug="$1" repo="$2" path="$3" recorded="$4" upstream="$5" identity="$6"
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
    | "$POST_JOB" --identity "$identity" "$base"
}

audited=0 current=0 drifted=0 posted=0 skipped_live=0 skipped_settled=0 skipped_noclone=0 absent=0
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

  if refresh_live "$slug"; then
    log "  refresh already live (plan/todo/doin) for $slug; skipping post"
    skipped_live=$((skipped_live+1))
    continue
  fi
  identity="$(drift_identity "$slug" "$recorded" "$upstream")"
  if refresh_settled "$identity"; then
    log "  a refresh for THIS drift ($slug ${recorded} -> ${upstream:-<path absent>}) already completed, yet the row still records ${recorded}; not re-posting (the completed refresh did not advance the recorded file-commit — wants a look)"
    skipped_settled=$((skipped_settled+1))
    continue
  fi
  if post_refresh "$slug" "$repo" "$path" "$recorded" "$upstream" "$identity"; then
    posted=$((posted+1))
  else
    log "  WARN: post of scholar-refresh-$slug failed; will retry next tick"
  fi
done < <(parse_rows)

log "audited=$audited current=$current drifted=$drifted (absent=$absent) posted=$posted refresh-already-live=$skipped_live refresh-already-completed=$skipped_settled no-local-clone=$skipped_noclone"

if [ "$DRYRUN" = 1 ] && [ "$drifted" -gt 0 ]; then
  exit 1
fi
exit 0
