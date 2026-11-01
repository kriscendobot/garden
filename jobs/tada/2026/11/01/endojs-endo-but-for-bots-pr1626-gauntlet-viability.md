Viability for endojs/endo-but-for-bots#1626 is **proceed**. I only read PR facts and spent nothing on clean, panel, fix, CI-wait or un-draft.

**PR facts:** #1626 is OPEN, draft and unmerged, with no reviews or comments yet; it was opened at 2026-11-01T18:03:46Z. Its base is the frozen branch `build/exo-agent-factory-stack-merge-790f436`, and the head is 2 commits ahead and 0 behind it.

**Deciding question:** Is #1626 still the only change that makes inference-backed `@endo/exo-agent-factory` children run on a real daemon, by fixing the three defects found when the #1562 and #1564 stacks run together? Those defects are the `ChildInference` exo that daemon `storeValue` can't store, the ledger calling `.next()` on an exo-stream reader, and the runner exiting before the child is active.

**Evidence:**
- The whole stack the PR builds on is still open and unmerged: #1558 (design), #1560, #1561, #1562, #1563 and #1564.
- `packages/exo-agent-factory` does not exist on `llm` (the contents API returns 404). Nothing upstream has landed this composition or these fixes, so the premise holds: nothing runs the two halves together yet.
- The only newer PR in the package is #1625, opened two minutes earlier. It works on a different part of the code: `coordinator.js` and `interfaces.js`, adding the coordinator facet for durable facet formulas on top of #1560. It does not touch `inference-adapter.js`, `inference-driver.js` or `turn-ledger.js`, so it complements #1626 rather than displacing it.
- I checked #1573 (a hosted-agent inference provider registry) because its name sounded close. It is a different package and does not replace this work.
- The design's phase ledger still lists this as the open composition step on the `minion-town-claude-api` arc.

I made no changes and opened no follow-up jobs. Merge order matters: #1626 can only land after #1562 and #1564 (and what they sit on), and its base will need re-pointing once they merge.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1626-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (243753 cached reads)
- Output: 2031 tokens
- Cost: $0.4822186
- Wall-clock: 33s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
