Implemented and pushed three bounded commits to `feat/ironhorse-262-language-completion`:

- `f5277f67a` — correct Map/Set/WeakMap/WeakSet method `name`/`length` metadata, including delete/redefine reflection tests.
- `dc62c7c34` — distinct Map/Set iterator prototypes, branded `next`, `@@toStringTag`, `@@iterator` aliases, and symbol-key `propertyIsEnumerable`.
- `34afa7ee1` — Iterator global, abstract-constructor behavior, helper metadata, built-in iterator inheritance, `Iterator.from` identity paths, and native-iterator `toArray`.

XS-differential Test262 results (`full-run.sh --no-fetch` at pin `be13516f`):

- `built-ins/Map`: 150/204 → 166/204 covered; unsupported 54 → 38.
- `built-ins/Set`: 336/383 → 348/383 covered; unsupported 47 → 35.
- `built-ins/MapIteratorPrototype`: 1/11 → 11/11 covered.
- `built-ins/SetIteratorPrototype`: 1/11 → 11/11 covered.
- `built-ins/Iterator`: 13/654 → 87/654 covered; unsupported 638 → 567; skipped 3 → 0.
- No Ironhorse failures or infrastructure results in any affected slice.

Verification:

- Focused `collections` and `iterator_helpers` Rust regression suites pass against XS.
- `cargo test --workspace --release` passes.
- `ironhorse-xst --gate-meter-exact` remains red with the same 17 unrelated language-expression/yield failures on each pre-push run; no family-slice regression was introduced.
- Remote branch and local head both resolve to `34afa7ee144822f1775d2fdc2594c8df670f59a7`.

Residual:

- Iterator helper execution remains largely open: lazy map/filter/take/drop/flatMap, terminal callback helpers, generic `Iterator.from` wrappers, iterator closing, and abrupt completion.
- Map/Set residuals chiefly involve general iterable constructors, weak-collection receiver paths, callback variants, exotic descriptors, and remaining abort parity.
- Generic native-constructor `.prototype` delete/redefine reflection remains unfinished.
- The specified PR https://github.com/endojs/endo-but-for-bots/pull/970 was already merged before this work, so it could not remain open/draft. The new commits are post-merge on the shared branch; no replacement PR was opened because marker discovery was inconclusive.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-js26-milestone-iterator-collections.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1542s

<!-- garden-usage-end -->
