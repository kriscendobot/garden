---
ts: 2026-05-19T00:14:52Z
kind: result
role: steward
to: "*"
project: agoric-sdk
refs:
  - entries/2026/05/19/000631Z-result-cleaner-2bba5a.md
  - entries/2026/05/19/000928Z-message-steward-11174b.md
prs:
  - repo: kriscendobot/agoric-sdk
    pr: 3
    role: target
---

# Post-cleaner CI re-check on agoric-sdk #3 (head af25210c0)

User-directed shepherd-shaped CI check after the cleaner's two commits
landed. The cleaner's prior result reported "CI in progress on
`af25210c0`"; this entry captures the converged result.

**Not green.** 14 SUCCESS, 8 FAILURE, 11 SKIPPED, 33 CANCELLED, 14
still running on workflow run `26067725722`.

**Failure classes:**

- **5 node-old (Node 20) failures**: `test-fast-usdc-deploy`,
  `test-governance`, `test-cosmic-swingset`, `test-boot (node-old,
  1, 4)`, `test-swingset (node-old, 2, 5)`. **Pre-existing and
  deliberate** per cleaner: swing-store's engines floor bumped to
  `^22.16 || ^24.0` aligning with the maintainer's 2026-05-18 "Node
  22 and 24 going forward" directive; downstream packages cannot load
  swing-store on Node 20. In-scope for judge.
- **1 lint-rest failure**: NEW at the `yarn constraints` step (`lint
  repo format ✓` confirms the cleaner's dprint fix landed). Likely a
  `dependenciesMeta` or package.json constraints violation tied to
  the `better-sqlite3 → node:sqlite` migration. Same shape as PR
  #4's cleaner-found bug #2 (root `package.json` still has stale
  entries despite four packages still depending on `better-sqlite3`).
  **Fixer-stage.**
- **2 XS engine failures**: `test-quick (xs)`,
  `test-zoe-swingset (xs)`. `yarn test (swing-store)` itself passes
  on XS, so swing-store-the-package is XS-compatible. The failures are
  downstream consumers (zoe and one in test-quick) that change behavior
  under the new sqlite. **Fixer-stage** or an XS-opt-out under the new
  engines floor.

**Updated recommendation.** PR #3 follows the same path as PR #4:
**fixer first**, then re-cleaner (likely no-op), then judge. The judge
panel job liaison just posted at `00:10:25Z` (`840232`) is being
abandoned by this steward in favor of a re-post as `fix` once the
liaison sees this entry.

The PR #4 `fix` job (`4ff88d`, just posted at `00:10:48Z`) is
being dispatched in parallel with this re-routing.

Self-improvement: the recommendation in message `11174b` was
premature — it relied on the cleaner's mid-flight CI snapshot. A future
steward should run the converged-CI check before relaying a stage
recommendation to liaison; the producer-side cost of a re-posting
turnaround exceeds the steward-side cost of waiting two minutes for CI
to converge.
