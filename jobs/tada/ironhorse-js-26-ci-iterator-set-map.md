---
handed-off: ironhorse-js-26-iter-set-map-orch
deliverable-complete: false
---
Everything is confirmed durable — and the handoff orchestration is already **live and executing**: the orchestrate watcher has promoted the first child (`ironhorse-js-26-map-methods` plan→todo), set the orchestration state→running, and gardeners have claimed it. My work is complete for this attempt as a declared handoff.

## Completion report

**What I did**

Implemented the largest tractable functional slice of this 952-case cluster directly, and durably decomposed the remainder.

*Engine work landed (commit `6b52994a9` on `feat/ironhorse-262-language-completion`, PR endojs/endo-but-for-bots#970, kept open/draft — not merged):*
- **The seven ES2025 "new Set methods"** on `Set.prototype` — `union`, `intersection`, `difference`, `symmetricDifference`, `isSubsetOf`, `isSupersetOf`, `isDisjointFrom` — as native methods driven against the XS differential oracle. Each validates the receiver's `[[SetData]]` directly, coerces its argument through `GetSetRecord` (observing `size`→ToNumber, `has`, `keys` in spec order), and drives the argument's `keys()` iterator / `has` callback via `call_primitive_method`/`ordinary_get`, returning a fresh `%Set.prototype%` Set (combinators) or a Boolean (predicates).
- **Fixed a pre-existing collection-constructor bug** the functional tests exposed: a second `new Set([...])`/`new Map([...])` in one program threw a spurious `TypeError` because the intrinsic-adder recovery was gated on the interned name (`method_was_linked`), which the first construction's `intern_key("add"/"set")` poisoned. Recovery is now gated on genuine property absence (`chain_has_descriptor`), so a truly-unbound intrinsic recovers while a user-cleared `add`/`set` still throws.
- Added `rust/engine/ironhorse-262/tests/set_methods.rs` (9 XS-differential tests, all pass).

**Totals before/after (pinned test262 `be13516fb6`, XS oracle `23b4d6b0a6`):**
- `built-ins/Set`: **174 → 293 covered** (0 failures); the 7 method dirs 0 → 154/186.
- `built-ins/Map`: **100 covered** (0 failures) — construction unblocked by the same bug fix.
- **Regression gates green:** `cargo test --workspace --release` all pass; exact-metering corpus **1711/1711 covered, 0 failed** (no computron drift).

**Remaining work decomposed & handed off** — posted `ironhorse-js-26-iter-set-map-orch`, a **serial, halt-on-failure** nested orchestration (already running) with four bounded causal children, each carrying the full acceptance bar / pins / regression invariant:
1. `ironhorse-js-26-map-methods` — `Map.prototype.getOrInsert`/`getOrInsertComputed` + `Map.groupBy` (in progress).
2. `ironhorse-js-26-map-set-iterator-proto` — Map/SetIteratorPrototype + residual collection aborts.
3. `ironhorse-js-26-set-map-metadata` — native-function `name`/`length`/`prototype` reflection + delete/redefine (the engine-wide `verifyProperty`/`isConstructor`/`builtins` gap).
4. `ironhorse-js-26-iterator-helpers` — the `Iterator` global + Iterator Helpers (~635 cases; expected to sub-decompose further).

**Remaining skip reasons in scope** (owned by the children): the Set/Map `name`/`length`/`not-a-constructor`/`builtins`/`add-not-called` metadata family (needs delete-aware exotic-function-property support — a partial GOPD fix was prototyped and reverted here because delete-tracking was missing), `collection-constructor:general-iterable`, weak-collection method edges, and the entire `built-ins/Iterator` surface.

**Head SHA:** `6b52994a9` · **PR:** https://github.com/endojs/endo-but-for-bots/pull/970 (open, draft, not merged).

Core cluster deliverable is unfinished; all remaining work is durably owned by the running orchestration `ironhorse-js-26-iter-set-map-orch`.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-js-26-ci-iterator-set-map.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s) (1 unmetered)
- Input: 150 tokens (7191697 cached reads)
- Output: 35706 tokens
- Cost: $5.7333215000000015 (1 engagement(s) unpriced)
- Wall-clock: 3015s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
