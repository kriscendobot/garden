The issue is OPEN and the reply is posted. Work complete.

## Completion report

**Job:** Follow-up on kriskowal/garden#9 — verify mhofman's two asks about the Moddable engine-side fix for the ymax0 v320 XS value-stack overflow.

**What I did**

Re-fetched the live #9 thread (treated as untrusted data). mhofman's comment 4898246955 asked two things; I answered both with a built-and-run engine A/B, then replied on the issue (comment [4898761427](https://github.com/kriskowal/garden/issues/9#issuecomment-4898761427)), addressing him by handle, leaving the issue OPEN, signing as the prior kriscendobot #9 comments.

Built three `xsnap-worker`s from the same pristine agoric-labs moddable base (`f6c5951`) at the on-chain default `stackCount=4096`, differing only in the `fx_Array_prototype_flatAux` `mxPop()`: `stock`, `cherry` (73aad47b's leaf-branch placement), `pr1` (kriscendobot/moddable#1's end-of-block placement). Ran two A/Bs through the fd-netstring driver.

**Findings (evidence in the reply)**
- **Ask 1 — cherry-pick of `73aad47b`:** *Yes, sufficient.* A shape-faithful `hex.js` `new Map(RI.flatMap(...))` overflows on `stock` at ≥3600 pairs (instrumented trace: 4092/4096 slots, one wide frame with 3878 live REFERENCE slots — width, not depth, matching the real ymax0 trace) and clears on `cherry` at every width. The commit is three one-line `mxPop()`s; only the `flatAux` leaf-branch hunk bears on #9 (the sort/`xsmc` hunks are unrelated leak sites).
- **Ask 2 — why PR#1 pops "at a different place":** PR#1's pop is at the end of the per-element block (covering both the leaf *and* nested-recursion branches); `73aad47b`'s is inside the leaf branch only. Equivalent for leaf-dominated `hex.js`; a nested-heavy `flat(1)` probe separates them — `stock` overflows ~N2000, `cherry` still leaks the un-popped sub-array refs and overflows ~N4100, `pr1` (pops both) clears past N4200. So PR#1's placement is a strictly-more-complete superset for `flatAux`; `73aad47b` is the better upstream cherry-pick overall because it also fixes sort/`xsDelete`.

**What changed (committed to `main2`, pushed, SHA `d9921c9d2`)**
- New durable harness `skills/agoric-chain-snapshot/repro/engine-flatmap-ab/` (`build-variant.py`, `synth-flatmap-ab.mjs`, `nested-flatmap-ab.mjs`, vendored `xsdrive.mjs`, `README.md` with the result tables) + a pointer from the parent repro README — so the engine A/B survives redeploys, addressing the thread's recurring "artifacts keep getting wiped" complaint.

**Scope/safety:** read-only analysis of upstream Moddable + on-host builds/runs of the open-source XS engine on bot forks only; no upstream `agoric/agoric-sdk` or `Moddable-OpenSource/moddable` interaction; issue left open for the submitter.

**Follow-ups (offered in the reply, not done):** if wanted, fold `73aad47b` into kriscendobot/moddable#1 with the pop moved to the end-of-block position (most complete), and/or route the real stock beta3 bundle import through the `cherry` engine (the SES-in-XS import harness was wiped; the real-bundle overflow at 4096 was already established earlier in the thread).
