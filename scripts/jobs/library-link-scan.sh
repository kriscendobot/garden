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
# DIAGNOSTIC vs ACTUATING. By default this scan is DIAGNOSTIC: it exits NONZERO
# when a navigation link dangles, which is exactly what the in-context callers
# want — the scholar's `--exists` re-verify primitive, a by-hand `--nav` scan, and
# the `--` passthrough all rely on a nonzero exit to mean "there is breakage to
# fix." The STANDING TIMER, by contrast, wants the ACTUATING shape (`--actuate`):
# it posts a single remediation job naming the dangling targets and exits 0, so a
# tick that finds breakage creates WORK rather than marking the systemd unit
# Failed (which would be noise and would fire a self-heal responder on a
# non-failure). This mirrors library-source-drift-scan.sh, which posts a
# scholar-refresh job per drift and exits 0. The actuating behavior is an explicit
# opt-in flag, NOT the default, precisely so the diagnostic callers above keep
# their raw nonzero-exit contract unchanged. See the systemd unit
# garden-library-link-scan.service for the standing caller.
#
# USAGE
#   library-link-scan.sh                  sync tip, scan navigation surfaces, emit
#                                         the genuinely-dangling links for repair.
#                                         DIAGNOSTIC: exit 1 if any dangle.
#   library-link-scan.sh --actuate        sync tip, scan navigation surfaces, and
#                                         on a dangle POST a single
#                                         scholar-fix-dangling-nav-links-<hash> job
#                                         naming the targets, then exit 0. The
#                                         standing-timer (ACTUATING) shape; the
#                                         job basename is content-derived so a
#                                         distinct dangle-set posts a distinct job
#                                         and a re-run with the same set is a
#                                         no-op. --dry-run posts nothing and exits
#                                         1 if any dangle (a CI-style check).
#   library-link-scan.sh --all            sync tip, scan EVERY library link but
#                                         gate ONLY on must-resolve navigation/
#                                         index/source-table links; verbatim
#                                         leaf-body upstream links are reported as
#                                         a separate advisory count (not gating).
#                                         Default is --nav.
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
#   0  clean scan (no dangling links) / `--exists` target present /
#      `--actuate` completed (a dangle, if any, was posted)
#   1  dangling links found / `--exists` target absent /
#      `--actuate --dry-run` found at least one dangle
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
POST_JOB="$HERE/post-job.sh"

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

  --actuate)
    # The standing-timer ACTUATING shape: run the --nav scan, and on a dangle post
    # ONE remediation job naming the targets, then exit 0 so the systemd unit is
    # Healthy and a tick that finds breakage creates WORK (mirroring
    # library-source-drift-scan.sh). --dry-run posts nothing and exits 1 on a
    # dangle (a CI-style freshness check).
    require_tools git sha256sum
    DRYRUN=0
    case "${2:-}" in
      --dry-run) DRYRUN=1 ;;
      '') : ;;
      *) die "usage: library-link-scan.sh --actuate [--dry-run]" ;;
    esac
    sync_tip
    log "scanning navigation surfaces (actuating) at origin/$JOURNAL_BRANCH tip $TIP ..."
    # Capture rather than exec: we must read the rc and the DANGLING lines. The
    # core never reaches the network and writes nothing, so capturing it is safe.
    set +e
    OUT="$("$CORE" --nav --library "$LIB" --quiet 2>&1)"; RC=$?
    set -e
    printf '%s\n' "$OUT"
    case "$RC" in
      0)
        log "tip $TIP: every navigation link resolves; nothing to post"
        exit 0 ;;
      1) : ;;   # dangling links — fall through to the post path
      *)
        # A genuine setup/usage error from the core (exit 2) or any unexpected rc:
        # propagate it so the self-heal wrapper diagnoses a real fault.
        die "library-link-check exited $RC (not a clean dangle result); see output above" ;;
    esac

    # Extract the genuinely-dangling navigation links the core reported. Each line
    # is `  DANGLING <referrer> -> <target> (<reason>)`; keep the referrer->target
    # spine, sorted+unique, as both the job-body list and the idempotency key.
    targets="$(printf '%s\n' "$OUT" \
      | sed -n 's/^  DANGLING \(.*\) (\(no such committed file\|exists on disk[^)]*\))\( — did you mean .*\)\{0,1\}$/\1/p' \
      | sort -u)"
    if [ -z "$targets" ]; then
      # Core said rc=1 but emitted no parseable DANGLING line — treat as a real
      # fault rather than silently posting an empty job.
      die "library-link-check exited 1 but no DANGLING line was parseable; see output above"
    fi
    count="$(printf '%s\n' "$targets" | grep -c . )"
    # Content-derived basename: a distinct dangle-set gets a distinct job, a re-run
    # with the same set is a post-job no-op (idempotent), and a NEW set after some
    # are fixed posts a fresh job — the standing-scan analogue of drift's per-slug
    # idempotency, without a fixed name that would post only once ever.
    hash="$(printf '%s\n' "$targets" | sha256sum | cut -c1-12)"
    base="scholar-fix-dangling-nav-links-$hash"

    log "tip $TIP: $count dangling navigation link(s); remediation job $base"
    if [ "$DRYRUN" = 1 ]; then
      log "dry-run: not posting"
      exit 1
    fi

    body="$(mktemp "${TMPDIR:-/tmp}/link-scan-job.XXXXXX")"
    trap 'rm -f "$body"' EXIT
    {
      printf '%s\n' \
"---
priority: normal
posted_by: $GARDEN_TAG
tip: $TIP
dangling_count: $count
---
# Repair dangling navigation links in the reference library

The standing $GARDEN_TAG (garden-library-link-scan.timer) found navigation/index/
source-table links that point at files NOT committed at origin/$JOURNAL_BRANCH tip
\`$TIP\`. These are scholar-authored navigation surfaces (concepts/topics/sources/
roles index pages, sections/README.md, the library README), NOT verbatim leaf
section bodies, so each one is the library's to resolve.

Dangling links (referrer -> target), $count total:

\`\`\`"
      printf '%s\n' "$targets" | sed 's/^/  /'
      printf '%s\n' \
"\`\`\`

For each: write the missing target file (commonly an omitted \`kind: index\`
parent section), or correct/remove the navigation row that points at it. Before
committing a repoint, re-verify the new target exists at the current tip with
\`scripts/jobs/library-link-scan.sh --exists <library-relative-path>\`. Land edits
through \`scripts/jobs/land-journal-edit.sh\` (never the live worktree), then
re-run \`scripts/jobs/library-link-scan.sh\` until it is clean. Normal priority:
broken navigation, caught downstream — not an urgent gate."
    } > "$body"

    if "$POST_JOB" "$base" "$body"; then
      log "posted $base"
    else
      log "WARN: post of $base failed; will retry next tick"
    fi
    exit 0 ;;

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
