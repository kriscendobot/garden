---
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-08-15T04:28:03Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Close residual: Map.prototype.getOrInsert / getOrInsertComputed + Map.groupBy

Causal features (all throw `ironhorse-aborted`/TypeError today — the methods are unbound):
- `Map.prototype.getOrInsert(key, value)` and `Map.prototype.getOrInsertComputed(key, callbackfn)` (the upsert / getOrInsert proposal; XS oracle supports them). ~33 cases under `built-ins/Map/prototype/getOrInsert` and `getOrInsertComputed`.
- `Map.groupBy(items, callbackfn)` (~14 cases under `built-ins/Map/groupBy`); consider `Object.groupBy` if in the same slice.

Reuse the js-26 Set-method template: register the methods on `map_proto` with `alloc_named_method` (correct name/length), dispatch through `call_native_method`, drive callbacks via `call_primitive_method`/`run_callback`, and (for getOrInsertComputed's callback + groupBy's iteration) force-bind support ids as js-26 did for `value`/`done`. getOrInsertComputed must call the callback exactly once on absence and insert the result; groupBy iterates an iterable, invokes the callback per element, and buckets by SameValueZero key.

Repository: `endojs/endo-but-for-bots`. Shared branch/PR (do NOT create a new one): work on `feat/ironhorse-262-language-completion` (PR endojs/endo-but-for-bots#970 — OPEN, draft, keep open, do NOT merge). Fetch+rebase before every push (serial orchestration to avoid CAS collisions; peers push serially).

Pins (unchanged): test262 `tc39/test262@be13516fb6441b950ba8a3df97eb34062c186972` (a checkout already exists at /home/kris/garden/scratch/test262-pin-be13516f); Moddable XS oracle `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d` (`git submodule update --init --depth 1 c/moddable`). Rust: prepend `$HOME/.cargo/bin` to PATH; set `TMPDIR` off noexec (/tmp is noexec — use e.g. /home/kris/garden/scratch/tmp-ironhorse-js26).

Acceptance bar (identical to js-26 parent, non-negotiable): convert this child's cases to **covered** via real execution against the XS differential oracle (`rust/engine/ironhorse-262/scripts/full-run.sh --subtree <PREFIX> --test262-dir <pinned checkout>`, or `ironhorse-xst --test262-dir ... <subtree>` for iteration). Add focused Rust tests under `rust/engine/ironhorse-262/tests/`. Do NOT relabel/suppress/skip-list. Zero generic `ironhorse-aborted`/`parse-or-decode`/`unsupported-opcode:*`/`abort-value-differs`/`non-primitive-completion` may remain within this child's scope.

Regression invariant: run `cargo test --workspace --release` (includes the exact-metering corpus via corpus_conversion_equivalence, must stay 1711/1711) and the affected official slice before every push; no covered case may regress, no new failure/infrastructure result. If THIS child is still too large for your budget, do NOT partially relabel — sub-decompose into a nested halt-on-failure orchestration and hand off.

Context from js-26 parent (already landed on the branch, commit 6b52994a9): the 7 ES2025 Set methods and a fix to the repeat array-constructed-collection TypeError bug (intrinsic-adder recovery now gated on genuine property absence via `chain_has_descriptor`). The set-method machinery (GetSetRecord, `call_primitive_method`-driven iterator/callback driving, `value_id`/`done_id` force-binding when a feature is referenced) is a reusable template in `rust/engine/ironhorse-vm/src/interp.rs`.
