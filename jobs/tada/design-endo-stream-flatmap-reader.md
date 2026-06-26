Job complete. Report follows.

---

**Job `design-endo-stream-flatmap-reader` — done. PR endojs/endo-but-for-bots#545.**

**Signature:** `flatMapReader(reader, transform)` where `transform: (value: TIn) => Iterable<TOut> | AsyncIterable<TOut>`, returning `Reader<TOut>`. The identity transform `value => value` flattens a `Reader<T[]>` into a `Reader<T>`.

**What I did (designer → builder in one pass):**
- Studied the existing `mapReader`/`mapWriter` siblings in `@endo/stream`. The design decision: `flatMapReader` is a one-token change from `mapReader` — `yield` becomes a delegating `yield*` over an async generator (`for await (const v of reader) yield* transform(v)`). This is the cleanest correct implementation and gets back-pressure structurally for free.
- **Naming decision:** kept the surface to the single primitive `flatMapReader` (no separate `flattenReader` helper) — flatten is just `flatMapReader(reader, x => x)`, documented in the README. Mirrors the minimal `mapReader`/`mapWriter` pair.
- **Back-pressure (the crux):** the generator suspends at every inner element until pulled, and reads the next source value only once the current group is exhausted — no upstream buffering, only the current group held. Empty groups advance; upstream `throw`/`return` and consumer `return()`/`throw()` propagate to both the inner iterable and the upstream reader.

**Changed files:** `packages/stream/index.js` (impl + JSDoc), `types.d.ts` (type decl with `Iterable | AsyncIterable` transform), `README.md` (new "Flat map" section), `test/flat-map.test.js` (7 tests), `.changeset/flat-map-reader.md` (`@endo/stream` minor).

**Tests** (all cases the job named): flatten arrays, 1-to-many map, empty groups, async-iterable transform, throw propagation, consumer-return termination propagation, and an instrumented-reader **lazy-pull** test asserting the source `next()` is not called again until the current group is drained.

**Verification (local, ran via `node` directly since the sandbox blocks bin shims):** `@endo/stream` suite **25 tests pass** (18 prior + 7 new) · `tsc` clean · `eslint` clean · `type-coverage` **99.00%** (≥ the package's pinned 95.22 floor).

**Subsumes the #486 deferrals:** confirmed — `parseStreamJsonLines` (chunk → many newline-delimited records) and the general stream-of-arrays flatten both reduce to `flatMapReader`; noted in the PR as the building block to refactor those follow-ups.

**Hygiene:** committed under the `endolinbot` bot identity, pushed branch `stream-flat-map-reader`, opened PR #545 with full design note in the body plus the standard summary comment (SHA + verification). Worktree torn down and pruned.

**Follow-ups (not in scope here):** refactor `parseStreamJsonLines` and the line-accumulator onto `flatMapReader`; CI on #545 will validate the full monorepo lint/type gates I could only run for the `stream` package locally.
