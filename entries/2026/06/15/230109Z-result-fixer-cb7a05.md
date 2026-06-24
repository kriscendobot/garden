---
ts: 2026-06-15T23:01:09Z
kind: result
role: fixer
repo: kriscendobot/agoric-sdk
project: agoric-sdk
refs:
  - entries/2026/06/15/213500Z-result-fixer-ba72cd.md
---

# Fixer: PR #5 classify remaining CI failures + address Class A (multichain SES split)

Maintainer kriskowal directive on PR #5 (2026-06-15T22:45Z): "Please classify
the remaining CI failures and dispatch a subagent to address each of these
classes, serially." This dispatch performed the classification and addressed
the first class.

## Classification of failing jobs on head c5689a5f96 (CI run 27577890352)

- **Class A** — lint-primary (multichain-testing imports.test.ts smoke).
  AssertionError null == true during SES setup. Cause: lockfile resolves two
  parallel SES variants (ses@1.15.0 via @endo/errors 1.3.0 + lockdown 1.0.18 +
  promise-kit 1.2.0 + import-bundle 1.6.0 + stream 1.3.0 + module-source 1.4.0
  + compartment-mapper 2.0.0; ses@2.2.0 via @endo/ses-ava 1.4.2 + marshal 1.10
  + pass-style 1.8.1 + errors 1.3.1 + common 1.4.0 + compartment-mapper 2.3.0).
  Tractable: surgical resolutions in multichain-testing/package.json.
- **Class B** — test-cosmic-swingset (node-old) exit 129 (SIGHUP after visible
  tests pass). Diff against base on inquisitor.test.ts is type-only; upstream
  master with same code passes. Likely transitive endo dep alignment issue.
  Medium tractability; reconsider after Class A converges.
- **Class C** — test-cosmic-swingset (node-new) CANCELLED downstream of B.
- **Class D** — test-dapp (node-new). EXPECTED FAIL per maintainer (2026-06-15
  T20:55Z). Not pursued.
- **Class E** — test-fast-usdc-deploy (node-old/new). Known structural impasse
  per fixer 38fcec (SES 2.x cannot deserialize fast-usdc-beta-1 bundles
  written under SES 1.x). 20 tests fail with "unsettled value for kpNNNN" or
  "no data at path published.fastUsdc.feeConfig". Maintainer-decision class;
  not pursued.

## Class A addressed

Added a `resolutions` block to `multichain-testing/package.json` pinning each
older endo package to its SES-2-compatible version:

- `@endo/errors ^1.2.13 / ^1.3.0 → ^1.3.1`
- `@endo/lockdown ^1.0.18 → ^1.0.19`
- `@endo/promise-kit ^1.2.0 → ^1.2.1`
- `@endo/import-bundle ^1.6.0 → ^1.7.0`
- `@endo/stream ^1.3.0 → ^1.3.1`
- `@endo/module-source ^1.4.0 → ^1.4.1`
- `@endo/compartment-mapper ^2.0.0 → ^2.3.0`
- `@endo/common ^1.3.0 → ^1.4.0`
- `@endo/eventual-send ^1.3.4 / ^1.4.0 → ^1.5.0`
- `@endo/pass-style ^1.6.3 / ^1.7.0 → ^1.8.1` (already-resolved)
- `@endo/marshal ^1.9.0 → ^1.10.0` (already-resolved)

Regenerated `multichain-testing/yarn.lock` by `yarn install` in a tmpdir
copy of the project (the dispatch root's portal paths assume an
`../../agoric-sdk/...` neighbor that does not exist locally). Net diff: -131
lines, +27 lines (collapse of duplicate SES 1.x entries). Verified the
resulting lockfile shows `"ses@npm:^2.0.0, ses@npm:^2.2.0"` as the single ses
entry.

## Commits (append-only push)

- pre: c5689a5f96c637e17a1897195c53a1a109102f26
- post: 9216c5a93634fbbb52a6f15b96f8f3a3697f8ca7

- cec9ed5c44 `fix(deps): pin SES-2-compatible endo versions in multichain-testing resolutions`
- 9216c5a936 `chore: Update yarn.lock`

## Maintainer notification

- Top-level classification comment posted:
  <https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4713162797>.
- Top-level follow-up comment posted:
  <https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4713164729>.

## Recommended next stage

`next: fixer` — Class B (test-cosmic-swingset SIGHUP), pending the next CI
cycle's verification that Class A is resolved on head 9216c5a936. If Class B
persists after the new CI cycle, the next fixer should investigate the
post-test hang. Candidate paths: explicit teardown in inquisitor.test.ts, or
revert to `provideBundleCache` (the pre-35c18254 form). If Class B
transitively resolves with Class A (the cosmic-swingset workspace shares the
same SES 1.x/2.x dep split), the gamut continues to whatever Class E
decision the maintainer makes.

Self-improvement: when a dispatch root's portal paths reference an
`../../agoric-sdk/...` neighbor that does not exist (because the dispatch
root is `dispatches/<role>--<id>/project/`, not the canonical
`<host>/agoric-sdk/`), `yarn install` cannot run in-place. The workaround is
to `cp -r` the project into `/tmp/<x>/agoric-sdk/` so the portal paths
resolve. Future fixers facing the same multichain-testing or services/ymax-
planner repro need will benefit from this note. The pattern generalizes to
any agoric workspace whose portal paths look like `portal:../../agoric-sdk
/...`.
