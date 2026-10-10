# IronHorse conformance audit against the Moddable SDK 10.0.0 XS fixes

I audited all 20 items against `endojs/endo-but-for-bots@llm` at commit `7d2eb307a`, under `rust/engine`. This was research only: no project edits, no garden commits, and no implementation jobs posted.

**How I got the evidence:**
- **Source evidence:** the inventory job `moddable-10-0-0-xs-source-inventory-20261009` split its work into three children. I read all three completed reports (`…-xs-inventory-part-{a,b,c}-20261009`).
- **Code and tests:** I read the IronHorse code, the `ironhorse-262/expectations/whole-tree` (WT) files, and `baseline/refresh-20260904`. Groups b and c were also checked by running JS snippets through a runner built from this same checkout, outside the project tree. That runner and its build output have since been deleted.
- **Spot checks:** I re-read the key citations myself: the oracle pin, the Math.round guard, the repeat check order, the TypedArray constructor order, and the revoked-proxy check.

**Key context:** the oracle is still Moddable 8.3.1 (`xs-oracle/build.rs`: submodule `23b4d6b0a65f`, no `mxImmutableArrayBuffers`). The test262 pin is `be13516…` (2026-08-07). At that pin, `testWithTypedArrayConstructors` builds resizable buffers, so most TypedArray, `ctors`, and Atomics cases halt as `native-call:ArrayBuffer:resizable`. Items 4a, 4c and 4d therefore have almost no live test262 coverage in IronHorse.

Paths below are relative to `ironhorse-vm/src/interp/`.

