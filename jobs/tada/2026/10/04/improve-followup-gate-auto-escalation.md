## Completion report: improve-followup-gate-auto-escalation

The follow-up gate no longer sends a job back for a retry just because its report lists findings nobody owns. It now forwards that section to the maintainer inbox and accepts the job only after the message is confirmed on the board. If the forward fails, the job stays blocked. The full gate test passes, before and after rebasing. Pushed to `main2` as `9d25d153e73`.

**What happens now** (`scripts/jobs/assert-followup-posted.sh`): when no other accepted disposition applies and the section asks for no new fleet work, the gate:
- sends the parsed `## Follow-ups` section through `message-user.sh`, tagged `reply_to=<base>`, under the stable coalescing key `followup-gate-<base>`, so a retried completion updates one inbox entry instead of adding another;
- re-reads the board and checks for the message with `maintainer_message_from` before accepting;
- keeps the block if the send fails, the re-read fails, or the message isn't there.

**One judgment call:** this does not apply to every blocked report. Two kinds still block exactly as before, because the maintainer's rule is that follow-up work must be posted, not just described:
- **Sections that ask for fleet work.** Examples: "a conductor job is warranted", "post a shepherd", "then conduct", or a list item starting with a command like "- Conduct next." or "- Investigate …".
- **Sections that claim the worker posted, parked, or staged a successor the gate can't find.** That is an unverified handoff, not an unowned finding.

**Supporting changes:**
- **`common.sh`:** the "asks for fleet work" check is now one shared helper, `followups_prescribe_fleet_work`, used both by the existing "decision already raised" exception and by the new escalation. I added the list-item command-verb check to it, which also makes that exception slightly stricter. Wrapped continuation lines (e.g. "  merge decision is …") don't count, so the existing #1310 status-report case still passes.
- **`gardener.sh`:** comment updated to describe the new behavior.
- **`followup-posted-gate-test.sh`:**
  - New cases: blocks when the send fails; blocks when the sender reports success but nothing reaches the board; the unassigned-telemetry case escalates once and a retry doesn't create a second entry; requested fleet work is never escalated.
  - The old "decision not yet raised with the maintainer" test (h3) now checks that it blocks without escalation and is forwarded with it.
  - A few tests of the other exceptions (f4, f5b, h6) now run with escalation turned off, so they still test only those exceptions.

**Follow-ups:**
- Reports escalated this way still land in the completed-jobs folder, and the background follow-up sweep may read them again. That double-handling already happened for reports where the worker messaged the maintainer itself, so nothing new, but the sweep could skip any report with a `reply_to=<base>` inbox entry. Not done here.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-followup-gate-auto-escalation.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 54 tokens (2544747 cached reads)
- Output: 19550 tokens
- Cost: $1.8082854000000002
- Wall-clock: 319s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
