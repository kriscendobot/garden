All deliverables landed. 

---

## Completion report

**Job:** symbolicated XS overflow stack trace + beta2 regression cross-check (ymax0 v320, garden #9)

### What I did
The prior round's instrumentation already named every JS frame via the engine's own `fxBufferFrameName`, but in a **non-minified** bundle the line numbers printed as negatives. Root cause: XS stores the source line in **16 bits**, so any line past 32767 (this contract bundle is ~43,886 lines) wraps negative (e.g. `-27787`). That was the one gap between "named frames" and a "fully source-mapped trace."

1. **Deepened the instrumentation** — added a `+65536` unwrap to the `XS_STACK_OVERFLOW_EXIT` frame walk (both the per-frame and wide-frame breakdowns) in `xsnapPlatform.c`. Confirmed the XS accessors in the moddable sources: `mxFrameToEnvironment(FRAME)->ID` *is* the file, `.value.environment.line` is the current line, `mxFunctionInstance{Code,Home}` give the declared name / profile ID.
2. **Rebuilt** the worker from source (recreated the wiped `build.config.env`, gcc-13 shim) and **reproduced** on the real v320 bundles.
3. **Captured the symbolicated beta3 trace** — frames now resolve to exact source: `#0 hex.js:37749 [lo,b2]` (the 256×4 `decodings` pair-arrays, ~1247 REFERENCE), `#1 Array.prototype.flatMap` (host, carrying the ~1992-CLOSURE flattened module functor), `#2 hex.js:37745 encodings.flatMap(...)`, `#3 bundle:43845 export {`. 9 frames → **width** exhaustion, not depth.
4. **beta2 cross-check (both halves of the directive):** beta2 Endo → **OK, exit 0, no overflow** at the 4096 on-chain default; beta3 Endo → exit 12. Forced beta2 with a 4032-slot worker to capture its near-limit chain — it trips at the **identical** frame chain ~37 closure slots narrower (functor 2538 vs 2575), matching the established +32 binding delta. Regression confirmed as pure width.

### What changed
- `kriscendobot/xsnap-pub` `debug/xs-stack-overflow-trace` (DRAFT #2) → commit `3e6c632` (line-unwrap), pushed.
- `kriscendobot/agoric-sdk` `debug/xs-stack-overflow-methodology` (DRAFT #6) → new "round 4" doc section (rebased over a peer's concurrent append), pushed as `4415b19`.
- Posted the symbolicated trace + beta2 cross-check to **garden issue #9** ([comment 4835369386](https://github.com/kriskowal/garden/issues/9#issuecomment-4835369386)); left the issue open for the maintainer.
- Updated memory `reference_xsnap_xs_repro_without_agoric_build` with the symbolication accessors, the unwrap, and the beta2/beta3 side-by-side repro steps.
- A peer dead-letter gardener (`deadmail-issue-comment-4835251662`) stood down so only one comment posted; no double-answer.

### Notes / follow-ups
- All work was fork-internal + the authorized issue-#9 comment; nothing upstream, all PRs kept DRAFT. No garden `main2` changes (this is an investigate job; deliverables are external).
- Primary fix is unchanged: contract-side `hex.js` `flatMap`→loop (`kriscendobot/agoric-sdk#7`) reclaims ~1000 REFERENCE slots, ~30× the Endo-side regression.
- The v320 swing-store export (maintainer-only) remains the one un-sourced path; not attempted.
