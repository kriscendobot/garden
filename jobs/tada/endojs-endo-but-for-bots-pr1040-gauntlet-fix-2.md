The fix is pushed, CI is green, and the completion-summary comment is posted. The job is genuinely finished.

## Completion report

**Stage:** FIX round 2 for endojs/endo-but-for-bots PR #1040 (gauntlet `endojs-endo-but-for-bots-pr1040-gauntlet`).

**What I did:** Applied the panel round-2 must-fix items to `@endo/hardened262` and pushed as review-feedback follow-up commit `92fdc1122` on `kriskowal-hardened262`. All three blocking findings shared one root cause (the per-agent argv builders had drifted from the shared scenario object), so I closed them with a single shared accessor.

**What changed:**
- **New `scripts/agents/scenario.js`** — single source of truth for a scenario's includes / module-mode / raw-ness. Both `xs.js` and `node.js` now read through it.
- **`agents/xs.js` (item 1)** — stopped reading the never-set `test.module` / `test.raw` / `test.includes`; module cases now pass `-m` to `xst`, `raw` cases skip harness injection, declared `includes:` honored.
- **`test.js` (item 2)** — removed `flags.onlyStrict = flags.strict` which clobbered the real canonical flag with `undefined`. Verified via `--list`: `test/harden/frozen.js` now enumerates only strict scenarios. Kept the needed `module`→`onlyModule` promotion.
- **includes additive (item 3)** — `scenarioIncludes` now prepends the default `assert.js`/`sta.js` (deduped) instead of replacing them, so an explicit `includes: [propertyHelper.js]` no longer strands `verifyProperty` on a missing `assert`.
- **Golden test** `scripts/scenarios.test.js` (`node:test`, no new deps) pinning all three contracts; wired as the package `test` script, now exercised by CI's affected-set `turbo run test`.
- **Stylist renames**: `args`→`childArguments`, `tmp`→`temporaryPath`, `tacet`→`quiet`, `ses`→`sesShim`.
- Posted a completion-summary PR comment (the scribe should-fix).

**Verification:** `yarn lint:eslint` (0 errors), `yarn lint:types` (clean), `yarn test` (8/8), full CI **green — 27/27 checks SUCCESS** on the pushed head.

**Follow-ups (deferred, non-blocking should-fix):** splitting `yarn.lock` out of the base `feat` commit (needs a history rewrite, not a follow-up commit); the four `no<agent>` files' missing `description:` rationale; and the test262-stream `createScenarios` scenario duplication.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1040-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 118 tokens (5038219 cached reads)
- Output: 36915 tokens
- Cost: $4.429922499999999
- Wall-clock: 1165s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
