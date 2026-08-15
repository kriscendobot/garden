---
gate: orchestrated
orchestrated_by: ironhorse-js-26-iter-set-map-orch
priority: normal
posted_by: producer
posted_at: 2026-08-15T04:26:19Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Close residual: the Iterator global + Iterator Helpers (built-ins/Iterator, ~635 cases)

Largest cluster piece: ironhorse has NO `Iterator` global at all (all `built-ins/Iterator` cases throw ReferenceError/aborted). Implement the ES2025 Iterator Helpers + iterator-sequencing surface against the XS oracle:
- The `Iterator` global constructor (abstract: `new Iterator()` from base throws TypeError; subclassable), `%Iterator.prototype%` with `[Symbol.iterator]` (identity), `[Symbol.toStringTag]` (get/set), and `constructor` (get/set).
- Lazy helper methods on %Iterator.prototype%: `map`, `filter`, `take`, `drop`, `flatMap`, plus eager `reduce`, `toArray`, `forEach`, `some`, `every`, `find`. Each returns/consumes a %IteratorHelperPrototype% object driving the underlying iterator via the iterator protocol (GetIteratorDirect, IteratorStep, IteratorClose on early return/throw), argument validation order per spec.
- `Iterator.from(obj)` (+ %WrapForValidIteratorPrototype%) and `Iterator.concat(...iterables)` (iterator-sequencing proposal; see the parent's example paths under `built-ins/Iterator/concat`).

This child is itself very large — it is EXPECTED to sub-decompose into a nested halt-on-failure orchestration (e.g. one child per helper family: map/filter, take/drop, flatMap, the eager reducers, Iterator.from/wrap, Iterator.concat, the prototype identity/toStringTag/constructor cases) and hand off. Do NOT partially relabel. Reuse the js-26 iterator-driving-from-native template (`call_primitive_method`, `ordinary_get` for next/value/done, force-binding value_id/done_id).

Repository: `endojs/endo-but-for-bots`. Shared branch/PR (do NOT create a new one): work on `feat/ironhorse-262-language-completion` (PR endojs/endo-but-for-bots#970 — OPEN, draft, keep open, do NOT merge). Fetch+rebase before every push (serial orchestration to avoid CAS collisions; peers push serially).

Pins (unchanged): test262 `tc39/test262@be13516fb6441b950ba8a3df97eb34062c186972` (a checkout already exists at /home/kris/garden/scratch/test262-pin-be13516f); Moddable XS oracle `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d` (`git submodule update --init --depth 1 c/moddable`). Rust: prepend `$HOME/.cargo/bin` to PATH; set `TMPDIR` off noexec (/tmp is noexec — use e.g. /home/kris/garden/scratch/tmp-ironhorse-js26).

Acceptance bar (identical to js-26 parent, non-negotiable): convert this child's cases to **covered** via real execution against the XS differential oracle (`rust/engine/ironhorse-262/scripts/full-run.sh --subtree <PREFIX> --test262-dir <pinned checkout>`, or `ironhorse-xst --test262-dir ... <subtree>` for iteration). Add focused Rust tests under `rust/engine/ironhorse-262/tests/`. Do NOT relabel/suppress/skip-list. Zero generic `ironhorse-aborted`/`parse-or-decode`/`unsupported-opcode:*`/`abort-value-differs`/`non-primitive-completion` may remain within this child's scope.

Regression invariant: run `cargo test --workspace --release` (includes the exact-metering corpus via corpus_conversion_equivalence, must stay 1711/1711) and the affected official slice before every push; no covered case may regress, no new failure/infrastructure result. If THIS child is still too large for your budget, do NOT partially relabel — sub-decompose into a nested halt-on-failure orchestration and hand off.

Context from js-26 parent (already landed on the branch, commit 6b52994a9): the 7 ES2025 Set methods and a fix to the repeat array-constructed-collection TypeError bug (intrinsic-adder recovery now gated on genuine property absence via `chain_has_descriptor`). The set-method machinery (GetSetRecord, `call_primitive_method`-driven iterator/callback driving, `value_id`/`done_id` force-binding when a feature is referenced) is a reusable template in `rust/engine/ironhorse-vm/src/interp.rs`.
