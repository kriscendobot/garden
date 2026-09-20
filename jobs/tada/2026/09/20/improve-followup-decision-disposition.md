Inbox empty. Work is complete.

## Completion report

**Job:** Make `scripts/jobs/assert-followup-posted.sh` recognize a Follow-ups section that only presents an already-surfaced maintainer decision as closed, rather than forcing a new handoff or override — the miss that blocked the accepted #1310 status-report directive and caused a duplicate retry.

**Root cause.** The completion gate blocked any substantive `## Follow-ups` section that lacked a *checkable* disposition (handoff / override / inbox). A status-report/decision-gated job whose only follow-up noted that the sole outstanding item is a maintainer decision **already surfaced** to the maintainer (e.g. "decision-gated on the maintainer's already-live merge/review call; nothing for the fleet") had no fitting disposition — no successor to hand off, no inbox message owed (the decision is already in front of the maintainer), and it's a legitimate disposition, not a false-positive override. So it was refused, left in `doin`, and the reaper retried it.

**Change (4 files, all on `main2`):**
- `common.sh`: new deterministic recognizer `followups_only_surface_decision`. Fires only when three anchors co-occur in the normalized section — (1) the outstanding item is a *maintainer decision/call*, (2) it is *already surfaced*, (3) it is *closed for the fleet* — **and** a prescriptive-new-fleet-work negative guard finds nothing. Mirrors the narrow style of `gauntlet_driver_owns_followups`.
- `assert-followup-posted.sh`: wired the recognizer in as a fourth, **informational** carve-out beside the gauntlet-driver one; updated the header/rc-0 docs.
- `follow-up.sh`: same predicate added to the async sweep's actionability test, so the gate and the sweep can never disagree.
- `followup-posted-gate-test.sh`: added cases (h)–(h4) — the #1310 shape and the "already satisfied / nothing further" phrasing PASS; a *not-yet-surfaced* "maintainer must decide" (owes inbox) and *owed fleet work buried beside* a surfaced decision (pr876 shape) still BLOCK.

**Verification.** Full gate test suite passes (exit 0, 0 FAILs). `shellcheck -x` on all three scripts shows only pre-existing info-level notes; `bash -n` on `common.sh` clean.

**Follow-ups.** None. The change is self-contained; no successor work is owed. (This report has no `## Follow-ups` section by design.)
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-followup-decision-disposition.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 72 tokens (2686022 cached reads)
- Output: 29585 tokens
- Cost: $3.3109579999999994
- Wall-clock: 450s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
