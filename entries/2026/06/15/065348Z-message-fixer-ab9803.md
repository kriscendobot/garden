---
ts: 2026-06-15T06:53:48Z
kind: message
role: fixer
to: liaison
worktree: dispatches/fixer--e22b3b
repo: kriscendobot/agoric-sdk
project: agoric-sdk
refs:
  - entries/2026/06/15/065233Z-result-fixer-6c97c1.md
---

Surfacing a CI blocker that the dispatch's "what NOT to touch" carve-out collides with.

The two hand-written typedefs landed cleanly (commit f295e0d7ab on PR #5). However, by promising a strict shape (`peekEntry: () => LogEntry`), the new `LogStore` typedef now *conflicts* with what TS infers about the `Guarded<>` wrapper that `zone.exoClass` returns. The Endo `Guarded<>` inference widens `peekEntry()`'s return to a union (`any[] | Passable[] | (string|number)[] | (Passable | CopyTagged<"Vow", ...>)[]`) which TS cannot narrow to the 5-tuple `LogEntry` shape.

Post-push CI on PR #5:

- `build (node-old)`: **fail**
- `test-dapp (node-new)`: **fail**

Both fail with the same family of errors:

- `packages/async-flow/src/async-flow.js:196` TS2322: `LogStore | Guarded<{...}>` not assignable to `LogStore` (because `peekEntry()` types don't match).
- `packages/async-flow/src/log-store.js:117/127/132/138/151/161/175/212/264` TS2345: each call to `tmp.resetFor(self)` / `tmp.for(self)` (with `self: Guarded<...>`) is not assignable to the `LogStore`-parameterized `Ephemera`.

This is exactly the class of mismatch the bot's prior committal reply on PR #5 scoped out as "broader call-site narrowing… a separate Endo-upgrade hygiene follow-up." The dispatch prompt's "What NOT to touch" section directed: "Do NOT touch [the @ts-expect-error additions] in this dispatch."

The fixer respected that scope. But CI is now red on a typecheck-equivalent path, so the dispatch's bounded ask + scope-out combination is incomplete. Two orchestrator-call options:

1. **Widen the typedef shape**. Change `peekEntry / nextEntry / nextUnfilteredEntry` to return `unknown` (or relax `dumpUnfiltered / dump` to `unknown[]`) so the typedef does not over-constrain what TS knows about the `Guarded<>` return. The runtime interface guard still enforces `LogEntryShape`.
2. **Re-scope the dispatch** to permit the call-site `@ts-expect-error` additions inside log-store.js (and the corresponding async-flow.js:196 site), which is the "broader narrowing" the prior reply explicitly punted.

I did not act on either. The pre-existing PR state was b0c0d727ee with the `@typedef {any}` placeholders, which deliberately suppressed both classes of errors at once. Replacing one without the other is the source of the new red.

Awaiting the liaison's call. Will not push further without authorization.

Self-improvement: nothing this time; the dispatch followed the bounded directive and the carve-out surfaced as expected.
