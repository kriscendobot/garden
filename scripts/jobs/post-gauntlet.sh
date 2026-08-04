#!/bin/bash
# post-gauntlet.sh — producer primitive: record a staged GAUNTLET run over a PR, so
# the deterministic gauntlet.sh driver walks it one claim-sized stage at a time
# (clean → panel → fix-loop → un-draft) rather than one monolithic job whose handler
# must span the whole chain (designs/staged-gauntlet.md).
#
# The gauntlet ran as ONE claimed job whose wall-clock was the SUM of every stage,
# every fix-loop iteration, and every CI wait — a sum that fits no handler budget
# (nine jobs doomed on deadline-overrun 2026-07-28, one already at a 14000s budget
# against the GARDEN_CLAIM_TTL ceiling). This records the run as a RECORD outside the
# claim lifecycle; the driver posts each stage as its own fresh-budget job and advances
# the record against each stage's completion marker. This is the per-PR analog of
# post-orchestration.sh + orchestrate.sh over jobs/orch/.
#
# Usage:
#   post-gauntlet.sh [--build-job <base>] [--probe] [--kind feature|probe]
#                    [--max-iterations N] [--by ROLE] <g> <pr-url>
#
#   <g>                 the gauntlet base (deterministic, e.g. <owner>-<repo>-pr<N>-gauntlet).
#   <pr-url>            the PR the gauntlet runs on (full github.com …/pull/<N> URL,
#                       or the short <owner>/<repo>#<N> form).
#   --build-job <base> provenance: the build whose completion edge posted this
#                       (empty for a `run the gauntlet` origin).
#   --probe            shorthand for --kind probe: a probe NEVER un-drafts (stays draft).
#   --kind feature|probe   the run kind (default feature).
#   --max-iterations N the panel/fix loop give-up bound (default 6).
#   --max-resumes N    give-up bound on still-pending re-posts of a CI-blocking
#                      stage (default 6). A repo whose PRs attach NO checks at all
#                      (only push-triggered workflows) never goes terminal, so the
#                      clean/fix stage would otherwise re-post forever, one whole
#                      CI deadline per round. The bound turns that into a loud halt.
#   --by ROLE          provenance for created_by (default $GARDEN_SENDER or producer).
#
# Idempotent on <g>: if the record (or a completed tada/<g>) already exists the post
# is a no-op success — a re-triggered gauntlet on the same PR reuses the same record
# and stage bases. Posts are ADDs, so a rejected push re-syncs and retries. Mirrors
# post-orchestration.sh exactly.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="post-gauntlet"

usage() {
  cat <<'EOF'
post-gauntlet.sh — record a staged gauntlet run over a PR.

Usage:
  post-gauntlet.sh [--build-job <base>] [--probe] [--kind feature|probe]
                   [--max-iterations N] [--max-resumes N] [--by ROLE] <g> <pr-url>

  <g>                 the gauntlet base (deterministic, stable across re-triggers).
  <pr-url>            the PR (full …/pull/<N> URL or short <owner>/<repo>#<N>).
  --build-job <base>  provenance: the build that posted this (empty otherwise).
  --probe             shorthand for --kind probe (a probe never un-drafts).
  --kind feature|probe   the run kind (default feature).
  --max-iterations N  panel/fix loop give-up bound (default 6).
  --max-resumes N     give-up bound on still-pending re-posts of a stage (default 6).
  --by ROLE           created_by provenance (default $GARDEN_SENDER or producer).
EOF
}

build_job=""
kind="feature"
max_iterations=6
max_resumes=6
by="${GARDEN_SENDER:-producer}"
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help)        usage; exit 0;;
    --build-job)      build_job="${2:?--build-job needs a value}"; shift 2;;
    --build-job=*)    build_job="${1#--build-job=}"; shift;;
    --probe)          kind="probe"; shift;;
    --kind)           kind="${2:?--kind needs feature|probe}"; shift 2;;
    --kind=*)         kind="${1#--kind=}"; shift;;
    --max-iterations) max_iterations="${2:?--max-iterations needs a number}"; shift 2;;
    --max-resumes)    max_resumes="${2:?--max-resumes needs a number}"; shift 2;;
    --max-resumes=*)  max_resumes="${1#--max-resumes=}"; shift;;
    --by)             by="${2:?--by needs a value}"; shift 2;;
    --)               shift; break;;
    -*)               die "unknown option: '$1' (run --help for usage)";;
    *)                break;;
  esac
