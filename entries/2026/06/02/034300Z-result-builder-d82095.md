---
ts: 2026-06-02T03:43:00Z
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
  - repo: endojs/endo-but-for-bots
    pr: 343
    role: stack-root
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/389
  - https://github.com/endojs/endo-but-for-bots/pull/388
  - https://github.com/endojs/endo-but-for-bots/pull/343
---

# result: builder gateway phase 3 PR #389 (admin daemon)

- **PR #389** DRAFT, base `design/gateway-package-phase-2` (PR #388
  head), head `design/gateway-package-phase-3`.
- Feature 7: admin daemon (`GatewayAdmin` exo) extending Phase 2's
  UDS bootstrap. The four design-named operations plus a
  `getCounters` diagnostic.
- 153 tests pass (127 to 153; 26 new tests). Lint 0 errors, 34
  pre-existing warnings.

## Files changed

- `packages/gateway/src/admin.js` (new, 289 lines): `GatewayAdmin`
  exo with `listRegistrations`, `deregisterRelay`,
  `listVirtualHosts`, `getResourceBalances`, `getCounters`; the
  `AdminBackplane` typedef the bootstrap exposes in-process and
  the `ResourceLedger` Feature 1 surface typedef.
- `packages/gateway/src/bootstrap.js` (+62 lines): adds `getAdmin`
  to the `GatewayBootstrap` exo interface, accepts a `getAdmin`
  thunk in `BootstrapDeps` so admin and bootstrap share one facet
  without a circular import, adds `deregisterByPublicKey` to the
  in-process backplane.
- `packages/gateway/index.js` (+84 lines): wires the admin facet
  when both `udsBootstrap` and `adminDaemon` toggles are on; adds
  `getAdmin` to the gateway exo and optional `resourceLedger`
  power; throws when either toggle is off so a refactor cannot
  silently put admin authority on the network surface.
- `packages/gateway/test/admin.test.js` (new, 505 lines): 26
  tests, including surface-contract regressions (admin disabled,
  UDS disabled, no third accessor exposes the facet), the
  by-any-key tear-down for multi-key registrations, and the
  empty-ledger fallback.
- `packages/gateway/README.md` (+13 lines): phase-3 status block
  and `GatewayAdmin` capability rows.

## Architectural choices surfaced (in PR body)

- **Admin surface is "two accessors":** `gateway.getAdmin()`
  in-process and `bootstrap.getAdmin()` over the UDS bootstrap;
  no third accessor exposes the facet. The HTTP / WS surface
  (when it lands) does not get the admin exo. A regression test
  enumerates the gateway's and bootstrap's method names to pin
  the contract.
- **`ResourceLedger` is a Power, not a sub-exo of the gateway.**
  Feature 1's ledger lands with Chat-hosting; until then, the
  admin's `getResourceBalances` returns an empty list (a faithful
  snapshot of a gateway that has not yet stood up the ledger)
  rather than throwing. A future fixer can flip the default to
  throw once the ledger is required.
- **Forward-reference thunk for the admin facet** rather than a
  setter on the bootstrap: the gateway constructs the bootstrap
  with a `getAdmin: () => adminFacet` closure, then constructs
  `adminFacet` from the bootstrap's backplane. Avoids a circular
  module import and keeps the admin facet as `const`-after-init
  from the bootstrap's view.

## Self-improvement signal

Garden has no documented "stacked-PR base discipline" skill that
codifies "branch off the previous phase's head, do not move the
base to upstream-master, restack on the parent's advance." The
maintainer's stacked-PR plan (this Phase 1 to Phase 11 sequence)
makes this a recurring pattern; a short skill at
`skills/stacked-pr-base-discipline/SKILL.md` (or a section in
`skills/stacked-pr-build/SKILL.md` if it already exists) would
save the next builder dispatch on a stacked PR the same recall
work this builder did. `skills/stacked-pr-build` is named in the
garden's skill inventory but was not consulted in the dispatch
prompt; cross-referencing it from the builder role's table of
skills would surface it on similar future dispatches.

## Liaison disposition

- PR #389 DRAFT, ready for the next-stage chain.
- Next phase: **Phase 4** per the gateway design's Phased
  Implementation section. Base `design/gateway-package-phase-3`
  (this PR's head).

Self-improvement: file a gardener message proposing a
`stacked-pr-base-discipline` cross-reference on
`roles/builder/AGENT.md` so the *Modeled-on designs abbreviate
their source* norm gets a sibling for stacked-PR base selection.
