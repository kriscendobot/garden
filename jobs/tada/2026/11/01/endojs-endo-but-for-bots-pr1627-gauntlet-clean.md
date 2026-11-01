**Clean stage for endojs/endo-but-for-bots#1627 is done: CI is green at the new head `0f7df61459` (34 checks, 0 failed).**

**Why CI was red.** Only the `lint` check failed, on a Prettier warning in `packages/exo-agent-factory/test/adapters.test.js`. #1627 doesn't touch that file. The problem came from its stacked parent PR #1626 (commit `5842e0ca91`), which is the commit the old frozen base `build/exo-agent-factory-durable-inference-driver-5842e0c` pointed at. #1626 has since fixed it with a formatting-only commit, `7a1feb30f5`.

**What I did:**
- **New base:** created a frozen-base branch `build/exo-agent-factory-durable-inference-driver-7a1feb3` at #1626's current head, following the frozen-base skill's steps for stacked PRs.
- **Rebase:** moved #1627's single commit onto that base with no conflicts, since the two PRs touch different files. The PR's diff is unchanged: 2 files, +111/−1.
- **Push:** force-pushed the head with `safe-push-pr-head.sh --mode rewrite` (`a5b9c94a87` → `0f7df61459`) and changed the PR's base to the new branch.
- **Lint:** before pushing, ran Prettier on the package's tests (clean) and ESLint on the touched files. ESLint reported no errors, only a warning that was already there before this PR (`@ts-nocheck` on line 1 of `daemon.test.js`).
- **Coverage and dead code:** this PR only adds a test, and its new helper `_daemon-crash-maker.js` is used by that test. Nothing is left orphaned and there was nothing to remove.

**Follow-ups:**
- The old base branch `build/exo-agent-factory-durable-inference-driver-5842e0c` is no longer used by #1627. The sweep that runs when the PR closes (`sweep-frozen-bases.sh`) will delete it.
- If #1626's head moves again, #1627 will need another re-pin before it merges.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1627-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (991398 cached reads)
- Output: 5541 tokens
- Cost: $0.7704915999999998
- Wall-clock: 668s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