| # | Item | Class | IronHorse evidence | test262 / expectation |
|---|---|---|---|---|
| 1 | Immutable ArrayBuffer | **needs-port** | No `transferToImmutable`, `sliceToImmutable` or `immutable` native exists; the only mention is a meter key (`ironhorse-meter/src/default_keys.rs:535`). No TypedArray or DataView write path checks for immutability. `tests/ses_boot_intrinsics.rs` (`FROZEN_REALM_FORECLOSURE`) assumes the engine lacks the proposal. | Under `built-ins/ArrayBuffer/prototype/{immutable,sliceToImmutable,transferToImmutable}/**` and the immutable-buffer cases in TypedArray, DataView, setFromHex and resize, nearly every test is a `skip:shared-*` because XS 8.3.1 also lacks the feature. `sliceToImmutable/this-is-not-detached.js` passes only vacuously and is in `refresh-20260904/covered.txt`. |
| 2 | ArrayBuffer resize rejection order | **not-applicable** | `natives/dispatch.rs:3907` `ArrayBufferResize` returns `Halt::NotImplemented("array-buffer-resize:unsupported")`. Constructing with `{maxByteLength}` halts too (`dispatch.rs:664`). | `resize/*`: `skip:unsupported-opcode:array-buffer-resize` |
| 3 | setFromHex: bounds check before odd-length check | **not-applicable** | No `setFromHex`, `fromHex` or base64 native exists | `setFromHex/*` fails; `detached-buffer.js` passes only because calling the missing method throws a TypeError |
| 4a | TypedArray constructor: ToIndex before the prototype read | **needs-port** | `natives/dispatch.rs` ~1043–1055: `to_number_f64`, then `typed_array_prototype`, then `index_from_number`. That is the old XS order, kept on purpose per the code comment. | `ctors/length-arg/*` mostly skip as resizable; `proto-from-ctor-realm` is a shared skip |
| 4b | TypedArray fill order and detached check | **already-conformant** | `natives/buffer.rs:1221` `TypedArrayFill`: value, then start, then end, then the detached TypeError. The out-of-bounds part doesn't apply (no resizable buffers). Tests: `ironhorse-262/tests/typed_array_mutators.rs` `fill_coerces_once_…` and `detachment_during_coercion_…`. | 11 pass, 38 skip as resizable |
| 4c | TypedArray set with an array-like | **needs-port** | `buffer.rs:1264` `TypedArraySet`: a negative offset correctly throws RangeError. But an offset above `i32::MAX` is rejected early ("byteLength too big"), before the source length is read (the old XS behavior). Separately, a detached target throws per element where the spec silently skips; `set_checks_detachment_after_each_array_like_get` locks that divergence in. | `set/array-arg-targetbuffer-detached-on-get-src-value-no-throw.js` **fails** |
| 4d | Species and constructor content type | **needs-port** (constructor only) | Species is conformant: `buffer.rs:600` `typed_array_species_create` already throws on a BigInt/Number mismatch, so XS 10 now agrees with IronHorse. The constructor (`dispatch.rs` ~870–960) is not: `new BigInt64Array(new Int8Array(0))` doesn't throw. | `ctors*/typedarray-arg/src-typedarray-{big,not-big}-throws.js` skip as resizable |
| 5 | Atomics.wait leak/deadlock; revalidation after coercion | **Temporal/host-excluded** | `buffer.rs:1772` `atomics_dispatch`: `wait`, `notify` and `waitAsync` return `Halt::Refused("atomics:wait-notify")`, so no lock or waiter exists to leak. Operands that need guest coercion halt `atomics:coerce`, and with no resizable buffers there is nothing to revalidate. SharedArrayBuffer is single-agent only. | `ironhorse-262/src/xst.rs:1536,1551` pre-skips these as `structural:can-block` and `structural:multi-agent` |
| 6 | Math.round subnormals | **needs-port** | `natives/number.rs:121` uses the old XS guard `a.is_normal() && \|a\| < 2^52−1`, so subnormals come back unchanged: measured `round(±MIN_VALUE)` = ±5e-324. The same window also leaves ±(2^52−1)+0.5 unrounded. This is an explicit port of the XS code, not Rust's `f64::round`. | All `Math/round` tests pass apart from metadata; test262 has no subnormal case |
| 7 | Math.irandom | **not-applicable** | Absent on purpose for determinism: `realm.rs:252` and `native_ids.rs:681` say `Math.random` is not implemented, and `Math.imod` is absent too | XS extension; no test262 coverage |
| 8 | charAt/charCodeAt 32-bit truncation | **already-conformant** | `natives/string.rs` `call_string_indexed` goes through `array_to_integer_or_infinity` with f64 math; `as i64` saturates. Measured: `charCodeAt(2**32+1)` and `charCodeAt(-Infinity)` give NaN, `charAt` gives `""`. | charAt 60/60, charCodeAt 50/50 pass |
| 9a | String repeat | **needs-port** (narrow) | `string.rs:594` checks `n > 0x7FFF_FFFF` and throws "count too big" before the empty-receiver shortcut, so `"".repeat(2**31)` and `"".repeat(Number.MAX_SAFE_INTEGER)` throw. They should return `""`. NaN, ±0, negative and Infinity are already correct. | repeat 32/32 pass; test262 only goes up to 2^31−1 |
| 9b | replace/replaceAll/@@replace/RegExpExec with a Proxy (IsCallable) | **already-conformant** | `function.rs` `slot_is_callable` follows the proxy target, and is used by `regexp.rs` `string_replace{,_plain,_all_plain}`, `regexp_replace_generic` and `regexp_exec_abstract`. Measured: a Proxy replacer and a Proxy `exec` are both called. | replace 108, replaceAll 90, Symbol.replace 136 pass |
| 9c | indexOf/lastIndexOf/includes/startsWith/endsWith with no argument | **already-conformant** | `call_string_indexed` treats a missing argument as undefined, then applies ToString | All pass |
| 10 | Symbol.for() with no argument | **already-conformant** | `natives/dispatch.rs:7574` `SymbolFor` treats a missing argument as undefined, then applies ToString | Passes apart from length/name metadata |
| 11 | Array.from: ToLength and iterator-callable order | **needs-port** (ToLength only) | `natives/array.rs` `array_from_inner`: `to_length_value` is right, but a length above `u32::MAX` throws RangeError before `Construct(C)`. Measured: `Array.from.call(C, {length: 2**32})` never calls C. The @@iterator callable check already comes before Construct and is conformant. | `get-iter-method-err.js`, `iter-cstm-ctor.js` and `source-object-length.js` pass; no test262 case uses length ≥ 2^32 with a custom C |
| 12 | Reflect.apply/construct argument-read order | **already-conformant** | `natives/reflect.rs` `reflect_call_operands`: the checks run, then `arraylike_to_vec`, then the call. The `invoke.rs` fast path shares this code. Measured order: `length`, then the trap. | `Reflect/{apply,construct}/*` pass |
| 13 | Object.prototype.toString: @@toStringTag through a handler | **already-conformant** | `natives/dispatch.rs` `ObjectToString`: IsArray follows proxies, the tag `Get` goes through the get trap, and the builtin tag is "Function" | `toString/proxy-*` pass |
| 14 | Array.fromAsync with a non-object next() result | **already-conformant** | `natives/array.rs` `from_async_resume_next` rejects with TypeError | `fromAsync/*` pass |
| 15 | Set methods with size over 2^31−1 | **already-conformant** | `natives/collection.rs` `get_set_record` keeps size as an f64 and every comparison is done in f64. Measured: sizes 2^32, 2^53 and Infinity take the correct branch. | `size-is-a-number.js` passes |
| 16 | Revoked Proxy IsCallable | **needs-port** | `function.rs:628` `slot_is_callable` and `slot_is_constructor` return false once a proxy is revoked, and `ProxyRevoke` nulls the target, so the [[Call]] fact is lost. `typeof` gives "object". About 114 call sites rely on these two functions. | `language/expressions/typeof/proxy.js`, `Proxy/revocable/target-is-revoked-function-proxy.js`, `Proxy/create-target-is-revoked-function-proxy.js` and `Function/internals/Construct/base-ctor-revoked-proxy.js` **fail**, while the 8.3.1 oracle passes them, so IronHorse is behind its own oracle here |
| 17 | SyntaxError for over 65535 scope slots | **needs-port** | `ironhorse-compile/src/coder.rs` `width_select_index_plus_one_family` adds 2 to the opcode id for indices above 65535, but the local, closure and private opcode families only have `_1`/`_2` forms: `GET_LOCAL_1`+2 becomes `GET_PRIVATE_1`, and the operand is written `as u16`. The scoper has no cap. Measured: more than 65535 slots compile and then halt with `NotImplemented("private:missing-brand")`. | No test262 case (XS limit). `tests/compiler_symbol_limit.rs` covers symbols only. |
| 18 | switch with labelled break/continue stack leak | **needs-port** | `coder.rs` `code_switch` pops the discriminant only at its own break target. `code_break_continue` emits no POPs, and `Target.stack_level` is recorded but never read. Measured: one slot leaks per switch per iteration (`StackOverflow(300004)`), with `continue outer`, labelled blocks, `try/finally`, and nested switches. | No test262 case. The fix will break the 8.3.1 byte-identity pins in `coder_byte_identity.rs` for these shapes. |
| 19 | String.prototype.replace capture-group memory safety | **already-conformant**, no analogous hazard | See the analysis below | `Symbol.replace/named-groups*.js` and `result-coerce-groups{,-prop,-err,-prop-err}.js` pass |

