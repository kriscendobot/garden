# fixer: XS 16.7.1 engine-behavior test failures on kriscendobot/agoric-sdk PR #12

PR: https://github.com/kriscendobot/agoric-sdk/pull/12
Head branch: xst/moddable-5.5.0-11297 (bot-pushable, kriscendobot fork)

Follow-up from the auto-dispatched shepherd (base kriscendobot-agoric-sdk-pr12-shepherd).
The shepherd already landed the two deterministic lint fixes and pushed them
(commits 3bf385cf47, dc0d4cf964):
  - lint-primary: node: protocol prefixes in packages/xsnap/src/build.js
  - lint-rest (typecheck-quick): excluded vendored packages/xsnap/moddable +
    xsnap-native from tsconfig.quickcheck.json

REMAINING RED (engine-behavior adaptations, beyond shepherd scope — need a
local xsnap-from-source build of Moddable 5.5.0 / XS 16.7.1 to regenerate
values, and some carry consensus-affecting judgment):

1. packages/xsnap/test/xsnap.test.js — "produce golden snapshot hashes" (test 73).
   The XS snapshot binary format changed with the engine bump, so the stored ava
   golden hashes no longer match. CAUTION: the test's own text says an engine
   upgrade needs "special accommodation for the new version, not just generating
   new golden hashes" — the snapshot hash is a within-consensus value. Do NOT
   blindly regenerate the snapshot; assess snapshot compatibility. Likely needs a
   maintainer/designer consensus decision.

2. packages/xsnap/test/xs-perf.test.js — "meter details" (test 53). Failure
   message: "compute, allocate meters should be stable; update METER_TYPE?"
   (current meterType xs-meter-36). Compute/allocate meter accounting changed with
   the engine. Bumping METER_TYPE is consensus-affecting; confirm the new numbers
   and whether a METER_TYPE bump is the intended path.

3. packages/xsnap/test/boot-lockdown.test.js — "console - objects should include
   detail" (test 12): console/inspect output format shifted with XS.
4. packages/xsnap/test/inspect.test.js — "xsnap inspect" (test 16): same class.
   (2,3,4 live in the diff's second commit "carry engine-behavior adaptations";
   the adaptations are incomplete. Regenerate expected strings from a real
   XS 16.7.1 build.)

5. test-swingset shards: several ran 43m+ (likely timeout/hang under the new
   engine) and one genuinely failed, cascading fail-fast cancellations to the
   rest. Reproduce packages/SwingSet under XS 16.7.1 locally; the diff touches
   packages/SwingSet/test/vat-admin/create-vat.test.js. Determine whether the long
   runs are a real hang/perf regression or just slower.

6. test-codegen: verify-codegen-idempotence flagged
   packages/orchestration/src/fetched-chain-info.js dirty after `yarn codegen`.
   UNRELATED to the XS engine. Almost certainly master-side drift or a stale
   committed file. First step: rebase on latest origin/master and re-run
   `yarn codegen` in packages/orchestration; commit the regenerated file if the
   drift is legitimate.

Recommended order: rebase on master (clears #6, refreshes CI), then build xsnap
from source (node packages/xsnap/src/build.js) to regenerate #1-#4 values, then
tackle #5. Escalate #1 (snapshot "special accommodation") and #2 (METER_TYPE bump)
to the maintainer via the liaison if a consensus decision is required before
regenerating within-consensus values.

Repo scope: kriscendobot/agoric-sdk fork experimentation is permitted; upstream
agoric/agoric-sdk stays comment-and-link-free (COMMON.md External-repo etiquette).

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  claimed_at: 2026-07-10T06:10:57Z
