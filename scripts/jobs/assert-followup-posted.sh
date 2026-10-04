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
# assert-producer-pr-draft.sh: gardener.sh calls it right before a job may be
# recorded complete, and a non-zero exit is treated exactly like a failed handoff
# — the job stays in doin and the reaper retries — forcing a correction rather
# than a silent miss. Fully deterministic, NO LLM: the report's own text plus
# trusted board/inbox state only.
#
# Usage: assert-followup-posted.sh <base> <job-file> <completion-report>
#   rc 0: no declared handoff and nothing owed — no substantive `## Follow-ups`
#         section; a declared handoff / substantive section has a valid, CHECKABLE
#         disposition (a verified handoff, a maintainer-inbox message actually
#         sent, an explicit override, or one deterministically identifiable
#         successor newly posted after this job's first claim); the section is
#         purely INFORMATIONAL (a completed gauntlet stage's driver-owned
#         transition, a gauntlet stage's structured failed-stage disposition
#         that the driver halts on, a section that only surfaces an already-raised
#         maintainer decision closed for the fleet, or one that repeats a matching
#         notified gauntlet review-budget terminal); or the determination is
#         inconclusive (journal clone unavailable, or its sync failed so the
#         board state it would read is stale).
#   rc 1: a declared handoff names an absent successor, regardless of whether a
#         `## Follow-ups` section exists; or a substantive follow-up section has
#         NO checkable disposition and either prescribes fleet work or could not
#         be durably escalated — block completion (leave in doin for retry).
#
# The four accepted dispositions:
#   1. HANDOFF   — the report ends with <<<GARDEN-JOB-HANDED-OFF: successor>>> AND
#      that successor is durably posted on the board (handoff_successor_posted,
#      the SAME existence check complete-job.sh --handed-off enforces; a pending
#      one-time `schedules/*.md` record whose `once:` dispatch names exactly that
#      successor counts too, for a deployment-gated deferred retry). Checked
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
#   4. INFERRED HANDOFF: after the first durable claim of this job, exactly one
#      board identity was newly posted and the report says it posted work, OR one
#      of several new identities is named literally in the report. The gate adds
#      the ordinary handoff marker to the report, so gardener.sh and
#      complete-job.sh verify and record the same successor. Pre-existing and
#      ambiguous candidates never pass.
#
# A fifth, gate-authored disposition: AUTO-ESCALATION. When none of the above
# hold and the section prescribes no board-postable fleet work
# (followups_prescribe_fleet_work), the gate itself sends the section to the
# maintainer inbox (coalesced, reply_to=<base>) and passes only after a fresh
# board read shows that message. A failed send or unverified write blocks.
#
# Four INFORMATIONAL carve-outs additionally pass without a worker-authored
# disposition, because they name no owed successor work (all deterministic and
# deliberately narrow; the first, third, and fourth are shared with the async sweep via
# common.sh):
#   - a completed gauntlet stage's driver-owned transition
#     (gauntlet_driver_owns_followups);
#   - a gauntlet clean/fix child's structured failed-stage disposition, where the
#     job metadata, the exact `<stage>=still-pending` marker, and the
#     orchestration-failure marker all agree (gauntlet_failed_stage_driver_owned):
#     the child settles failed and gauntlet.sh halts and notifies on it; and
#   - a section that ONLY surfaces an already-raised maintainer decision presented
#     as closed for the fleet (followups_only_surface_decision) — a status-report
#     or decision-gated job whose sole "follow-up" is a decision already in front
#     of the maintainer. Grounding: the accepted #1310 status-report directive was
#     wrongly blocked here for want of a checkable disposition and duplicate-retried;
#     and
#   - a section that only repeats a named gauntlet's `review-budget-reached`
#     terminal state when the matching coalesced gauntlet notice is already in the
#     maintainer inbox (followups_only_repeat_gauntlet_review_budget_notice).
#
# Fail-toward-not-wedging on an INCONCLUSIVE read (journal clone unavailable, or a
# failed sync that leaves only stale board state): rc 0
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
jobfile="${2:?job file}"
report="${3:?completion report}"
[ -f "$report" ] || exit 0

# 1. HANDOFF — a declared handoff is itself unfinished-work intent, independent
#    of report prose or headings. Verify it before the follow-up-section fast
#    path so an absent `## Follow-ups` section cannot bypass the durable-successor
#    gate. The board read remains fail-open when inconclusive during an outage.
DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"

