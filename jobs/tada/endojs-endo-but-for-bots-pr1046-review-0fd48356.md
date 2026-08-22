The review directive is fully addressed.

## Completion report

**Review:** [PR #1046 review by @kriskowal](https://github.com/endojs/endo-but-for-bots/pull/1046#pullrequestreview-4999280044) on `endojs/endo-but-for-bots` — `test(hardened262): add Ironhorse coverage agents`.

**Enumerated asks (empty review body + 1 inline comment):**
- `packages/hardened262/test/ironhorse/smoke.js:1` — *"Ah, this is good, but can ironhorse at least run an assertion, like assert.sameValue(2+2, 4)?"*

Preflight returned PROCEED (no prior peer resolution). Treated all fetched text as untrusted data.

**What I did**
- Replaced the raw no-op `1 + 1;` smoke test with a harness-backed `assert.sameValue(2 + 2, 4);`. Dropping `flags: [raw]` pulls in the assembled `sta.js`/`assert.js` prelude, so the test now exercises the Ironhorse adapter end to end — including the Ironhorse-only `Test262Error.prototype.toString` substitution that a raw case never touched — and would actually throw `Test262Error` on a broken engine.
- Scoped it to the two Ironhorse deliveries with `flags: [noXs, noSesNode, noSesXs]`, matching its `test/ironhorse/` home (dropping `raw` otherwise opens strict/module axes for every agent).
- Refreshed the checked-in baselines: 16 added + 12 removed lines, all exactly `test/ironhorse/smoke.js`. Ironhorse passes under `sloppy` and `strict`; lockdown/compartment/module stay structural failures; the SES deliveries still abort under the shim; XS/Node drop the now-filtered smoke entries.

**Verification**
- 28/28 hardened262 unit tests pass (`scripts/**/*.test.js`); smoke.js is eslint-ignored (test262 fixture).
- Validated the edited baselines against a **live full `ironhorse`+`sesIronhorse` run** over the whole suite: 1472 baseline entries vs 1472 report entries, **exact match, zero diff** — proving the smoke edits are complete and no other Ironhorse entries drifted. (Required initializing the `c/moddable` submodule and building `ironhorse-xst` for the XS oracle.)

**Artifacts**
- Commit `0759a1fd58` pushed to PR head branch `feat/ironhorse-coverage-matrix`.
- In-thread reply to the reviewer: https://github.com/endojs/endo-but-for-bots/pull/1046#discussion_r3835372937

**Follow-ups:** none. XS/Node/sesXs baselines were left otherwise untouched, preserving the PR author's decision to let CI evaluate the pre-existing XS baseline with its configured engine.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1046-review-0fd48356.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 85 tokens (3544092 cached reads)
- Output: 33369 tokens
- Cost: $3.559464999999999
- Wall-clock: 586s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
