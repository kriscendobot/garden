## Completion report: fix-gauntlet-stage-marker-completion-order

The fix is on main2 as `a4268c400d3`. Gauntlet stage jobs that end with the stage-result marker after the completion signal now count as complete, so they are no longer requeued until doomed. That was the pr174 panel-7 incident.

**What changed**
- **`scripts/jobs/gauntlet.sh`:** I reworded all five stage prompts (viability, clean, panel, fix, undraft). They now tell the worker to put exactly one stage-result marker on its own line just before the completion signal, with the completion signal staying the last line. Before, they said to put the marker on the "last line".
- **`scripts/jobs/common.sh`:**
  - `report_has_completion_marker` still accepts a report that ends with `<<<GARDEN-JOB-COMPLETE>>>`. It now also accepts the old ordering, where the last two non-blank lines are the completion marker and then one `<!-- gauntlet-stage-result: … -->` marker. This rescues stage bodies already posted and workers still on the old prompt.
  - `strip_completion_marker` cleans up the old ordering: it removes the completion marker and keeps the stage marker as the last line. `gauntlet.sh` finds the stage marker anywhere in the report, so it still reads it.
  - The forgery guard still holds. The check fails if prose sits between the completion marker and the stage marker, if two stage markers follow it, or if any other line follows it.
- **`scripts/jobs/test/completion-signal-test.sh`:** I added 8 checks to SUBTEST 1. They cover both orderings (detection and stripping), that a cleaned-up report no longer counts as complete, and the three forgery cases.

**Tests**
- All 19 checks in SUBTEST 1 of `completion-signal-test.sh` pass, including the 8 new ones.
- SUBTEST 2 onward fail: 10 failures, ending at SUBTEST 2I. Unchanged HEAD fails in exactly the same places, so my change did not cause them; they look like an environment problem when the suite runs inside a live gardener.
- `gauntlet-test.sh` passes (rc 0, 96 checks).

**Follow-up worth considering:** look into why `completion-signal-test.sh` SUBTEST 2 onward fails when run from inside a gardener job. Unchanged HEAD fails there too.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-gauntlet-stage-marker-completion-order.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (1025959 cached reads)
- Output: 8195 tokens
- Cost: $0.8922357999999999
- Wall-clock: 1075s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
