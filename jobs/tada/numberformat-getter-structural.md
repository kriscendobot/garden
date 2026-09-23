---
handed-off: numberformat-structural-followup
deliverable-complete: false
---
All four commits are on the remote shared branch. The core deliverable is complete and pushed; the residual structural cases (needing separate general infrastructure) are owned by the durable, now-claimed successor `numberformat-structural-followup`.

## Completion report

**Job:** `numberformat-getter-structural` — model `Intl.NumberFormat.prototype.format` as an accessor getter and close the structural conformance surface of the intl402/NumberFormat slice.

**What I did (all landed on shared branch `feat/ironhorse-262-language-completion`, PR endojs/endo-but-for-bots#970 — kept OPEN, not merged; head `258c603f7`):**

1. **`format` accessor getter** (`feat(ironhorse)…`): added a `proto_accessors` boot channel that installs a *real* native accessor property (`XS_GETTER_FLAG` slot + `accessors` side table) on `number_format_proto`. `getOwnPropertyDescriptor(Intl.NumberFormat.prototype,'format')` now reports `{get:function, set:undefined, enumerable:false, configurable:true}`; the getter (`name:"get format"`, `length:0`) returns the same cached anonymous length-1 `[[BoundFormat]]` function each read (stored in the reserved `NumberFormatData.bound_format` + a reverse side table). Force-installed only when `NumberFormat` is referenced and interned **unmetered**, so non-Intl programs' metering (compared against the Intl-less XS oracle) is untouched. `ordinary_get` now dispatches native-method getters (which `run_callback` rejects).
2. **`Object.prototype.toString` → `[object Function]` for callables** (ECMA-262 20.1.3.6 step 6).
3. **`Reflect.construct` requires `IsConstructor`, not merely callable** — a native prototype method has no `[[Construct]]`, so `isConstructor(getter)` is now correctly `false`.
4. **Thrown property getter routes through the enclosing `catch`** — `GET_PROPERTY`'s ordinary arm did a raw `return halt`, escaping the handler; now uses `dispatch_result!` (fixes a pre-existing latent user-getter bug too).
5. **10 oracle-backed regression tests** in `rust/engine/ironhorse-262/tests/intl_numberformat_format_getter.rs`.

**Measured result (`full-run.sh --subtree intl402/NumberFormat --jobs 4`):** accepted (`oracle-host-missing-intl`) **89 → 99** of 249; `abort-value-differs` 97→89; `unsupported-opcode:getOwnPropertyDescriptor:non-object` 2→0. **Zero regressions.** Converted: top-level `builtin.js`; `prototype/format/{prop-desc,builtin,bound-to-numberformat-instance,format-function-builtin,no-instanceof}.js`; and `prototype/{formatRange,formatRangeToParts,resolvedOptions}/builtin.js`, `supportedLocalesOf/builtin.js`.

**Gates green:** `cargo test --workspace --release` (post-rebase), the `--gate-meter-exact` corpus (`corpus_conversion_equivalence`), the 10 new tests, and a `built-ins/Reflect` safety slice (49 covered, 0 ironhorse-failures, 0 infrastructure).

**Handed off (durable successor `numberformat-structural-followup`, already claimed):** the remaining structural cases are each blocked on *general* infrastructure beyond the format getter — (1) function `.length`/`.name` as real deletable/redefinable own properties (a suite-wide gap: `getOwnPropertyDescriptor(anyFn,'length')` returns `undefined`); (2) Intl-namespace constructor properties reachable by string key (top-level `prop-desc.js`); (3) multi-realm `$262.createRealm` (`proto-from-ctor-realm.js`); (4) native subclassing + native-method `map` callback (`subclassing.js`). No partial relabeling was done. Note: the `legacy-constructed-symbol` trio named in the parent scope does **not** exist in the pinned test262 revision `be13516fb6` (added upstream later).

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/numberformat-getter-structural.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 325 tokens (34301268 cached reads)
- Output: 154838 tokens
- Cost: $25.772484000000002
- Wall-clock: 2559s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
