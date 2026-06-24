---
ts: 2026-05-19T23:36:20Z
kind: result
role: designer
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
worktree: dispatches/designer--3f4694/project
refs:
  - entries/2026/05/19/233500Z-dispatch-liaison-3f4694.md
---

Drafted `designs/patterns-diagnostic-feedback.md` and opened DRAFT PR #307
on `endojs/endo-but-for-bots` against `llm`.

**PR.** https://github.com/endojs/endo-but-for-bots/pull/307
**Head SHA.** `65dab647a62e021255aa025cf7b1570c7dfb948d`
**Branch.** `design/patterns-diagnostic-feedback`
**Status.** Proposed

**Axis split + size estimates.**

- **A. Tree-path accumulation (S, ~1 day).** Replace flat label strings in
  `applyLabelingError` with structured `PatternPathStep` entries
  (`property` / `index` / `mapKey` / `setElement` / `orBranch`); accumulate
  onto `error.patternPath`; one-release deprecation shim on the prefix
  format. Sweep ~30 call sites in `patternMatchers.js`. New
  `pattern-path.test.js`.
- **B. Per-combinator reason renderers (M, ~2 days).** Renderer registry
  keyed by `match:*` tag; tailored renderers for `match:or` (closest-
  alternative heuristic), `match:splitRecord` (combined missing/unexpected/
  value-mismatch reason), `match:arrayOf` (count + first three failing
  indices), `match:and`, `match:not`. Structured payload on
  `error.mismatchReason`.
- **C. Alternate text-source path with own parse (M-L, ~1 week).** New
  `parsePattern` at `@endo/patterns/text-source.js` for the referentially-
  transparent `M.*` subset; produces an `M.*`-built pattern plus a
  `WeakMap` source map; `mustMatch` accepts the map via options and emits
  `sourceName:line:column` on the failing leaf.

Total per-design estimate: M (4-5 days) across the three phases, with each
phase a separately mergeable PR.

**Three exemplar error messages (current vs improved).**

1. Nested `splitRecord` with a wrong-typed leaf
   (`{ user: { name: 'kris', age: -3 }, meta: { source: 'cli' } }`):
   - Today: `user: age: -3 - Must be non-negative`
   - After A+B: `.user.age: -3 - Must be a non-negative bigint (got number)`
   - After C: `schema.pat:3:11 .user.age: -3 - Must be a non-negative bigint (got number)`

2. `M.or` over three structural `splitRecord` alternatives
   (`{ kind: 'image', url: 42 }`):
   - Today: `{"kind":"image","url":42} - Must match one of [splitRecord(...), splitRecord(...), splitRecord(...)]`
   - After A+B:
     ```
     closest alternative (alt 0): .url: 42 - Must be a string (got number)
       alt 0: .url: 42 - Must be a string
       alt 1: .kind: "image" - Must be "text"
       alt 2: .kind: "image" - Must be "embed"
     ```

3. `M.arrayOf(M.nat())` with multiple bad elements
   (`[1n, 2, 3n, -4n, 'five']`):
   - Today: `[1]: 2 - Must be a bigint`
   - After A+B: `[1]: 2 - Must be a bigint (and 2 more failures at [3], [4]; 4 total of 5 elements)`

**Open questions surfaced for the maintainer.**

1. Backward-compatibility window for the path-prefix format (one release
   vs two).
2. Where to attach `mismatchReason`: on the `Error` (proposed) vs a
   side-channel `WeakMap<Error, MismatchReason>`.
3. Text-source surface as a function (`parsePattern(string, options)`,
   proposed) vs a tagged template literal.
4. Whether the closest-alternative heuristic for `match:or` should be
   configurable.
5. Interaction with `@endo/exo` argument guards (which also use
   `applyLabelingError`).

**README sync.** `designs/README.md` updated: new row in Summary, totals
bumped to 105 designs / 10 Proposed, M4 milestone table row added, M4
per-design size estimate row added.

**Authorization scope honored.** Pushed only `design/patterns-diagnostic-feedback`;
opened DRAFT PR #307 against `llm`; no comments, reviews, or cross-links
posted. Read-only on `endojs/endo`.

Self-improvement: nothing this time.
