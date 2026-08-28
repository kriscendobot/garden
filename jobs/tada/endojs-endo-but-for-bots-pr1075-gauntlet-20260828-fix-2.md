Applied the panel-2 must-fix items to PR #1075 and drove CI to green.

**What I did**

- **Must-fix #1 (prover — self-defeating gated assertions):** The prior fix commit's throw-on-call/construct assertions were wrapped in `if (Object.isFrozen(AsyncFunction))` in the always-on `intrinsic-metadata.js`, so a freeze regression would make the gate false and silently no-op the block instead of failing. Split those assertions into a new lockdown-scoped file `packages/hardened262/test/intrinsics/AsyncFunction/inert-stand-in.js` with `flags: [onlyLockdown]` (mirroring `test/lockdown/function-frozen.js`), asserting `Object.isFrozen(AsyncFunction)` **unconditionally** — a claim the test fails on, not a runtime guard — then asserting both call and construct throw `TypeError`. Removed the gated block from `intrinsic-metadata.js`, which now keeps only host-invariant identity relationships.
- **Baselines:** Regenerated with the real harness (`node scripts/test.js --update-baseline baseline`) across all three agents (`xs`/`sesXs`/`sesNode`). Strictly additive — the new file registers in the 18 lockdown baseline files (passes `lockdownModule`, skipped in the other lockdown scenarios, filtered out of non-lockdown scenarios by the `onlyLockdown` rule). Reverted an unrelated `xs/module` pass→fail flake (`Compartment/prototype/globalThis/defaults.js`) that differed only due to local-vs-CI xst; the committed diff is exclusively the new file.
- **Must-fix #2 (integrator — stale description):** Rewrote the PR body to describe both test files, the added `%AsyncFunction% !== %Function%` distinctness assertion, and refreshed the diff figures to current HEAD (38 files, +208 / −0; +9 net covered scenario-cases).
- **Should-fix #3 (purist — family consistency):** Panel explicitly permitted either backporting the block to the two siblings or noting why `%AsyncFunction%` alone carries it. Added a "Notes" section to the description stating honestly that the gap is coverage in the siblings, not anything specific to `%AsyncFunction%`, and flagging the sibling backport as a natural follow-up left out to keep this PR focused.

**Result:** Fix pushed to PR head (`40b328610..66d1b72d0`). All **24 CI checks SUCCESS**, zero failures, zero pending.

**Follow-up:** Optional backport of the `onlyLockdown` inert-stand-in file to the sibling `%GeneratorFunction%` / `%AsyncGeneratorFunction%` intrinsic-metadata tests (noted in the PR description).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1075-gauntlet-20260828-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 104 tokens (4131456 cached reads)
- Output: 25204 tokens
- Cost: $3.591379
- Wall-clock: 454s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
