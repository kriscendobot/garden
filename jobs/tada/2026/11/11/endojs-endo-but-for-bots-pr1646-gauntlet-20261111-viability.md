**Viability report: endojs/endo-but-for-bots#1646, "chore(ci): pin .node-version to 24"**

The PR is open and unmerged, still a draft, with head `224852cb`, on base `llm-48d6f3e`. The gauntlet can start.

Deciding question: Is `llm` still on `.node-version` = `lts/*` and still failing test-xs under Node 26, with no other fix (a pin, a hardened262 baseline update, or an SES repair) landed or open?

Evidence:
- **Premise still holds.** `.node-version` on `llm` still reads `lts/*`. It was last changed in 01bbaccc1f on 2026-05-20, so nobody has pinned it since.
- **`llm` is still red.** Its tip is 48d6f3e, the same commit as this PR's base. Its latest CI run (41370492445) still has test-xs failing (job 125718398161), which is the failure the PR body describes.
- **Not superseded.** No commits have touched `packages/hardened262` on `llm` since 2026-11-02, so the baseline hasn't been re-stamped. Searching PRs for ThrowTypeError, node-version and Node 26 found no competing pin or Node-26 compatibility fix. #1076 is an older, closed pin-metadata test and doesn't address this.
- **The fix works.** The PR's latest CI run (41584227374) has test-xs passing in 8m50s and build-xsnap passing. Every check is pass (13) or skipping (10), with no failures.
- **The earlier halt is out of date.** The terminal comment from 2026-11-03 reported "CI: red" and a halted clean stage. CI is green now, so that halt reason no longer applies to the PR's current state.

I made no changes and spent no clean, panel, fix or CI-wait budget.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1646-gauntlet-20261111-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (310458 cached reads)
- Output: 1973 tokens
- Cost: $0.4894476
- Wall-clock: 60s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
