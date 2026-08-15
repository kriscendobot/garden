---
gate: orchestrated
orchestrated_by: ironhorse-js-26-cf-resid
priority: normal
posted_by: gardener
posted_at: 2026-08-15T01:02:14Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# js-26 cf: resizable/growable ArrayBuffer + length-tracking view semantics

**Scope:** resizable `ArrayBuffer` and growable `SharedArrayBuffer` — the
`{maxByteLength}` options-bag constructor form, `ArrayBuffer.prototype.resize`,
`SharedArrayBuffer.prototype.grow`, the `resizable`/`growable`/`maxByteLength`
getters, and the **auto-length-tracking** + **out-of-bounds** view semantics that
ripple into TypedArray and DataView (a view over a resizable buffer whose length
tracks, and OOB detection after a shrink).

**Reason families now blocking (measured on built-ins/ArrayBuffer):**
`unsupported-opcode:native-call:ArrayBuffer:resizable` (~32),
`unsupported-opcode:array-buffer-resize:unsupported` (~4), plus the SharedArrayBuffer
`:growable` twin and many `ironhorse-aborted` across built-ins/TypedArray & DataView.

**Engine sites:** `rust/engine/ironhorse-vm/src/interp.rs` — `struct ArrayBufferData`
(add `max_length: Option<u32>`; ~line 2452), the `Native::ArrayBuffer`/`SharedArrayBuffer`
constructor arms (the `argc>=2 && arg(1).kind==Reference` early `Unsupported` skip), the
`NativeMethod::ArrayBufferResize` arm (~line 20633), `alloc_array_buffer`, and every view
length/OOB read in the TypedArray & DataView element paths.

Part of the **js-26 TypedArray/ArrayBuffer residual-closure** effort, re-decomposed
from the oversized parent cluster job `ironhorse-js-26-cf-typedarray-arraybuffer`
(measured on PR endojs/endo-but-for-bots#970 head `b3c3ae93`). That parent closed
the ArrayBuffer/SharedArrayBuffer **constructor** ToIndex-coercion + catchable
RangeError/TypeError surface (commits landed on `feat/ironhorse-262-language-completion`,
head `1c41b9a61`) and re-decomposed the remainder into this orchestration.

**Shared branch/PR (do not create a new one):** work on `feat/ironhorse-262-language-completion`
(PR endojs/endo-but-for-bots#970 — OPEN, draft, keep open, do NOT merge). Fetch the
remote branch, preserve every prior commit, stack bounded commits on its head, push with a
rebase CAS loop. This orchestration is **serial** — always fetch+rebase before push.

**Pins (unchanged):** engine measured on head `b3c3ae93b81c0f266458cd25f2f27d94ef80cc5b`;
test262 `tc39/test262@be13516fb6441b950ba8a3df97eb34062c186972`; Moddable XS oracle
`23b4d6b0a65f35209d9118c4c13c6c9b3e68784d` (`git submodule update --init --depth 1 c/moddable`).
Rust toolchain: prepend `$HOME/.cargo/bin` to PATH; set `TMPDIR` off any noexec mount
(e.g. a dir under /home/kris/garden/scratch). A cached test262 checkout at the exact pin
lives at `/home/kris/garden/scratch/test262-pin-be13516f` (pass `--test262-dir … --no-fetch`).

**Acceptance bar (non-negotiable, identical to the js-XX arc):** convert this child's cases
from unsupported/failure to **covered** via **real execution against the official XS
differential oracle** (`rust/engine/ironhorse-262/scripts/full-run.sh --subtree <PREFIX>
--test262-dir <pinned checkout>`), except for a specifically justified, standards-grounded
host-only/proposal exclusion. Add focused Rust regression tests under
`rust/engine/ironhorse-262/tests/`. Do NOT relabel, suppress, skip-list, or add expectation
files. Zero generic `ironhorse-aborted`, `parse-or-decode`, `unsupported-opcode:*`,
`abort-value-differs`, or `non-primitive-completion` may remain within this child's scope.

**Regression invariant:** no case covered in `rust/engine/ironhorse-262/baseline/baseline.json`
or by any earlier child may regress; no new `ironhorse-failure`/`infrastructure`; the exact-
metering corpus must stay green (`ironhorse-xst --gate-meter-exact rust/engine/ironhorse-262/cases`
and `cargo test --workspace --release`). Run the affected official slice + these gates before EVERY push.

**CROSS-CUTTING PREREQUISITE (discovered by the parent, read this):** a large fraction of
this cluster's `ironhorse-aborted` / `abort-value-differs` error-path cases are blocked not by
TypedArray semantics but by a **general object-model gap**: reading `.constructor` on an instance
of a user-defined function (and `Foo.prototype.constructor`, and property access on `null`/`undefined`
throwing a catchable TypeError) currently aborts. The ubiquitous `assert.throws(Ctor, fn)` harness
reads `thrown.constructor` on the success path, so ANY case whose expected error is inspected that way
stays `ironhorse-aborted` even once this child throws the correct error. This gap is OUTSIDE the
TypedArray cluster's nominal scope (it belongs to the general object-model / built-ins-Object cluster).
If your child's coverage is gated on it, throw the correct error anyway (it is still progress toward the
bar and unblocks instantly once the prereq lands), and note the dependency in your report rather than
hacking a cluster-local workaround.

**If this child is itself too large for your handler budget:** do NOT partially relabel. Bank the
real bounded progress you CAN verify + land (like the parent did for the ctor surface), then
sub-decompose the remainder into a nested halt-on-failure orchestration and hand off (report the
durable continuation). Recursion is expected.

Repository: `endojs/endo-but-for-bots`. issue_spine: issue-kriscendobot-garden-51