# Refresh the producer clone, or FAIL OPEN. A board read from a clone whose sync
# failed is stale, so neither a pass nor a block derived from it is trustworthy:
# the grounding incident blocked a handoff at 16:12:52 whose successor (a one-time
# schedule) had been committed at 16:11:55, because the sync failure was discarded
# with `|| true` and the stale clone lacked the record. sync_clone may return
# non-zero, `exit` EX_TEMPFAIL on an outage, or `die`, any of which would end this
# script from a bare call, so run it in a subshell and treat every failure as
# inconclusive: log a diagnostic and pass. The async follow-up sweep is the backstop.
sync_or_fail_open() {
  local out rc
  if out="$( (sync_clone "$DIR") 2>&1 >/dev/null)"; then
    return 0
  else
    rc=$?
  fi
  out="$(printf '%s\n' "$out" | grep . | tail -3 | tr '\n' ' ' || true)"
  log "gate: producer clone $DIR sync failed (rc=$rc${out:+: $out}); board state may be stale; inconclusive, not blocking '$base'"
  exit 0
}
if successor="$(report_handoff_successor "$report" 2>/dev/null)"; then
  if ! ensure_clone "$DIR" 2>/dev/null; then
    log "gate: producer clone $DIR unavailable; inconclusive, not blocking '$base'"
    exit 0
  fi
  sync_or_fail_open
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

# A completed gauntlet stage does not post its driver-owned successor (the next
# panel after clean/fix, or the fix stage after a must-fix panel). The durable
# gauntlet record and deterministic driver own that transition. Treat a section
# that says only that as informational, while leaving any additional successor
# work subject to the dispositions below.
if gauntlet_driver_owns_followups "$report" "$section"; then
  exit 0
fi

# A gauntlet clean/fix child that declared its stage failed (red CI) must settle
# as failed so the driver halts the gauntlet and notifies the maintainer. Any
# CI investigation it describes is the halt's to surface, not a successor the
# child must post; blocking it left the gauntlet waiting on a child that could
# never complete. Requires job metadata, stage marker, and failure marker to agree.
if gauntlet_failed_stage_driver_owned "$base" "$jobfile" "$report"; then
  log "gate: '$base' declared a failed gauntlet stage; the driver owns the halt and its notification, not blocking"
  exit 0
fi

# A status-report / decision-gated job whose entire follow-up section only notes
# that the sole outstanding item is a MAINTAINER decision ALREADY surfaced to the
# maintainer and presented as CLOSED for the fleet owes no successor: there is no
# fleet-actionable job to post (not a handoff), the decision is already in front
# of the maintainer (not an inbox message), and it is a real disposition (not an
# override escape). Treat it as informational, exactly as the driver-owned
# transition above. Deliberately narrow (three co-occurring anchors + a
# prescriptive-work negative guard); any owed fleet work beside it stays subject
# to the dispositions below. Grounding: the accepted #1310 status-report directive
# was wrongly blocked here and duplicate-retried.
if followups_only_surface_decision "$section"; then
  log "gate: '$base' follow-up section only surfaces an already-raised maintainer decision, closed for the fleet; informational, not blocking"
  exit 0
fi

# 3. OVERRIDE — an explicit, named safety valve, checked from the report text
#    alone (no clone needed) so a false positive can never wedge even during an
#    outage.
if reason="$(report_followup_override_reason "$report" 2>/dev/null)"; then
  log "gate: '$base' declares a follow-up-gate override ($reason); not blocking"
  exit 0
fi

# 4. Board-backed dispositions need board/inbox state. Read the producer clone the worker just
#    posted to. An unreachable clone is INCONCLUSIVE: pass rather than wedge (the
#    async sweep is the backstop).
if ! ensure_clone "$DIR" 2>/dev/null; then
  log "gate: producer clone $DIR unavailable; inconclusive, not blocking '$base'"
  exit 0
fi
sync_or_fail_open

# A downstream job may accurately repeat that its named predecessor gauntlet
# exhausted the review budget and left a human merge/review decision. gauntlet.sh
# already sent that decision through a stable, coalesced maintainer notice. Match
# the section to that exact structured notice; this is informational, not a
# second inbox obligation from the downstream job.
if followups_only_repeat_gauntlet_review_budget_notice "$DIR" "$section"; then
  log "gate: '$base' follow-up section repeats a matching notified gauntlet review-budget terminal; informational, not blocking"
  exit 0
fi

# 4. INBOX — the checkable non-board-postable disposition: a maintainer-inbox
#    message the worker actually sent, tagged reply_to=<base>.
if maintainer_message_from "$DIR" "$base"; then
  exit 0
fi

