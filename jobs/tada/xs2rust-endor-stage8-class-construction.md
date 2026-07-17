Clean working tree, local == remote, all 3 commits pushed to `xs2rust-endor`. The work is complete.

<<<GARDEN-JOB-COMPLETE>>>

## Completion report — Stage-8c child 1/3: class-instance construction (PR #600, branch `xs2rust-endor`)

**Landed the big rock: base-class construction in endor-vm.** Class syntax moved from a named `to_instance` skip to *covered on real test262 cases*: `language/statements/class` went **0 → 398 covered, 0 failed** (of 3908). The PR stays **DRAFT** (tada-only child).

### What I implemented (opcode chain in `endor-vm/src/interp.rs`)
- **`to_instance`** (ToObject): reference/instance pass-through (the common case — the freshly-built constructor is already an object); nullish and primitive receivers *self-name* an honest skip rather than throw an uncatchable native error (endor doesn't model catchable native-error construction — the same gap `strict-set:integrity-violation` and the delete/define paths self-name for; a raw throw would diverge from a surrounding `try`/`catch`).
- **`class`**: wire constructor + prototype object + superclass — install `.prototype` (`ctor_prototype` side table), the non-enumerable `prototype.constructor` backref, base/derived + can-construct marks; chain a derived constructor's `[[Prototype]]` to its superclass.
- **`name`** (`fxRenameFunction`): name an anonymous class/function on the stack.
- **`set_home`**: record a method/field-initializer's home object — unlocks class-field syntax (`class C { x = 1 }`).
- **`extend`** (`fxRunExtends` static half): build a derived class's prototype chained to the superclass's `.prototype`.
- **`begin_strict_base`** now runs `fxRunConstructor` so `new C()` allocates its `this`; a class constructor is not callable without `new`.

**Covered constructs (reported precisely):** `class {}` declarations/expressions, `new C()`, instance methods, static methods, constructor field assignment (`this.x = …`), **class-field syntax** (`x = 1`), `instanceof`/`typeof`, and the **static half of `extends`** (`Object.getPrototypeOf(D) === B`). **Remaining honest named skips:** `super()` construction (`super`/`set_this` + `new.target` retargeting — needs invasive newTarget threading through the frame model, deliberately deferred to protect the landed base; 18 skips), private fields `#x` (`new_private`, 1049 — a large separate feature), `async_generator_function` (933), and compiler negatives (595). This is the sanctioned clean partial.

### Bars (all from `rust/engine`, captured, `$?` checked)
1. **`cargo test --workspace --no-fail-fast -- --test-threads=1`**: **505 passed, 1 failed**. The lone failure — `compile_diff::tests::module_corpora_byte_identity_no_divergence` (top-level-await module bytecode, 1 byte longer) — is **pre-existing**: I proved it fails identically on the base commit `9bef7de` in a fresh worktree, and my diff touches none of the module-compilation path (endor-compile/compile_diff.rs/corpora-modules are byte-identical to base). Every other test line is 0 failed.
2. **`compile-diff`**: **1722/1722 identical + SYMB 1722/1722**, EXIT=0. Corpus **grew** 1711 → 1722 (11 class cases added under `cases/language/stage8-classes/`, byte-identical compiles).
3. **`endor-xst statements/class`**: **0 → 398 covered, 0 failed** (measured before/after). **`built-ins/Function`** spot: 43 → 43 (unchanged, no regression).
4. **Dual-run regressions**: the 11 new corpus cases are permanent dual-run regressions gated covered-end-to-end by `corpus_conversion_equivalence.rs`. Metering is honest and close (e.g. 55/55, 65/65, 43/43 exact; `typeof C` off by 1) — advisory computron-gap only, never back-fit.
5. **`#![forbid(unsafe_code)]`** intact; **no new warnings** (2 warnings exist but are pre-existing, outside all my edits).
6. **Side-table ledger**: I added no new `Interp` field or side table — I extended the already-ledgered `functions` map (`FuncInfo` gains `is_class_ctor`/`is_derived_ctor`/`home`). Updated the ledger's `Functions` row to note the new heap-slot `home` field. `home` holds user-object slots (class prototypes) reachable via `ctor_prototype`, parallel to `closures` — correctly **not** in `lockdown_roots()` (primordials only).

### Ledger maintenance my change necessitated (committed honestly)
- Boot-bundle gap ledger: `to_instance` closed → bundles advance to `defineProperty:partial-descriptor`; destructuring at module-init promoted from a named skip to a **green** dual-run step (it needs `to_instance`); polyfills whole-file skip advances past the class polyfills.
- `CORPUS_PROGRAM_COUNT` 1711 → 1722.

### Commits (pushed, `xs2rust-endor` @ `3734c168a3d`, working tree clean)
- `c43cf7456c1` feat(endor-vm): class-instance construction
- `dec8107f567` test(endor-262): advance boot-bundle gap ledger past to_instance
- `3734c168a3d` test: advance boot/corpus ledgers for the class-instance surface

### Follow-ups
- `super()` construction + `new.target` retargeting (the derived-class construction path) — the next natural child; needs a real newTarget value threaded through the frame model.
- Private class fields (`#x`) — `new_private`/`get_private`/`set_private`, the largest remaining class skip (~1049 cases).
- Pre-existing top-level-await module-compiler byte divergence (unrelated to classes) remains open on the branch.