done

base="${1:?usage: post-gauntlet.sh [--build-job <base>] [--probe] <g> <pr-url>}"
pr_url="${2:?usage: post-gauntlet.sh <g> <pr-url> (a PR URL is required)}"

case "$base" in
  -*)        die "illegal gauntlet base: '$base' (names must not start with '-')";;
  */*|.*|'') die "illegal gauntlet base: '$base'";;
esac
case "$kind" in feature|probe) :;; *) die "illegal kind: '$kind' (feature|probe)";; esac
case "$max_iterations" in
  ''|*[!0-9]*) die "illegal --max-iterations: '$max_iterations' (want a positive integer)";;
  0)           die "illegal --max-iterations: 0 (the loop needs at least one round)";;
esac
case "$max_resumes" in
  ''|*[!0-9]*) die "illegal --max-resumes: '$max_resumes' (want a non-negative integer)";;
esac

# Parse the PR reference into <owner>/<repo> + number. parse_pr_ref accepts both a
# full URL and the short <owner>/<repo>#<N> form and is the shared classifier the
# proxy / unblock watcher already use, so a gauntlet identifies a PR identically.
if ref="$(parse_pr_ref "$pr_url")"; then
  repo="$(printf '%s' "$ref" | cut -f1)"
  pr_number="$(printf '%s' "$ref" | cut -f2)"
else
  die "could not parse a PR reference from '$pr_url' (want a github.com …/pull/<N> URL or <owner>/<repo>#<N>)"
fi
# Normalize to a canonical PR URL so the record always carries a full URL even when
# the caller passed the short form.
pr_canonical="https://github.com/$repo/pull/$pr_number"

DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
ensure_clone "$DIR"

compose() {
  printf -- '---\n'
  printf 'pr: %s\n' "$pr_canonical"
  printf 'repo: %s\n' "$repo"
  printf 'pr_number: %s\n' "$pr_number"
  printf 'build_job: %s\n' "$build_job"
  printf 'kind: %s\n' "$kind"
  printf 'stage: clean\n'
  printf 'iteration: 0\n'
  printf 'max_iterations: %s\n' "$max_iterations"
  printf 'resumes: 0\n'
  printf 'max_resumes: %s\n' "$max_resumes"
  printf 'current_child: \n'
  printf 'state: pending\n'
  printf 'created_by: %s\n' "$by"
  printf 'created_at: %s\n' "$(date -u +%FT%TZ)"
  printf -- '---\n\n'
  printf '# gauntlet %s\n\n' "$base"
  printf 'Staged gauntlet run over %s (%s).\n' "$pr_canonical" "$kind"
  [ -n "$build_job" ] && printf 'Posted by the completion edge of build `%s`.\n' "$build_job"
  printf '\nThe deterministic gauntlet.sh driver walks this PR one claim-sized stage at\n'
  printf 'a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler\n'
  printf 'spans the loop; each stage is its own fresh-budget claimable job.\n'
}

for attempt in $(seq 1 "${GARDEN_POST_ATTEMPTS:-50}"); do
  sync_clone "$DIR"
  if [ -e "$DIR/$JOBS_GAUNTLET/$base.md" ] || [ -e "$DIR/$JOBS_TADA/$base.md" ]; then
    log "gauntlet '$base' already recorded; nothing to do"
    exit 0
  fi
  mkdir -p "$DIR/$JOBS_GAUNTLET"
  compose > "$DIR/$JOBS_GAUNTLET/$base.md"
  git -C "$DIR" add "$JOBS_GAUNTLET/$base.md"
  if commit_and_push "$DIR" "gauntlet($base) recorded [$kind, pr #$pr_number] by $GARDEN"; then
    log "recorded gauntlet '$base' ($kind, $repo#$pr_number, max_iterations=$max_iterations, max_resumes=$max_resumes)"
    exit 0
  fi
  log "post-gauntlet of '$base' lost a push race (attempt $attempt); re-syncing"
  backoff "$attempt"
done
die "could not record gauntlet '$base' after retries"
