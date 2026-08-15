All work is committed, pushed, and verified. HEAD matches origin.

## Completion report

**Job:** NumberFormat structural residue — function length/name descriptors, Intl-namespace string-key install, multi-realm, native subclassing (successor to `numberformat-getter-structural`).

**Outcome:** 3 of the 4 items closed via real execution; the 4th was explicitly out of reach per the job spec. Pushed 3 commits to shared branch `feat/ironhorse-262-language-completion` (PR endojs/endo-but-for-bots#970, kept OPEN), rebased cleanly onto the branch head, now at `33ec04ff1`.

**What I did (all in `rust/engine/ironhorse-vm/src/interp.rs`):**
- **Item 2 — Intl namespace string-key install** (`cd63eaffc`): mirrored the `proto_accessors` guard so `Intl.*` constructor members force-install (unmetered) when a program references `Intl`, even under a string key. Closes top-level `prop-desc.js`.
- **Item 1 — function length/name as reflective own properties** (`5a310f05e`): routed all MOP paths (`getOwnPropertyDescriptor`, `hasOwnProperty`, non-writable set, `delete` via a tombstone, `defineProperty` via unmetered slot materialization) through one synthesized `{writable:false, enumerable:false, configurable:true}` view read live from `FuncInfo` — no backing slot, no metering (XS pre-pays the allocation in `FUNCTION_DEFINE_METERING`). Also gave Promise resolve/reject functions a real empty `name` chunk + length 1 (they were `FuncInfo::default()` with a NULL chunk the new read path faulted on — caught by the full sweep as a panic and fixed).
- **Item 4 — native-method callbacks + subclassing** (`33ec04ff1`): generalized `run_callback` to dispatch native-method callees through `call_native_method` (as `invoke_getter` does). Closes `subclassing.js` — the native-base `super()` machinery already worked; the map-callback gap was the only blocker.
- **Item 3 — multi-realm** (`proto-from-ctor-realm.js`): left as `abort-value-differs`, out of reach exactly as the job scoped it (needs the harness `$262.createRealm` surface). No relabeling.

**Verification (definitive, base = branch commit `de1abf6ac`, full-tree oracle sweep both sides):**
- Suite-wide covered **26232 → 26689 (+457)** — the function length/name fix cascaded across every built-in's `length.js`/`name.js`/`prop-desc.js`, `Function.prototype.bind` instance-length/name, `class` fn-*-static-precedence, Promise resolve/reject-function-name, etc.
- **0 covered regressions, 0 new `ironhorse-failure` paths** (9 failures, byte-identical set to the base — all pre-existing branch drift: Error stack setters, setPrototypeOf, super-null, RegExp compile, yield star), **0 infrastructure delta**.
- `--gate-meter-exact` corpus (`generated_cases_reproduce_corpus_coverage`) and `cargo test --workspace --release` green.
- intl402/NumberFormat slice: **99 → 118 accepted** (`oracle-host-missing-intl`), 0 failures.

**Pins honored:** test262 `be13516fb6`, XS oracle `23b4d6b0a6`, branch kept open/not merged.

**Process note:** the highest-risk item (function length/name) initially destabilized 14 suite-wide paths into engine panics (a slotless synthetic descriptor breaking `ordinary_define_own_property`'s `find_property().unwrap()`, plus the NULL Promise name chunk). I isolated these against a rebuilt pre-change binary, fixed both root causes (materialize-on-define, real empty name chunk), and re-swept — rather than partially relabeling, per the acceptance bar.

**Follow-ups (unblocked residue, out of scope):** `proto-from-ctor-realm.js` awaits `$262.createRealm`; the remaining NumberFormat `abort-value-differs` (72) are unrelated (`formatRange`, `indexOf` scan-metering, etc.). The `legacy-constructed-symbol` trio still absent from the pinned test262 revision.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/numberformat-structural-followup.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (1 unmetered)
- Input: 341 tokens (31035578 cached reads)
- Output: 156283 tokens
- Cost: $24.334410000000005 (1 engagement(s) unpriced)
- Wall-clock: 2737s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
