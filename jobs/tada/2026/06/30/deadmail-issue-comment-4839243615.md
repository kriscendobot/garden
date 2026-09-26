Done. No `main2` code changes were needed (this was a research-and-answer job); the deliverable was the issue comment.

## Completion report

**Job:** `deadmail-issue-comment-4839243615` — dead-lettered comment from issue-inbox, original recipient `issue-kriskowal-garden-9` had already completed. Picked up its intent: kriskowal's new comment on kriskowal/garden#9 asked to "show the native XS `flatMap` code to illustrate that it spreads its argument or result array onto the stack."

**What I did:**
- Located the native XS source at `moddable/xs/sources/xsArray.c` (XS 13.3, as built into `@agoric/xsnap` 0.15.0 under `~/.cache/garden-scratch/exp6-ymax0/`; same logic as the on-chain prebuilt worker).
- Traced the exact value-stack discipline of `fx_Array_prototype_flatMap` → `fx_Array_prototype_flatAux`, verifying against the push/pop macro semantics in `xsAll.h` (`mxPushSlot`, `mxRunCount`, `mxDefineIndex`→`fxDefineAll`, `fxHasIndex`→`fxHasAll`) and the contrasting `fx_Array_prototype_forEach`.
- Confirmed the mechanism: the helper's `while` loop pushes one value-stack slot per visited element and **never `mxPop`s `item` within the loop** (flat/flatMap must hold each result to inspect and flatten it), so the entire flattened set is resident on the stack at once and freed only when the C call returns. `forEach`, by contrast, `mxPop()`s each result per iteration. This maps directly to the measured ~1232 live `REFERENCE` slots in `frame#0` (the `hex.js` `decodings = new Map(encodings.flatMap(...))` line) and explains why the `for`-loop rewrite drains the transient and clears the 4096-slot overflow.

**What changed:**
- Posted the answer as a comment on the issue thread: https://github.com/kriskowal/garden/issues/9#issuecomment-4839285776 (quoting both native functions with file/line, the slot-leak walkthrough, and the `forEach` contrast). Did not close the issue (submitter's prerogative).
- Updated the durable reference memory (`reference_xsnap_xs_repro_without_agoric_build`) with the native-code provenance (exact file/function names and the no-pop-vs-`forEach`-pop contrast) so a future agent can answer the same question without re-deriving it.

**Follow-ups:** None outstanding. Inbox was empty at start and after posting. The investigation's open empirical item (load a real pre-upgrade swing-store on a taller worker, Q8) remains parked under job `verify-ymax0-hex-fix-inquisitor`, gated on a captured snapshot — unaffected by this answer.

**Self-improvement:** nothing this time.
