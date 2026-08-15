---
order: serial
children: ironhorse-js-26-cf-ta-ctor ironhorse-js-26-cf-ta-proto ironhorse-js-26-cf-dataview ironhorse-js-26-cf-slice-transfer ironhorse-js-26-cf-resizable-buffers ironhorse-js-26-cf-atomics ironhorse-js-26-cf-array-nondense
on-child-failure: halt
state: pending
created_by: gardener
created_at: 2026-08-15T01:02:50Z
---

# js-26 cf residual-closure orchestration (TypedArray / ArrayBuffer / DataView / Atomics / Array)

Serial, halt-on-failure orchestration owning the **remaining** scope of the parent cluster
job `ironhorse-js-26-cf-typedarray-arraybuffer` (js-26; PR endojs/endo-but-for-bots#970 head
`b3c3ae93`). The parent measured **3243 actionable cases** across
built-ins/{TypedArray,TypedArrayConstructors,DataView,Array,ArrayBuffer,Atomics}, closed the
ArrayBuffer/SharedArrayBuffer **constructor** ToIndex-coercion + catchable RangeError/TypeError
surface (landed on `feat/ironhorse-262-language-completion`, head `1c41b9a61`; +6 covered on the
built-ins/ArrayBuffer slice, 0 regressions, exact-metering corpus + full workspace green), and
re-decomposed the rest here per the "too large → sub-decompose + hand off" clause.

**Children (serial run order):**
1. `ironhorse-js-26-cf-ta-ctor` — TypedArray constructors (all forms + errors + species)
2. `ironhorse-js-26-cf-ta-proto` — %TypedArray%.prototype methods + element coercion (largest; expect re-decomposition)
3. `ironhorse-js-26-cf-dataview` — DataView ctor + get/set all element types
4. `ironhorse-js-26-cf-slice-transfer` — ArrayBuffer slice (species) + transfer/transferToImmutable/detach
5. `ironhorse-js-26-cf-resizable-buffers` — resizable/growable buffers + length-tracking/OOB views
6. `ironhorse-js-26-cf-atomics` — Atomics single-agent ops
7. `ironhorse-js-26-cf-array-nondense` — built-ins/Array non-dense/holey/abrupt fast paths

**Standing finding fed to every child (do not lose):** a large fraction of the cluster's
`ironhorse-aborted` / `abort-value-differs` error-path cases are blocked by a **general
object-model gap OUTSIDE this cluster** — reading `.constructor` on a user-function instance
(and `Foo.prototype.constructor`, and property access on `null`/`undefined` throwing a catchable
TypeError) currently aborts, and `assert.throws(Ctor, fn)` reads `thrown.constructor` on its
success path. Verified minimally by the parent: `new ArrayBuffer(-1)` caught by assert.throws is
covered, but `assert.throws(Test262Error, () => { throw new Test262Error() })` is `ironhorse-aborted`
because the catch-path `.constructor` read aborts. **This should be raised to the js-26 parent /
maintainer as a shared prerequisite** better owned by the general object-model (built-ins/Object)
cluster; TypedArray children should throw correct errors regardless and note the dependency.

Each child inherits the full acceptance bar and regression invariant (real XS-oracle execution,
no relabeling, Rust regression tests, exact-metering corpus green). Halt-on-failure: a child that
finishes without its gated outcome halts the serial run and surfaces to the maintainer.
