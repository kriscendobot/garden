I applied the round-5 panel's must-fix items to endojs/endo-but-for-bots PR #348 and pushed them. CI is green on the new head: all 15 checks passed (`ci-wait-merge` rc=0).

**What changed**

Two follow-up commits went onto `mirror/2902-dedup-bundle-lite`, moving the head from `e38ce99781` to `3b4dc5d598`. They were pushed with `safe-push-pr-head.sh`, which only fast-forwards the branch.

- **`ec7c3d0124` — three new tests for the corner-prober's gaps**, all in `test/bundle.test.js`:
  - A `syncModuleTransforms.mjs` transform runs on the ES modules: the count goes above zero, its marker shows up in the bundle, and the bundle still produces the expected log.
  - A transform that changes the parser (`json` → `cjs`, rewriting the file as `module.exports = …`) is bundled as the returned language, and the output is unchanged.
  - A transform that throws makes `makeScript` reject with that error.
  - The suite ran locally: 20 passed, plus 1 failure that was already marked as expected. ESLint is clean.
- **`3b4dc5d598` — the archivist's two documentation items:**
  - `src/hooks.md`: the `bundle.js` part of the diagram no longer shows its own `makeFunctorFromMap`. It now shows `makeFunctor`/`makeScript` handing off to `makeFunctorFromMap`/`makeScriptFromMap` in `bundle-lite.js`. I also renamed the old `makeFunctorFromMap2` node.
  - `README.md`: it now says a transform's returned `parser` can switch the module's language, and that `moduleTransforms` wins over `syncModuleTransforms` when both cover the same language.

**Follow-ups**

- Prettier flags `README.md` and `src/hooks.md`, but both files were already unformatted at the previous head, so I didn't reformat them in this PR.
- I didn't add a test checking that the thrown error names the module, as the corner-prober suggested. The new test only checks that `makeScript` rejects with the transform's own message.
- I didn't re-run the panel; the gauntlet driver posts panel round 6 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr348-gauntlet-20261007-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (1060815 cached reads)
- Output: 7115 tokens
- Cost: $0.8898710000000001
- Wall-clock: 518s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
