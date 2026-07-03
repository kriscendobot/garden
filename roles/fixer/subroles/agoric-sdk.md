---
created: 2026-07-03
updated: 2026-07-03
author: gardener
---

# Fixer sub-role: agoric-sdk

The fixer's project-keyed specialization for work on `agoric/agoric-sdk` (via the
`kriscendobot/agoric-sdk` fork). Read `roles/fixer/AGENT.md` first; this is
additive. Selection and the sub-role concept: [README](README.md).

**Repo etiquette (load-bearing).** All agoric-sdk work stays on the
`kriscendobot/agoric-sdk` fork and bot-owned forks: clone, branch, build, test,
run, and read-only analysis are in scope. **No upstream `agoric/agoric-sdk`
interaction** at any point: no comments, reviews, reactjis, or review-comments;
no issue/PR opens, edits, or closes; no cross-references
(`Closes agoric/agoric-sdk#N`, `cc`/`@`-mention, "Related to …") from any repo
including the fork. See `roles/COMMON.md` § External-repo etiquette, *Project
scope: agoric/agoric-sdk*.

## Debugging dimension

The skills for diagnosing an agoric-sdk failure before fixing it:

- [xs-debugging](../../../skills/xs-debugging/SKILL.md): the XS value-stack
  overflow envelope (width-not-depth diagnosis, symbolicating a native crash into
  JS frames, and the targeted `flatMap`->loop remedy versus the coarse taller
  `stackCount` lever with its lockstep-cutover determinism constraint). This is the
  cross-project envelope; the same skill serves the [endojs](endojs.md) sub-role.
- [slog-debugging](../../../skills/slog-debugging/SKILL.md): read the swingset
  slog / flight recorder for the delivery-level failure record (`Stack meter
  exceeded`, `#error`, exit-12), and preserve `flight-recorder.bin` before a
  harness `shutdown()` removes the temp db.
- [agoric-chain-snapshot](../../../skills/agoric-chain-snapshot/SKILL.md): the
  reproduction lever. Capture a real mainnet swing-store (Polkachu, no
  credentials), build inquisitor's host, seed/install the bundle, and A/B the fix
  through the `createVat` import vector (decisive) or the contract-control
  `upgrade(bundleId)` vector (faithful). Includes the two capture scripts
  (`scripts/agoric/fetch-polkachu-snapshot.sh`,
  `scripts/agoric/fetch-chain-snapshot.sh`) and the committed repro drivers
  (`skills/agoric-chain-snapshot/repro/`).

## When this sub-role engages

- A vat upgrade or contract-bundle import aborts with exit 12 / `Stack meter
  exceeded` / `vat-upgrade failure` (the ymax0 v320 70→71 shape).
- A `flatMap`/`map`/spread expression built during module evaluation is suspected
  of tipping the XS value stack (width-not-depth; the `@agoric/internal/src/hex.js`
  `decodings`-table pattern).
- A failure needs reproduction against **real chain state**, not a synthetic
  worker, to be trusted.

## Project gotchas (carried from kriskowal/garden#9)

- **The faithful upgrade vector needs the live-instance admin facet**, reached via
  `getUpgradeKit` / the delegated `ContractControl`, **not** the stale bootstrap
  `ymax0Kit.adminFacet` (which drives the now-terminated original instance). The
  `createVat` import A/B is the runnable stand-in and the decisive cross-check.
- **The over-threshold bundle is a release asset**, not on-chain: `gh release
  download <tag> --repo agoric/agoric-sdk --pattern bundle-ymax0.json`. On-chain
  mainnet bundles flatten to only 3–5 `flatMap`s and import clean; the failing
  devnet/beta3 bundle flattens to 10.
- **Build the worker bundles** (`xsnap-lockdown`, `swingset-xsnap-supervisor`)
  after the immutable install, or `createVat` fails `ENOENT … .sha256`. The
  inquisitor overlay needs the `initTranscript` seed fix to run `createVat`
  end-to-end against a read-only snapshot. Both are in the
  [agoric-chain-snapshot](../../../skills/agoric-chain-snapshot/SKILL.md)
  procedure.