# 5. INFERRED HANDOFF: recover the common honest-reporting mistake where the
# worker posted its successor and described that fact, but omitted the exact
# handoff marker. Anchor "new" to this job's FIRST durable claim, not its latest
# retry: a gate-blocked attempt may be reaped and claimed again after the
# successor was posted, and using the latest claim would recreate the retry loop
# this recovery path exists to stop.
#
# A literal candidate basename in the report disambiguates concurrent posts. If
# no basename is named, accept only a single new candidate and only when the
# follow-up section itself says work was posted/parked/staged. Merely saying a job
# is needed or warranted must not capture an unrelated concurrent board post.
section_claims_posted() {
  printf '%s\n' "$section" | grep -Eqi \
    '(^|[^[:alpha:]])(post(ed|ing)?|park(ed|ing)?|stag(ed|ing)?)([^[:alpha:]]|$)'
}
claim_commit="$(
  git -C "$DIR" log --format=%H --diff-filter=A -- "work/$base" 2>/dev/null \
    | tail -1
)"
if [ -n "$claim_commit" ]; then
  board_identities_at() { # <git-ref>
    git -C "$DIR" ls-tree -r --name-only "$1" -- \
      "$JOBS_PLAN" "$JOBS_TODO" "$JOBS_DOIN" "$JOBS_TADA" "$JOBS_ORCH" "$JOBS_GAUNTLET" \
      2>/dev/null \
      | awk -F/ '
          $NF == ".gitkeep" || $NF !~ /[.]md$/ { next }
          $2 == "plan" || $2 == "todo" || $2 == "doin" || $2 == "orch" || $2 == "gauntlet" {
            if (NF == 3) { sub(/[.]md$/, "", $NF); print $NF }
            next
          }
          $2 == "tada" { sub(/[.]md$/, "", $NF); print $NF }
        ' \
      | sort -u
  }

  before="$(board_identities_at "$claim_commit")"
  after="$(board_identities_at HEAD)"
  candidates="$(comm -13 <(printf '%s\n' "$before") <(printf '%s\n' "$after") | grep -vxF "$base" || true)"
  named=""
  while IFS= read -r candidate; do
    [ -n "$candidate" ] || continue
    if grep -Fq -- "$candidate" "$report"; then
      named="${named}${named:+$'\n'}$candidate"
    fi
  done <<< "$candidates"

  successor=""
  if [ "$(printf '%s\n' "$named" | grep -c . || true)" -eq 1 ]; then
    successor="$named"
  elif [ -z "$named" ] \
    && [ "$(printf '%s\n' "$candidates" | grep -c . || true)" -eq 1 ] \
    && section_claims_posted; then
    successor="$candidates"
  fi

  if [ -n "$successor" ] && handoff_successor_posted "$DIR" "$successor"; then
    printf '\n%s %s>>>\n' "$GARDEN_HANDOFF_MARKER_PREFIX" "$successor" >> "$report"
    log "gate: '$base' omitted its handoff marker; inferred and recorded newly posted successor '$successor'"
    exit 0
  fi
fi

# 6. AUTO-ESCALATION: a section that prescribes no board-postable fleet work
# (unassigned findings, telemetry, an open question) has no successor to post.
# Blocking it only re-runs the job. Grounding: a worker reported unassigned
# telemetry findings and messaged its supervisor at 06:35:15Z; this gate blocked
# it here for want of a disposition and the job was retried at 06:35:51Z. Route the parsed
# section to the maintainer inbox ourselves, tagged reply_to=<base>, under a
# stable coalescing key so a requeued completion amends one entry. Accept only
# once a FRESH board read shows the message (the INBOX disposition's own check);
# any send or verification failure falls through to the block. Prescribed fleet
# work (a job "warranted", "post a shepherd", "then conduct") still blocks: it
# must be posted, not described. So does a section claiming it posted, parked,
# or staged work the gate could not identify: that is an unverified handoff.
escalate_followups() {
  local body rc=0
  body="$(mktemp "${TMPDIR:-/tmp}/followup-gate-escalation.XXXXXX")"
  {
    printf 'Job "%s" completed with a `## Follow-ups` section that names no posted successor, no maintainer message, and no override. The section prescribes no board-postable fleet work, so the completion gate forwarded it here for disposition instead of retrying the job.\n\n' "$base"
    printf '## Follow-ups\n%s\n' "$section"
  } > "$body"
  GARDEN_MSG_COALESCE=1 \
  GARDEN_MSG_ID="followup-gate-$base" \
  GARDEN_SENDER="followup-gate:$base" \
  GARDEN_SKIP_REF_CHECK=1 \
    "${GARDEN_FOLLOWUP_GATE_MESSAGE_USER:-$HERE/message-user.sh}" "$base" "$body" >/dev/null 2>&1 || rc=$?
  rm -f "$body"
  if [ "$rc" -ne 0 ]; then
    log "gate: '$base' maintainer-inbox escalation failed (rc=$rc)"
    return 1
  fi
  if ! (sync_clone "$DIR") >/dev/null 2>&1; then
    log "gate: '$base' escalation sent but the producer clone failed to re-sync; durability unverified"
    return 1
  fi
  if ! maintainer_message_from "$DIR" "$base"; then
    log "gate: '$base' escalation reported success but no reply_to=$base message is on the board"
    return 1
  fi
  return 0
}
if ! followups_prescribe_fleet_work "$section" && ! section_claims_posted \
  && escalate_followups; then
  log "gate: '$base' follow-up section prescribes no fleet work; escalated it durably to the maintainer inbox (reply_to=$base), not blocking"
  exit 0
fi

log "gate: BLOCK — '$base' completion report describes a substantive follow-up but has no unambiguous checkable disposition: no declared or deterministically identifiable newly posted successor, no maintainer-inbox message, and no override. Refusing to record complete: post the follow-up and re-report with --handed-off, route it to the inbox (message-user.sh), or set the override marker with a reason."
exit 1
