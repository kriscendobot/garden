Inbox empty. The retire-master sweep for PR #344 is complete.

## Completion report

**Job:** `ebfb-retire-master-pr-344` (weaver) — retire the `master` base for [endojs/endo-but-for-bots#344](https://github.com/endojs/endo-but-for-bots/pull/344) under the 2026-07-16 maintainer directive, per `skills/frozen-base-branch`.

**Preconditions confirmed**
- PR #344 was OPEN and targeted `master`. It is not cross-repository (head `mirror/3047-readmes` and base both live on `endojs/endo-but-for-bots`).
- Base SHA taken from **upstream `endojs/endo` master = `46d4edf`** (never the fork/ebfb master, which sits at `fcbb540`).

**What I did**
1. Set up an isolated project worktree keyed by this job base; deepened the shallow bare clone to recover a real merge-base.
2. Determined the docs stack (30 commits mirroring endojs/endo#3047) was built on endo master `bf951df3` — ~5 months behind current master `46d4edf`.
3. **Reused the existing reflection `master-46d4edf`** on the repo (already pointed at endo master `46d4edf`; no new branch needed).
4. Rebased the 30-commit head onto `46d4edf`. **One focused conflict** in `packages/immutable-arraybuffer/README.md`: upstream had independently rewritten the "Purposeful Violation" concordance paragraph. Resolved by keeping upstream's newer paragraph and appending the `## License` footer the normalization commit intends — a focused doc weave, within scope. Commits 8–30 applied cleanly. (`packages/netstring/reader.js`'s spacing fix had already landed upstream, so it dropped out benignly; final diff is docs-only.)
5. Pushed the rebased head `5b5209a` with `--force-with-lease` (old `0c9fe40` → new `5b5209a`).
6. Moved the PR base to `master-46d4edf`.

**Result**
- PR #344: OPEN, base `master-46d4edf`, head `5b5209afda…`. Mergeability flipped from **CONFLICTING/DIRTY → MERGEABLE** (`mergeStateStatus: UNSTABLE` = CI pending, not a conflict). Fork `master` was never touched.

**Follow-ups for the maintainer**
- The upstream source PR **endojs/endo#3047 is still OPEN and idle since 2026-02-13** (never merged); mirror #344 had been idle since 2026-05-22. This is a long-idle mirror. The sweep went through cleanly because the only conflict was a single focused weave, but as #3047 continues to evolve upstream the mirror will need periodic re-sync — worth a look at whether #344 should keep tracking #3047 or be retired.
- No garden `main2` changes were needed (this job mutated a project repo, not the garden library).
