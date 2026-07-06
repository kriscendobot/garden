My inbox was empty; the supervisor report was cleanly dead-lettered (s8 completed) and promoted for delivery, so the intent is preserved. The work is complete, tested, and pushed.

## Completion report

**Job:** Fixer — bound function in callback position dispatches at pc 0 (PR #600, `endojs/endo-but-for-bots` branch `xs2rust-endor`, kept DRAFT).

**Pushed:** commit `84e119fae` → `origin/xs2rust-endor` (rebase-CAS, first attempt).

### Root cause
A bound function (`f.bind(...)`) was registered in `functions` via `..FuncInfo::default()` — so `body_start = 0` — with its callability realized only by the CALL-opcode arm consulting `bound_functions`. Every other "user function" path trusted `native.is_none() && method.is_none()` and dispatched at `body_start`, re-executing the whole program from pc 0 inside the callee frame: unbounded re-entrant recursion → Rust-stack overflow → **process abort** in callback position, or **silent completion divergence** via `.then`/`.call`/`.apply`.

### Fix (`rust/engine/endor-vm/src/interp.rs`)
1. **`run_callback`** (Array map/forEach/filter/reduce/flatMap, Map/Set forEach, promise then-handler) now **trampolines** a bound callback exactly as `enter_call_bound` does — dispatch the target with bound `this` + bound leading args prepended, charging the calibrated `BIND_CALL_METERING + per-arg`. Verified **bit-exact on both result and computron** against the pin. Bound-of-bound stays the existing named skip.
2. **`enter_call_dot_call` / `enter_call_dot_apply`** self-name `Halt::Unsupported("bind:bound-callback")` for a bound receiver (the correct trampoline stacks two calibrated overheads — exactness not affordable now; an honest skip, never pc-0).
3. **Defused the gun:** `FuncInfo.body_start` is now `Option<usize>` (`None` for bodyless native/method/bound instances). `enter_call` — the single dispatch choke point — unwraps with a loud `Halt`, so any *future* missed gate self-names instead of recursing.

### Regression coverage
- Corpus lines (bound callback through every site, with/without bound args) in `stage3b-fundamentals-followup.js`.
- Dedicated test `bound_function_in_call_apply_position_self_names_never_diverges` in `endor-262/src/lib.rs`.
- New fundamentals-followup **fuzz arm** emitting bound functions in callback position (`endor-fuzz/src/lib.rs`) + `saw_callback` coverage assertion.

### Bar — all met
- `built-ins/Array`: covered=**437** (≥403), **no process abort** (the tree that killed the sweep now completes), divergent=0.
- `built-ins/Function` **39**, `Map` **25**, `Set` **37**, `Promise` **7** — all divergent=0.
- Full `cargo test --workspace` green (endor-vm 46, endor-262 32, endor-fuzz 23, oracle 7, regexp 10, parity 1; **0 failed**).
- `#![forbid(unsafe_code)]` intact on all four safe crates.

### Follow-ups / scope
No scope folds. `.call`/`.apply`-of-bound and bound-of-bound-callback remain honest `bind:bound-callback` skips — a future exactness increment if the stacked trampoline metering is wanted. Two pre-existing warnings (`interp.rs:7185` unused `mut`, `7998` unused `argc`) predate this change and were left untouched. The supervisor report was dead-lettered to `port-xs-to-rust-memory-safe-engine-s8` (completed) and promoted for delivery.
