Fix pushed (`1649db1691`) to PR #1588. CI is still pending at the end of my watch, so this round is not done.

- **Prepass fix:** `packages/http-confine/index.js` now uses a top-of-file `@import { … as …Type }` tag plus aliased `@typedef`s instead of the nine inline `import('./src/types.js')` typedefs. I did not run a type-check locally: the project checkout has no `node_modules` (`yarn install --immutable` failed during setup), so the fix is checked only by CI.
- **`packages/fetch/src/index.js`:** the two flagged lines were already fixed by the PR head commit `70d9f028ad`. I made no change there.
- **`packages/confined-fetch/src/index.js` advisory:** I left the 22-line header comment alone. It documents the module's contract (which powers it looks up and how revival works), not narration of adjacent code.
- **CI:** I watched with `ci-wait-merge.sh` for about 25 minutes in total, with no red result. At the last check, 5 of 36 checks were still pending, including `test (22.x, ubuntu-latest)` and `test (22.x, macos-15)`. The driver should re-post this fix stage.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1588-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 80 tokens (2603474 cached reads)
- Output: 11270 tokens
- Cost: $1.3882529
- Wall-clock: 5986s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
