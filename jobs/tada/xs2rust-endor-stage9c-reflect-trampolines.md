All work is committed, pushed, and verified. HEAD (`6c9ca62198`) matches `origin/xs2rust-endor`; c/moddable is clean at the pin. The job is complete.

## Completion report

**Job:** Stage-9c child 3/9 — `Reflect.apply` / `Reflect.construct` re-entrant trampolines (PR #600, `endojs/endo-but-for-bots`, branch `xs2rust-endor`, kept DRAFT, no PR comments).

**Measured starting tip:** `58261fcbd4` (the real remote tip; the body's `8865953620` had advanced through children 1 and 2). c/moddable pinned at `23b4d6b0a6`.

**What I did — three commits, each pushed as it completed:**

1. **`076f0ed33c` feat** — Implemented both re-entrant natives in `endor-vm/src/interp.rs`:
   - `Reflect.apply(target, thisArgument, argumentsList)` and `Reflect.construct(target, argumentsList[, newTarget])` now drive the target through the call/construct machinery behind a **jump barrier**, following the proven `op_add` ToPrimitive precedent (`cfbca1092c`). Added `run_reentrant_call` / `run_reentrant_construct` (the latter stages the `[THIS=uninitialized, ctor, RESULT, FRAME]` construct geometry and enters with `has_target=true`) and `create_list_from_array_like` (CreateListFromArrayLike over a real Array, dense or holey with holes reading `undefined`).
   - A throwing callee/constructor escapes the barriered nested dispatch as `Halt::Throw`; I added an `op_add`-style reroute at the `RUN`-opcode native-method dispatch site, **scoped to the two Reflect methods**, so a surrounding `try`/`catch` catches it while `JSON.stringify`-cyclic / `lockdown` keep their escape-to-host behavior.
   - Added a `FuncInfo.can_construct` flag stamped from `XS_CODE_CONSTRUCTOR_FUNCTION` (XS's `XS_CAN_CONSTRUCT_FLAG`) so `Reflect.construct`'s IsConstructor gate rejects a non-constructor (arrow/method/generator/native) as an honest skip rather than running its body. Bound targets, class constructors, distinct `newTarget`, non-object argLists, and array-like ordinary objects all self-name.
   - 25 dual-run cases in `reflect_intrinsic.rs` (result agreement + BothAbort agreement for the honest-skip forms).

2. **`b18130c0b8` test** — 16 curated corpus cases (9 `stage9c-reflect-apply`, 7 `stage9c-reflect-construct`), all completing/result-agreeing so `covered==total` holds. Bumped `CORPUS_PROGRAM_COUNT` 1825 → **1841**.

3. **`6c9ca62198` fix** — Removed a new unused-import warning I'd introduced.

**Verification (all executed, exit codes checked):**
- Full engine-workspace `cargo test --workspace`: **EXIT=0**, all 42 `test result:` lines show `0 failed`. `reflect_intrinsic` 25/25, `endor-vm` 88/88.
- Curated compile-diff: **1841/1841 identical, 0 divergent**; SYMB **1841/1841 identical**.
- Coverage-equivalence proof: `covered==total` (1841) passes.
- Boot gate: **17/17 green** (no skip→green conversions this child).
- Zero NEW Rust warnings (the C-oracle `-Wclobbered` warnings are pre-existing).
- `#![forbid(unsafe_code)]` intact at all **8** engine crate roots; I added no unsafe.
- c/moddable clean at the pin, never staged; no committed bundles.
- `can_construct` is a bool on the existing `FuncInfo`, not a new side table; consistent with siblings `is_class_ctor`/`is_generator` (none snapshotted).

**Honest remainders (named, out of scope by soundness gate):**
- **Array-like non-Array argLists** self-name — endor's covered grammar cannot build one (ordinary objects hold no integer-indexed own properties; the sloppy `arguments` object is a separate unimplemented surface, `Unsupported("arguments_sloppy")`). Documented in `reflect_intrinsic.rs`.
- **`newTarget !== target` retargeting** self-names (no `new.target` retargeting slot in the covered grammar).
- **Class-constructor** and **bound-target** construction self-name (separate super-aware / bound-reshape paths).

The eventual-send shim (child 5) can now call both `Reflect.apply` and `Reflect.construct` on ordinary user functions.
