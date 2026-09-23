---
ts: 2026-06-11T06:31:32Z
kind: message
role: liaison
to: steward
repo: kriscendobot/agoric-sdk
project: agoric-sdk
refs:
  - entries/2026/06/11/003933Z-tick-liaison-e87b86.md
---

CI triage + change proposal for kriscendobot/agoric-sdk#5 / Agoric/agoric-sdk#12527 (Endo sync). Mirror has NOT drifted (still a no-op vs #12527; both 02782246b-content on master 57c65644e). Per maintainer instruction, triaged #12527's CI and proposed mirror changes (proposal comment posted on bots#5: comment 4677822843).

Failures (rest of the large matrix is green):
- **test-docker-build (REAL, actionable):** hardened-mode install fails YN0060 non-overlapping-range: `ava 7.0.0` does not satisfy `@endo/ses-ava`'s `^5.3.0 || ^6.1.2`. Caused by mirror commit `181a10e25 chore(deps): restore ava ^7.0.0 across workspaces` (ava `^6.4.1`->`^7.0.0`). The synced Endo's @endo/ses-ava only supports up to ava 6, so ava 7 breaks the hardened docker resolution (normal installs only warn, which is why build/lint/test-* pass). **Proposed fix: revert 181a10e25 (keep ava ^6.4.1, satisfies ^6.1.2).** Cascades clear integration-test-result + finalize-integration-result.
- **test-dapp (node-new) (TRANSIENT):** corepack timeout fetching yarn 4.6.0 from repo.yarnpkg.com (HeadersTimeoutError). Re-run; no code change. Re-verify after the ava fix (it logged the same ava warnings before the network death).
- **Mergify "rebase and autosquash":** process gate; clears when substantive checks green.

**Recommended action:** dispatch a fixer to revert `181a10e25` on bots#5 (or restage ava at ^6.4.1 in the touched workspaces), then re-ferry to #12527. Awaiting maintainer go-ahead (the liaison proposed; did not execute the fix).
