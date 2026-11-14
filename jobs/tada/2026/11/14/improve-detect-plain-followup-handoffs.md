The follow-up gate now catches a standalone `Follow-up:` line. Pushed to `main2` as `34b72683ba7`.

**The gap:** `report_followups_section` in `scripts/jobs/common.sh` only read text under a `## Follow-ups` heading. The weaver report for #1559 (2026-11-14T10:29:47Z) wrote `Follow-up: reweave #1590, then #1592, in stack order.` as a plain line, so the gate never saw it and the job settled with neither reweave posted.

**What changed:**
- **`common.sh`, `report_followups_section`:** it now also picks up standalone follow-up labels, both plain (`Follow-up:`, `Follow-ups:`, `Followup:`) and bold (`**Follow-up:**`). A label covers the rest of its line plus the lines after it, up to the next blank line or heading.
  - A label inside a fenced code block is ignored, and so is a passing mention in a sentence ("the follow-up gate passed").
  - Each block is checked for "None." on its own, so a `## Follow-ups / None.` section can't hide a real label later in the report.
  - The async follow-up sweep and the other callers use this same function, so they now agree on what counts as a follow-up.
- **`common.sh`, `followups_prescribe_fleet_work`:** `reweave` and `restack` now count as fleet-work verbs. Without this, the gate would have forwarded "reweave #1590" to the maintainer inbox instead of blocking until a successor job is posted.
- **`assert-followup-posted.sh`:** only the header comment and the escalation message changed. The rest of the gate (handoff, override, inbox, inferred handoff, escalation) runs unchanged on the wider input.
- **`followup-posted-gate-test.sh`:** I replaced the old (g) case, which deliberately expected bold `**Follow-up:**` to be ignored. New cases cover:
  - the exact #1559 report shape and the bold form, both of which now block;
  - a label with a posted successor, which passes;
  - "Follow-up: none.", a fenced label and a passing mention, which have no effect;
  - a "None." section followed by a real label, which blocks.

**Tests:** `followup-posted-gate-test`, `design-build-handoff-test`, `follow-up-gauntlet-budget-test`, `follow-up-design-build-recheck-test` and `follow-up-seen-cursor-test` all pass. The seen-cursor test only ran with `HOME=$TMPDIR`, because it creates its temp directory under `$HOME`, which is read-only in this sandbox. `bash -n` and shellcheck are clean.

**Follow-ups:**
- The reweaves of #1590 and #1592 in the original incident are still not posted; this job did not post them. If nobody has, they need a reweave job with a date suffix.
- Bold `**Follow-up:**` lines that used to be ignored now count, so reports written that way will start blocking or being forwarded to the maintainer inbox.
- `roles/COMMON.md` still prefers the `## Follow-ups` heading, and I left it as is.
- Hosts pick up the fix only after the next deploy.

<<<GARDEN-FOLLOWUP-GATE-OVERRIDE: the #1590/#1592 reweave note above is a pointer to the grounding incident's pending maintainer/liaison action, not this job's chained work>>>
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-detect-plain-followup-handoffs.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1362045 cached reads)
- Output: 11934 tokens
- Cost: $1.1492489999999997
- Wall-clock: 242s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
