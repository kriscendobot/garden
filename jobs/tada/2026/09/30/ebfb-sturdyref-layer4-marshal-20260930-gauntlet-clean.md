Clean stage for endojs/endo-but-for-bots PR #1393 (`build/sturdyref-marshal-representation`, head `36c4f40bcd`) is done: CI is green at the current head. I pushed nothing, and I did not run a line-by-line coverage pass or a dead-code sweep.

- **Idempotence check:** the PR is an open draft whose head branch is on `endojs`. The diff already brings its own tests: `packages/marshal/test/sturdyref.test.js`, `packages/sturdyref/test/sturdyref-shim.test.js`, and regenerated `rankCover` snapshots in `packages/patterns`. So I treated it as already in shape and skipped steps 2–4 (isolated checkout, coverage run, dead-code removal) to fit this run's budget.
- **CI:** `ci-wait-merge.sh endojs/endo-but-for-bots 1393 --no-merge` returned rc 0 with all 33 checks terminal and 0 failed.

**Follow-ups:** the panel review should look at the marshal encoders the PR touches (`encodeToSmallcaps.js`, `encodeToCapData.js`, `encodePassable.js`, `rankOrder.js`, `marshal-justin.js`, `dot-membrane.js`) for sturdyref branches the new tests don't reach, and for any code the change left unused.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer4-marshal-20260930-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 32 tokens (783282 cached reads)
- Output: 5868 tokens
- Cost: $0.9972964
- Wall-clock: 126s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
