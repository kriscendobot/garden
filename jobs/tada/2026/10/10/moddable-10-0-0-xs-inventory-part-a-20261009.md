I finished the inventory for all five items. On resume I read the diff hunks for every commit, which resolves most of the open points from the first attempt, including the missing `fill` change. Research only: no build, no ports, nothing committed.

**Scope:** commits in Moddable-OpenSource/moddable dated 2026-09-04 to 2026-10-08, reached from `5f215f776f93039755343dbe75a09aa2615045f4`. I listed them with the GitHub commits API and read the patches with `gh api`. All engine changes below are in `xs/sources/xsDataView.c`, except Atomics (`xsAtomics.c`) and the build flag (`xsCommon.h`). Commit URLs take the form `https://github.com/Moddable-OpenSource/moddable/commit/<sha>`.

### Engine semantics

| # | Item | Commit(s) | XS file / symbols | test262 path / spec | What should happen |
|---|---|---|---|---|---|
| 1 | Immutable ArrayBuffer on in all builds | `f98758c91a2d305639f75b60807770d385ab8d57` (2026-10-07); docs `bf1c67142309fe2cc64563632622fda656e9e8ad`; `33cc1b4bf1` fixes the `sliceToImmutable` callback name in the snapshot table; skip-list `2836649956640c40dddc38b13f4fa2e3d704ddd6` (2026-09-26) | `xsCommon.h`: `#ifndef mxImmutableArrayBuffers` default changes 0→1, so `XS_MINOR_VERSION` goes up by 1. `mxImmutableArrayBuffers` is also removed from `XS_MOD_COMPATIBLE_MINOR_VERSION` (ES2026 branch), so mod compatibility no longer depends on the flag. | feature `immutable-arraybuffer`: `built-ins/ArrayBuffer/prototype/{transferToImmutable,sliceToImmutable,immutable}/**`, plus the immutable-buffer write cases in TypedArray and DataView | `transferToImmutable`, `sliceToImmutable` and `.immutable` exist unless a build explicitly sets `-DmxImmutableArrayBuffers=0`. Writes to an immutable buffer throw TypeError (`fxCheckArrayBufferMutable`, `XS_MUTABLE` size checks). |
| 2 | ArrayBuffer resize rejection order (#1724) | `b4e0cab143c70566de72c859e5e176f0f34521ad` | `fx_ArrayBuffer_prototype_resize` | `built-ins/ArrayBuffer/prototype/resize/*` (non-resizable / argument-coercion order); spec ArrayBuffer.prototype.resize steps 2–5 | New order: instance check → mutable check → non-resizable check (max length) → `fxArgToByteLength` (ToIndex) → detached check. The old code converted the argument before checking that the buffer is resizable. So a non-resizable buffer now throws TypeError without calling `valueOf`, and detachment is checked only after coercion. |
| 3 | setFromHex: detached check before odd-length check (#1700) | `c97c28ec568a72280e461cd3a11f2d5acdbfaf70` (2026-09-22) | `fx_Uint8Array_prototype_setFromHex`: `fxCheckDataViewSize(..., XS_MUTABLE)` now runs before hex decoding | `built-ins/Uint8Array/prototype/setFromHex/*` (feature `uint8array-base64`), the detached and immutable target cases | Per the spec, a detached or out-of-bounds target throws TypeError before an odd-length or invalid string throws SyntaxError. An immutable target now also throws TypeError first. The fix is about detached/out-of-bounds versus odd length; I found no separate change to a bounds check. |
| 4a | TypedArray constructor: length before prototype (#1718) | `df98bbacb808c957d1343c09fb9daa8158d19d36` | `fx_TypedArray`, `fxConstructTypedArray`, `fxNewTypedArrayInstance`: `fxArgToByteLength` moved ahead of the newTarget prototype read | `built-ins/TypedArrayConstructors/ctors/length-arg/*` (proto-from-ctor-realm vs ToIndex order) | Per the spec, `ToIndex(length)` comes before `GetPrototypeFromConstructor(newTarget)`. The title describes the old bug ("read newTarget's prototype before converting"); the fix converts the length first. |
| 4b | TypedArray fill argument conversion order (#1711) | `2d530640aed424c074a48499d918613e3359d9a1` (2026-09-24). This is the `fill` change I couldn't find in the first attempt. | `fx_TypedArray_prototype_fill`: start/end `fxArgToIndexInteger` reordered relative to value conversion, then `fxCheckDataViewSize(XS_MUTABLE)` | `built-ins/TypedArray/prototype/fill/*` (coerced-value/start/end order; detached-after-coercion) | Spec order: value (ToNumber or ToBigInt) → start → end → revalidate, with TypeError if the array became detached or out of bounds. The reorder only partly shows in the hunk, so it is worth confirming with the conformance test. |
| 4c | TypedArray.prototype.set: large offset (#1726) | `2d059ebaee86c18a30bd641c467663bef0c079eb` | `fx_TypedArray_prototype_set`: the array-like path now uses `txNumber targetOffset` (truncated, NaN→0, <0 → RangeError) instead of `fxArgToByteLength`, and `sourceLength = ToLength(src.length)` | `built-ins/TypedArray/prototype/set/array-arg-*offset*`, `…src-get-length*` | A negative offset throws RangeError right away. An offset above Int32 no longer throws early; the source is read first and RangeError comes only when `srcLength + offset > targetLength`. |
| 4d | TypedArray species content type (#1723) | `c645752e4b44b405f0c0eab8f7c957c8ae391b81`; `d19b9da1e009d85ec3d645229f9b0c11c632752f` (read-only-buffer follow-up in `subarray`) | new `fxCheckTypedArrayContentType`, called from `fx_TypedArray` (TypedArray source), `filter`, `map`, `slice`, `subarray` | `built-ins/TypedArray/prototype/{filter,map,slice,subarray}/speciesctor-*content-type*`, `TypedArrayConstructors/ctors/typedarray-arg/*bigint*` | A species or derived result whose BigInt-vs-Number content type doesn't match the source throws TypeError. The follow-up adjusts `subarray` for read-only (immutable) buffers. |
| 5 | Atomics.wait leak/deadlock | `e1fa1b78892242cbe9fcec4c48addb73c8a614f1` (2026-09-27); related `83ab166a03866d01d909feafb3ed6eeb33c96cff` (2026-09-30) | `fxWaitSharedChunk`: the "main thread cannot wait" TypeError is now thrown up front (sync wait with no resolve function on the main thread), before the lock is taken or a waiter allocated. `83ab166a03` adds `fxRevalidateAtomicsIndex` (out-of-bounds TypeError, index RangeError) after argument coercion in each Atomics read-modify-write op. | `built-ins/Atomics/wait/*` (main-thread / agent-cannot-suspend); `built-ins/Atomics/{add,and,compareExchange,exchange,…}/*` (validate after coercion with resizable buffers) | `Atomics.wait` on a thread that cannot suspend throws TypeError without holding the cluster lock or leaking the waiter, which was the source of the deadlock and leak. Atomics ops recheck bounds after `valueOf` side effects. I saw 7 revalidate call sites; whether `wait`/`notify` themselves are among them is unconfirmed. |

### Not engine semantics (separated out)
- **ECMA-419:** System object, keyValue, RTC/ArrayBuffer conformance (`add95da93e`, `137beda5ca`), 419 tweaks.
- **Device and board:** pico, nrf52, esp32, zephyr, m5dualkey, OTA.
- **TypeScript:** typings and linting, heavy churn on 2026-09-27/28 and 2026-10-01/03.
- **Other:** Piu (`f45deeedae`), Pebble, mcrun/mcpack/manifest, `xsLogDebug`, ASAN poisoning (`31f7c389bc`), fuzzilli `detachArrayBuffer` (`b2a085e352`), xsbug test-runner skip list (`2836649956`).
- **Other XS engine fixes outside this part's items**, a natural "part b": #1715–#1717, #1720–#1722, #1725, regexp replace (`db0490c5bc`), switch with labelled break (`051b31b2dc`).

### Oracle and ratchet implications
- **Minimum oracle xst does not change.** The feature code already existed behind `mxImmutableArrayBuffers`, and the garden's finding is that the Moddable 9.0.0 release xst already has native immutable ArrayBuffer. 10.0.0 only flips the source default, so a self-built xst without flags now has it too. The on-PATH xst still lacks it (per memory), so keep ≥ 9.0.0 for immutable-arraybuffer.
- **10.0.0 is needed to get the ordering fixes** (#1700, #1711, #1718, #1723, #1724, #1726, and the Atomics fixes) in the oracle. Moving to 10.0.0 will change test262 outcomes in the TypedArray, ArrayBuffer/resize, setFromHex and Atomics directories.
- **Ratchet baseline:** `context/operations/ironhorse-ratchet.md` (line 106) forbids adopting a newer `baseline/refresh-<date>/` floor by date alone. So the oracle change needs a deliberate, recorded baseline refresh, and differences between XS and the shim in those directories should be expected, not treated as regressions.
- **Hardened262 / Ironhorse test matrix:** the "XS lacks immutable ArrayBuffer unless built with the flag" assumption is now false for 10.0.0 builds.
- **The `XS_MINOR_VERSION` bump** changes the xst version string; any version gate or fingerprint on the oracle needs updating.
- **The `immutable-arraybuffer` skip-list entry** covers only xsbug's runners (`xsbug-test.js`, `Test262Pane.c`). It was added 2026-09-26, while the default was still off. Hardened262 and Ironhorse must not copy it.

### Remaining uncertainties
- The exact final order in `fill` (value vs start/end) is inferred from a partly visible reorder.
- Whether `fxRevalidateAtomicsIndex` covers `Atomics.wait`/`notify` is unconfirmed.
- I didn't check whether the xst test262 runner under `xs/tools` has its own skip list.
- Author dates fall outside the window for `c4bae39c71` and `1052d363df` (June/July); both are out of scope.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/moddable-10-0-0-xs-inventory-part-a-20261009.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 16 tokens (458926 cached reads)
- Output: 7641 tokens
- Cost: $1.3287414
- Wall-clock: 132s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
