---
ts: 2026-05-21T07:24:42Z
kind: dispatch
role: builder
project: endo-but-for-bots
to: builder
---

# Dispatch: builder 570bb5 — mirror endojs/endo#59 fix onto endo-but-for-bots@master (autonomous-loop pickup)

Dispatch root: `dispatches/builder--570bb5/`. Project worktree on `endojs/endo-but-for-bots@master` (head `9213d2c566dc013da8454af92147c8154c178f80`).

Autonomous-loop pickup (2026-05-21T07:24Z, continuing the cross-fork-block pattern). Source: branch `fix/issue-59-star-export-cycle` on `kriscendobot/endo` at head `461c392dc` (builder 8e2aba earlier this session — see `journal/entries/2026/05/20/220659Z-result-liaison-8e2aba.md`).

## Origin: builder 8e2aba's verified fix for issue #59

Defect: cyclic star export with renaming reexport (the original 2019 issue #59) reproduces today on master `ec3dcbc0` as `TypeError: notify is not a function` at `packages/ses/src/module-instance.js:364` (mutated from the original `SyntaxError`).

Fix: in `packages/ses/src/module-instance.js`, when `wireUpExportNotifier` is called for a reexport whose upstream notifier is `undefined`, install a **deferred forwarding notifier** that queues subscribers until the upstream resolves (looked up through `mapGet(importedInstances, specifier).notifiers[localName]` on first invocation). Genuine missing exports still raise `SyntaxError` from the deferred lookup.

Regression test: `packages/ses/test/import-gauntlet.test.js` gains `cyclic star export with renaming reexport (issue #59)`. Without the fix the test fails with the exact `TypeError`; with the fix it passes alongside the 14 pre-existing gauntlet tests.

Changeset: `'ses': patch`.

Wider verification (builder 8e2aba): `ses` 502 / `module-source` 53 / `compartment-mapper` 882 all pass. Pre-existing known-failures unchanged.

The kriscendobot mirror got the cross-fork PR-create block. This dispatch transplants the fix onto `endo-but-for-bots@master` (bot-pushable) so the gauntlet can run.

## Task

### Phase 1: pull the fix commits from kriscendobot/endo into the worktree

You're checked out detached on endo-but-for-bots@master `9213d2c5`. Fetch the fix branch from kriscendobot/endo directly into your worktree:

```sh
git fetch git@github.com:kriscendobot/endo.git fix/issue-59-star-export-cycle:refs/heads/upstream-fix-59
```

(If SSH access via the kriscendobot account is not available from this host, fall back to the public HTTPS URL: `https://github.com/kriscendobot/endo.git`.)

Inspect the commit(s) on `upstream-fix-59` relative to its merge-base with current endojs/endo master. There should be 2-3 commits (fix + test + changeset). Cherry-pick them onto detached HEAD, preserving kriskowal authorship if the original commits carry it, or rewriting authorship to the bot identity if they were bot-authored (check `git log --format='%an <%ae>' upstream-fix-59 ^upstream-fix-59~3` to see).

### Phase 2: validate and push

- `yarn workspace @endo/ses lint && yarn workspace @endo/ses test` — expect 502 + 1 (new regression test) = 503 pass.
- `yarn workspace @endo/module-source test && yarn workspace @endo/compartment-mapper test` — expect 53 and 882 pass respectively (within known-failure tolerance).
- Push branch `fix/issue-59-star-export-cycle` to `endojs/endo-but-for-bots`. Bot has direct push permission.

### Phase 3: open DRAFT PR

```sh
gh pr create --repo endojs/endo-but-for-bots --base master --head fix/issue-59-star-export-cycle --draft \
  --title "fix(ses): cyclic star export with renaming reexport (issue #59)" \
  --body "<see below>"
```

Body must:
- Cite the original issue (endojs/endo#59, opened 2019)
- Cite the prior verification builder (this session's builder 8e2aba, kriscendobot branch `fix/issue-59-star-export-cycle @ 461c392dc`)
- Note the surface crash today (`TypeError: notify is not a function` at `module-instance.js:364`) and that the test fails-without-fix
- Note the cross-fork PR-create block on kriscendobot; this is the bot-pushable mirror so the gauntlet can run
- Reference the deferred forwarding notifier shape + the regression test

## Per-action authorization

- Standing on `endojs/endo-but-for-bots`: push to `fix/issue-59-star-export-cycle`, create draft PR against `master`.
- READ-ONLY on `endojs/endo` (for cross-checking only). READ-ONLY on `kriscendobot/endo` (you're fetching, not pushing).
- No comments anywhere. Don't open un-draft. Don't merge.

## Out of scope

- Don't touch files outside the fix's scope (`packages/ses/src/module-instance.js`, the gauntlet test file, the changeset).
- Don't run the gamut's downstream stages — the liaison's autonomous-loop tick continues them on your return.

## Report

≤ 300 words:
1. Commits cherry-picked (count + subjects + authorship after pick).
2. Test outcomes per package (counts).
3. Branch + head SHA pushed.
4. PR URL.
5. One-line `Self-improvement: ...`.

Write into `journal/entries/2026/05/21/<HHMMSS>Z-result-builder-570bb5.md` and commit+push to origin journal before returning.
