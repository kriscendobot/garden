I applied and pushed the round-3 fixes for endojs/endo-but-for-bots#1393. CI hit the 3600 s deadline with one check still pending (`ci-wait-merge` rc 4), so this round is still pending, not done.

**What was pushed** (head `f5d0de0bba` → `4b4842c464`, via `safe-push-pr-head.sh`):
- `2b7e382ba0` docs(marshal): the README's `makePassableKit` paragraph now names the `{encode,decode}SturdyRef` pair and the `t` prefix (surfacer's finding).
- `4b4842c464` fix(spaces-util): `value-render.js` and `value-vnodes.js` each get a `sturdyRef` case. Without it, a decoded SturdyRef would hit `render`'s default case, which throws (migrator and breaker should-fix). The package is private, so it needs no changeset.

**PR body edits** (pruner's findings):
- The test inventory is cut down to what reviewers should check.
- The "Drift from layer 3's live head" notes moved out of the body and into a PR comment.
- Upgrade Considerations now says something specific: code that switches over pass styles and throws in its default case needs a `sturdyRef` case.
- Documentation Considerations mentions the README change.

**Summary comment:** posted as https://github.com/endojs/endo-but-for-bots/pull/1393#issuecomment-5967464226. It lists what was applied and what was declined, adds the round-1 fix summary the panel said was missing, and holds the drift notes for the weave.

**Declined, with reasons in the comment:**
- **archivist** (must-fix): a false positive. `@endo/sturdyref` is only in marshal's `devDependencies`, so the docstring it flagged is accurate.
- **engine-realist:** the PR body already notes the XS coverage gap under Testing Considerations.
- **procurer:** marshal's local `isSturdyRef` is deliberate. Importing the one from `@endo/sturdyref` would make it a runtime dependency of marshal.
- **purist** (`M.sturdyRef()`): this would be new patterns API, so it's left to a later layer.

**CI:** 32 of 33 checks finished, all passing or skipped. The one left is `test (24.x, macos-15)`, still pending after the deadline. The driver should re-post this stage.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer4-marshal-20260930-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 54 tokens (1784860 cached reads)
- Output: 10578 tokens
- Cost: $1.1381960000000002
- Wall-clock: 3743s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
