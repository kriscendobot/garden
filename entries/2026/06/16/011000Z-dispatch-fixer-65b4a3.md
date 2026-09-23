---
ts: 2026-06-16T01:10:00Z
kind: dispatch
role: steward
host: endolinbot
repo: kriscendobot/agoric-sdk
project: agoric-sdk
to: fixer
dispatch_root: /home/kris/dispatches/fixer--65b4a3
prs:
  - repo: kriscendobot/agoric-sdk
    pr: 5
    role: target
refs:
  - https://github.com/kriscendobot/agoric-sdk/pull/5
  - https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4713916780
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/16/010500Z-result-investigator-a29762.md
---

# dispatch: fixer — endow SwingSet evaluator with Float*Array typed arrays per kriskowal

Maintainer directive (kriskowal on PR #5, 2026-06-16T01:07:34Z):

> @kriscendobot We should endow the SwingSet evaluator with the floating point typed arrays.

This authorizes the architectural option investigator a29762 enumerated but had marked "out of scope for mirror PR" (option 2). The maintainer overrides the scope restriction.

## Background (from investigator a29762)

- **Root cause**: SES 2.x removed `Float16Array`, `Float32Array`, `Float64Array` from default globals (NaN side-channel hardening). Pre-built fast-usdc-beta-1 / rc1 / rc2 / cctp-b1 bundles embed pre-fix marshal source that uses `new Float64Array(...)` inside `encodePassable`. Inside SES 2.x vat compartments, this throws `Float64Array is not a constructor`.
- **Tractable angle (authorized)**: explicitly endow `Float*Array` constructors at the SwingSet supervisor's compartment-creation site.
- **Cited location**: `packages/SwingSet/src/supervisors/subprocess-node/supervisor-subprocess-node.js:144-148`.
- **SES-supported escape**: per the SES 2.0 CHANGELOG (endojs/endo#3153), "explicitly endowed to child compartments at the price of enabling code in that compartment to read the side-channel."

## State at dispatch time

- **PR** `kriscendobot/agoric-sdk#5`, DRAFT, head `46b5491dec`.

## Task

In your `project/` worktree at `46b5491dec`:

1. Read `packages/SwingSet/src/supervisors/subprocess-node/supervisor-subprocess-node.js` around line 144-148 to understand the compartment-creation site.
2. Check the xs supervisor sibling (`packages/SwingSet/src/supervisors/subprocess-xsnap/supervisor-subprocess-xsnap-lockdown.js` or similar) — if it has the same compartment-creation pattern, apply the endowment there too.
3. Endow `Float16Array`, `Float32Array`, `Float64Array` in the compartment's globals or as endowments per the SES discipline. Likely shape:
   ```js
   const c = new Compartment({
     ...,
     // or: globals: { ..., Float16Array, Float32Array, Float64Array }
   });
   ```
   Choose the canonical SwingSet pattern; the existing endowments at that site are the model.
4. Add a brief comment naming the SES 2.0 CHANGELOG reference (endojs/endo#3153) and why these are endowed (to enable pre-fix marshal bundles to deserialize within the vat).
5. Run `corepack yarn workspace @agoric/fast-usdc-deploy test` locally (the test that exercises the fast-usdc-beta-1 bundles) to verify the fix takes.
6. Run pre-push-gates.
7. Commit: `fix(SwingSet): endow vat evaluator with Float*Array constructors per ses#3153`.
8. Push: `git push origin HEAD:mirror/12527-endo-sync-refresh` (append only).
9. Post a top-level comment on PR #5 at-mentioning @kriskowal:
   - Summary of the endowment (which files touched, which constructors added).
   - Cite SES 2.0 CHANGELOG / endojs/endo#3153.
   - Commit SHA.
   - Note that this enables the pre-built fast-usdc bundles to deserialize.

## Authorizations

- Push to `mirror/12527-endo-sync-refresh` (append only).
- Top-level comment on PR #5.
- Do NOT touch upstream Agoric/agoric-sdk.

## Out of scope

- Do NOT pursue test-dapp Class A (expected fail).
- Do NOT widen the trust boundary beyond what the maintainer's directive authorizes.

## Deliverable

A `result` entry under `journal/entries/2026/06/16/` naming:

- Pre/post head SHAs.
- Files touched + endowment pattern.
- Local test verification result.
- pre-push-gates result.
- PR #5 comment URL.
- A `Self-improvement: ...` line.
- **Recommended next stage**: per the OODA loop, the next *Observe* phase happens when CI settles on the new head.

End your turn with a concise summary back to the orchestrator.
