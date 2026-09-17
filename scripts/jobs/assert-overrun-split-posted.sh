#!/bin/bash
# assert-overrun-split-posted.sh — completion gate for a reaper-routed split job.
#
# A deterministic ordinary-job wall overrun is re-posted under the same base with
# role=orchestrator. The handler may complete only after it has durably posted the
# named orchestration and declared that exact handoff. Multi-child records are the
# divisible disposition. A one-child record is the indivisible disposition and
# must carry a concrete reason plus an explicitly larger, claim-safe timeout in
# both the orchestration description and the child job.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG="assert-overrun-split"

base="${1:?base}"
jobfile="${2:?job file}"
report="${3:?completion report}"

[ "$(plan_field "$jobfile" split_eligible)" = true ] || exit 0
[ "$(plan_field "$jobfile" split_reason)" = deadline-overrun ] || exit 0
[ "$(plan_role "$jobfile" 2>/dev/null || true)" = orchestrator ] || exit 0

expected="$(plan_field "$jobfile" split_orchestration)"
prior_timeout="$(plan_field "$jobfile" split_source_handler_timeout)"
case "$expected" in ''|*/*|.*|-*) log "gate: BLOCK — '$base' has an invalid split_orchestration"; exit 1;; esac
[[ "$prior_timeout" =~ ^[1-9][0-9]*$ ]] \
  || { log "gate: BLOCK — '$base' has no valid split_source_handler_timeout"; exit 1; }

successor="$(report_handoff_successor "$report" 2>/dev/null || true)"
if [ "$successor" != "$expected" ]; then
  log "gate: BLOCK — '$base' must hand off to its deterministic split orchestration '$expected' (reported '${successor:-none}')"
  exit 1
fi

DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
if ! ensure_clone "$DIR" >/dev/null 2>&1 || ! sync_clone "$DIR" >/dev/null 2>&1; then
  # Completion itself performs the authoritative synced successor check and will
  # leave the job in doin on an outage. Do not turn that environmental state into
  # a deterministic split-shape failure here.
  log "gate: journal snapshot unavailable; split disposition inconclusive for '$base'"
  exit 0
fi

record="$DIR/$JOBS_ORCH/$expected.md"
if [ ! -f "$record" ]; then
  terminal="$(tada_find "$DIR" "$expected" 2>/dev/null || true)"
  if [ -n "$terminal" ] && grep -q '^orchestration-status:' "$DIR/$terminal"; then
    exit 0
  fi
  log "gate: BLOCK — '$base' named '$expected', but no active or completed orchestration record exists"
  exit 1
fi

children_text="$(orch_children "$record")"
read -r -a children <<<"$children_text"
if [ "${#children[@]}" -ge 2 ]; then
  exit 0
fi
if [ "${#children[@]}" -ne 1 ]; then
  log "gate: BLOCK — split orchestration '$expected' has no children"
  exit 1
fi

# A one-child campaign is allowed only as the explicit indivisible-leaf case.
reason="$(plan_field "$record" split-indivisible-reason)"
larger_timeout="$(plan_field "$record" split-indivisible-handler-timeout)"
case "$reason" in ''|too-large|'too large')
  log "gate: BLOCK — indivisible split '$expected' lacks a concrete split-indivisible-reason"
  exit 1
  ;;
esac
[[ "$larger_timeout" =~ ^[1-9][0-9]*$ ]] \
  || { log "gate: BLOCK — indivisible split '$expected' lacks a valid split-indivisible-handler-timeout"; exit 1; }
budget_max=$(( ${GARDEN_CLAIM_TTL:-14400} - ${GARDEN_HANDLER_KILL_AFTER:-60} - 1 ))
if [ "$larger_timeout" -le "$prior_timeout" ] || [ "$larger_timeout" -gt "$budget_max" ]; then
  log "gate: BLOCK — indivisible split '$expected' timeout $larger_timeout is not strictly larger than $prior_timeout within claim-safe max $budget_max"
  exit 1
fi

child="${children[0]}"
child_file=""
for lifecycle in "$JOBS_PLAN" "$JOBS_TODO" "$JOBS_DOIN"; do
  if [ -f "$DIR/$lifecycle/$child.md" ]; then child_file="$DIR/$lifecycle/$child.md"; break; fi
done
if [ -z "$child_file" ]; then
  # A completed child proves the already-driven orchestration was not a hollow
  # handoff; the active-record metadata above remains the disposition record.
  tada_find "$DIR" "$child" >/dev/null 2>&1 && exit 0
  log "gate: BLOCK — indivisible split child '$child' is absent from the board"
  exit 1
fi
child_timeout="$(plan_field "$child_file" handler-timeout)"
child_reason="$(plan_field "$child_file" split-indivisible-reason)"
if [ "$child_timeout" != "$larger_timeout" ] || [ "$child_reason" != "$reason" ]; then
  log "gate: BLOCK — indivisible child '$child' does not carry the orchestration's reason and larger timeout"
  exit 1
fi

exit 0
