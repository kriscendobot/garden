Experiment 6 is complete and the result is posted. Final report:

---

## Completion report — `kriskowal-garden-pr9-2146e297`

**Directive:** kriskowal commented "Please try experiment 6" on kriskowal/garden issue #9 (the ymax0 v320 XS stack-overflow investigation). Experiment 6, defined in the prior session's methodology, is the export-free decisive test: drive the contract-bundle import through XS, with V8 and beta2-Endo controls.

**What I did:** Built an XS repro on-host with **no agoric-sdk build** — reimplemented the `xsnap-worker` fd-3/4 netstring protocol as a ~120-line node driver against the cached prebuilt worker 0.14.2, detecting the metered stack overflow as process exit code 12 (the production `exited: stack overflow` signature). Stood up SES inside XS via `@endo/bundle-source` (`endoScript`) of `@endo/init`, then ran the actual experiment.

**Result (decisive, positive):**
- `importBundle(bundle-ymax0)` on **XS → exit 12 "stack overflow"**; identical import on **V8 → OK** (exports `start`, `contract`, `meta`, …). A trivial-bundle control imports fine on XS, isolating the contract bundle's content as the cause.
- The crash reproduces from a **fresh import** (incarnation 0), so the v320 swing-store **export is not needed** — confirming the prior "overflow is at bundle import, not durable-data unserialization" finding.
- **beta2 vs beta3 Endo XS depth is identical** (passStyleOf 49 / marshal 48 / mustMatch 48; raw native budget XS≈390 vs V8≈15660). The Endo bump did not deepen frames-per-level → the regression is **contract structural depth crossing XS's ~48-level budget**, not Endo. (This also corrected the prior session's *estimated* 115/15 figures to the measured ~48–49.)

**What changed:**
- Posted the full result + reproducible methodology to issue #9: https://github.com/kriskowal/garden/issues/9#issuecomment-4823402129
- Saved a reusable-technique memory (`reference_xsnap_xs_repro_without_agoric_build`) + MEMORY.md pointer.
- Harness left on host under `/tmp/xs6` (driver, bundles, probes); beta2/beta3 endo sets in `/tmp/endo-beta{2,3}`. Read-only throughout; no agoric-sdk push/PR/merge, and the standing agoric-sdk monitor worktree was only read, not dirtied.

**Follow-ups (export-free, for the maintainer to direct):** (1) bisect which top-level contract definition overflows by importing with progressively stubbed exo/guard registration → names the exact guard; (2) rebuild the contract against beta2 Endo to close the import-path attribution empirically (needs an agoric-sdk contract build); (3) fix direction is contract-side depth-bounding of the deepest interface-guard / durable-record nesting (Auto-Features #12761 prime suspect), not an Endo change.

**Self-improvement:** Recorded the xsnap-without-build repro technique (prebuilt worker + netstring driver + the XS `'use strict'`/non-simple-param directive gotcha) as a reference memory; genuinely reusable for the next XS-only chain-bug investigation.
