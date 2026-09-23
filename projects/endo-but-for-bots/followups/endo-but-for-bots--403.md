---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 403
created_at: 2026-06-11T00:22:30Z
last_appended_at: 2026-06-11T00:22:30Z
status: parked
---

# Follow-ups for endojs/endo-but-for-bots#403

## Items

- [ ] Land layer 4 of the daemon-worker importLocation stack:
  `@registry` HostFormula slot, `MakeFromPackageFormula`,
  daemon-side `makeFromPackage` worker dispatch, CLI `endo run <mount>`,
  host-formula migration, and daemon integration tests against a
  registry fixture.
  **Source juror(s)**: integrator, packager, releaser (round 1)
  **Round**: 1 (barrister 5a67ca)
  **Recommended action**: open follow-up PR scoped to layer 4 wiring;
  consume this PR's `@endo/exo-npm` API surface; touches `host.js`,
  `daemon.js`, `formula-type.js`, `worker-node.js`, `mount.js`, and
  `packages/cli/`.

- [ ] Phase 5: Rust-backed `EndoRegistry` wrapping
  `endor-npm-registry-proxy`.
  **Source juror(s)**: integrator (round 1)
  **Round**: 1 (barrister 5a67ca)
  **Recommended action**: open follow-up PR (or design doc + PR pair)
  after layer 4 merges; the Rust backend swaps for the reference
  backend at the consumer's option.

- [ ] SQLite-backed `PackageCacheTable` implementation.
  **Source juror(s)**: integrator, breaker (round 1)
  **Round**: 1 (barrister 5a67ca)
  **Recommended action**: open follow-up PR after layer 4 merges; the
  SQLite implementation pairs with `daemon`'s existing migration
  table. The 2026-06-11 fixer's offline-walk fix has a forward-compat
  fallback for cache rows without a `packageJson` snapshot (the gap
  surfaces on `unmetOptionals`); the SQLite table may want to carry
  the column from day one to avoid the diagnostic.

- [ ] `compartment-mapper` extension point (may become entangled with
  the layer-4 PR's must-fix #2-style mapper plumbing).
  **Source juror(s)**: integrator, breaker (round 1)
  **Round**: 1 (barrister 5a67ca)
  **Recommended action**: open follow-up PR or design amendment; the
  layer-4 PR may need to land this extension point so the daemon's
  `mapSnapshot` consumer can plug into `compartment-mapper.importLocation`
  cleanly.

- [ ] `test/snapshot-mapper.test.js`: property-test-shaped pass over
  the multi-major satisfies-range selection. The current example case
  covers the load-bearing inversion (first-match to satisfies-range);
  a follow-up `fast-check`-shaped pass would harden the selection
  against pathological resolution shapes (e.g. a four-major
  coexistence, or a `>=1.0.0 <2.0.0 || ^3.0.0` disjunction).
  **Source juror(s)**: fast-checker (round 2)
  **Round**: 2 (justice 6f3a91)
  **Recommended action**: open follow-up PR adding the `fast-check`
  property test alongside the existing example case.
