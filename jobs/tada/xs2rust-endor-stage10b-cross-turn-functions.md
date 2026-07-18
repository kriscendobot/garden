All verified. Both commits are on `origin/xs2rust-endor`, working tree clean, no bundles committed, moddable clean at pin. The job is complete.

## Completion report — `xs2rust-endor-stage10b-cross-turn-functions` (PR #600 stage-10b child 1/5)

**Repo:** `endojs/endo-but-for-bots`, branch `xs2rust-endor` (PR #600, kept DRAFT, not commented). Synced to real tip `d197a95e34` before starting; pushed two commits.

### What I did

**Cross-turn function invocation is now callable — via an append-only retained code buffer.** The named prerequisite from stage-10 child 3 (a function installed by turn 1 survived as *data* but was not *callable* in turn 2, because dispatch jumps to a `body_start` offset into the *currently running* program's bytes) is closed for self-contained function bodies.

- **The design chosen (least-disturbing to the metered path):** the persistent realm grows a single **append-only** code buffer (`Interp::retained_code`). Each turn's program is appended at `base = retained_code.len()` and dispatched from that base over the whole buffer. Because XS branches are **pc-relative** (`branch_target`) and prior turns' bytes are never moved, a function defined by turn 1 keeps its original `body_start` and its body dispatches against the SAME retained bytes when called from a later turn — the flat dispatch loop's `pc` simply lands back in the retained region, so **no re-entrancy or offset rebasing is needed**.
- **Byte-identity of the single-shot path:** `run(code)` now delegates to a new `run_at(code, 0)` whose body is identical to the prior `dispatch(code)` epilogue; `retained_code` stays empty off the persistent realm. Proven untouched (see verification).

**DoD — both bindings green:**
1. **endor-vm persistent-realm tests** (6 new): invoke a prior-turn function (arg round trip + return value `20*2+1=41`), string-argument round trip, a prior-turn `throw` caught in the calling turn, a turn-1 function still callable in turn 3, and a **named-remainder guard** pinning the honest boundary.
2. **`endo` crate multi-turn worker test** (1 new): turn 1 installs `globalThis.handleCommand` as a **function**, turn 2 invokes it (`7*3+1=22`), turn 3's negative input surfaces as a catchable error.

**Ledger (item 4):** new VM state `Interp::retained_code` ledgered as `SideTable::RetainedProgramCode` — **SnapshotExcluded** (host-only live-realm state, empty on the single-shot path), **GC-invisible** (raw bytes, no arena slots; the function instances are rooted independently). `VARIANT_COUNT` 34→35, `ALL` + descriptor + a by-contract test added.

### Verification (all EXIT=0)
- Engine `cargo test` (3 crates cleaned after seeding): **48 `test result` lines, all 0 failed, 701 passed** (695 at cut + 6 mine).
- compile-diff curated: **1909 identical, 0 divergent**, full accept/reject agreement; **SYMB 1909 identical, 0 divergent** — the metered single-shot path is byte-identical.
- Boot gate: **22 passed, 0 failed** (no skip→green changes).
- **Zero new Rust warnings** (only the pre-existing moddable C `cc` warnings); `#![forbid(unsafe_code)]` intact on all **8** engine crate roots.
- `c/moddable` clean at pin `23b4d6b0…`, never staged; no committed bundles (gitignored placeholders used for the endo build, per child-3 precedent).
- ROOT-workspace `cargo test -p endo --lib`: **83 passed, 0 failed** (82 at cut + 1 mine).

Commits: `995535e40c` (engine) and `e8db14a179` (worker), both on `origin/xs2rust-endor`.

### Named remainder (honest boundary, exact resume point)
- **Cross-turn *symbol* resolution is NOT closed.** A prior-turn function body that resolves a **symbol id** reads it against THIS turn's symbol tables, because the C-XS compiler numbers symbols program-locally (the same name gets a different id each turn) and `carry_globals_into` rebuilds the tables per turn. Two characterized failure modes: an **intrinsic reference** (`new Error(...)`) fails *loudly* (undefined-variable throw, run does not complete); a **named-global read** (`globalThis.base`) is *silently wrong* (misses under the new ids → `undefined`/`NaN`). Both are pinned by `persistent_realm_prior_turn_symbol_ref_is_the_named_remainder`.
- **Resume point for the next child:** per-turn **symbol-context switching on cross-program frame entry/exit** (retain each turn's `symbol_names`/`symbol_ids`/`symbol_key_ids` + cached ids in a `RetainedProgram` record keyed off the callee's owning region, swap on `enter_call`/`leave_call`), **plus** making the shared global object carry bindings under every turn's numbering (or re-key on entry) so intrinsic/global reads from a prior-turn body resolve correctly. This is the change that would let a *real* handler (one referencing `Error`, `JSON`, or realm globals) run across turns.
- **Closures over turn-1 top-level `var`** (a frame local, not carried) likewise do not survive; the working realm idiom is `globalThis.X = …`, which the tests and worker use.
- SES worker bundle boot (note 2) and snapshot suspend/restore (note 3) remain as before, untouched.
