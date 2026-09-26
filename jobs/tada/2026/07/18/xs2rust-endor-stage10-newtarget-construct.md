Inbox empty. Work is complete and verified. Here is my completion report.

---

## Completion report — `xs2rust-endor-stage10-newtarget-construct` (PR #600 stage 10 child 2)

**Context:** This was a **resumed** run. A prior invocation of this same job had already implemented and pushed the core deliverables. My contribution was to (a) run the full acceptance verification on the pushed state, (b) close the precise item-3 gap I could safely land, and (c) report the honest remainder.

**Branch state measured:** synced to the real remote tip `2771330b9b` (the branch had advanced past the sha in the job body). c/moddable populated at pin `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`, verified clean, never staged. Seeded `target/` from a sibling and `cargo clean`ed **all** endor crates (superset of the required three) to eliminate stale-cache false results.

### What was already done and pushed (prior run — verified by me)
- **Item 1 — `Reflect.construct(target, args, newTarget)` retargeting** (`newTarget !== target` mints `newTarget.prototype` via the new per-frame `cur_new_target` seam; body runs as `target`).
- **Item 2 — Promise-subclass construction via `Reflect.construct(Promise, [executor], Subclass)`** — the exact bottom `new HandledPromise(executor)` reaches. Executor driven, instance carries the subclass prototype, lives in the `promises` side table (no new shape), resolve/reject round-trips.
- **Item 3 half — `new.target` in ordinary function bodies** — green (corpus `008.js`/`009.js` + `reflect_intrinsic` tests).
- Corpus: `cases/language/stage10-newtarget-construct/` (13 cases); `CORPUS_PROGRAM_COUNT` 1896→1909.

### Verification bar — all green (captured to files, checked by exit code)
- `cargo test --workspace` **EXIT=0**; all **48** `test result:` lines `0 failed`; **683 passed**.
- **Zero new Rust warnings** (the 346 warnings are all endor-oracle C-build output from the audited FFI seam).
- Curated compile-diff: **1909 identical, 0 divergent**; SYMB: **1909 identical, 0 divergent** (grown from 1878 at stage-9 close).
- Boot gate: **17 passed** (unchanged; its only remaining skips are the unrelated receiver-chain `at` guard + the structural out-of-workspace-bundle skip — no class-construction skips remain there).
- `#![forbid(unsafe_code)]` at **7** crate roots; endor-oracle correctly the sole audited FFI seam.
- c/moddable clean at pin; no committed bundles; no new VM side table.

### What I added this run (committed `5d8df81871`, pushed `2771330b9b..5d8df81871`)
A named honest-skip guard section (§3 in `promise_subclass_construct.rs`, 2 self-alarming tests) formalizing the **super()-construction soundness gate** in the `boot_bundle_gate` §2 ledger discipline: the oracle completes, endor halts at exactly `Unsupported("super")`, and each assertion **fails the day super() lands**, forcing the next stage to promote it. Directly serves item 3's "keep the soundness gate on what remains." Verified green (8 passed, exit 0, zero warnings).

### Honest remainder (precisely named)
**`super()` construction in class constructor bodies via ordinary `new Derived()`** — `XS_CODE_SUPER` (opcode 208) currently falls through to `Unsupported("super")`. This is a distinct, larger VM surface than items 1–2: the derived-constructor `this`-TDZ protocol (`BEGIN_STRICT_DERIVED`/`SET_THIS`/`END_DERIVED`, `fxRunDerived`), the parent-constructor invocation threading the derived `new.target`, and field initializers after `super`. The **18 class-construction honest skips** of item 3 depend on this surface. I deliberately did not attempt it within a single deadline-bound handler after spending budget on setup+verification — a rushed, half-verified `super()` change risks regressing a green branch, strictly worse than a clean, named, self-alarming remainder. Notably the **boot-critical path is unaffected**: `new HandledPromise(executor)` bottoms into `Reflect.construct(Promise, […], new.target)` (item 2, complete), not the `super()` top.

**Follow-up for a future stage-10 child:** implement `XS_CODE_SUPER`/`SET_THIS` and the derived-constructor `this`-TDZ protocol, then promote the two §3 skips (they will fail-to-green automatically) and the broader 18 class-construction skips.