**Item 19, the replace capture-group fix.** The XS bug came from sizing the output in one pass and copying in a second, with two `Get`+`ToString` calls per group. IronHorse can't have that bug:
- The three GetSubstitution routines in `natives/regexp.rs` (`regexp_generic_substitution`, `regexp_get_substitution`, `string_plain_substitution`) each make a single pass. `reserve_scratch` only sets the starting capacity, and `extend_work_scratch` grows a `Vec` safely. There is no `unsafe` code.
- On the generic path, `$<name>` calls `mop_get` once and ToString once per occurrence. Measured: a getter that returns a longer string on its second call produced `[s][LONGER_STRING]` with exactly two calls, which is the correct count and output.
- A Rust slice panic (an abort/DoS risk) is ruled out because every user-controlled index is bounded before slicing:
  - `position` is clamped to `[0, len]`.
  - The `$'` start uses `saturating_add(...).min(len)`.
  - The `$<` scan checks `i+1 < len` first.
  - `$nn` is checked against `captures.len()`.
  - User captures are capped at 2^24.
  - Assembly guards against positions that move backwards or overrun.
- The fast path runs only with no getters, proxies, or shadowed `exec`, and uses the engine's own monotone match positions.

**Immutable ArrayBuffer: xst, matrix and ratchet implications.**
- **Oracle:** 9.0.0 already has the feature natively, and 10.0.0 only turns it on by default. Moving the oracle from 8.3.1 to 9.0.0 or later turns every `shared-*` immutable-ArrayBuffer skip into an `ironhorse-failure` or `oracle-disagreement` (`xst.rs:709-714`). The vacuous `covered.txt` pass would likely regress against the covered set. Under `context/operations/ironhorse-ratchet.md`, that needs a deliberate, recorded baseline refresh rather than a date-based one. The ratchet doc says nothing about immutable buffers or the oracle version.
- **Version string:** the 10.0.0 `XS_MINOR_VERSION` bump changes the xst version string, so any fingerprint or version gate on it needs updating.
- **Feature exclusions:** none assume XS lacks immutable buffers. `DEFAULT_ENDOR_SKIP_FEATURES` (`xst.rs:47`) lists only ShadowRealm, TCO, IsHTMLDDA and ses-xs-parity. Don't copy Moddable's xsbug `immutable-arraybuffer` skip-list entry.
- **hardened262:** `packages/hardened262/test/ArrayBuffer/view-behavior-matrix.js` (`onlyRaw`, needs native immutable buffers) appears in none of the `baseline/{xs,sesXs,ironhorse,sesIronhorse,sesNode}` lists. It will start showing up for `xs` with a newer xst and will fail for `ironhorse`.
- **SES boot test:** `ses_boot_intrinsics.rs`'s frozen-realm foreclosure assumption would need to be revisited.
- **Side effect of the upgrade:** it removes the XS 8.3.1 species/content-type deferral that IronHorse documents, so the two engines converge there.

