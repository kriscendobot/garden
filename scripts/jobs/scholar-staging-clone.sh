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
# WHAT IT DOES. Resolve a destination dir (positional arg, else $GARDEN_SCHOLAR_
# STAGING_CLONE, else the PER-JOB-BASE default $GARDEN_STATE/scholar-staging/
# <job-base>/journal), then:
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
# WHY PER-JOB-BASE (the 2026-07-29 destroyed-edits incident). The default used to
# resolve to a SINGLE FIXED path ($GARDEN_STATE/scholar-staging/journal), so two
# scholar-role jobs alive on the same host staged in the SAME directory. Each call
# runs sync_clone = `git reset --hard origin/journal2`, so one peer's hard reset
# silently discarded the other's uncommitted section/topic edits, and the peer's
# `git add` swept the loser's WIP into its own commit. Observed 2026-07-29:
# scholar-library-cycle-20260729-013504 racing scholar-ingest-atproto-ucan-did-specs
# lost 13 insert-sections-table-row.sh inserts, and the step-8 integrity gate did
# NOT catch it (a topic page missing a row for an existing section is not a dangling
# link) — silent loss behind a green gate. The fix keys the DEFAULT staging path by
# the caller's job base, exactly the way ensure-project-worktree.sh keys per-job
# project worktrees: peers may race at the git-push CAS, but WORKING TREES MUST
# NEVER BE SHARED (the same lesson as the endojs/endo-but-for-bots#58 corruption).
#
# USAGE
#   scholar-staging-clone.sh [--base <job-base>] [<dest-dir>]
#   scholar-staging-clone.sh -h | --help
#
# Examples
#   staging="$(scholar-staging-clone.sh --base "$JOB_BASE")"  # per-base default
#   staging="$(scholar-staging-clone.sh)"                     # base from GARDEN_JOB_BASE
#   staging="$(scholar-staging-clone.sh /tmp/x)"              # explicit path
#
# The base is taken from --base, else the GARDEN_JOB_BASE env the gardener handler
# exports for every job. When neither a dest-dir, GARDEN_SCHOLAR_STAGING_CLONE, nor
# a base is available the script REFUSES (exit 2) rather than fall back to a shared
# path — that fallback is the very hazard this removes.
#
# EXIT CODES
#   0  the staging clone is ready and fresh; its path is on stdout
#   2  usage error / missing base / live-worktree refusal
#   75 EX_TEMPFAIL: transient connectivity outage during the tip sync (from
#      sync_clone) — caller skips this tick and retries next cadence
#
# CONFIG (overridable; tests point these at a throwaway journal)
#   GARDEN_SCHOLAR_STAGING_CLONE       explicit staging clone path; when set it
#                                      overrides the per-base default entirely
#   GARDEN_JOB_BASE                    the job base the per-base default keys on
#                                      (exported by the gardener handler)
#   GARDEN_SCHOLAR_STAGING_TTL_HOURS   prune a sibling per-base staging dir idle
#                                      this long (default 24); they accumulate one
#                                      per job, so the default layout self-prunes

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG="scholar-staging-clone"

require_tools git

# Usage / live-worktree refusals exit 2, kept distinct from die's generic exit 1.
refuse() { log "FATAL: $*"; exit 2; }

usage() {
  awk 'NR>1 && /^#/{sub(/^# ?/,"");print;next} NR>1{exit}' "$0"
}

# --- argument parsing: [--base <b>] [<dest-dir>] ----------------------------
base_opt=""
dest=""
while [ "$#" -gt 0 ]; do
  case "$1" in
    -h|--help)  usage; exit 0 ;;
    --base)     base_opt="${2:-}"; [ "$#" -ge 2 ] || refuse "--base needs a value"; shift 2 ;;
    --base=*)   base_opt="${1#--base=}"; shift ;;
    --)         shift; [ "$#" -gt 0 ] && { dest="$1"; shift; }; break ;;
    -*)         refuse "unknown option: $1 (usage: scholar-staging-clone.sh [--base <job-base>] [<dest-dir>])" ;;
    *)          dest="$1"; shift; break ;;
  esac
done

# --- resolve the staging path -----------------------------------------------
# Precedence: an explicit dest-dir, then the GARDEN_SCHOLAR_STAGING_CLONE override,
# then the PER-JOB-BASE default. The base-keyed default is what keeps two concurrent
# scholar cycles from sharing one staging tree (see the header § WHY PER-JOB-BASE);
# it is used only when neither an explicit dest nor the env override is given, and
# only that path is eligible for the sibling-pruning below.
default_per_base=0
if [ -n "$dest" ]; then
  DIR="$dest"
elif [ -n "${GARDEN_SCHOLAR_STAGING_CLONE:-}" ]; then
  DIR="$GARDEN_SCHOLAR_STAGING_CLONE"
else
  base="${base_opt:-${GARDEN_JOB_BASE:-}}"
  [ -n "$base" ] || refuse "no staging base: pass a dest-dir, set GARDEN_SCHOLAR_STAGING_CLONE, or provide --base <job-base> (the gardener handler exports GARDEN_JOB_BASE for you). A per-base default keeps concurrent scholar cycles from sharing one staging tree and destroying each other's edits (the 2026-07-29 incident)."
  # `base` is a job basename (no '/', '#', ':'); sanitize to a safe path component
  # defensively anyway, matching ensure-project-worktree.sh's base_safe.
  base_safe="${base//[^A-Za-z0-9._-]/-}"
  DIR="$GARDEN_STATE/scholar-staging/$base_safe/journal"
  default_per_base=1
fi

# --- prune stale sibling per-base staging dirs -------------------------------
# The per-base default accumulates one $GARDEN_STATE/scholar-staging/<base>/ dir
# per job. Opportunistically remove sibling dirs whose whole subtree has been
# UNTOUCHED for the TTL window (mtime-quiescence = "no live owner", the same proxy
# reaper.sh's scratch janitor uses), keeping the current base. Safe because a
# staging clone is fully regenerable — every cycle re-provisions it with a hard
# reset (sync_clone below), so nothing precious lives in a quiescent one; a live
# peer touches its clone continuously and is never quiescent. Best-effort: a prune
# failure never blocks the handoff. Only runs for the base-keyed default layout.
prune_stale_staging() {
  local keep="$1" root="$GARDEN_STATE/scholar-staging" ttl d name
  ttl="${GARDEN_SCHOLAR_STAGING_TTL_HOURS:-24}"
  [ -d "$root" ] || return 0
  case "$ttl" in ''|*[!0-9]*) return 0 ;; esac      # a garbled TTL disables pruning
  for d in "$root"/*; do
    [ -d "$d" ] || continue
    name="$(basename "$d")"
    [ "$name" = "$keep" ] && continue
    # Quiescent = nothing in the subtree modified within the TTL window.
    if find "$d" -newermt "-${ttl} hours" -print -quit 2>/dev/null | grep -q .; then
      continue
    fi
    rm -rf "$d" 2>/dev/null && log "pruned stale scholar staging dir $d (quiescent >${ttl}h)" || true
  done
  return 0
}
[ "$default_per_base" = 1 ] && prune_stale_staging "$base_safe"

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
