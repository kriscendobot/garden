All bars measured. PR #600 confirmed OPEN/DRAFT at my measurement tip `43b6128`. Here is the completed report.

---

## Stage-8d child 2/2 — whole-stage re-measure at the tip `43b6128e185`

**Setup.** Isolated project worktree at the real remote tip `43b6128e1852d78b478c575f67b7d94c673eb8ae` (2 commits past the 02:05Z press `2ef06cfdde`: `feat: bind String.raw static` + `docs: correct gate skip ledger`). Seeded `rust/engine/target/` and (after a first build failed on a missing submodule) `c/moddable/xs/sources` by `cp -al` from the stage8-boot-surface-remainder sibling. Tree clean of tracked changes throughout; **no** corpus/test additions were needed, so nothing was committed. PR #600 remains **OPEN / DRAFT**, head = measurement tip.

### Bar 1 — Boot-bundle gate: **14/14, 0 failed, EXIT=0** (`cargo test -p endor-262 --test boot_bundle_gate`)

10 green boot steps + 4 named skips. ≥ as green as stage-7 (also 14/14, but with more of the 14 as skip-assertions); **no regression**; **`boot_step_polyfills_full_file_agrees` (polyfills.js whole-file) stays GREEN**.

**Conversion table — stage-7 named-skip ledger → stage-8 status:**

