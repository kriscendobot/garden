---
gate: orchestrated
orchestrated_by: ironhorse-js-26-iter-set-map-orch
priority: normal
posted_by: producer
posted_at: 2026-08-15T04:26:14Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Close residual: native-function metadata reflection (name/length/prototype delete + redefine)

Causal feature: `Object.getOwnPropertyDescriptor(fn, "name"|"length")` on a NATIVE method currently returns `value: undefined` because the native GOPD `None` branch (rust/engine/ironhorse-vm/src/interp.rs, `ObjectGetOwnPropertyDescriptor`) does not consult `exotic_own_descriptor`, and `name_id`/`length_id` caches are `None` when the program never spells those names. Worse, `verifyProperty`/`propertyHelper.js` then `delete`s the property and re-checks it is gone, and `isConstructor.js` probes construct behavior — so full support needs the exotic function `name`/`length`/`prototype` own properties to be reflectable AND deletable/redefinable (configurable:true for name/length), with subsequent reflection honoring the deletion.

This is an engine-wide gap (existing methods like `built-ins/Set/prototype/has/name.js` fail identically), but scope THIS child to the metadata cases of the Set/Map method dirs and the shared harness path. Test262 case shapes in scope: `name.js`, `length.js`, `not-a-constructor.js`, `builtins.js` under `built-ins/Set/prototype/{union,intersection,difference,symmetricDifference,isSubsetOf,isSupersetOf,isDisjointFrom}` and the analogous Map method dirs, plus `Set/prototype/*/add-not-called.js` (currently `non-primitive-completion`). A partial GOPD fix (surfacing the exotic descriptor) was prototyped by js-26 but reverted because delete-tracking was missing — implement the complete, delete-aware version.

Repository: `endojs/endo-but-for-bots`. Shared branch/PR (do NOT create a new one): work on `feat/ironhorse-262-language-completion` (PR endojs/endo-but-for-bots#970 — OPEN, draft, keep open, do NOT merge). Fetch+rebase before every push (serial orchestration to avoid CAS collisions; peers push serially).

Pins (unchanged): test262 `tc39/test262@be13516fb6441b950ba8a3df97eb34062c186972` (a checkout already exists at /home/kris/garden/scratch/test262-pin-be13516f); Moddable XS oracle `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d` (`git submodule update --init --depth 1 c/moddable`). Rust: prepend `$HOME/.cargo/bin` to PATH; set `TMPDIR` off noexec (/tmp is noexec — use e.g. /home/kris/garden/scratch/tmp-ironhorse-js26).

Acceptance bar (identical to js-26 parent, non-negotiable): convert this child's cases to **covered** via real execution against the XS differential oracle (`rust/engine/ironhorse-262/scripts/full-run.sh --subtree <PREFIX> --test262-dir <pinned checkout>`, or `ironhorse-xst --test262-dir ... <subtree>` for iteration). Add focused Rust tests under `rust/engine/ironhorse-262/tests/`. Do NOT relabel/suppress/skip-list. Zero generic `ironhorse-aborted`/`parse-or-decode`/`unsupported-opcode:*`/`abort-value-differs`/`non-primitive-completion` may remain within this child's scope.

Regression invariant: run `cargo test --workspace --release` (includes the exact-metering corpus via corpus_conversion_equivalence, must stay 1711/1711) and the affected official slice before every push; no covered case may regress, no new failure/infrastructure result. If THIS child is still too large for your budget, do NOT partially relabel — sub-decompose into a nested halt-on-failure orchestration and hand off.

Context from js-26 parent (already landed on the branch, commit 6b52994a9): the 7 ES2025 Set methods and a fix to the repeat array-constructed-collection TypeError bug (intrinsic-adder recovery now gated on genuine property absence via `chain_has_descriptor`). The set-method machinery (GetSetRecord, `call_primitive_method`-driven iterator/callback driving, `value_id`/`done_id` force-binding when a feature is referenced) is a reusable template in `rust/engine/ironhorse-vm/src/interp.rs`.
