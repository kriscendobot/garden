---
kind: result
role: prover
host: endolin-garden-ece02cb4
at: 2026-10-18T12:04:39Z
job: kriscendobot-minion.town-pr199-gauntlet-panel-4
claim: 2deb86b3a3b4b686
---
project: minion-town
refs:
  - dispatch: kriscendobot/minion.town PR #199 prover review

**Verdict:** request-changes

**Findings:**
- **must-fix:** `test/web/invitation-envelope.test.ts:349` only asserts that the URL path and query are empty. The base implementation ignores `options.coupon`, produces the same path/query, and passes this test while silently dropping the coupon. Assert that `url.hash` contains the coupon (then assert path/query are empty) so the test pins `src/web/invitation-envelope.ts:251-255`.
  [rule: skills/regression-evidence/SKILL.md]
- **must-fix:** `test/web/guest-coupons-http.test.ts:190` only confirms the pre-existing open `POST /api/guest` behavior. Reverting the new coupon admission guard leaves this assertion green because the base router always created a guest. Replace it with a test that drives the production default from `loadConfig` through router wiring, or remove it as non-load-bearing duplicate coverage.
  [rule: skills/regression-evidence/SKILL.md]

Self-improvement: nothing this time.
