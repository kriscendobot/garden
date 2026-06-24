---
ts: 2026-06-16T00:46:00Z
kind: dispatch
role: steward
host: endolinbot
repo: kriscendobot/agoric-sdk
project: agoric-sdk
to: investigator
dispatch_root: /home/kris/dispatches/investigator--a29762
prs:
  - repo: kriscendobot/agoric-sdk
    pr: 5
    role: target
refs:
  - https://github.com/kriscendobot/agoric-sdk/pull/5
  - https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4713808013
---

# dispatch: investigator — root-cause analysis on PR #5 failing jobs per kriskowal

Maintainer directive (kriskowal on PR #5, 2026-06-16T00:44:35Z):

> @kriscendobot Let's begin investigating the root cause of the failing jobs while the rest are settling.

Current CI on `46b5491dec` (post-Class-A ava fix):
- **test-dapp (node-new)**: previously labeled "expected fail per maintainer" (documentation dep skew). REVISIT — confirm or revise.
- **test-fast-usdc-deploy (node-old)**: previously labeled "structural impasse" (per fixer 38fcec 2026-06-14: SES 2.x cannot deserialize pre-built fast-usdc-beta-1 / fast-usdc-rc1 released bundles). REVISIT — the maintainer's framing suggests revisiting whether this is truly impasse-class or has a tractable angle.
- (Other CI matrix still settling; revisit when complete.)

## State at dispatch time

- **PR** `kriscendobot/agoric-sdk#5`, DRAFT, head `46b5491dec`.

## Task

In your `project/` worktree at `46b5491dec`:

1. **test-fast-usdc-deploy** — read the latest CI log (`gh run view --log-failed`) and `packages/fast-usdc/test/` source. Key failure signatures from prior runs:
   - `prop 87: Beta` REJECTED with `TestFailure`.
   - `LP deposits` REJECTED with `TypeError: Cannot read properties of undefined (reading 'brand')`.
   - `prop 88: RC1; update noble ICA` REJECTED.
   - Documented root cause: pre-built `fast-usdc-beta-1` bundles fail to deserialize under SES 2.x (`Float64Array is not a constructor` in `kunser`).
   - Investigate: is there a way to:
     - Refresh the pre-built bundles (where do they live? agoric-labs releases? bundle service?)
     - Skip just the pre-built-bundle-loading paths in this test while keeping the rest?
     - Pin the marshal/ses versions only in fast-usdc to stay 1.x while rest of repo runs 2.x?
     - Wait for upstream to publish refreshed bundles (timeline?)
   - Classify: is this truly structural impasse (maintainer-decision-only) or is there a tractable sub-fix?

2. **test-dapp (node-new)** — read the log briefly. Was the "documentation dep skew" framing accurate? Or has the dep skew shifted?

3. **Watch for new failures** — when other matrix jobs complete, re-check.

4. Post a top-level investigation comment on PR #5 at-mentioning @kriskowal with:
   - Per-class root-cause findings (revised or confirmed).
   - For each class: tractable angle (if any) + suggested approach + tractability score.
   - For truly impasse classes: name the maintainer-decision dimension explicitly.

## Authorizations

- Read-only on project.
- Top-level comment on PR #5.
- Do NOT push code.
- Do NOT touch upstream Agoric/agoric-sdk.

## Out of scope

- Do NOT dispatch fixers (orchestrator's call after your report).

## Deliverable

A `result` entry under `journal/entries/2026/06/16/` naming:

- Per-class root cause + tractable angle.
- Recommendations.
- PR #5 comment URL.
- A `Self-improvement: ...` line.
- **Recommended next stage**: per class — `next: fixer` (tractable), `next: liaison` (impasse), or `next: nothing` (expected).

End your turn with a concise summary back to the orchestrator.
