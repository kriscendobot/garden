# Milestone report — js-26 native/bound callable invocation

**Repo/branch/PR:** endojs/endo-but-for-bots, `feat/ironhorse-262-language-completion`, draft PR endojs/endo-but-for-bots#970 (kept **open + draft**, not merged).
**Head SHA:** `1caaf58c7f48fae45ebf24f95843041826c70b5e` (9 commits stacked on base `93e08776a8`, all pushed).

## What I did (each feature has focused dual-run regression tests)
Added `rust/engine/ironhorse-262/tests/native_callable_invocation.rs` (11 test fns, all green against the XS oracle). All engine work is in `rust/engine/ironhorse-vm/src/interp.rs`:

1. **`bind` on a non-callable target → catchable TypeError** (ECMA-262 20.2.3.2 step 2); callable-proxy target keeps its honest skip.
2. **`new Function.prototype.{call,apply}` → TypeError** (built-ins aren't constructors).
3. **Native / native-method receiver routed through `Function.prototype.apply`** (new `call_dot_apply_native`, mirroring the existing `.call` fast-path) — dense-array + no-array shapes.
4. **Native-callable callbacks** (`[…].map(parseInt)`, `filter(Boolean)`, `map(String/Number)`) routed through `call_native` in `run_callback` (closes that arm of `callback:non-user-function`).
5. **`new` on a bound function** constructs the ultimate target (bound-arg prepend inner-first; `new.target` resolved through the bound chain; abrupt/object-return handled by the normal construct path).
6. **Primitive `this` boxing for sloppy callees** deferred to `begin` (`bind_this_sloppy` boxes Number/Boolean; strict callees pass the primitive through). Narrowed the `.call`/`.apply` guards to skip only String/Symbol/BigInt.
7. **`apply` non-object argArray → TypeError**; **calling a bound *native* function dispatches the native in place** — this eliminated the entire `bind:bound-callback` family (was 6, now 0).
8. **`apply` array-like argArray** via the existing `arraylike_to_vec` (CreateListFromArrayLike: length + indexed reads + abrupt-getter propagation).

## Before/after (official slices, XS oracle, pinned test262)
- **built-ins/Function/prototype: covered 131 → 178 (+47)**, unsupported 178 → 131, **ironhorse-failures 0** throughout, **no covered case regressed** (verified superset each batch).
- built-ins/Reflect: covered 70, failures 0 (no regression). built-ins/Number/prototype 65, Boolean/prototype 7 — failures 0 (confirming the general sloppy-boxing change introduced no divergence). Array/prototype 1420 (unchanged; native-callable-callback capability added + tested — that pattern is rare in conformance cases though common in real code).

## Gates (run before every push)
- `cargo test --workspace --release`: **green** every batch.
- `ironhorse-xst --gate-meter-exact …cases`: **51 failures — 100% pre-existing.** I rebuilt base head `93e08776a8` in a sibling worktree and confirmed the failing set is **byte-identical**; my milestone adds **zero** new violations. All are off-by-one in `stage3b-json-metering`/`stage3b-regexp`/`stage3-arrays`/`bigint` — unrelated to this family. **Flagged to the maintainer** (message delivered) and saved to memory; it blocks the branch's meter-exact invariant and needs a dedicated bisect/fix (likely the post-`b3c3ae93` Date/TO_INSTANCE work).
- No new `ironhorse-failure`/`infrastructure`; no relabeling/skip-listing.

## Honest residual (where the next claim resumes)
- **String/Symbol/BigInt `this` boxing** via call/apply (~4 cases): needs the exotic String-wrapper (own `length`/indexed props), a separate sub-family.
- **Sparse-array argArray to `apply`** (`apply:sparse-arguments-array`): holes-through-prototype not modeled.
- **`new` on a bound *native* target** (`bind:new-bound-target`, 1 case).
- `ironhorse-aborted` (~91 in Function/prototype) and `to_primitive:no-primitive-result` etc. — out of this family's scope (meter/other opcodes).

Milestone discipline followed: partial gains banked in bounded implement→test→gate→push cycles. This is real progress, not a gate breakage — no orchestration-failure condition.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-js26-milestone-native-callables.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 368 tokens (31886791 cached reads)
- Output: 137774 tokens
- Cost: $22.003401500000013
- Wall-clock: 3155s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
