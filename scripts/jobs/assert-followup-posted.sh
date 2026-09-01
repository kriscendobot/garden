#!/bin/bash
# assert-followup-posted.sh — DETERMINISTIC completion-time GATE that a described
# follow-up was POSTED before the job settles, never merely described.
#
# The grounding incidents (two, the same day): `endojs-endo-but-for-bots-pr910-
# shepherd` completed with "the maintainer's most recent comment is 'Conduct.' —
# that is a conductor job, not this shepherd's scope" and settled WITHOUT posting
# one; the already-parked orchestrated conductor child then sat unpromoted for 5
# days. `endojs-endo-but-for-bots-pr876-rebase` completed with "a fresh shepherd
# and then conduct are warranted now" and settled WITHOUT posting either. Both
# used bold-prose headers ("**Follow-up:**"), not the canonical `## Follow-ups`
# heading, so even the async garden-follow-up sweep (~10m cadence, scans
# jobs/tada/*.md for that exact heading) silently missed them.
#
# The maintainer's standing requirement, stated directly: any follow-up job must
# be POSTED before a task settles, never merely described. A 10-minutes-later
# async sweep is a backstop for the genuinely-not-board-postable case (a
# maintainer-judgment call routed to the inbox), not the primary mechanism.
#
# This gate is the primary mechanism, structurally mirroring
# assert-design-pr-gauntlet.sh: gardener.sh calls it right before a job may be
# recorded complete, and a non-zero exit is treated exactly like a failed handoff
# — the job stays in doin and the reaper retries — forcing a correction rather
# than a silent miss. Fully deterministic, NO LLM: the report's own text plus
# trusted board/inbox state only.
#
# Usage: assert-followup-posted.sh <base> <job-file> <completion-report>
#   rc 0: no declared handoff and nothing owed — no substantive `## Follow-ups`
#         section; or a declared handoff / substantive section has a valid,
#         CHECKABLE disposition (a verified handoff, a maintainer-inbox message
#         actually sent, or an explicit override); or the determination is
#         inconclusive (journal clone offline).
#   rc 1: a declared handoff names an absent successor, regardless of whether a
#         `## Follow-ups` section exists; or a substantive follow-up section has
#         NO checkable disposition — block completion (leave in doin for retry).
#
# The three accepted dispositions:
#   1. HANDOFF   — the report ends with <<<GARDEN-JOB-HANDED-OFF: successor>>> AND
#      that successor is durably posted on the board (handoff_successor_posted,
#      the SAME existence check complete-job.sh --handed-off enforces). Checked
#      first and unconditionally because the marker itself declares unfinished
#      work, even when the report has no `## Follow-ups` section.
#   2. OVERRIDE  — the report carries a standalone
#        <<<GARDEN-FOLLOWUP-GATE-OVERRIDE: reason>>>
#      line. The safety valve: a report mentioning a follow-up in passing (not as
#      unfinished chained work) declares that with a one-line reason, so a
#      false-positive detection can never wedge a job forever. Read the same
#      deliberate way orchestration-failed / deliverable-complete are — a named
#      signal, not free prose.
#   3. INBOX     — a maintainer-inbox message tagged reply_to=<base> exists
#      (the worker actually ran message-user.sh), the checkable form of the
#      non-board-postable disposition.
#
# Fail-toward-not-wedging on an INCONCLUSIVE read (journal clone offline): rc 0
# rather than block a completion on a transient blip. The async garden-follow-up
# sweep remains the backstop, and a genuine miss re-surfaces on the next claim; a
# wedged completion during an outage would be worse. The gate bites ONLY on a
# POSITIVE substantive-follow-up + POSITIVE no-disposition determination.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG="assert-followup-posted"

base="${1:?base}"
# shellcheck disable=SC2034 # Retained positional API: complete-job passes its job file.
jobfile="${2:?job file}"
report="${3:?completion report}"
[ -f "$report" ] || exit 0

# 1. HANDOFF — a declared handoff is itself unfinished-work intent, independent
#    of report prose or headings. Verify it before the follow-up-section fast
#    path so an absent `## Follow-ups` section cannot bypass the durable-successor
#    gate. The board read remains fail-open when inconclusive during an outage.
DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
if successor="$(report_handoff_successor "$report" 2>/dev/null)"; then
  if ! ensure_clone "$DIR" 2>/dev/null; then
    log "gate: producer clone $DIR unavailable; inconclusive, not blocking '$base'"
    exit 0
  fi
  sync_clone "$DIR" >/dev/null 2>&1 || true
  if handoff_successor_posted "$DIR" "$successor"; then
    exit 0
  fi
  log "gate: BLOCK — '$base' declares handoff to '$successor' but that successor is not durably posted on the board; leaving in doin for retry"
  exit 1
fi

# 2. Is there a substantive follow-up section at all? Most jobs have none, or a
#    trivially-empty "None." — the gate is a no-op for them, provided they did
#    not declare a handoff above.
section="$(report_followups_section "$report" 2>/dev/null || true)"
if ! followups_actionable "$section"; then
  exit 0
fi

# 3. OVERRIDE — an explicit, named safety valve, checked from the report text
#    alone (no clone needed) so a false positive can never wedge even during an
#    outage.
if reason="$(report_followup_override_reason "$report" 2>/dev/null)"; then
  log "gate: '$base' declares a follow-up-gate override ($reason); not blocking"
  exit 0
fi

# 4. INBOX needs board/inbox state. Read the producer clone the worker just
#    posted to. An unreachable clone is INCONCLUSIVE: pass rather than wedge (the
#    async sweep is the backstop).
if ! ensure_clone "$DIR" 2>/dev/null; then
  log "gate: producer clone $DIR unavailable; inconclusive, not blocking '$base'"
  exit 0
fi
sync_clone "$DIR" >/dev/null 2>&1 || true

# 4. INBOX — the checkable non-board-postable disposition: a maintainer-inbox
#    message the worker actually sent, tagged reply_to=<base>.
if maintainer_message_from "$DIR" "$base"; then
  exit 0
fi

log "gate: BLOCK — '$base' completion report describes a substantive follow-up but posted no board job (no handoff), sent no maintainer-inbox message, and set no override. Refusing to record complete: post the follow-up and re-report with --handed-off, route it to the inbox (message-user.sh), or set the override marker with a reason."
exit 1
