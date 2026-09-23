PR #600 confirmed still draft/open. The job is complete — all work committed and pushed to `xs2rust-endor`, acceptance bar fully met.

---

## Completion report — xs2rust-endor stage 2b (child 1/3): allocation-faithful object heap + metering

**What landed** (2 commits on `endojs/endo-but-for-bots` branch `xs2rust-endor`, PR #600, kept DRAFT):

`0cbe7fec6` — allocation-faithful var/environment heap + the two supervisor findings:
- The global object is now a real arena-backed instance; a top-level `var` hoists onto it as an own **property slot** (`fxNewSlot`, `1<<8`) at `EVAL_ENVIRONMENT`, and `SET_VARIABLE` meters one built-in step (`mxMeterOne`, `1<<14`), creating the property (sloppy global) when absent. The program-frame + eval-environment setup overhead (invocation baseline + the measured 17688 aggregate) is accrued once at `BEGIN_*`, in raw 16.16 units so it composes with allocation metering through the carry into computrons. `EVAL_ENVIRONMENT` also resets the scope (`fxRunEvalEnvironment` `the->scope = top+1`) so a hoisted var lives in its global property and its freed scope slot is reused.
- **Finding 2**: `Meter::begin` now matches `fxBeginMetering` (`interval<<16`, `meterIndex=0`, `meterCount=interval<<16`); armed-meter tests re-expressed with computron-unit intervals.
- **Finding 1**: `RETURN`/`END` run **no** meter check when the top frame exits to the C caller (`xsRun.c` 1080-1092 / 1069-1078); the `mxFirstCode` check sites arrive with child 2's frame machinery.

`bdaec4e9e` — object literals + own-property heap: `OBJECT` (`fxNewObject` = 16384+256), `NEW_PROPERTY` (536 create + 16384 built-in for `fxRunDefine`), `SET_PROPERTY` (536 create / 0 overwrite, no `fxRunHas` so no built-in step), `GET_PROPERTY` (0, like `GET_VARIABLE`). Every weight verified per-site against the pin's raw meter. Property slots hold the value directly, keyed by id and chained via `next`, so the GC traces them.

**Acceptance evidence (verbatim, reproduced against the `c/moddable` pin `48ee02d8cfe0`):**
- Stage-1: `total=86 bit_exact=86 result_div=0 computron_div=0 completion_div=0 unsupported=0` — `ACCEPTANCE BAR MET`.
- Stage-2 corpus (11 var/loop behavioral + 12 object/property = 23): `total=23 bit_exact=23 result_div=0 computron_div=0 completion_div=0 unsupported=0` — **graduated into the bit-exact bar (result AND computron)**. The "16920 per var" is now reproduced, not measured (536 property alloc + 16384 store).
- `endor-vm` 22/22, `endor-262` 4/4, `endor-fuzz` 3/3, `endor-oracle` 3/3.
- GC suite under Miri (extended over the instance/property/prototype shapes): `test result: ok. 8 passed; 0 failed`.
- `#![forbid(unsafe_code)]` intact on endor-vm/endor-262/endor-fuzz; no stray `unsafe` outside endor-oracle.

**Scope folds / frictions for the supervisor:**
1. **Closure-cell aliasing deferred to child 2** — I materialize the global property (for metering + GC shape) while the interpreter's scope/global-props hold the working value, unified via the scope-reset-on-`EVAL_ENVIRONMENT`; XS's actual closure-cell aliasing between a top-level var's scope slot and its global property is not modeled.
2. **`DELETE_PROPERTY` not implemented** — no corpus program in the current grammar reaches it; it still halts `Unsupported` (self-naming), as do all opcodes outside this child's subset (full 245-opcode coverage + closures/exceptions/frame-switching are children 2 & 3).
3. **Two metering aggregates are measured constants, not fully decomposed**: the program-frame+eval-environment setup (17688) and the property-create remainder (280, atop one real `fxNewSlot` of 256 → 536 total). Both are documented and verified against the oracle's raw meter; individual `fxNewSlot`/`fxNewChunk` decomposition (incl. the property-name chunk, which the current grammar never allocates independently) is engine-internal and deferred.

No blocking discovery, so nothing sent to the supervisor's inbox. PR #600 remains draft/open.
