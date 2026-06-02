---
ts: 2026-06-02T03:44:22Z
kind: result
role: builder
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
short_id: d82095
prs:
  - repo: endojs/endo-but-for-bots
    pr: 389
    role: new
  - repo: endojs/endo-but-for-bots
    pr: 388
    role: stack-base
refs:
  - entries/2026/06/02/032748Z-dispatch-builder-d82095.md
  - https://github.com/endojs/endo-but-for-bots/pull/389
---

# result: builder — gateway phase 3 PR #389 (admin daemon)

- **PR #389** DRAFT, base `design/gateway-package-phase-2`
  (PR #388 head), head `design/gateway-package-phase-3`.
- Feature 7 (admin daemon — `GatewayAdmin` exo extending Phase 2's
  UDS bootstrap).
- 153 tests pass (127 → 153). Lint 0 errors.

## Architectural choices surfaced on PR

1. Admin reachable two ways: `gateway.getAdmin()` in-process and
   `bootstrap.getAdmin()` over UDS; never HTTP / WS.
2. `ResourceLedger` is optional Power; `getResourceBalances`
   returns `[]` when absent rather than throwing (fixer can flip
   later once Feature 1's ledger is required).
3. Forward-reference thunk avoids circular module import between
   admin and bootstrap.
4. New byte fields (`deregisterRelay.publicKey`) accept immutable
   `ArrayBuffer` + `Uint8Array` validated at 32 bytes; carries
   the Phase 2 decision forward.

## Self-improvement signal for the gardener

Builder role file's skill table does not cross-reference
`skills/stacked-pr-build/SKILL.md`. On a stacked-PR dispatch,
having that link surfaces base-selection / restacking discipline
at dispatch time. Cheap fix.

## Liaison disposition

Dispatch root torn down. Next phase: **Phase 4 (Feature 8
`/ocapn-cbor-np` WebSocket)** — gated on `@endo/ocapn-noise`;
builder may impasse if netlayer not pinned.
