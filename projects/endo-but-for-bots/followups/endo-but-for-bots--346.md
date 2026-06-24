---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 346
created_at: 2026-05-22T01:31:30Z
last_appended_at: 2026-05-22T01:31:30Z
status: parked
---

# Follow-ups for endojs/endo-but-for-bots#346

Created from the barrister code-panel verdict (26 seats, in-band fallback) on the "fix(bundle-source): bind aliased exports correctly in nestedEvaluate format (fixes endojs/endo#2981)" PR. The PR is a +48/-8 single-bug-fix in `packages/compartment-mapper/src/bundle-mjs.js`, with the regression test un-`.failing`'d in `packages/bundle-source/test/export-alias.test.js` and a `patch` changeset on `@endo/compartment-mapper`. Four follow-ups warrant revisit at merge time.

## Items

- [ ] **Unit-test coverage for the bundle-mjs generator's emitted text.**
  **Source juror(s)**: prover, integrator.
  **Round**: 1.
  **Recommended action**: open a follow-up test PR adding a `packages/compartment-mapper/test/bundle-mjs.test.js` (or extending an existing test file) that exercises `importsCellSetter` (and `exportsCellRecord`) directly against synthetic `__fixedExportMap__` / `__liveExportMap__` inputs, pinning the emitted text shape for: (a) zero exports, (b) single-alias, (c) multi-alias of one local binding, (d) mixed multi-alias and single-alias bindings. Today the regression coverage for the alias bug lives downstream in `packages/bundle-source/test/export-alias.test.js`; an in-package test would catch future shape regressions where the integration test happens to keep passing. Actioning trigger: PR #346 merges, or its upstream mirror merges (the upstream mirror PR number is not yet known; the boatman fills `upstream_mirror_*` after ferry).

- [ ] **Asymmetry note in `bundle-cjs.js`.**
  **Source juror(s)**: spec-keeper, archivist (proposed-rule).
  **Round**: 1.
  **Recommended action**: add a one-line comment to `packages/compartment-mapper/src/bundle-cjs.js` near the analogous cell-wiring code noting that CJS uses a `require`-based linker (no per-export cell-setter object literal), so the alias-bug class does not apply. The asymmetry is correct today; the note prevents a future reader from "fixing the same bug here too" when in fact there is nothing to fix. Trivial doc-only follow-up, post-merge.

- [ ] **Promote the alias-and-marshal-failure tests in the README.**
  **Source juror(s)**: curator.
  **Round**: 1.
  **Recommended action**: add a small section to `packages/bundle-source/README.md` titled "Module-format edge cases covered by tests" enumerating the `marshal-failure.test.js` and `export-alias.test.js` pair (and any future edge-case-pinning tests). The demo fixture `packages/bundle-source/demo/exports.js` is a tasteful spread of alias shapes (string, number, bigint; named, destructured, value, function) and deserves discovery surface. Out of scope for the bug-fix PR; doc follow-up.

- [ ] **Scout audit: other bundle-format emitters for the same bug class.**
  **Source juror(s)**: spec-keeper, follow-up rationale endorsed by the assessor's correctness lens.
  **Round**: 1.
  **Recommended action**: dispatch a scout (or assayer) to read every `packages/compartment-mapper/src/bundle-*.js` (`bundle-json.js`, `bundle-cjs.js`, `bundle-lite.js`, future formats) under the question "does this emitter build a per-export record from an `exportMap`-shaped input via `Object.fromEntries` or object-literal construction, in a way that would collapse on multiply-aliased local bindings?" The bug class ("object-literal key collision silently drops setters") is a generic JS hazard; the bug surfaced in `bundle-mjs.js` because the `__fixedExportMap__` / `__liveExportMap__` shape happens to be keyed by exported name with the local binding inside the value, but other emitters may have analogous patterns. Park as a one-shot audit dispatch post-merge; the deliverable is a report (zero or more affected files), not a fix.
