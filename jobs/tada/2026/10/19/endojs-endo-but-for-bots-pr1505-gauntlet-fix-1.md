Fix round 1 for PR #1505 is pushed and CI is green: all 35 checks passed, 0 failed (`ci-wait-merge` rc 0).

**What changed:** one follow-up commit on `endojs/endo-but-for-bots` branch `feat/daemon-cbor-frame-seam`, `0ba87f2ccc` ("refactor(daemon): use @import tags, @endo/hex, and makeExo in the framing seam"). It was pushed with `safe-push-pr-head.sh` and moved the branch from `a8bcf3c3be` to `0ba87f2ccc`. It fixes everything the style pre-pass flagged as failing:
- **Inline JSDoc imports (`no-inline-import-jsdoc`):**
  - `packages/daemon/src/connection.js`: added `/** @import { CapTPOptions } from '@endo/captp' */` and replaced all 5 inline `import('@endo/captp').CapTPOptions` uses with it. The pre-pass flagged two of those lines.
  - `packages/daemon/src/framing.js`: added `/** @import { PromiseKit } from '@endo/promise-kit' */` and used it.
  - `packages/daemon/test/framing.test.js`: added `/** @import { Reader } from '@endo/stream' */` and used it in both flagged places.
- **Endo primitives (`prefer-endo-primitives`):**
  - In `framing.js` and `framing.test.js`, the first byte's hex is now built with `encodeHex(Uint8Array.of(byte))` from `@endo/hex` instead of `toString(16).padStart(2, '0')`.
  - In the test, the CapTP bootstrap `Far('bootstrap', …)` is now `makeExo` with an interface guard (`M.interface('bootstrap', { hello: M.call().returns(M.string()) })`).
  - `@endo/hex`, `@endo/exo` and `@endo/patterns` were already dependencies of the daemon package, so nothing new was added.
- **The 5-line comment the pre-pass marked as a non-blocking warning:** I kept it. It is the doc comment on `makeSniffingCapTP` and explains why outbound writes wait until the framing is known, which the code alone doesn't make obvious.

**Local checks:** `test/framing.test.js` passes (21/21). ESLint on the three files shows no errors; its one warning, an unused `eslint-disable` at `connection.js:112`, was already there. The repo-root `tsc` type check reports nothing in the changed files.

I did not re-run the panel; the gauntlet driver posts panel-2 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1505-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1202159 cached reads)
- Output: 5938 tokens
- Cost: $0.8731518000000003
- Wall-clock: 2273s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
