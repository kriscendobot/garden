---
ts: 2026-06-16T08:42:00Z
kind: dispatch
role: steward
host: endolinbot
repo: kriscendobot/agoric-sdk
project: agoric-sdk
to: fixer
dispatch_root: /home/kris/dispatches/fixer--cb75d8
prs:
  - repo: kriscendobot/agoric-sdk
    pr: 5
    role: target
---

# dispatch: fixer — OODA cycle 7 on PR #5 (absorb fallout continued)

OODA cycle 7 on PR #5 head `1122a57c04` shows ~30 NEW lint-primary TS errors. Different signature from cycle 5/6. The absorb (`d8a32b`'s `3a6be3fa1b` Endo absorb commit) keeps exposing new layers of TS errors that were previously masked by other failures.

## Failing TS errors (categorized)

**Missing module `temp`** (probably needs `@types/temp` or `temp` itself added):
- `packages/deployment/src/entrypoint.js:7`
- `packages/solo/src/start.js:6`

**`t.context` unknown (TestFn typing)**:
- `packages/governance/test/swingsetTests/contractGovernor/governor.test.js:72`
- `packages/spawner/test/swingsetTests/contractHost/contractHost.test.js:17`

**portfolio-contract / SetAutoFeatures enum mismatch** (real type issue):
- `packages/portfolio-contract/src/evm-wallet-handler.exo.ts:396, 401`
- `packages/portfolio-contract/test/portfolio.contract.test.ts:2703`

**swingset-runner/demo/ Zoe-related types** (~20 errors across exchanger, helpers, vat-alice, bootstrap, etc.):
- Missing names: `ZoeService`, `Issuer`, `Payment`, `Invitation`, `ERef`
- `'temp' module`, `null possibility`, unused vars, missing bundle-* imports.

## State at dispatch time

- **PR** `kriscendobot/agoric-sdk#5`, DRAFT, head `1122a57c04`.
- **Class A**: test-dapp (skip).
- **Class B**: none (fast-usdc-deploy PASSED in cycle 4).
- **Class C/D**: ~30 lint-primary + many test-* cascades.

## Note on escalation

This is the 5th cycle on lint-primary in the OODA loop. The pattern is "each cycle exposes new layers" not "the same errors persist". If THIS cycle's fix uncovers yet another layer, the steward should consider escalating to maintainer for strategic decision (revert d8a32b? batch all remaining type errors via wholesale upstream? accept structural impasse?).

## Task

In your `project/` worktree at `1122a57c04`:

1. **Triage each error category**:
   - **`temp` module**: Add `temp` (and/or `@types/temp`) to deployment + solo package.json. Check upstream Agoric#12734 for the version.
   - **`t.context` unknown**: Same TestFn typing pattern fixer ba72cd addressed for async-flow with `@ts-expect-error`. Apply the same pattern to governance + spawner tests OR adopt upstream's narrowing.
   - **`SetAutoFeatures`**: Real type issue. Investigate — was a new "SetAutoFeatures" action added but the enum union not updated? Add it to the enum if so.
   - **swingset-runner/demo Zoe types**: These are demo files. Either fix imports (likely the demo's tsconfig is missing endo type refs) OR exclude `swingset-runner/demo/` from lint-primary's typecheck if upstream excludes them.
2. Verify locally: `corepack yarn lint:primary` clean.
3. Pre-push-gates.
4. Commit per logical group.
5. Push append-only.
6. Top-level comment on PR #5 @-mentioning @kriskowal:
   - Cycle 7 classification + per-fix SHA.
   - Note: if signature still expanding next cycle, recommend escalation.

## Authorizations

- Append-push.
- Top-level comment.
- Do NOT revert prior fixer substance.
- Do NOT touch upstream Agoric/agoric-sdk.

## Out of scope

- Do NOT pursue Class A.

## Deliverable

A `result` entry naming pre/post head SHAs, per-fix mapping, SHAs, pre-push-gates result, PR #5 comment URL, recommended next stage. **Recommend `next: ooda-observation` if signature shrinks, `next: liaison` if new layer surfaces.**

End your turn with a concise summary back to the orchestrator.
