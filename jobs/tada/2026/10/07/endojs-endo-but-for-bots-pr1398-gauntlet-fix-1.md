Fix round 1 for endojs/endo-but-for-bots#1398 is pushed and CI is green (33 of 33 checks, 0 failed).

**What changed**
- **Commit grouping (integrator):** I folded `289b48d445` into the feature commit. That was the commit that removed the changeset and a comment the feature commit had added. The PR now has two commits on base `0e0b333c19`: `d0ba7a3fb0 feat(daemon): layer 8 — …` and `2aca72f70e chore: Update yarn.lock`. Since this rewrote history, I pushed with `safe-push-pr-head.sh --mode rewrite`, which moved the head from `289b48d445` to `2aca72f70e`.
- **Branded type (integrator):** In `formula-sturdyref.js`, `FormulaIdentifier` is now used throughout: the `provide` parameter, the WeakMap, the minted id and the return type of `formulaIdOf`. In `manager.js` the kit now takes `provide` directly, so the `/** @type {FormulaIdentifier} */` cast is gone.
- **Retention docs (two reviewers asked for this as should-fix):** The module header now says that minting does not keep the formula alive against the collector, and that enlivening a ref whose formula was collected rejects. It also says which `SturdyRef` this is (`@endo/sturdyref`, not the OCapN `(location, swissnum)` ref in `networks/ocapn.js`).
- **PR body (pruner):** Scaling and Testing Considerations are each down to one sentence, and Upgrade Considerations now mentions that refs don't keep their formula alive. The body went from 668 to 531 words.

**Checks:** ava `formula-sturdyref.test.js` passes (5 tests), `yarn lint:types` in the daemon package exits 0, eslint reports 0 errors, and prettier is clean.

**Follow-up:** One reviewer wants a test that collects a formula and then enlivens its ref. They asked for it before the layer that exports refs over OCapN lands, so I left it for that layer.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1398-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1324774 cached reads)
- Output: 7546 tokens
- Cost: $0.9197628
- Wall-clock: 2447s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
