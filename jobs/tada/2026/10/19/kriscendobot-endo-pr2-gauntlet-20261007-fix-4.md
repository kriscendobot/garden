Fix round 4 for kriscendobot/endo#2 is pushed and CI is green: all 15 checks passed on head `b7db92f59` (`ci-wait-merge.sh` rc 0). This round had no deterministic pre-pass block, so I worked from the latest panel review (5566817671). It had no must-fix items, so I applied its should-fix items.

**Code changes in `packages/cjs-module-analyzer/index.js` (commit `80d1813e9`):**
- **Object-literal siblings (breaker, migrator):** in `tryParseLiteralExports`, a quoted key that won't decode (for example a lone surrogate) is now skipped. Before, it threw away the whole literal, so the keys after it were lost.
- **Empty-string name (wire-watcher):** the unsafe-getter guard was `if (expt)`, which skips `''`. It is now `!== undefined`, so `''` with an unsafe getter is filtered out like any other name.
- **One decoder path (purist, saboteur):** I removed both `JSON.parse` fast paths, so only the hand-written scanner decodes. That also removes the `.at(-1)` call engine-realist flagged. The catch now rethrows anything that isn't the scanner's `SyntaxError`.
- **Naming and small guards (stylist, typist, purist):** renamed `expt` to `exportName`, added an end-of-input check in the octal scanner, and noted that `isWellFormedString` stands in for `String.prototype.isWellFormed`.

**New tests (prover, spec-keeper, breaker, wire-watcher):**
- an escaped name and a lone-surrogate name through `Object.defineProperty`
- `\uD7FF\uE000\uFFFF` still accepted
- valid keys after a bad key in an object literal
- `exports['']` alone, and `''` with an unsafe getter

The package's 49 tests pass, and eslint, `tsc` and prettier are clean.

**Changeset (commit `b7db92f59`, migrator):** added an explicit `'@endo/compartment-mapper': patch` entry.

**PR description (integrator, pruner):** rewritten to:
- describe the lone-surrogate drop as an Endo-side check a later upstream sync should keep;
- say why the `ci.yml` comment fix is bundled: zizmor fails CI without it;
- cut the sections pruner flagged;
- name the `'*'` collision as a follow-up.

**Not done:**
- **Commit regrouping (integrator):** the job said to push follow-up commits, so I didn't rewrite history. The fix commits still need squashing into one `feat` commit plus the changeset `chore`, either at merge or with a retcon.
- **`'*'` export name (warden, wire-watcher):** `exports['*']` is now detected and collides with SES's `'*'` namespace key in `packages/ses/src/module-instance.js`. It's outside this package, so it's listed as a follow-up and not fixed here.
- **Downstream test (integrator, comment-only):** no compartment-mapper test yet shows a non-identifier name such as `'a-b'` importing end to end.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-endo-pr2-gauntlet-20261007-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 46 tokens (1880010 cached reads)
- Output: 11373 tokens
- Cost: $1.334542
- Wall-clock: 607s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
