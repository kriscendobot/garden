---
ts: 2026-05-21T06:29:44Z
kind: result
role: boatman
project: endo
repo: endojs/endo
refs:
  - entries/2026/05/21/062400Z-dispatch-liaison-92d137.md
---

Ferried `endojs/endo-but-for-bots#75` (source head `77f4e0526acbbb8e323c17d90c0b7f8c5bc058ff`, branch `kriskowal-random-chacha12`) onto fresh `endojs/endo` master and force-pushed (with lease) to upstream PR `endojs/endo#3232` (branch `kriskowal-random-chacha20`).

## Pre-flight ancestor / lease check

`git fetch origin kriskowal-random-chacha20` after cherry-picks confirmed the remote tip still at `6fbe4b06adb2175ecc77be7d4628e810723a64bb`, matching the dispatch-named lease target. Force-with-lease was safe to issue.

## Push mode

`git push origin HEAD:kriskowal-random-chacha20 --force-with-lease=kriskowal-random-chacha20:6fbe4b06adb2175ecc77be7d4628e810723a64bb`. No unsafe `--force`.

## Upstream head SHA after force-push

`71055ef1780339fece1b13eedc48a8a1f37e9164`

## 11 new commit SHAs (in order)

1. `c5d08db77` feat(random): add @endo/random source-agnostic samplers
2. `6bc35af94` feat(chacha12): add @endo/chacha12 pure-JS ChaCha12 keystream
3. `8ec16285d` feat(chacha12-fast-check-test): adopt test-package shape
4. `ce8c3370e` refactor(hex): use @endo/chacha12 keystream + @endo/random/seeds for bench inputs
5. `5b9c35ee7` refactor(ocapn): use @endo/chacha12 + @endo/random for fuzz drivers
6. `91cda2581` fix(ses): tuple-typed args restores Parameters<typeof compartmentOptions> overlap
7. `15bfaee23` style(evasive-transform): align customVisitor JSDoc continuation indent
8. `f27fb8c31` docs: document the thunk-module policy in AGENTS.md
9. `8c8205b0f` chore: register chacha12, chacha12-fast-check-test, random in root tsconfig and typedoc
10. `f161c4219` docs(random,chacha12): changeset for @endo/random + @endo/chacha12
11. `71055ef17` chore: Update yarn.lock

## Attribution verified

`git log origin/master..HEAD --pretty=fuller` shows 11 commits, every one author + committer `Kris Kowal <kriskowal@kriskowal.com>`. `git interpret-trailers --parse` returned empty for every commit (no bot or co-author trailers present in source; nothing to strip).

## Conflict resolution notes

The cherry-picks applied unusually cleanly given the recompute brief. Commits 1, 2, 3 added wholly new package trees (`packages/random/`, `packages/chacha12/`, `packages/chacha12-fast-check-test/`) and applied as net-new files. Commits 4 and 5 (refactor hex / ocapn fuzz drivers) applied without textual conflicts; the deletions of `_xorshift.js` test helpers landed cleanly. Commit 6 (fix ses tuple-typed args) was a two-line edit and applied without overlap. Commits 7, 8, 10 were small edits to stable files. Commit 9 (root tsconfig / typedoc) auto-merged `tsconfig.composite.json`. Commit 11 (yarn.lock) auto-merged. Git emitted "Auto-merging" for `packages/ocapn/package.json`, `tsconfig.composite.json`, and `yarn.lock`, but none required manual intervention. No regenerated yarn.lock was needed.

## Source-side cross-link URL

`https://github.com/endojs/endo-but-for-bots/pull/75#issuecomment-4505395388` (posted under kriskowal, named the new head SHA, the 11-commit shape, and confirmed the recompute onto fresh master). No upstream PR comment posted; title and body of `endojs/endo#3232` left untouched.

## Mergeability post-push

`gh pr view 3232 -R endojs/endo --json mergeable,mergeStateStatus,headRefOid` returns:

```
{"headRefOid":"71055ef1780339fece1b13eedc48a8a1f37e9164","mergeStateStatus":"BLOCKED","mergeable":"MERGEABLE"}
```

Advanced from CONFLICTING to MERGEABLE; `BLOCKED` is the usual "needs review approval" gate, not a merge-conflict signal.

Self-improvement: nothing this time.
