All three commits are on the remote `xs2rust-endor` (DRAFT PR #600 kept draft — I never touched PR state). Work is complete for this budget.

---

## Completion report

**Job:** Stage-7 child 2/7 — intrinsics-ledger residuals on `endojs/endo-but-for-bots` PR #600 (branch `xs2rust-endor`, kept DRAFT). Synced to the real remote tip first (child 1's live-`globalThis` had landed at `05dda5747d`, and the branch had also advanced with endor-naming/rename commits; rebased cleanly on top).

**Landed (3 of 4 items), each green + pushed:**

1. **`Reflect` namespace intrinsic** (commit `1464d27eb5`) — `typeof Reflect === "object"` with the reflective built-ins the SES shim/boot bundles consume: `getPrototypeOf`, `setPrototypeOf`, `getOwnPropertyDescriptor`, `defineProperty`, `ownKeys`, `has`, `get`, `set`, `deleteProperty` (boolean-returning ones return the accept/reject boolean XS does). Re-entrant `apply`/`construct` are honest named skips (spread-argument trampoline metering is a later increment). Reuses the existing property-op machinery; descriptor members reuse the calibrated `Object.*` residuals. 10 dual-run tests.

2. **Typed-array construction from a dense Array / source TypedArray** (commit `6054397412`) — `new Uint8Array([1,2,3])` (the ses-boot byte-view form) and `new Int32Array(u8)` were a `from-object` skip; now copy+coerce each element via the existing `typed_array_element_set`. A plain array literal's dense sequence is result-faithful to the spec iterator result. 4 dual-run tests.

3. **Symbol-keyed property operations** (commit `668f24994b`) — symbols as first-class property keys via a `symbol_key_ids` desc-slot→id map (XS's `mxID(symbol)`): computed `o[sym]`, `Object.defineProperty`/`getOwnPropertyDescriptor`, the `Reflect.*` key surface (new shared `property_key_id`), and `sym in o`. `Object.keys`/`Reflect.ownKeys` partition symbol keys out of the string enumeration. Added the honest `SideTable::SymbolKeyIds` snapshot-ledger row (Pending). 6 dual-run tests.

**Deferred (item 4 — class-instance construction) with precise gap note:** `new` on class constructors is **not** a residual but a whole unimplemented multi-opcode subsystem. The construct path halts progressively through `XS_CODE_TO_INSTANCE` → `XS_CODE_CLASS` → `XS_CODE_EXTEND`; a complete implementation needs `TO_INSTANCE` (mxToInstance: reference-identity, else box/TypeError), `INSTANTIATE` (fxRunInstantiate → the prototype object), `CONSTRUCTOR_FUNCTION` (constructor instance + default `.prototype`), `EXTEND` (fxNewInstance / fxRunExtends), `CLASS` (wire `ctor.prototype`↔`prototype.constructor`, `XS_CAN_CONSTRUCT`/`BASE`/`DERIVED` flags, the home object), `SUPER`, and the `new`-on-class construct path. I built and validated a `TO_INSTANCE` handler as a spike but reverted it — with `CLASS` still unmodeled no class program completes, so it had no independent green test and would be dangling untested surface. It can't be landed green + verified in this budget without regression risk. This matches the job's "deliver the ones that land + a precise gap note."

**Verification (all EXIT=0):** `cargo test --workspace -- --test-threads=1` all `test result:` 0 failed (incl. the snapshot sidetable ledger tests); `compile-diff` curated 1711/1711 + SYMB 1711/1711; endor-xst grew coverage with 0 failed and no regression — `built-ins/Reflect` 0→6, `built-ins/Symbol` 8, `built-ins/Object` steady at 182, `built-ins/TypedArray` unchanged (its corpus cases gated by other named harness reasons; the behavior is proven by the dual-run gate); `#![forbid(unsafe_code)]` intact; no new warnings. Oracle pinned at `23b4d6b` (moddable 8.3.1) — `c/moddable` never `git add`ed.

**Follow-ups:** (a) item 4 (class construction) per the gap note above — a candidate for its own child job; (b) `XS_CODE_DELETE_PROPERTY_AT` (computed `delete o[key]` for any key) is a pre-existing unrelated gap surfaced while testing symbol delete; (c) `Reflect.apply`/`construct`, symbol-key `Reflect.ownKeys` (renders only the string portion today), and `Object.prototype`-as-a-readable-data-property remain unmodeled.
