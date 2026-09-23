Everything is clean and complete. Final report:

---

## Completion report — stage-4 child 3/8: generator functions & iteration protocol

**Ported the pin's `xsGenerator.c` sync half to `rust/engine/endor-vm`, bit-exact (result AND computron) against C-XS.** Pushed to `origin/xs2rust-endor` (PR #600, kept DRAFT). Commits `b41446ad7` (engine), `87536751d` (Miri test), `f7d0d957d` (README).

**What changed**
- **Suspend/resume as heap state**: a new `generators` side table (modeled on `promises`) holds each generator's lifecycle state (suspended-start / suspended-yield / executing / completed) and a `SavedFrame` — scope (`locals`/`id_map`), call identity (`args`/`this`/`cur_func`/`cur_target`/`strict`/`result`), the generator's own value-stack temporaries, and the resume cursor. Deliberately the representation async/await (child 4) resumes on.
- **Opcodes**: `GENERATOR_FUNCTION` (`.prototype` → new `%GeneratorPrototype%`), `START_GENERATOR` (create instance + snapshot + return), `YIELD` (snapshot + unwind via a new `Halt::Yield`; the `{value,done}` object is the one the body builds by bytecode, returned as-is), and `BRANCH_STATUS_{1,2,4}` (the yield-resume epilogue). `%GeneratorPrototype%.next(v)`/`return(v)` via `resume_generator` (suspends the driver onto `call_stack`, reinstalls the frame, nested-dispatches, restores). `for-of`/spread over a generator.
- **Metering** allocation-driven (no `mxMeter` in `xsGenerator.c`): calibrated frozen constants `GENERATOR_{FUNCTION_EXTRA=24, START=1136, YIELD=32616, RESULT=66304, RESUME=65536}`; object-literal `*m()` naming charges `fxRenameFunction`.

**Verification (bar met)**
- Dual-run, **divergent=0, every skip named**: `statements/generators` 74 covered, `expressions/generators` 79, `built-ins/GeneratorPrototype` 8, `built-ins/GeneratorFunction` 0 (ctor-as-value skips); **`statements/for-of` grew 92→118**. No regressions (`expressions/object` 309, `for-in` 19, `defineProperty` 9 — all 0-div).
- `cargo test` green: endor-vm (10), endor-262 lib (38, incl. new `stage4_generators_corpus_is_bit_exact_against_oracle`), endor-regexp (52). Corpus `stage4-generators.js` locked.
- **Miri-clean** (`generator_suspend_resume_is_miri_clean`); `#![forbid(unsafe_code)]` intact. README evidence block updated.

**Scope fold** (honest named skips, carried forward): `yield*` delegation; `throw`/`return` **into** a suspended body (throw-into-suspended + `finally` unwinding through the catch/finally jump chain); `yield` inside a live `try` (needs the jump-chain snapshot/rebase); `new`-constructed generators; async generators / `await` (child 4, resumes on this same `SavedFrame` machinery).

**Advisory metering note** (accuracy-over-parity): `GENERATOR_YIELD_METERING` is calibrated on a top-of-body yield; XS's saved-stack `fxNewChunk` scales with the exact activation size, so a yield reached with extra live loop temporaries carries a ~408 raw/resume sub-computron residual (the `while(true) yield` drift) — below the computron floor, 0-divergent across all sections, documented as endor's own deterministic approximation. A follow-up could make the constant a function of the saved-slice length for raw-exactness on loop-heavy generators.

Supervisor (`port-xs-to-rust-memory-safe-engine-s9`) inbox was gone; the completion message was dead-lettered and will be promoted to a fresh job (intent preserved). No GC scheduling touched (GC-roots note carried forward untouched).
