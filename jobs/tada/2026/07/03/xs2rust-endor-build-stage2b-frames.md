Both commits are on `origin/xs2rust-endor` (HEAD = pushed). The job is complete. Writing the completion report.

---

## Completion report — xs2rust-endor stage 2b (2/3): user functions, closures, meter-check placement (PR #600)

**Landed** two green increments on `endojs/endo-but-for-bots@xs2rust-endor` (PR #600, kept DRAFT):

**1. User functions end to end** (`f1e97bd2a`): the `constructor_function`/`function` opcodes (real arena function instances + body-range/closures side table), `code` (faithful `fxNewChunk` metering — `round_up_8(N)+16`, not `N`), `function_environment`, and the call machinery — `call` reserving the stack-based RESULT/FRAME slots, `run`/`run_N` switching into the callee body frame reading XS's frame geometry (`[THIS, FUNCTION, RESULT, FRAME]` below the args), `argument` binding `mxFrameArgv`, `end` popping into the caller. **Meter-check placement moved to C-XS's real sites** (supervisor finding 1): checks fire at the `mxFirstCode` sites — call entry (`run`) and return-into-a-JS-caller (`end`) — and at backward branches; split `end` (pop+resume, checks) from `return` (exit-to-C, **no** check).

**2. Closures via heap cells** (`a2a39d7a7`): `new_closure` (shared cell, metered `fxNewSlot`), `store` (capture into the closure environment, metered), `retrieve` (import into the callee frame), `get`/`set`/`var`/`pull_closure` (read/write through the shared cell); added `Kind::Closure`; `function_environment` now pushes the env reference so `store`s target it. Mutations persist across calls and are visible to every capturer; distinct activations get distinct cells (non-aliasing).

**Acceptance evidence (verbatim):**
- `cargo test --workspace`: `endor-262` 11 passed, `endor-oracle` 3, `endor-fuzz` 3, `endor-vm` 25 — 0 failed.
- New corpora bit-exact (result **and** computron) vs the C-XS oracle: `stage2b-functions.js` (33 programs: IIFEs, multi-arg, locals, var-stored/named functions, nested calls, recursion incl. `fac(8)`/`fib(7)`/`sum(10)`, functions in loops) and `stage2b-closures.js` (10 programs: counters, captured parameters, multiple cells, triple-curried, in-scope closures, independent-activation counters). Sample raw agreement: `(function(x){return x+1})(5)` oracle=endor=2003288; `fac(8)` oracle=endor=12997512; counter closure oracle=endor=5759416/5759704 → computrons 87/87.
- Armed-meter placement tests pass: abort at call entry, abort at a backward branch, and — critically — **completes with the host never consulted** when a straight-line program exits to C (`no_meter_check_when_program_returns_to_c`).
- Prior green: stage-1 corpus, stage-2 corpus, child-1 heap corpus all still bit-exact. **Miri: all 25 endor-vm tests (frames + closures) pass with no UB.** `#![forbid(unsafe_code)]` holds outside `endor-oracle`.
- Two oracle-free captured-bytecode fixtures lock the frame + closure machinery/metering without linking C.

**Metering derivations** (measured per-site against pin `48ee02d8cfe0`, verified against the oracle's raw meter): call frames are stack-based → dispatch-metered only (recursion depth does not perturb the count); definition costs are `FUNCTION_DEFINE_METERING` (instance + default prototype), `+2` builtin steps for a real name (`fxRenameFunction`), `FUNCTION_LOCAL_METERING` per declared local at `code`-time, and per-cell `fxNewSlot`s at `new_closure`/`store`.

**Scope folds / frictions:**
- `PROGRAM_INVOCATION_COMPUTRONS` remains the measured constant `3`: it is the C-caller→program entry cost (`fxRunProgram`), not a JS→JS frame the bytecode-level machinery covers, so the frame machinery does not "explain it away" — hardcoding-as-measured is the correct outcome, documented in situ.
- `new`/constructor `target` binding (`new.target`) and class instances are out of the corpus scope (functions/closures/recursion/nested) and deferred; sloppy `this`→global binding is implemented.
- Sub-computron raw residuals remain on some definitions (≤~288 raw per definition, e.g. a `var`-closure declaration): they are per-definition (constant across calls/recursion depth, do not accumulate) and stay below one computron, so every corpus program is bit-exact at the computron level; documented honestly at the `FUNCTION_*` constants. No blocking discoveries — nothing sent to `port-xs-to-rust-memory-safe-engine-s5`.

**Follow-ups:** whole-section test262 runs (stage 3+) could surface a many-declaration function where the sub-computron residual crosses a boundary — closing the last per-declaration residual analytically (vs. the current measured constant) would harden that; `new`/constructor frame `target` is the natural next slice.
