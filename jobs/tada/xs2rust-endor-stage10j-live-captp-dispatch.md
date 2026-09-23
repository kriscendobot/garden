Push confirmed (remote == local at `42e4fcdf8e`), inbox empty, PR #600 remains DRAFT. All work is complete and verified.

## Completion report

**Job:** stage-10j — advance the CapTP-dispatch frontier of the endor-vm worker (PR #600, `endojs/endo-but-for-bots` @ `xs2rust-endor`, kept DRAFT).

**What I found.** Instrumenting the fully-booted worker bundle's own `globalThis.handleCommand`, invoked with a real CBOR `deliver` envelope, showed the handler halted the moment it *decoded* the frame — not on the missing global stage-10i predicted, but earlier: the CBOR reader slices the buffer with `cursor.data.subarray(pos, pos+n)`, and endor had **no `%TypedArray%.prototype.subarray`**, so the callee resolved `undefined` → `Throw("call: not a function")`.

**Step 1 — closed the frontier (`subarray`).**
- Added `NativeMethod::TypedArraySubarray`, installed on the abstract `%TypedArray.prototype%` (concrete views chain to it).
- Implemented it as a NEW view of the receiver's kind over the SAME backing ArrayBuffer (no element copy): `begin`/`end` clamp through XS's `fxArgToIndexInteger` (relative-from-end, saturating); result byteOffset = `this.byteOffset + start·elemSize`, length = `max(stop−start, 0)`.
- Fixed a species-prototype bug: the result must chain to `%<Kind>.prototype%` (default species), not the abstract prototype — otherwise `subarray() instanceof Uint8Array` is false, which broke the `TextDecoder` polyfill's `buf instanceof Uint8Array` guard downstream.
- Metering: folded XS's `fxCreateTypedArraySpecies` + 3-arg buffer-view construct into one op, calibrated **raw-exact** against the C-XS oracle (`TYPED_ARRAY_SUBARRAY_FRAME_METERING = 212_984`, isolated on computron-agreeing length/buffer-form sources). Dual-run suite `endor-262/tests/typed_array_subarray.rs` (7 tests): result agreement on all shapes + bit-exact computron agreement on the covered integer-argument shapes.

With subarray closed the handler now decodes the whole envelope and routes it, advancing the dispatch path two frontiers further.

**Step 2 — the BINDING gate: RED (honest DEGRADED success).** The representative command still does not return `Ok` — it advances to the NEXT bindings: the **`trace`** host global on the route/log path (`get <id>: undefined variable` — exactly the frontier stage-10i predicted; an XS global built-in endor doesn't model) and, on a real CapTP-bootstrap serialize branch, the **`dub_at`** opcode. Both are new-KIND frontiers in different subsystems (a realm-global binding + a new opcode), so per the "do not reach a new-kind frontier" + HARD-STOP discipline I stopped rather than reach. `dispatch_deliver` keeps degrading to the fold-ack round trip, so the worker still answers.

**Step 3 (LIVE round trip):** not attempted — gate precondition (Step 2 GREEN) not met.

**Ledger:** updated the `dispatch_deliver` comment to record the advance, and added a self-updating marker test `real_handler_decodes_a_real_envelope_to_the_dispatch_path_frontier` that asserts the decode advanced PAST subarray and pins the current `trace` frontier (fails/promotes the day it closes).

**Bars (all green):** engine workspace all-pass EXIT=0 (`--test-threads=1`); compile-diff **1909/1909** + SYMB **1909/1909**; boot gate **30/0**; endo lib **111/0** (full-boot marker GREEN); no new `unsafe`; zero new non-oracle warnings; no new side table (reused `typed_arrays`).

**Push:** committed `42e4fcdf8e` and pushed to `origin/xs2rust-endor` (verified: remote tip == local HEAD). Bundles remained gitignored (not committed).

**Follow-ups for the next stage:** (1) bind the `trace` host global (a realm-global change with SES-lockdown/snapshot implications — do it same-day per the ledgered-binding contract) to flip the simple-command gate GREEN; (2) implement the `dub_at` opcode the CapTP-serialize path needs; together these enable the live daemon round trip (Step 3).
