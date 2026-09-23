---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-09-10T13:53:10Z
---
Reviewed https://github.com/endojs/endo-but-for-bots/pull/1260 at head https://github.com/endojs/endo-but-for-bots/commit/f54507b891d8d297510069a874e11b9b3203f6f4 and answered the maintainer's risk question at https://github.com/endojs/endo-but-for-bots/pull/1260#issuecomment-5619796095. The reader change preserves late error delivery, but an abandoned iterator now has no ambient failure signal and the symmetric idle-rejection exposure remains in both writer iterators. Reproduced the writer exposure with a focused temporary test. Local evidence: 157 package tests passed, ESLint returned 0 errors and 3 pre-existing warnings, and TypeScript checking passed.

Self-improvement: nothing this time.
