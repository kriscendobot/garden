---
model: opus
roadmap: xs2rust-endor
---
# Fixer: bound function in callback position dispatches at pc 0 — crash / silent divergence (PR #600)

**Repo:** `endojs/endo-but-for-bots`, branch `xs2rust-endor` (PR #600, DRAFT — keep it DRAFT).
Work in an isolated project worktree keyed by THIS job's base
(`ensure-project-worktree.sh <this-base> endojs/endo-but-for-bots xs2rust-endor`), repopulate the
`c/moddable` oracle pin `48ee02d8cfe0` per `rust/engine/README.md` (empty-gitlink footgun: `git init`
first, fetch from a sibling `/home/kris/scratch/project-wt-*/c/moddable`).

## The defect (found by the s7 supervisor's whole-stage-3 independent reproduction, 2026-07-06)

A bound function (`f.bind(...)`, stage-3b child 4) is registered in `functions` with
`..FuncInfo::default()` — i.e. **`body_start = 0`** — and its callability is realized only by the
CALL-opcode arm checking `bound_functions` (`interp.rs` ~4684 → `enter_call_bound` ~8015). Every
OTHER path that enters a "user function" trusts `native.is_none() && method.is_none()` and dispatches
at `body_start`, so a bound function reaching those paths **re-executes the whole program from pc 0**
inside the callee frame:

- **`run_callback` (~5956): unbounded re-entrant recursion → Rust-stack overflow → process abort.**
  Repro (each crashes the harness):
  `[0].map(function(){return 1;}.bind(null))`, same for `forEach`/`filter`/`reduce`/`flatMap`
  (and by code inspection every callback-taking Array method), `new Map().set(1,2)` +
  `m.forEach(bound)`, Set `forEach(bound)`. This is what killed the whole `built-ins/Array` dual-run
  sweep: `built-ins/Array/prototype/flatMap/bound-function-argument.js` aborts the runner process.
- **Silent divergence (worse than a crash for the invariant):**
  `Promise.resolve(1).then(function(v){return v;}.bind(null))` → completion diverges
  (pump handler path ~7598); `b.call(null)` / `b.apply(null,[])` on a bound `b` → completion
  diverges (`enter_call_dot_call` ~7876 / `enter_call_dot_apply` ~7937 reshape into the *bound
  wrapper's* frame and run `body_start=0`). completion_div=1, unsupported=0 — a wrong outcome the
  never-a-wrong-value invariant forbids.

## Required fix

1. **Close every gate.** Audit ALL sites that treat a `functions` entry as having a real body:
   `run_callback`, `enter_call_dot_call`, `enter_call_dot_apply`, the promise pump's handler
   invocation, the promise executor path (already excludes bound — keep), and any other
   `body_start` consumer. For each, a bound function must either (a) **trampoline correctly** —
   reshape to the TARGET with bound `this`/prepended bound args and charge the already-calibrated
   `BIND_CALL_METERING + per-arg` (mirror `enter_call_bound`; bound-of-bound stays the existing
   named skip), or (b) self-name **`Halt::Unsupported("bind:bound-callback")`** where exactness
   is not affordable now. Never dispatch at pc 0; never a wrong value.
2. **Defuse the loaded gun.** `FuncInfo::default()`'s `body_start = 0` is indistinguishable from
   "program start". Make the bound entry's body unrepresentable-as-runnable (e.g. an
   `Option<usize>`/sentinel checked at every dispatch entry, failing loud as a `Halt`), so a future
   missed gate cannot recurse silently again.
3. **Regression coverage.** Corpus programs (bound callback through map/forEach/filter/reduce/
   flatMap, Map/Set forEach, then-handler, `.call`/`.apply` of bound) + extend the
   fundamentals-followup differential fuzz arm to emit bound functions in callback position.
4. **Bar:** re-run `built-ins/Array` (whole tree — must complete without process abort; expected
   covered >= 403), `built-ins/Function` (>= 39), `Map` 25 / `Set` 37, `Promise` 7 — all
   divergent=0; full `cargo test --workspace` green; `#![forbid(unsafe_code)]` intact. Doctrine:
   accuracy-over-parity is decided (design § Metering, 2026-07-04) — result agreement gates; the
   branch's runner still checks computrons, keep it green via the calibrated trampoline constants
   or honest skips, never a fitted number.

Report completion + any scope folds to inbox `port-xs-to-rust-memory-safe-engine-s8` (the supervisor
continuation; a dead-letter is fine, it gets promoted). Do NOT touch the maintainer inbox or un-draft
the PR.
