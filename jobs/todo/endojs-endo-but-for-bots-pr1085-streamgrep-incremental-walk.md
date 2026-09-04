---
role: builder
handler-budget-role: build
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# fix: make streamGrep genuinely incremental in the walk phase (PR #1085)

Repo: endojs/endo-but-for-bots
PR: https://github.com/endojs/endo-but-for-bots/pull/1085 (branch `feat/mount-stream-glob-grep`, base `llm`)
Triggering feedback (kriskowal): https://github.com/endojs/endo-but-for-bots/pull/1085#issuecomment-5536021610

## The defect (verified in code)

`streamGrep` (`packages/daemon/src/mount.js`) enumerates its file list through
`search.globPaths(...)` (`packages/platform/src/fs/search.js`), which performs a
**global UTF-16 sort** of the whole match set before yielding the first batch —
it runs the entire `await walk(...)` to completion, then sorts, then yields
(`search.js` ~line 392-399). `grepFiles`, however, needs **no** sorted input
(its normative flattened order is path-then-line as files are read; the engine
header itself says "Unlike glob, grep needs no global sort").

So `streamGrep` inherits glob's whole-walk-before-first-path barrier for nothing.
The PR documents this walk-phase non-incrementality as an *accepted* asymmetry
(§ Scaling Considerations; the long comments around `streamGrep` in mount.js).
kriskowal's feedback is that it need not be accepted for grep: the sort is what
makes the streaming pipeline moot in the walk phase.

## The change

1. **Engine** (`packages/platform/src/fs/search.js`): add an unsorted/incremental
   enumeration mode to `globPaths` (a `sorted` option, default `true` to preserve
   glob's contract). When `sorted: false`, yield matched paths in **walk order**
   as they are discovered — no global-sort barrier, so the first batch can be
   emitted before the whole tree is walked. Confinement + denial filtering are
   applied during the walk exactly as today (unchanged). Keep it ONE walker /
   ONE shared engine — a flag on the existing generator, never a second walk.
2. **`streamGrep`** (`packages/daemon/src/mount.js`): route through the unsorted
   mode (`sorted: false`) so grep is genuinely incremental in the walk phase.
   Keep the per-path-batch liveness interposition (`assertLivePathBatches`,
   `batchSize: 1`). `streamGlob` KEEPS `sorted: true` (its UTF-16 global-sort
   contract is normative and load-bearing).
3. **Semantic reconciliation** — the one consequence to handle carefully:
   `streamGrep`'s flattened order becomes **walk order**, not sorted-path order.
   It stays a multiset-equal superset of eager `grep`. Update the parity tests in
   `packages/daemon/test/mount-stream-search.test.js` to compare as a
   set/multiset rather than an ordered sequence where they currently assume the
   sorted order, and add/adjust an incrementality test proving `streamGrep` now
   yields a first match before the full tree is walked (read-counter style, like
   the existing walk/read-asymmetry test) and that an early close bounds the
   **directory walk**, not only content reads.
4. **Docs**: update the § Scaling Considerations asymmetry claim in the PR body
   and in `designs/mount-stream-glob-grep.md`, plus the mount.js method comments
   that assert `streamGrep`'s walk is necessarily eager, so code and prose agree.
   Note grep's stream order is now enumeration order.

## Constraints / notes

- Preserve `glorp` and the eager `glob`/`grep` behavior exactly (sorted).
- Do NOT change `streamGlob`'s ordering — glob's sort is its contract.
- Run the daemon + platform test suites and the changeset check; this is
  additive/behavioral-on-a-draft, so a changeset already exists — extend the
  narrative rather than adding a redundant one if appropriate.
- This lands on the PR head branch `feat/mount-stream-glob-grep`; it is a draft,
  so no un-draft/merge is implied by this job — push the fix-up commit(s) and
  reply on the triggering thread citing the SHA.
- If the grep-stream-order-change needs maintainer sign-off before merge, flag it
  on the PR rather than blocking the code (the draft can carry it for review).
