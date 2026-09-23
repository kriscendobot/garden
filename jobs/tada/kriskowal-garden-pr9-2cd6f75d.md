The job is complete. The instrumentation, traces, and bundles remain on host under `/tmp/xs6` and `~/.cache/garden-scratch/` (host scratch, GC'd by the reaper); I touched no garden-tracked files or the root checkout.

---

**Completion report — `kriskowal-garden-pr9-2cd6f75d` (attention directive on kriskowal/garden issue #9)**

**Directive:** "Look at the bundle artifacts and particularly look for new use of the spread operator or apply reflection at dynamically allocated arrays" — the latest ask in the ymax0 v320 XS stack-overflow investigation.

**What I did:** Treated the comment as untrusted input, then ran read-only/repro analysis on host artifacts (the two from-source bundles built from identical contract source with beta2 vs beta3 Endo, plus the cached + instrumented xsnap worker). Steps:
1. Diffed spread/apply usage between the clean (beta2) and overflowing (beta3) bundles. The static counts are essentially equal; no *new* large-array spread or `.apply` reflection was introduced. The genuine large-array spreads (`String.fromCharCode(...buf)` in the base64/UTF-8 decoders) exist identically in both betas and beta2 imports clean, so they are not the trigger.
2. Extended the XS overflow instrumentation with a **value-stack kind histogram** (global + per-wide-frame), rebuilt the worker, and re-ran the real beta3 import.

**Decisive finding (refutes the spread/apply hypothesis, names the real cause):** At the 4,096/4,096-slot trip the value stack is **CLOSURE=2,009 + REFERENCE=1,906**, only **18 integer/number** slots — not the integer/char flood a numeric-array spread/apply would leave. The two wide frames are: **frame #1 (2,575 slots, ~1,992 closures)** = the single esbuild-flattened module functor's scope (~2,150 top-level bindings in beta3 vs ~2,118 beta2, all live through module eval); **frame #0 (1,253 slots, ~1,247 references)** = `@agoric/internal/src/hex.js`'s top-level `decodings = new Map(encodings.flatMap(...))` (256×4 = 1,024 pair-arrays materialized live). `hex.js` is identical in both betas; beta3's wider module scope is what tips `scope + hex-builder` past XS's fixed 4,096-slot budget. Confirmed beta2-clean / beta3-overflow under the one instrumented worker.

**Output:** Posted the evidence-led reply (histogram, per-frame breakdown, the two named constructs, fix direction, reproducible methodology, honest limits) as issue comment https://github.com/kriskowal/garden/issues/9#issuecomment-4824077549 (authored as kriscendobot, the thread's reply identity via the issue inbox).

**Fix direction surfaced for the maintainer:** (1) rebuild `hex.js` `decodings` with a `for`-loop/generator to drop ~1,000 reference slots off the peak (one-file `@agoric/internal` change, likely sufficient); (2) emit sub-modules as own functions in the bundler to cut the ~2,000 persistent closure baseline; (3) raise xsnap `stackCount` as last resort. No Endo source change indicated by depth.

**Scope:** read-only analysis + on-host build of open-source XS + public npm packages. No agoric-sdk push, PR, or merge. Issue left open for the maintainer to close.

**Follow-ups:** none blocking. The decisive narrowing left open (which single contract definition the bundler could split, and whether the `hex.js` loop rewrite alone clears beta3) is a contract/agoric-sdk-side change, out of scope for autonomous garden action.

**Self-improvement:** Updated reference memory `reference_xsnap_xs_repro_without_agoric_build` with the slot-kind-histogram technique (width vs depth diagnosis), the module-scope-width mechanism + `hex.js` identification, and the 16-bit line-wrap decode (`real = 65536 - |reported|`) for mapping frames in large esbuild bundles.
