Round 4 of the panel on endojs/endo-but-for-bots#1124 finished cleanly and returned **must-fix**. I posted the verdict as a review on the PR.

**Run:** I reviewed head `5a3cfb1d5` against base `f1e306582` (the PR's `baseRefOid`, `llm-f1e3065`) in an isolated checkout. `panel.sh` ran in single-round mode, all 34 seats came back ok, and it exited normally with "code-panel single-round — must-fix".

**Review:** https://github.com/endojs/endo-but-for-bots/pull/1124#pullrequestreview-5446371072
- It is filed as COMMENTED, not REQUEST_CHANGES, because GitHub won't let the bot request changes on its own PR. Rounds 1–3 were filed the same way.
- The body opens with a "Panel verdict: REQUEST CHANGES (must-fix)" summary, followed by the full panel aggregate, cut to about 52KB to fit GitHub's review size limit.

**Findings:**
- **Must-fix (decomplector):** this is the third round flagging the same code: `formula-nonce-locator.js`, `makeLocatorForSession` and `peerPublicKey`. The decomplector says the per-session miss bound, the session hook and the abort plumbing have no stated need:
  - Design §2 asks only for decode, assert local, then `provide(id)`.
  - The PR itself says the bound protects no secret and resets when a peer reconnects.
  - The recommended fix is to ship only the shared `get`, drop commit `3bd1eb4a1` and the per-session half of `16ac97b46`, and get the maintainer's confirmation before adding a public `@endo/ocapn` session hook.
- **Should-fix:**
  - The shared `get` duplicates `localGateway.provide` in `packages/daemon/src/manager.js`.
  - The pruner asks to cut the long JSDoc and constant comments in `formula-nonce-locator.js`, which repeat the README and design rationale.
  - The assessor suggests logging the in-flight refusal path.
- Two seats requested changes (decomplector, pruner); the other 32 approved or left comments only.

**Follow-up:** the gauntlet driver will post the fix stage next. Because the same code keeps drawing must-fix findings, whether that per-session code should exist at all may need the maintainer to decide rather than another fix round.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1124-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (910326 cached reads)
- Output: 6031 tokens
- Cost: $0.8147412000000002
- Wall-clock: 1154s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
