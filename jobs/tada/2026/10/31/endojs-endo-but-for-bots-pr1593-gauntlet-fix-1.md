Round 1 needed no code change on PR #1593, and CI on the head (`d1f1cc58d9`) is green.

- **Finding:** the pre-pass flagged a bare `Far` in `packages/agent-tools/test/workspace.test.js`. The file at the PR head has no `Far`. It already builds its stand-ins with `makeExo` from `@endo/exo`, with an `M.interface` guard (the inert `grant` helper and `GitFixture`). I re-ran `prefer-endo-primitives.sh` against the PR's base commit and it passes (rc 0). So the finding was stale or already fixed, and I pushed nothing.
- **CI:** `ci-wait-merge.sh --no-merge` returned rc 0 (GREEN). All 36 checks finished with 0 failures, after about 5 minutes of waiting.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1593-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s) (1 unmetered)
- Input: 44 tokens (1293805 cached reads)
- Output: 7102 tokens
- Cost: $0.6361885 (1 engagement(s) unpriced)
- Wall-clock: 1673s

<!-- garden-usage-end -->
