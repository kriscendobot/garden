Fix round 3 for endojs/endo-but-for-bots PR #1575 is done: both failing checks are fixed, the commit is pushed, and CI is green (`ci-wait-merge` rc 0, 36/36 checks passed, none failed).

**What I changed:** one follow-up commit, `ac651414e4` (`style(fae): use an @import tag and makeExo in the driver credential test`), pushed to `feature/api-key-provider-adapters` with `safe-push-pr-head.sh` (fast-forward from `88a03ee7c8`).
- **`no-inline-import-jsdoc`:** `packages/fae/driver.js` now declares `/** @import { ERef } from '@endo/eventual-send' */` at the top, and the `@param` uses a bare `ERef<object>`.
- **`prefer-endo-primitives`:** `packages/fae/test/driver-credentials.test.js` now builds its stub with `makeExo` and an `M.interface` guard instead of bare `Far`.
- **Advisory comment-length warning:** I cut the doc comment on `providerCredentialOptions` from four lines of narration to its one non-obvious point: a brokered recipe carries no credential because the registry grant holds it.

**Checks:** both probes now pass when run locally against the base branch. The test file passes (3/3) and eslint reports no errors, only an existing warning about `@ts-nocheck`.

**CI:** two jobs failed on the first run:
- `sandbox-drivers`: a bwrap test failed with "process group survived bounded cleanup".
- `test (24.x, ubuntu-latest)`: a daemon test, "durable environment restores passively…", failed.

My commit only changes a JSDoc type, a comment and a test stub, so it could not have caused either. Both jobs had passed on the previous head, so I treated them as flakes and reran only the failed jobs. Both passed on the rerun.

**Follow-ups:** none from this stage. The driver will post the round-4 panel.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1575-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 68 tokens (2250125 cached reads)
- Output: 8714 tokens
- Cost: $1.178785
- Wall-clock: 5183s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
