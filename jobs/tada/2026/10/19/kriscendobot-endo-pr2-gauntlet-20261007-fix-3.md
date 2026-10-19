Fix round 3 for kriscendobot/endo PR #2 is pushed and CI is green (15 checks, 0 failed).

**The must-fix item:** the latest panel review (5566384607) had one must-fix, raised by spec-keeper as must-fix and by purist as should-fix. Export names that decode to a lone surrogate, such as `exports['\uD800']`, were being reported. An ECMAScript module export name must be well-formed Unicode, so these names are invalid.

**What I changed** (commit `2efd412f6`, branch `cjs-module-analyzer-upstream-2.2`, pushed with `safe-push-pr-head.sh` from `1abec4470`):
- **`packages/cjs-module-analyzer/index.js`:** `decodeStringLiteral` now passes its result through a new helper, `isWellFormedString`. The helper checks that every surrogate is part of a pair, and doesn't need `String.prototype.isWellFormed` to exist. A name that fails the check is dropped. The old decoder body is unchanged and renamed `decodeStringLiteralUnchecked`. I believe this matches the surrogate filter in upstream `cjs-module-lexer`'s `decode()`, but that comes from memory: neither the jurors nor I compared against the upstream source.
- **Test:** a new case, "export names with lone surrogates are dropped". It covers `\uD800`, `\u{DC00}`, `\uDF10x`, `\uD83Cx` and an object-literal key `'\uD83C'`, and checks that a valid pair (`\uD83C\uDF10`) is still reported.
- **Two small should-fix items from typist:**
  - The changeset example said "`exports['a']` reports `a`", which shows no decoding; it now says `exports['\u0061']`. The changeset also gains a sentence saying lone-surrogate names are dropped.
  - The `readStringLiteral` JSDoc now says it leaves `pos` at the closing quote, which is what the code does.

**Checks:** all 47 package tests pass locally, Prettier is clean, and ESLint printed no errors.

**Open, not addressed here:**
- Purist and spec-keeper both suggested removing the `JSON.parse` shortcuts so there is one decoding path. That is should-fix; I left it as is.
- Scribe asked for a completion-summary comment on the PR (a summary-fix). I didn't post one.
- Purist noted that a `__proto__` export name hits a bug in `@endo/compartment-mapper`. The bug predates this PR and could be a follow-up issue there.

Per the stage instructions I did not re-run the panel; the driver posts panel-4.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-endo-pr2-gauntlet-20261007-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (961603 cached reads)
- Output: 5615 tokens
- Cost: $0.7741486000000001
- Wall-clock: 535s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