| stage-7 named skip | stage-7 surface | stage-8 status |
|---|---|---|
| `polyfills.js` whole file (TextEncoder/Decoder classes) | `Unsupported("to_instance")` | **→ GREEN** `boot_step_polyfills_full_file_agrees` (class-instance construction, 8c) |
| `assert` destructuring at module init (`const {Fail}=assert`) | `Unsupported("to_instance")` | **→ GREEN** `boot_step_assert_destructuring_at_module_init_agrees` (8c ch1) |
| `assert` error formatting (`String.raw`) | absent builtin (`Throw`) | **→ GREEN** `boot_step_assert_error_formatting_string_raw_agrees` (String.raw static, 8d) |
| `polyfills.js` harden slot (partial descriptor) | `Unsupported("defineProperty:partial-descriptor")` | **→ GREEN** `boot_step_polyfills_harden_slot_agrees` (partial descriptors, 8c) |
| `assert.details()` residue `{toString(){}}` `+` | `Unsupported("add")` | **still SKIP** `skip_assert_details_add_needs_toprimitive` — refined: method-shorthand construction now green; residual stop is ToPrimitive-in-`op_add` |
| `host_aliases.js` whole file (40-entry table) | `Unsupported("at")` | **still SKIP** `skip_host_aliases_full_file_does_not_yet_lower` — needs receiver-chain-aware absent-key guard |
| `HandledPromise` shim | absent (`Throw`) | **still SKIP** `skip_ses_boot_handled_promise_shim_absent` — full constructor, deferred to eventual-send surface |
| `ses_boot/worker_bootstrap/daemon_bootstrap` | gitignored makeBundle artifacts (gap #3) | **still SKIP** `skip_generated_bundles_are_out_of_workspace_scope` — structural |

**Yield: 4 conversions** (polyfills whole-file, assert destructuring, String.raw, partial-descriptor harden slot). **Residual named-skip ledger for stage-9 scoping (4):** ToPrimitive-in-`add` (assert.details); `host_aliases` at-scale (`at`); `HandledPromise` constructor; the three generated bundles (gap #3).

### Bar 2 — Workspace: **35 `test result:` lines, 527 passed, 1 failed** (`cargo test --workspace --no-fail-fast -- --test-threads=1`, EXIT=101)

34 of 35 lines are `0 failed`. The **sole** failure is the requested `module_corpora`.

**`compile_diff::tests::module_corpora_byte_identity_no_divergence` → FAILED** (verbatim):
```
compile byte-identity differential [corpora-modules]: total=47 identical=45 divergent=2 ...
  DIVERGENT [byte-length/endor-longer] top-level-await.js#1
    len oracle=154 endor=155; first diff @1 oracle=0x57 endor=0x07
  DIVERGENT [byte-length/endor-longer] top-level-await.js#2
    len oracle=196 endor=197; first diff @1 oracle=0x57 endor=0x07
BAR NOT MET: 2 divergent, 0 endor-rejected, 0 accept-disagreements
```
This is **Finding F1** below — a genuine, pre-existing engine divergence, not the environment artifact the press suggested.

### Bar 3 — Curated compile-diff: **1730/1730 identical + SYMB 1730/1730, EXIT=0**
Corpus 1730 (matches press `2ef06cfdde`; stage-7 anchor 1711 → +19).

### Bar 4 — Spot checks (all `0 failed`):
| subtree | covered / failed |
|---|---|
| `built-ins/Object` | 270 / 0 |
| `built-ins/Promise` | 112 / 0 |
| `built-ins/Compartment` | 0 / 0 (42 named skips) |
| `statements/class` | 398 / 0 |
| `language/expressions/object` | 355 / 0 |
| `built-ins/String/raw` | 3 / 0 |
| `built-ins/Object/defineProperty` | 79 / 0 |
| `-l built-ins/Boolean` | 16 / 0 |
| ses-parity sweep (`-l --feature-filter ses-xs-parity --features-include ses-xs-parity built-ins`) | 1 / 0 (1 named skip) |

`built-ins/Array/prototype/at` → **EXIT=2 "no test files to run"**: this vendored test262 snapshot has no `Array/prototype/at` subtree, so that spot check is a no-op here (the `at` surface is exercised via the gate/host_aliases skip, not test262 built-ins).

### Bar 5 — Full 121-run whole-tree enumeration: **PASS**
```
RUNS=121 NONZERO_EXITS=0
SUMMED total=20603 identical=16981 divergent=0 oracle-rejected=3622 endor-rejected=0 accept-disagree=0
```
Detail log empty (0 divergences / rejections / accept-disagreements). **Exactly matches the stage-7/s19/s21/s22/s23 anchor** (20603 / 16981 / 0 / 3622); `divergent=0`, `accept-disagree=0` held.

### Bar 6 — `#![forbid(unsafe_code)]`: intact at all **7** engine crate roots (endor-262, -compile, -fuzz, -oracle, -regexp, -snapshot, -vm). Warning inventory below (Finding F2).

---

## Findings for the supervisor (I fixed nothing — measurement + named findings only)

**F1 — `module_corpora` top-level-await divergence is REAL and pre-existing; the press's EXIT=0 was the environment artifact (the inverse of the supervisor's hypothesis).**
Endor emits 1 byte more than the C-XS oracle for two top-level-await module programs (`155/154`, `197/196`; first diff at offset 1, endor `0x07` vs oracle `0x57`). The module corpus is read at test runtime from committed `endor-262/corpora-modules/*.js` (`CARGO_MANIFEST_DIR`), **not** from `target/` — so the case set is fixed and this is genuine engine bytecode behavior, not a fixture-count artifact. It reproduces in my **fresh** checkout at tip `43b6128` (oracle rebuilt from moddable sources, endor recompiled), and the stage-8c class-construction child already proved it fails at base `9bef7de`. The 02:05Z press's whole-workspace EXIT=0 at `2ef06cfdde` is therefore the **false-pass**: its seeded `target/` carried a stale cached endor (or oracle) build object for the module-compile path that `cargo` did not invalidate, masking the divergence. Orthogonal to stage-8 (module-compile path untouched by any stage-8 commit). **Do not back-fit** — it is an open module-bytecode divergence to be scoped separately. *(Consequence: the honest whole-workspace number at the tip is 527 passed / 1 failed, not 0-failed; every non-module line is green.)*

**F2 — Warning count is 4 cosmetic Rust warnings, not the "2" prior reports cited; all pre-existing, none stage-8-introduced.** `endor-vm/src/interp.rs:9756` (`mut` not needed) + `:11122` (`unused argc`), and `endor-compile/src/coder.rs:69` (`plus_one` never read) + `:335` (`index` never read). `git blame` dates them 2026-07-03…07-07, all **before** the 2026-07-16+ stage-8 window. The prior "2" was an incremental-rebuild undercount (a warning only re-emits when its crate recompiles; the seeded `target/` suppressed half). All four are one-line-trivial `cargo fix` candidates; non-blocking, left for the supervisor's fixer round. The moddable C-compiler `cargo:warning=` lines from the oracle build are also pre-existing and expected.

**Bottom line (not an acceptance call — that's yours):** every whole-stage bar re-measures green at the tip except the one pre-existing, stage-orthogonal `module_corpora` module-bytecode divergence (F1); the boot-gate yield is 4 skip→green conversions with a clean 4-entry residual ledger; corpus 1730, 121-run enumeration at the anchor with 0 divergent / 0 accept-disagree; `forbid(unsafe_code)` intact.
