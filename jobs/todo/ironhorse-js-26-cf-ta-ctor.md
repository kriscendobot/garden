---
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-08-15T01:04:03Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# js-26 cf: TypedArray constructors (all forms + errors + species)

**Scope:** `built-ins/TypedArrayConstructors` (~688 cases) + the constructor-shaped
subset of `built-ins/TypedArray`. The `new TA(length|buffer,offset,length|typedArray|arrayLike|iterable)`
forms, ToIndex coercion of length/offset, the RangeError/TypeError error paths
(`native-call:TypedArray:{coerce-offset,bad-offset,coerce-length,bad-length,bad-byteLength,from-object}`),
`%TypedArray%` abstract constructor (newless TypeError), and `Symbol.species` on derivations.

**Engine sites:** interp.rs `Native::TypedArray(i)` ctor arm (~12633–12825, dense list of
`native-call:TypedArray:*` Unsupported skips), `TYPED_ARRAY_TYPES`/`TypedArrayData` (~2476/2543).
Reuse the parent's `to_index_arg` helper for the length/offset coercion + catchable errors.
Existing `typed_array_from_source` test is the pattern.

Part of the **js-26 TypedArray/ArrayBuffer residual-closure** effort, re-decomposed
from the oversized parent `ironhorse-js-26-cf-typedarray-arraybuffer` (measured on PR
endojs/endo-but-for-bots#970 head `b3c3ae93`). Parent closed the ArrayBuffer/SharedArrayBuffer
constructor ToIndex-coercion + catchable RangeError/TypeError surface (landed on
`feat/ironhorse-262-language-completion`, head `1c41b9a61`) and re-decomposed the rest here.

**Shared branch/PR (do not create a new one):** `feat/ironhorse-262-language-completion`
(PR endojs/endo-but-for-bots#970 — OPEN draft, keep open, do NOT merge). Fetch+preserve prior
commits, stack bounded commits, push with a rebase CAS loop. Serial orchestration — fetch+rebase before push.

**Pins:** engine head `b3c3ae93b81c0f266458cd25f2f27d94ef80cc5b`; test262
`tc39/test262@be13516fb6441b950ba8a3df97eb34062c186972`; XS oracle `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`
(`git submodule update --init --depth 1 c/moddable`). PATH: prepend `$HOME/.cargo/bin`; TMPDIR off noexec.
Cached test262 at pin: `/home/kris/garden/scratch/test262-pin-be13516f` (`--test262-dir … --no-fetch`).

**Acceptance bar (non-negotiable):** convert cases to **covered** via real execution against the
official XS differential oracle (`rust/engine/ironhorse-262/scripts/full-run.sh --subtree <PREFIX>
--test262-dir <pin>`), except a specifically justified standards-grounded host-only/proposal exclusion.
Add focused Rust regression tests under `rust/engine/ironhorse-262/tests/`. Do NOT relabel/suppress/skip-list.
Zero generic `ironhorse-aborted`, `parse-or-decode`, `unsupported-opcode:*`, `abort-value-differs`,
`non-primitive-completion` may remain within this child's scope.

**Regression invariant:** no covered case in `baseline/baseline.json` or from an earlier child regresses;
no new `ironhorse-failure`/`infrastructure`; exact-metering corpus stays green
(`ironhorse-xst --gate-meter-exact rust/engine/ironhorse-262/cases` + `cargo test --workspace --release`).
Run the affected slice + these gates before EVERY push.

**CROSS-CUTTING PREREQUISITE (from parent, read this):** many `ironhorse-aborted`/`abort-value-differs`
error-path cases are blocked by a **general object-model gap**, not TypedArray semantics: reading
`.constructor` on a user-function instance (and `Foo.prototype.constructor`, and `null`/`undefined`
property access throwing a catchable TypeError) currently aborts. `assert.throws(Ctor, fn)` reads
`thrown.constructor` on its success path, so error cases stay `ironhorse-aborted` even after you throw
the right error. This gap is OUTSIDE the TypedArray cluster (general object-model / built-ins-Object).
Throw the correct error anyway (real progress; unblocks instantly when the prereq lands) and note the
dependency rather than a cluster-local hack.

**If too large for your budget:** do NOT partially relabel. Bank verified bounded progress + land it,
then sub-decompose the remainder into a nested halt-on-failure orchestration and hand off (report the
durable continuation). Recursion is expected.

Repository: `endojs/endo-but-for-bots`. issue_spine: issue-kriscendobot-garden-51
