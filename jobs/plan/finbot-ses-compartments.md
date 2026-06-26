---
gate: deferred
priority: normal
roadmap: finbot
posted_by: gardener
posted_at: 2026-06-26T01:19:40Z
---

# GOAL: replace the in-process v0.5 capability attenuator with real SES compartments

## Context (what exists now)
`packages/pipeline/cap-attenuation.js` enforces the *wallet boundary* in plain JS:
a capability MAP keyed by role, wallet/signing-rpc gated on `live`, an
interface-guarded revocable wallet, and `runInAttenuatedCompartment` that drops
the vended wallet on return. The executor asserts `caps.wallet === undefined` in
dry-run. This enforces the boundary but does NOT yet sandbox globals/modules
(the `ambient` column of CAPABILITY_MAP is documentary).

## Build
- Adopt `@endo/compartment-mapper` (+ `ses`, `@endo/exo`, `@endo/pass-style`,
  `@endo/patterns`) per `designs/cap-attenuation.md`. Each role's code runs in an
  SES Compartment whose globals/modules policy is built from the capability map.
- Vend each cross-compartment capability as an `@endo/exo` Far ref behind an
  InterfaceGuard; replace `makeWalletCapability`'s plain-JS guard with the Exo.
- For the (future) live executor: run the signing call in a SEPARATE worker
  process over CapTP (`@endo/captp`) per the design's § Process boundary.
- Keep the existing `attenuateForRole` semantics and all current tests green;
  add tests proving an ambient-authority escape is denied (e.g. a role cannot
  read the filesystem or reach `fetch` unless its policy grants it).

## Safety bounds (hard)
Dry-run only; do NOT wire a real wallet/key/funds. Live executor stays gated.
No agoric-sdk work.

## Done
SES compartments in force for spawned roles; wallet is a real Far+InterfaceGuard
vended only to the executor in live; ambient-authority denial is tested; the
`designs/cap-attenuation.md` Notes-from-the-field section is updated. Tests green.
