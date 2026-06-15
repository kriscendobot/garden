---
ts: 2026-06-15T22:48:00Z
kind: dispatch
role: steward
host: endolinbot
repo: kriscendobot/agoric-sdk
project: agoric-sdk
to: fixer
dispatch_root: /home/kris/dispatches/fixer--cb7a05
prs:
  - repo: kriscendobot/agoric-sdk
    pr: 5
    role: target
refs:
  - https://github.com/kriscendobot/agoric-sdk/pull/5
  - https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4713078503
---

# dispatch: fixer — PR #5 classify CI failures + address class 1 per kriskowal

Maintainer directive (kriskowal on PR #5, 2026-06-15T22:45:24Z):

> @kriscendobot Please classify the remaining CI failures and dispatch a subagent to address each of these classes, serially.

Per prior fixer ba72cd's report and current `gh pr checks 5` enumeration, failures are:

| Job | Status | Class hint |
|---|---|---|
| lint-primary | fail 28m | multichain-testing runtime test (`makeStargateClient` returns null) |
| test-cosmic-swingset (node-old) | fail 4m | SIGHUP / process management |
| test-cosmic-swingset (node-new) | fail 4m | canceled, possibly cascade from node-old |
| test-dapp (node-new) | fail 2m | **expected per maintainer** (documentation dep skew) — skip |
| test-fast-usdc-deploy (node-old) | fail 22m | known structural impasse: SES 2.x deser of fast-usdc-beta-1 bundles |
| test-fast-usdc-deploy (node-new) | fail 1m | same class as node-old |

State: PR #5 DRAFT, head `c5689a5f96`, base `master-57c6564`.

## Task

This dispatch is the FIRST of the serial-per-class chain. Your job:

1. **Classify**: read each failing job log; confirm the class hint above or revise. Post a top-level classification comment on PR #5 @-mentioning @kriskowal naming each class with:
   - Affected jobs.
   - Failure signature (short).
   - Tractability assessment (1-2 sentences).
   - Recommended fix approach.

2. **Pick the most-tractable class** that does NOT exceed your dispatch scope (i.e., skip the structural-impasse fast-usdc-deploy class — that's class-N requiring maintainer decision per fixer 38fcec's prior report; pick from cosmic-swingset SIGHUP or lint-primary multichain-testing runtime test).

3. **Address that class**: apply the fix.

4. **Push + commit per discipline**.

5. **Post a top-level comment** on PR #5 @-mentioning @kriskowal with:
   - Per-class classification (re-post the full classification from step 1).
   - The class you addressed + commit SHA.
   - Recommended next class for the next serial dispatch.

## Authorizations

- Push commits to `mirror/12527-endo-sync-refresh` (append only).
- Top-level comments.
- @-mention kriskowal (re-request not available since not a collaborator).
- Do NOT touch upstream Agoric/agoric-sdk.

## Out of scope

- Do NOT address test-dapp (expected fail).
- Do NOT pursue the fast-usdc-deploy structural-impasse class (that's maintainer-decision).
- Do NOT pursue multiple classes in one dispatch — that's what serial-dispatch means.

## Deliverable

A `result` entry under `journal/entries/2026/06/15/` naming:

- The classification (all classes).
- The class addressed + commit SHAs.
- PR #5 classification comment URL + per-class fix comment URL.
- A `Self-improvement: ...` line.
- **Recommended next stage**: `next: fixer` for class N+1.

End your turn with a concise summary back to the orchestrator.
