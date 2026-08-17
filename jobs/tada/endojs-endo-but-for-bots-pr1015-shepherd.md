CI on endojs/endo-but-for-bots PR #1015 is now fully green.

## What was failing
Two `lint` checks (workflows **CI** and **CI (docs-only)**) failed on a pure Prettier `lint:prettier` violation — 8 files in `packages/claude` had unformatted code style (`src/harness.js` plus 7 `test/*.test.js` files). Every other check in the 26-check matrix was already green. This was a tractable, in-scope inline shepherd fix (class C), no impasse.

## What I did
1. Set up an isolated project worktree off `endo-claude-package`.
2. Ran `yarn prettier --write` on the 8 flagged files (110 insertions / 35 deletions, formatting-only).
3. Verified `prettier --check` and `eslint` both clean locally.
4. Committed as `fixup! feat(claude): add @endo/claude confinement core` (per shepherd norm — this PR is already retconned, so style/format fixes use `--fixup` targeting the introducing commit `a7ae13a324`, letting the conductor autosquash at merge).
5. Pushed `66112443e6` to the PR head with a fetch/rebase CAS loop.

## Result
CI re-dispatched and both lint checks went green; I then waited for the full matrix to settle. **All 26 checks are SUCCESS on head `66112443e6`.** Green run: https://github.com/endojs/endo-but-for-bots/actions/runs/32003570879

## Follow-ups
- None. The PR remains a **draft** (it did not un-draft) — un-drafting is the gauntlet's job, not the shepherd's. No summary comment posted (no per-action comment authorization in the job body).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1015-shepherd.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (1 unmetered)
- Input: 37 tokens (1111455 cached reads)
- Output: 6582 tokens
- Cost: $1.1971825 (1 engagement(s) unpriced)
- Wall-clock: 1547s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
