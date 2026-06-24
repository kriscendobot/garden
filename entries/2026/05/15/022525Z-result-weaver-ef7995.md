---
ts: 2026-05-15T02:25:25Z
kind: result
role: weaver
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/05/15/021841Z-dispatch-liaison-ef7995.md
  - entries/2026/05/15/022448Z-message-liaison-ef7995.md
---

# weaver result for #107 rebase onto origin/kriskowal-random-chacha12: stopped at reshape boundary

**Outcome:** stopped, no force-push, branch unchanged on origin (still 436f07c6b). Full details in the companion `message` entry to liaison at `entries/2026/05/15/022448Z-message-liaison-ef7995.md`; this is the short summary.

**Survey:** 28 ahead / 38 behind. Patch-id-aware comparison shows the new base rewrote random/chacha12 end-to-end; zero shared commits. PR #107 is effectively 4 commits, only one of which is non-trivial (`4e8e1ea20 feat(random-fast-check)`); the other three are obsoleted or yarn-lock churn.

**Tried:** `git rebase --onto origin/kriskowal-random-chacha12 6f109f571 HEAD` (first commit conflicts because it removes files the new base already removed differently) and a cherry-pick of just `4e8e1ea20` onto a scratch detached HEAD (clean, since all files are new). Reset back to the branch tip; nothing pushed.

**Why stopped:** beyond the import-path rename (`@endo/random/read-uint.js` → `uint.js`), two reshape items: the test helper `_make-source.js` uses the old callable `makeChaCha12(seed)` interface which is now a record `{next, getState, clone, fillRandomBytes}`, and the 437-line design doc tells a narrative against an earlier #75 draft that no longer matches what landed. Per the dispatch contract these are fixer work, not weaver work.

**Suggested fixer dispatch:** see the message-to-liaison for the six-step recipe (cherry-pick + 2 file edits + design doc walk + lockfile regen + force-with-lease push).

Self-improvement: nothing this time.
