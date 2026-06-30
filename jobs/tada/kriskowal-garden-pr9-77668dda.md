Done. Completion report follows.

---

**Job: attention directive on kriskowal/garden#9** — "show the native XS `flatMap` code to illustrate that it spreads its argument or result array onto the stack."

**What I did**
- Re-fetched the directive and treated it as data. Routed it to the right work: locate the native XS source, verify the mechanism against measured evidence, and answer on the issue.
- Read the native code in the engine ymax0 v320 actually runs (XS 13.3.0, `agoric-labs/moddable@f6c5951`, `@agoric/xsnap@0.15.0`, vendored under `moddable/xs/sources/`): `fx_Array_prototype_flatMap`/`flat`/`flatAux` in `xsArray.c`, plus the helper `fxDefineAll`/`fxHasAll`/`fxGetAll` in `xsAPI.c` and the `mxPushSlot`/`mxOverflow` macros in `xsAll.h`.
- **Confirmed the maintainer's hypothesis with the exact line.** The leak is not the recursion (depth-bounded; `depth=1` for flatMap) and not the `while` guard (`fxHasIndex` pops). It is two unbalanced pushes per element: `fxDefineAll`'s single `mxPop()` pops only the freshly-pushed `mxResult` instance and leaves the value `item` resident, and the array branch never pops the mapper's returned sub-array after the recursive `flatAux`. So `flatAux` leaves ~5 slots per source byte (1 sub-array + 4 pairs) resident until the whole builtin frame unwinds: `256 × 5 = 1280`, matching the previously-measured ~1238-slot hex frame that overflowed `stackCount = 4096`. Peak value-stack use of `flatMap` is O(flattened output length).
- Tied it to the fix: the `for` loop makes each `decodings.set(...)` a fully-unwinding statement, so peak is O(1), which is why the patched bundle's hex moment drops out of the peak.
- Posted the answer (native code + slot accounting + version provenance) as an issue comment, on the thread's established channel, as kriscendobot: https://github.com/kriskowal/garden/issues/9#issuecomment-4839300009. Drained inbox first (empty).

**What changed**
- No `main2` / garden code change (analysis-and-answer job). One new GitHub comment on garden#9.

**Follow-ups**
- None required. The one open empirical item from the prior thread (the inquisitor confirmation on a real mainnet swing-store) is unchanged and still queued behind the snapshot capture; this job did not touch it.

**Self-improvement:** Saved a reusable reference memory (`reference-xs-flatmap-spreads-onto-value-stack`) recording the `fxDefineAll`-leaves-value-resident mechanism, companion to the existing xsnap-repro reference, so future value-stack-overflow work starts from the precise cause instead of re-deriving it.
