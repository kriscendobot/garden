All green and consistent — HEAD = origin/xs2rust-endor = 6243a64468. PR untouched (still DRAFT). Here is my completion report.

---

## Job: `xs2rust-endor-s27-module-corpora-fix` — completion report

**Repo/PR:** `endojs/endo-but-for-bots` #600, branch `xs2rust-endor` (kept DRAFT, no PR comment posted). Synced to real remote tip `43b6128e18` (subject-verified). Seeded `c/moddable` + `rust/engine/target` via `cp -al` from sibling `stage8-boot-surface-remainder-r2` at the same commit; every crate on the compile path (endor-compile, endor-vm, endor-262) **and** the C oracle were rebuilt from scratch for the proof runs.

### Item 1 (F1) — `module_corpora_byte_identity_no_divergence`: **endor is RIGHT; no endor change made**

The honest diagnosis is the escape-hatch case in the spec ("endor is RIGHT and the oracle disagrees with itself across contexts"). I did **not** touch endor's emission, the corpus, or the test. Evidence:

- **The test passes at tip with a fresh rebuild, against *both* legitimate moddable pins.** After `cargo clean -p endor-compile -p endor-vm`, the test is green: `total=47 identical=47 divergent=0`, with the oracle built against **either** the tree-recorded `c/moddable` gitlink `5516726818` (= moddable **8.0.1**, exactly what a fresh `git submodule update` produces) **or** the build.rs/design-declared pin `23b4d6b0a6` (= moddable **8.3.1**). Both oracles emit **155** bytes for both top-level-await programs, **byte-identical to endor**.
- **The byte.** For `top-level-await.js#1`: endor=155, oracle(8.0.1)=155, oracle(8.3.1)=155, all starting `8e 07 …` (offset 1 = **0x07**). For `#2`: 197 = 197 identical. The job's reported `oracle=154 … offset-1 0x57` is the signature of an oracle built against a moddable **predating** the `c41a35d16 "XS: for await in module body"` support — i.e. a *non-async* module (one byte shorter, header flag 0x57 instead of 0x07). endor correctly emits the **async top-level-await module** (155, 0x07), matching every for-await-capable oracle.
- **Independent corroboration.** A fully independent fresh worktree (endor-compile built from zero, no seeding) also gave 47/47 identical, exit 0. I proved the 8.0.1 oracle direction by cleaning `endor-oracle` and rebuilding the C against a `git checkout 5516726818` of the submodule (448 files rebuilt) → still 155.

**Conclusion:** there is no module-bytecode divergence to fix — forcing endor to 154 would *regress* it away from the certified for-await oracle. The job's fresh-checkout reproduction of 154 must have used a moddable older than the for-await commit (older than the tree gitlink `5516726818` itself).

**Latent hazard flagged for the supervisor (not fixed — I am forbidden to `git add c/moddable`):** the committed `c/moddable` gitlink is `5516726818` (8.0.1) while `endor-oracle/build.rs` and the design declare the pin as `23b4d6b0a6` (8.3.1). The test passes either way (8.0.1 also has for-await), so this is benign for F1, but the s28 re-measurement should build the oracle against a moddable ≥ the for-await commit (both declared pins qualify). Consider a deliberate gitlink bump `5516726818 → 23b4d6b0a6` to make the tree record the declared pin.

### Item 2 (F2) — the 4 cosmetic warnings: **fixed** (commit `6243a64468`, pushed to `xs2rust-endor`)

- `endor-compile/src/coder.rs`: removed the vestigial always-false `Payload::Index.plus_one` (the `index+1` family is selected by opcode id in `width_select_index_plus_one_family`, never this field; comment rewritten to say so); marked the unread `Target._index` (XS target-numbering mirror) intentional via `_`-prefix (silences the field `dead_code` in this rustc).
- `endor-vm/src/interp.rs`: `split_aux` `push_segment` closure needs no `mut`; `enter_call_dot_apply`'s unused `argc` → `_argc` (apply ignores the count).

No behavior change (proven by the byte-identity bars below).

### Verification (exit codes captured to files)

1. `cargo clean -p endor-compile -p endor-vm && cargo test --workspace --no-fail-fast` → **EXIT=0**, 35 `test result:` lines all `0 failed`, incl. `module_corpora_byte_identity_no_divergence` ok (`divergent=0`).
2. Curated `./target/debug/compile-diff` (no `--`) → **EXIT=0**, `total=1730 identical=1730 divergent=0`; SYMB `1730/1730`.
3. Enumeration spot check — `language/module-code`: 534 total, 35 identical, **0 divergent, 0 accept-disagree** (499 oracle-rejected module-goal files), EXIT=0; `statements/class`: 3908 total, 3298 identical, **0 divergent, 0 accept-disagree**, EXIT=0.
4. Fresh `cargo build -p endor-compile -p endor-vm` (after `cargo clean` of both) → **zero warnings**.
5. `#![forbid(unsafe_code)]` intact at all 7 engine crate roots (untouched).

### Commits pushed
- `6243a64468` — `fix(endor): clear 4 cosmetic dead-code/mut warnings (PR #600 stage-8 review F2)` → `origin/xs2rust-endor`. Only the two `.rs` files staged; `c/moddable` never staged. PR remains DRAFT.

**Follow-ups for the supervisor:** (1) F1 needs no endor fix — decide whether to reconcile the `c/moddable` gitlink (5516726818 → 23b4d6b0a6) so the tree records the declared oracle pin; (2) ensure s28 re-measurement builds the oracle against a for-await-capable moddable.
