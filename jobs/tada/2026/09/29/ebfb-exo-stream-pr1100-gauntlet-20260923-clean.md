The clean stage for endojs/endo-but-for-bots#1100 is done, and CI is green at the current head.

**What was failing** at the original head `f8c369ddf5`:
- **All four test legs (Node 22 and 24, Ubuntu and macOS):** four `@endo/platform` tests failed with `Buffer.from(undefined)`, because the regenerated `cached-fs` and `cas` snapshot files were unreadable.
- **Lint:** Prettier flagged `packages/git/src/native-git-backend.js`.

**Cause of the test failures:** on the `llm` base branch, the immutable-arraybuffer change (#475) replaces the global `Uint8Array` when `@endo/init` runs. ava's snapshot encoder was set up with the original `Uint8Array` before that swap, so it wrote the snapshot bytes as a plain object that ava then can't read back. The bug is in `llm`; this PR was just the first to regenerate these snapshots.

**What I changed:** commit `aeba1a3f81`, pushed with `safe-push-pr-head.sh`.
- Re-encoded both snapshot files so they store the same values as bytes again.
- Applied Prettier to `native-git-backend.js`.
- All 371 platform tests passed locally, and eslint reported 0 errors.

**Coverage and dead code:** I did not run a full coverage pass. I only checked for dead code left by the change: the two remaining `streamBase64` mentions are intentional history comments, and eslint found no orphaned imports.

**Current state (after the requeue):**
- The branch has since been rebased and gone through later panel rounds; the head is now `b946ac4986`.
- My fix is carried in that history as "fix(platform,git): repair corrupt ava snapshots and prettier drift".
- The PR is open, draft, and mergeable.
- `ci-wait-merge.sh --no-merge` returned 0 on `b946ac4986`: 33 checks, 0 failed (25 passed, 8 skipped).

**Follow-up job posted:** `ebfb-lockdown-ava-snapshot-uint8array-corruption` (fixer, `llm` branch). It asks for a root-cause fix, a regression test that writes and reads back a snapshot under `@endo/init`, and a sweep for other snapshot files written corrupt since #475 landed.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-exo-stream-pr1100-gauntlet-20260923-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 5 on 2 host(s) (3 unmetered)
- Input: 118 tokens (4787578 cached reads)
- Output: 23147 tokens
- Cost: $5.6088710000000015 (3 engagement(s) unpriced)
- Wall-clock: 1564s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
