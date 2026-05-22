---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 313
created_at: 2026-05-22T01:13:00Z
last_appended_at: 2026-05-22T01:13:00Z
status: parked
---

# Follow-ups for endojs/endo-but-for-bots#313

Created from the code-panel verdict (26 seats, in-band fallback) on `feat(patterns): explainMismatch submodule for rich diagnostics`. The PR introduces an opt-in `@endo/patterns/explain-mismatch.js` submodule per `designs/patterns-diagnostic-feedback.md` (merged via #307). Five `follow-up` items deferred for revisit at merge time.

## Items

- [ ] **`captureRejectMessage` opaque-mismatch fall-through is unreachable on the current matcher; add defensive test.**
  **Source juror(s)**: saboteur, breaker, corner-prober.
  **Round**: 1.
  **Recommended action**: open a follow-up test PR adding a test that constructs an artificial divergence between `matches(specimen, pattern)` and `confirmMatches(specimen, pattern, rejector)`, pinning the `'mismatch'` opaque string at `packages/patterns/src/explain-mismatch/trace.js:87`. The test documents the case as defensive coverage; if the divergence is impossible to construct on the production matcher, the JSDoc on `captureRejectMessage` should say so explicitly.

- [ ] **`expanded` output lacks an overall header for multi-leaf failures.**
  **Source juror(s)**: archivist, copyeditor, novice.
  **Round**: 1.
  **Recommended action**: open a follow-up PR adding an overall `mismatch (N leaves):` header to the expanded form analogous to the compact form's header. Update `designs/patterns-diagnostic-feedback.md` to show the multi-leaf expanded shape (the design currently shows only single-leaf examples).

- [ ] **`rejectorThrow` cast-to-any discards Rejector type relationship.**
  **Source juror(s)**: typist, integrator.
  **Round**: 1.
  **Recommended action**: open a follow-up PR (or issue) on `@endo/patterns` to expose a typed `Rejector` interface from `packages/patterns/src/types.js`. Wire `packages/patterns/src/explain-mismatch/trace.js:84` to use the typed interface in place of `/** @type {any} */ (rejectorThrow)`. If a typed `Rejector` already exists somewhere in the package, the cast is the cleanup; if not, the issue files the request.

- [ ] **README.md does not point readers to the new opt-in submodule.**
  **Source juror(s)**: archivist, scribe, surfacer, novice.
  **Round**: 1.
  **Recommended action**: open a follow-up PR adding a short "Diagnosing a mismatch" subsection to `packages/patterns/README.md` naming `import { explainMismatch } from '@endo/patterns/explain-mismatch.js';` with one `compact`-format example. Honors the opt-in posture (the production matcher path is unaffected) while making the submodule discoverable to readers of the package README.

- [ ] **Double `matches` call on the diagnostic path; benchmark before optimizing.**
  **Source juror(s)**: benchmarker, assessor.
  **Round**: 1.
  **Recommended action**: scout-style measurement at follow-up time. `packages/patterns/src/explain-mismatch.js:48` calls `matches(specimen, pattern)` to decide whether to walk; `traceWalk` then calls `matches` again on every recursion level. For deeply nested patterns the double match could be folded into the root call. Confirm the cost with a measurement before changing; if the cost is real, the cleanup is local to `explain-mismatch.js`.

- [ ] **Compact-format header line is not escaped for `|` in the specimen.**
  **Source juror(s)**: spec-keeper, fast-checker, corner-prober.
  **Round**: 1.
  **Recommended action**: open a follow-up PR routing the header-line specimen interpolation at `packages/patterns/src/explain-mismatch/render.js:209` (and the leaf-less header at `render.js:256-258`) through `escapeBar`. Add a test that pins a specimen containing a `|` and asserts the resulting header escapes it as `\|`. The existing test at `packages/patterns/test/explain-mismatch.test.js:136-155` covers leaf rows but not the header.

- [ ] **No property-based tests on `explainMismatch`.**
  **Source juror(s)**: fast-checker, prover.
  **Round**: 1.
  **Recommended action**: open a follow-up PR adding `@fast-check/ava` properties to `packages/patterns/test/explain-mismatch.test.js`. At minimum: for-all `(specimen, pattern)` pairs from a hardened arbitrary, `explainMismatch({ specimen, pattern }) === undefined` iff `matches(specimen, pattern) === true`; for all mismatches, the returned string is non-empty and includes a non-empty path. `@fast-check/ava` is already in the package's devDeps.

- [ ] **Unproduced `mapOf` / `setOf` / `bagOf` walkers (optional follow-up).**
  **Source juror(s)**: pruner, surfacer, typist, prover, corner-prober.
  **Round**: 1.
  **Recommended action**: optional follow-up to the summary-fix bundle. If the team wants the renderer's `mapKey`/`mapValue`/`setElement`/`bagElement`/`bagCount` cases reached by real traces (rather than trimmed), open a follow-up PR adding walkers for `match:mapOf`, `match:setOf`, and `match:bagOf` to `packages/patterns/src/explain-mismatch/trace.js`. Adds coverage and delivers the renderer's promised attribution for `M.mapOf` / `M.setOf` / `M.bagOf` patterns. The summary-fix bundle chose the trim; this item preserves the alternative for revisit.