**Provisional port candidates.** These are a grouping only; no jobs were posted.
1. **Engine safety and correctness (compiler):** #17 (the >65535-slot SyntaxError; today the wrong opcode runs) and #18 (the switch labelled-jump stack leak; this changes the byte-identity pins).
2. **Proxy callability:** #16 (record the callable and constructor bits on `ProxyData`, plus the persist/restore snapshot rows).
3. **Small built-in order fixes:**
   - #6 Math.round: subnormals, plus the ±(2^52−1)+0.5 window.
   - #9a: `"".repeat` with a huge count should return `""`.
   - #11: Array.from with length ≥ 2^32 must call Construct(C) first.
4. **TypedArray order:** #4a (constructor ToIndex order), #4c (huge offset rejected early; detached-target writes), #4d (content-type check in the constructor). These have weak test262 coverage until resizable ArrayBuffer exists, so they need targeted unit tests.
5. **Feature work, larger than a port:**
   - #1 Immutable ArrayBuffer, coupled to the oracle upgrade and a baseline refresh.
   - #2 and #3 are blocked on resizable ArrayBuffer and on base64/hex support.
   - #5 and #7 are excluded by design.

**Outside these items:**
- `Atomics.load` on a detached view reads stale bytes instead of throwing; `detach_array_buffer` doesn't zero the view length.
- `String.prototype.substr` (Annex B) is unimplemented, so XS's substr overflow fix has nothing to apply to.
- Every Math function, and `Symbol.for`, fails its `length.js` and `name.js` metadata tests.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/moddable-10-0-0-ironhorse-audit-20261009.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 40 tokens (1159939 cached reads)
- Output: 16995 tokens
- Cost: $7.274121000000004
- Wall-clock: 2116s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
