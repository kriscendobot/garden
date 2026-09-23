Both test suites pass and the work is pushed to `main2`. 

## Completion report

Implemented a deterministic, no-LLM gate that refuses to record a gardener job complete while its report describes further necessary action it did not actually post. Motivated by two same-day misses: `endojs-endo-but-for-bots-pr910-shepherd` (described a needed conductor job, settled without posting one; the parked conductor child sat unpromoted for 5 days) and `endojs-endo-but-for-bots-pr876-rebase` (said a fresh shepherd then conduct were warranted, posted neither). Both used bold-prose headers invisible even to the async `garden-follow-up` sweep.

**What changed** (commit `b6a248123b`, pushed to `main2`):

1. **House-style rule** (`roles/COMMON.md` § House style): a report describing further necessary action uses the literal `## Follow-ups` / `## Follow-up` heading, never a bold-prose variant. Cross-linked to both deterministic consumers and cites both grounding incidents. This alone closes the async sweep's silent-miss gap.

2. **`scripts/jobs/assert-followup-posted.sh`** — new gate structurally mirroring `assert-design-pr-gauntlet.sh`. Wired into `gardener.sh` right before `doin->tada`; a non-zero exit is treated exactly like a failed handoff (job stays in `doin`, reaper retries). No-op unless the report carries a substantive `## Follow-ups` section, then requires one *checkable* disposition:
   - an explicit `<<<GARDEN-FOLLOWUP-GATE-OVERRIDE: reason>>>` marker (safety valve against false positives),
   - a verified handoff (reusing the **same** `handoff_successor_posted` existence check `complete-job.sh --handed-off` enforces — factored into `common.sh`, no reimplementation), or
   - an actual maintainer-inbox message tagged `reply_to=<base>` (checkable evidence the worker ran `message-user.sh`, not a bare prose claim).
   Fail-open (rc 0) on an offline clone, matching the gauntlet gate.

3. **Shared helpers in `common.sh`**: `report_followups_section` / `followups_actionable` (now used by both `follow-up.sh` and the gate so they can never disagree; the unified scan also now recognizes the singular `## Follow-up` the old sweep missed, and the null-signal set gained `nothing`), plus `handoff_successor_posted`, `maintainer_message_from`, and `report_followup_override_reason`.

4. **Regression test** `scripts/jobs/test/followup-posted-gate-test.sh`: block (substantive follow-up, no disposition); pass (verified handoff, orchestration record, real inbox message, override); the trivial-empty/absent-section no-op; plus negatives for a bare-prose inbox claim, an unposted handoff, and an empty-reason override. Verified passing; the existing design-PR gauntlet test still passes.

**On the judgment-call fork the job flagged:** the detection turned out to be a mechanical extension of the gauntlet-gate pattern, not a genuine design fork — "substantive" reuses the existing async-sweep null-signal convention, and the valid dispositions reuse the existing `--handed-off` verification plus a checkable inbox marker. No design handoff was needed.

## Follow-ups
None.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/assert-followup-posted-gate.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 103 tokens (5794620 cached reads)
- Output: 37967 tokens
- Cost: $5.041911000000001
- Wall-clock: 658s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
