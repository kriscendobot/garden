---
ts: 2026-06-02T05:16:48Z
kind: result
role: builder
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
dispatch_root: /home/kris/dispatches/builder--c592cb
prs:
  - repo: endojs/endo-but-for-bots
    pr: 395
    role: opened
  - repo: endojs/endo-but-for-bots
    pr: 394
    role: predecessor
  - repo: endojs/endo-but-for-bots
    pr: 343
    role: source-design
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/395
  - https://github.com/endojs/endo-but-for-bots/pull/394
  - https://github.com/endojs/endo-but-for-bots/pull/343
---

# result: builder — opened #395, gateway Feature 2 formula-backed AppsNameHub

## Outcome

Opened DRAFT [#395](https://github.com/endojs/endo-but-for-bots/pull/395)
implementing the gateway-package phase-7 slice (Feature 2: formula-backed
`AppsNameHub`).

- Branch: `design/gateway-package-phase-7`, based off
  `design/gateway-package-phase-6` (PR #394's head). Stack: #343 → #388 →
  #389 → #392 → #393 → #394 → #395.
- 6 files changed, 1255 insertions, 17 deletions. One feat commit;
  yarn.lock was unchanged (no dependency churn).

## Scope of the slice

New module `packages/gateway/src/apps-formula.js`:

- `makeFormulaBackedAppsNameHub({ formulaStore })`: drop-in replacement
  for the in-memory `makeAppsNameHub`. Same exo contract
  (case-insensitive names, first-bind-wins, idempotent rebind to same id).
  Hydrates asynchronously at construction from `formulaStore.listBindings`;
  writes through on bind/unbind; rolls back the in-memory map if the store
  throws. Adds a `whenReady()` accessor for deterministic startup-failure
  surfacing.
- `validateWebletFormula(candidate)`: shape guard for the `WebletFormula`
  typedef the design names under Feature 2 (`type: 'weblet'`,
  `contentRoot`, optional `mimeTypes` / `ssrHandler` / `virtualHosts`).
  Returns a hardened, normalized record; throws on malformed input.

Wiring in `index.js`:

- New optional `appsFormulaStore` field on `GatewayPowers`. `makeGateway`
  selects the formula-backed variant when present; otherwise falls back
  to the in-memory hub (phase-1 behavior preserved).
- `Gateway.start()` awaits `whenReady()` when the formula-backed variant
  is in play. Fail-closed posture: a broken store is a startup error,
  not a silent degrade to in-memory.

## Tests (31 new)

26 in `packages/gateway/test/apps-formula.test.js`:

- `WebletFormula` validation (7 tests): minimal shape; optional fields;
  rejection of non-objects, wrong type discriminator, missing
  `contentRoot`, malformed `mimeTypes` / `ssrHandler` / `virtualHosts`.
- Formula-backed hub shape parity (9 tests): bind/lookup,
  case-insensitive lookup, unbound lookup throws, has/unbind,
  first-bind-wins, idempotent rebind, list, empty weblet id rejection.
- Hydration on construction (2 tests): seeded round-trip; case
  normalization on hydration.
- Write-through behavior (3 tests): bind, unbind, name-normalization.
- Roll-back on store failure (2 tests): write throws, delete throws.
- Hydration-failure modes (5 tests): `whenReady` surfaces; subsequent
  exo calls reject; non-array; malformed records; duplicate-different
  rejected; duplicate-same tolerated; empty weblet id rejected.
- Store-interaction count assertions (3 tests): listBindings once;
  writeBinding called on idempotent rebind; deleteBinding called on
  unbind of unbound name.

5 in `packages/gateway/test/gateway.test.js`:

- In-memory hub used when `appsFormulaStore` is omitted.
- Formula-backed hub used when supplied.
- `start()` awaits hydration.
- `start()` surfaces hydration failures.
- Cross-restart round-trip: a binding installed through one gateway
  persists through the supplied store and re-hydrates on a second
  gateway built against the same store.

## Verification

- `yarn workspace @endo/gateway test`: 316 / 316 passing.
- `yarn workspace @endo/gateway lint`: 0 errors, 171 warnings (all
  pre-existing `jsdoc/reject-any-type` warnings in test files and other
  prior-phase modules; no new warnings introduced).
- `yarn workspace @endo/gateway lint:types`: clean.
- `yarn format` applied; prettier-reformatted the new files (and
  inadvertently reformatted `packages/hex-test/package.json`, which I
  left out of the commit — unrelated to this PR's scope).
- Regression-evidence sample check:
  - Sabotaged `hydrateEntries` call → 10 tests fail (hydration tests
    + cross-restart test). Restored after verification.
  - Sabotaged `store.writeBinding` call → 5 tests fail (write-through
    + roll-back + cross-restart). Restored after verification.

## Architectural choices

- **Synchronous `makeFormulaBackedAppsNameHub`.** The factory matches
  the `make({ powers, config })` corpus pattern by returning the hub
  synchronously and kicking off hydration in the background. Each exo
  method awaits the internal `ready` promise; `whenReady()` exposes
  the same promise for embedders that want a deterministic startup
  failure. The alternative (async factory) would break `makeGateway`'s
  sync API and cascade through `getApps` consumers.
- **Fail-closed on broken store.** A `listBindings` throw causes every
  subsequent exo method to reject with the same error. `Gateway.start()`
  awaits hydration so the broken store surfaces as a clean startup error
  rather than a silent degrade. This matches Phase 5's relay-policy
  fail-closed posture.
- **Roll-back on partial failure.** If `writeBinding` throws after the
  in-memory `set`, the in-memory map rolls back so the two stay in
  sync; if `deleteBinding` throws after the in-memory `delete`, the
  binding is restored. A split-brain (in-memory has, store does not)
  is the regression mode the tests pin.
- **`WebletFormula` is design-side only.** The gateway carries the
  typedef and validator; the daemon-side formula-store adapter that
  consumes it (and the weblet content-tree resolution path through
  CAS) is deferred to a follow-on PR. This keeps the slice focused on
  the gateway's persistence surface.

## Stack restacking discipline

This PR's base is `design/gateway-package-phase-6` (PR #394's head),
NOT master. When PR #394 advances, this PR rebases; when this PR
advances, hypothetical phase-8+ PRs rebase.

Self-improvement: nothing this time.
