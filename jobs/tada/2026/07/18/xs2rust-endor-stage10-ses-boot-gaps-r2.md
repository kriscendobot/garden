All work verified and pushed. Inbox empty, branch tip clean, bundle uncommitted, c/moddable at pin. Writing the completion report.

---

## Completion report — stage-10 child 5/7: SES worker-bundle boot on endor-vm, gap round 2

**Branch/tip measured:** `endojs/endo-but-for-bots` PR #600, `xs2rust-endor`. Synced to the real remote tip **`ba039431b0`** (child 4's last commit; the body's predicted press-rebase had not occurred). Pushed 5 commits onto it; final tip **`d197a95e34`**. PR kept DRAFT; no PR comments.

**Resumed from child 4's exact halt** (`Unsupported("defineProperties:accessor-descriptor")` — the getter/setter invocation plumbing) and drove the real `ses_boot.js` bundle (70 009 bytes, gitignored, never committed) through the dual-run harness, closing each halt in bundle order.

**Gaps closed, in bundle-halt order (5 commits, all pushed):**

| # | Halt signature | Fix | Commit |
|---|---|---|---|
| 1 | `defineProperties:accessor-descriptor` | **Accessor (getter/setter) own properties** — modeled as a property slot flagged `XS_GETTER_FLAG`/`XS_SETTER_FLAG` referencing a private holder instance carrying the getter under the `get` id / setter under the `set` id. `Object.defineProperty`/`defineProperties`/`Object.create`/`Reflect.defineProperty` accept `{get,set}`; `GET_PROPERTY` + computed `o[k]` invoke the getter (`this`=receiver) behind the jump barrier; `SET_PROPERTY` + `o[k]=v` invoke the setter; `getOwnPropertyDescriptor` renders `{get,set,enumerable,configurable}`. Holder lives in the slot arena — GC/snapshot reach it via the property's `Reference`, **no side table**. | `f027d8519a` |
| 2 | `freeze:accessor-property` | `Object.freeze`/`seal` stamp an accessor `DONT_DELETE` without `DONT_SET` (an accessor has no writable bit); `isFrozen`/`isSealed` judge it by non-configurability alone. | `5e8937372f` |
| 3 | `native-call:Map:iterable` | **Map/Set copy-constructor from an array iterable** — `new Map([[k,v]…])`/`new Set([…])` populate directly for a plain array with the standard iterator; a non-array iterable still self-names. | `bdfe1c04b9` |
| 4 | `Throw("call: not a function")` (root cause) | **Global-accessor identifier resolution** — a global accessor now joins the `global_props` fast index at define time and its getter/setter fire on a bare-identifier read/write (`GET_VARIABLE`/`SET_VARIABLE`, `this`=global). This is the SES lazy-`assert`/tamed-global shape; without it a bare read returned the holder (a non-function). | `093b5c6836` |
| 5 | — | Promoted the stale `define_property_partial.rs` accessor skip-guard to a green result-agreement run. | `d197a95e34` |

**Exact resume point for child 6:** the bundle now halts at **`Throw("call: not a function")`**, which is **past the C-XS oracle's own raw-bundle ceiling** — the standalone bundle references host-provided globals (the oracle aborts at `ReferenceError: get assert: undefined variable`), so a raw dual-run can no longer supply ground truth past that point. **Child 6 should drive the bundle *with its host prelude/environment*** (the daemon's polyfills + host powers, of which the §1 `composed_boot_bundle` tests are fragments) so the oracle boots far enough to validate, then attribute the `call: not a function` throw. The bundle did **not** boot to `lockdown()`/CapTP this round; four real engine gaps stood between child 4's halt and the oracle's ceiling, and all four are now closed.

**Verification (all bars met, real-execution evidence):**
- Full engine-workspace `cargo test --no-fail-fast` (after `cargo clean -p endor-compile -p endor-vm -p endor-oracle`, c/moddable seeded at pin): **EXIT=0**, captured to `acc_test2.log` — **48 `test result:` lines, every one `0 failed`; 695 passed** (was 47/673 at stage-9 close).
- `compile-diff` (no-arg = curated corpora + SYMB): **1909 identical / 0 divergent**, full accept/reject agreement; **SYMB 1909 identical / 0 divergent** (unchanged from child 4 — compiler untouched).
- Boot gate green: **20 → 22 test fns** (`boot_step_ses_accessor_descriptors_agree` with 15 driven forms incl. global-accessor + freeze/seal; `boot_step_ses_collection_from_array_iterable_agrees` with 7). All `assert_boots` result-agreement.
- **Zero new Rust warnings** (endor crates; the moddable C-build warnings are pre-existing and not mine).
- `#![forbid(unsafe_code)]` intact at **8** engine crate roots (none removed; `endor-oracle` stays the audited FFI seam).
- `c/moddable` clean at pin `23b4d6b0`, never staged. **No bundles committed** (`ses_boot.js` gitignored). **No new VM side tables** — the accessor holder is an ordinary arena instance, so GC-roots + snapshot reach it through the property's existing `Reference` edge; no ledger entry required.

**Doctrine note:** result agreement gates every promoted form (accuracy-over-parity); the getter/setter call bodies meter themselves, and the per-property `mxCheckMetering` / iterator-protocol computrons XS incurs are the advisory divergence tolerated — no meters back-fit.

**Follow-ups:**
- **Snapshot round-trip of an object carrying an accessor property is not *explicitly* tested** (correct by construction — the holder is a plain instance reachable via the property `Reference`; harden traversal documents skipping the getter/setter transitive freeze). A targeted snapshot test would harden the guarantee.
- Primitive receivers (string/number/symbol) with accessors, and non-array iterables for `Map`/`Set`, still self-name (documented gaps).
- The accessor dispatch charges only the callee body's metering (no calibrated fixed dispatch residual) — advisory per doctrine.
