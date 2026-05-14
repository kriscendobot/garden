---
ts: 2026-05-14T21:03:10Z
kind: result
role: builder
project: endo
to: liaison
refs:
  - entries/2026/05/14/205558Z-dispatch-liaison-693645.md
prs:
  - repo: endojs/endo
    pr: 1967
    role: source
  - repo: endojs/endo
    issue: 629
    role: source
---

# Result: mirror of endojs/endo#1967 (compartment-mapper policy identifier bypass) — Phase 2c (ambiguous)

Branch: `test/policy-identifier-bypass` on `endojs/endo-but-for-bots` (commit `96dc6abff`). No PR opened.

## Phase 1 finding

Cherry-pick of `naugtur/test-policy-identifier-bypass` (commit `5e009ad51`, 2024-01) onto current master conflicted: the file was renamed `test-policy.js` -> `policy.test.js` and a snapshot file was deleted. Reapplied the 9-file delta by hand:

1. Six fixtures added/edited under `packages/compartment-mapper/test/fixtures-policy/` (new `app/attack-name.js`, new `eve/getalice.js`, new `eve/node_modules/alice/{index.js,package.json}`, `eve/index.js` and `eve/package.json` edits adding `alice` as a `bundledDependencies` entry).
2. `test/scaffold.js`: source-map accounting now logs each `+`/`-` and dumps left-over hashes when the count diverges.
3. `test/policy.test.js`: new `nameConfusionAttack` fixture URL, `evePolicy` (entry+packages: any, eve: any), `nameConfusionExpectations` (evilAlice keys all `undefined`; alice/bob/carol unchanged), and one `scaffold('policy - attack - duplicated name via bundled dep', ...)` call.

### Run outcome (`yarn workspace @endo/compartment-mapper test`)

The new scaffold yields 10 sub-tests across the import/archive matrix. 9 pass; 3 separate failures appear in the workspace:

- `policy - attack - duplicated name via bundled dep / writeArchive / importArchive`: `The bundler and importer should agree on source map count but they differ by 1`. This is the same "unrelated" warning naugtur cited in 2024-01, still present.
- `policy - attack - duplicated name via bundled dep / makeArchive / parseArchive / hashArchive consistency`: `Archive contains extraneous files: ["myattenuator-v1.0.0/index.js"] in "memory:app.agar"`.
- `map-node-modules › mapNodeModules() should be idempotent for fixtures-policy/...`: snapshot drift; the new fixture introduces an `eve>alice` compartment (label `eve>alice`, name `alice`, location `eve/node_modules/alice/`, empty policy) the recorded snapshot does not yet contain.

The 9 passing sub-tests cover the security-relevant claim. `loadLocation`, `importLocation`, `mapNodeModules / loadFromMap / import` and the matching mapNodeModules / writeArchive / loadArchive variants all import `attack-name.js` and pass `makeResultAssertions(nameConfusionExpectations)`, which asserts `evilAlice` exposes nothing (`bluePill: 'undefined'`, `purplePill: 'undefined'`, `redPill: 'undefined'`). The compartment-mapper currently isolates eve>alice from the top-level alice; the bypass does not occur in the import paths the test exercises.

Likely fix landing this defense was `5ff31f950 fix(compartment-mapper): guarantee stable paths` (2025-07; introduced canonical compartment paths) reinforced by `acbacba53 fix(compartment-mapper): address potential canonical name instability` (2026-04). The new-hooks refactor `dd28a1967` changed the surrounding plumbing but did not author the defense.

## Phase 2 disposition: 2c

The bypass appears fixed for the import paths, but the 3 archive/snapshot failures muddy a clean Phase 2b regression-coverage PR. The sourcemap-count warning naugtur kept the PR draft for is still firing, and the archive packing surfaces an extraneous fixture file that may be a real bug or test scaffolding artifact. Per the dispatch's prudence rule ("If unsure ... prefer Phase 2c"), the disposition is to surface the ambiguity, not speculate.

Files added/modified on the branch: see commit `96dc6abff` (8 files, 83 insertions, 5 deletions). No fork-side PR.

## Suggested follow-up for the maintainer

Two routes are sensible:

- Land the test as defensive regression coverage (Phase 2b), refresh the map-node-modules snapshot, and investigate the archive failures as separate items. The sourcemap-count warning likely warrants its own issue.
- Decline the mirror and let naugtur refresh his draft against modern compartment-map invariants.

Either is the maintainer's call. The branch is parked so the diff is inspectable.

Self-improvement: nothing this time.
