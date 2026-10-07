#!/bin/bash
# design-build-handoff.sh — DETERMINISTIC design-to-build dispatch at a designer
# job's completion. No LLM: the report's PR citation, its `## Follow-ups` section,
# and board state only.
#
# Usage: design-build-handoff.sh <job-base> <job-file> <completion-report>
#
# Grounding: `design-minion-town-oauth-bonds` opened draft design PR
# kriscendobot/minion.town#168, auto-gauntlet-handoff.sh staged its gauntlet, and
# its report's `## Follow-ups` said "The build is one builder job". The build was
# already the parked next child of `orch-minion-town-oauth-bonds`, but the report
# named no checkable disposition, so assert-followup-posted.sh blocked the
# completion at 2026-10-07T22:13:39Z and the reaper re-ran a finished design.
# Whether a design's build got dispatched depended on how its author phrased the
# report. This script makes that dispatch a property of the completion path.
#
# It acts only when ALL of these hold, and is otherwise a silent no-op:
#   - the job wears the designer role;
#   - its `## Follow-ups` section names a build (`build`, `builder`, `builds`);
#   - the report's FIRST PR citation (the same artifact auto-gauntlet-handoff.sh
#     chose) is the design PR: its PR-keyed gauntlet is either live with
#     `build_job: <job-base>` (just staged by this job) or already in tada/.
#
# Then, in order, it resolves the build successor:
#   1. orchestrated: an orchestration lists <job-base> as a child and the next
#      child is on the board. The orchestration owns the build; post nothing.
#   2. existing: the derived build base (`build-<slug>` for `design-<slug>`, else
#      `<job-base>-build`) is already on the board. Post nothing.
#   3. posted: the design gauntlet already finished `gauntlet-status: complete`,
#      so the prerequisite is satisfied: post the builder job to todo/.
#   4. recheck: the gauntlet is still running: park the builder job as a
#      `gate: blocked` plan with `blocked_on: <gauntlet-base>`. That is the typed
#      recheck: unblock.sh promotes it when the gauntlet lands in tada/, and holds
#      it with one maintainer notice if the gauntlet finishes failed.
# A finished gauntlet that is not `complete` (halted, not-viable, coalesced, held)
# gets no build: there is no reviewed design to build, and the normal follow-up
# gate decides the report.
#
# After a fresh board read confirms the successor (handoff_successor_posted), it
# appends one design-build handoff marker line to the report. The completion gate
# and the async follow-up sweep accept that marker as the follow-up disposition
# (design_build_handoff_verified). This is not the HANDED-OFF marker: the design
# deliverable is complete, and complete-job.sh must not record it as unfinished.
#
# Exit status: 0 on every path, including a failed post or an unavailable board.
# Without the marker, assert-followup-posted.sh applies its ordinary rules, so a
# transient failure here costs at most the retry the gate would have caused anyway.
#
# Pluggable for tests:
#   GARDEN_PRODUCER_CLONE              the journal clone read and posted to.
#   GARDEN_DESIGN_BUILD_POST_JOB       default $HERE/post-job.sh
#   GARDEN_DESIGN_BUILD_POST_PLAN      default $HERE/post-plan.sh

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG="design-build-handoff"

base="${1:?job basename}"
jobfile="${2:?job file}"
report="${3:?completion report}"
[ -f "$report" ] && [ -f "$jobfile" ] || exit 0

[ "$(plan_field "$jobfile" role)" = designer ] || exit 0
# A requeued completion already carries the marker; the gate re-verifies it.
report_design_build_handoff_successor "$report" >/dev/null 2>&1 && exit 0
# A report ending in a disposition signal has already disposed of itself, and
# that signal must stay its last line; appending a marker would hide it.
if report_handoff_successor "$report" >/dev/null 2>&1 \
   || report_has_orchestration_failure_marker "$report" \
   || report_has_orchestration_auth_unavailable_marker "$report"; then
  exit 0
fi

section="$(report_followups_section "$report" 2>/dev/null || true)"
followups_actionable "$section" || exit 0
printf '%s\n' "$section" | grep -Eqi '(^|[^[:alnum:]_-])build(er|s)?([^[:alnum:]_-]|$)' || exit 0

pr_url="$(extract_pr_refs_from_text "$report" | head -1 || true)"
[ -n "$pr_url" ] || exit 0
ref="$(parse_pr_ref "$pr_url")" || exit 0
repo="$(printf '%s' "$ref" | cut -f1)"
pr_number="$(printf '%s' "$ref" | cut -f2)"
gauntlet_base="${repo%/*}-${repo#*/}-pr${pr_number}-gauntlet"

DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
fresh_board() {
  ensure_clone "$DIR" >/dev/null 2>&1 && (sync_clone "$DIR") >/dev/null 2>&1
}
if ! fresh_board; then
  log "'$base': producer clone $DIR unavailable or stale; no design-build handoff (the follow-up gate decides)"
  exit 0
fi

# Recognize the design PR through the gauntlet this job's completion staged.
prereq=""
gauntlet_rec="$DIR/$JOBS_GAUNTLET/$gauntlet_base.md"
if [ -f "$gauntlet_rec" ]; then
  [ "$(plan_field "$gauntlet_rec" build_job)" = "$base" ] || exit 0
  prereq=pending
elif tada_rel="$(tada_find "$DIR" "$gauntlet_base" 2>/dev/null)"; then
  if [ "$(plan_field "$DIR/$tada_rel" gauntlet-status)" != complete ] \
     || tada_failed "$DIR/$tada_rel"; then
    log "'$base': design gauntlet '$gauntlet_base' finished without passing; no build dispatched"
    exit 0
  fi
  prereq=satisfied
else
  exit 0
fi

record() {  # <successor> <state>
  if ! handoff_successor_posted "$DIR" "$1"; then
    log "'$base': build successor '$1' ($2) is not visible on the board; no marker written"
    exit 0
  fi
  printf '\n%s successor=%s state=%s pr=%s -->\n' \
    "$GARDEN_DESIGN_BUILD_HANDOFF_MARKER_PREFIX" "$1" "$2" "$pr_url" >>"$report"
  log "'$base': design $pr_url hands its build to '$1' ($2)"
  exit 0
}

# 1. The design's orchestration already owns its build as a later child.
for orch in "$DIR/$JOBS_ORCH"/*.md; do
  [ -f "$orch" ] || continue
  # shellcheck disable=SC2207
  children=($(plan_field "$orch" children))
  for i in "${!children[@]}"; do
    [ "${children[$i]}" = "$base" ] || continue
    next="${children[$((i + 1))]:-}"
    [ -n "$next" ] && handoff_successor_posted "$DIR" "$next" \
      && record "$next" "orchestrated:$(basename "$orch" .md)"
  done
done

# 2. A build job under the derived name already exists.
case "$base" in
  design-?*) build_base="build-${base#design-}" ;;
  *) build_base="$base-build" ;;
esac
handoff_successor_posted "$DIR" "$build_base" && record "$build_base" existing

# 3./4. Post the build: queued when the design passed review, else parked on it.
body="$(mktemp "${TMPDIR:-/tmp}/garden-design-build.XXXXXX")"
trap 'rm -f "$body"' EXIT
arc="$(job_arc "$jobfile" 2>/dev/null || true)"
# shellcheck disable=SC2016  # backticks are Markdown, not expansions
{
  printf -- '---\nrole: builder\n'
  [ -z "$arc" ] || printf 'arc: %s\n' "$arc"
  printf 'dispatch: automatic\n---\n'
  printf '# Build: the design in %s#%s\n\n' "$repo" "$pr_number"
  printf 'Repo: https://github.com/%s. Design PR: %s.\n\n' "$repo" "$pr_url"
  printf 'Build exactly the design produced by the completed designer job `%s` (its report is in `jobs/tada/`). ' "$base"
  printf 'Base the implementation on the merged design or the design branch, as the project convention requires; weave onto the live base first if it moved. '
  printf 'Open a DRAFT PR: completion stages its gauntlet. Report a gap rather than weaken a property the design requires.\n\n'
  printf 'Dispatched by design-build-handoff.sh from the design report'"'"'s follow-ups:\n\n'
  printf '%s\n' "$section" | sed 's/^/> /'
} >"$body"

if [ "$prereq" = satisfied ]; then
  state=posted
  post=("${GARDEN_DESIGN_BUILD_POST_JOB:-$HERE/post-job.sh}" "$build_base" "$body")
else
  state="recheck:$gauntlet_base"
  post=("${GARDEN_DESIGN_BUILD_POST_PLAN:-$HERE/post-plan.sh}" --blocked
        --blocked-on "$gauntlet_base" --role builder --by design-build-handoff
        "$build_base" "$body")
  [ -z "$arc" ] || post=("${post[0]}" --arc "$arc" "${post[@]:1}")
fi
if ! GARDEN_SENDER="design-build-handoff:$base" "${post[@]}" >/dev/null 2>&1; then
  log "'$base': posting build '$build_base' ($state) failed; no marker written"
  exit 0
fi
fresh_board || { log "'$base': posted '$build_base' but could not re-read the board; no marker written"; exit 0; }
record "$build_base" "$state"
