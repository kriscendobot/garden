---
ts: 2026-05-20T22:55:13Z
kind: dispatch
role: builder
project: endo
to: builder
---

# Dispatch: builder e1d015 — mirror endojs/endo#3036 onto kriscendobot/endo@master (compare URL fallback expected)

Dispatch root: `dispatches/builder--e1d015/`. Project worktree on `kriscendobot/endo` with local ref `refs/heads/upstream-master` set to `endojs/endo@master` head `bf951df346cfcf605a6709e6a5479f2fdd526113`.

Maintainer directive (2026-05-20T22:54Z): *"Please create mirrors of [https://github.com/endojs/endo/pull/3036](https://github.com/endojs/endo/pull/3036) both on master and llm branches and run them through the gauntlet."*

This dispatch handles the **master** mirror. A sibling builder (96fa5a) is handling the **llm** mirror on `endojs/endo-but-for-bots@llm` in parallel.

## The source PR (#3036)

- Title: *feat(exo-stream): Introduce Exo streams*
- Author: kriskowal, head `ce7293d677956d3937f8ed9c8afd62cb7ec2639d`, base `master`
- 63 files. Heavy review (erights ×25+, jcorbin, grypez, gibson042 comments through Feb 2026). Sat ~9 months. Still OPEN.
- Substance: new `@endo/exo-stream` package (4 exports: `streamIterator`, `iterateStream`, `streamBytesIterator`, `iterateBytesStream` — symmetric local-↔-remote conversions for async-iterator streams over CapTP). Refactors `@endo/daemon` and `@endo/cli` to use it; removes daemon's `reader-ref.js` / `ref-reader.js`. Plus a `PROTOCOL.md` proposing the over-CapTP shape for OCapN collaboration.

## Task

Standard three-phase mirror (same shape as builder d7878e and 8d44fd earlier today):

### Phase 1: extract the diff

`gh pr diff 3036 --repo endojs/endo --patch > /tmp/3036-master.patch`. Inspect: file count, hunks, anything that's obviously stale (deleted-file references for files that no longer exist, new-file conflicts with packages added since 2025-11, daemon module reshuffles).

### Phase 2: rebase onto current master (head `bf951df3`)

Branch from `refs/heads/upstream-master`. Apply via `git apply --3way /tmp/3036-master.patch`. Given 9 months of drift across 63 files (especially in `@endo/daemon` and `@endo/cli`, which have churned hard), expect conflicts. Resolve conservatively against the intent: the new `@endo/exo-stream` package is the load-bearing surface; the refactors in daemon/cli are to wire it in.

Triage shape if conflicts are extensive:
- **Hunks that conflict on the new `@endo/exo-stream/` package files**: keep the original PR's content; these are net-new files and shouldn't really conflict.
- **Hunks that conflict on `@endo/daemon/src/*.js` switching `reader-ref` / `ref-reader` to `exo-stream`**: re-do the wire-in against the current shape of those files. If daemon has been refactored to use a different stream module since, the intent may already be partially-satisfied — flag this in the report.
- **Hunks that conflict on `@endo/cli/src/commands/*.js`**: same shape — re-do the wire-in.
- **Hunks that conflict on `@endo/cli/demo/cat.js`, `CONTRIBUTING.md`, `.gitignore`, `package.json`s**: re-do mechanically.

If `git apply --3way` rejects more than ~40% of hunks, fall back to: do the new-file additions (the `@endo/exo-stream/` package) verbatim, then re-do the daemon/cli wire-ins by hand against current master's shape. **Don't get stuck rebasing — partial-mirror is better than no-mirror; surface the gaps in the report.**

Preserve kriskowal's authorship on commits (`--author "Kris Kowal <kris@agoric.com>"`); the bot identity is the committer. Commit subject should match: `feat(exo-stream): Introduce Exo streams`. If you naturally split into multiple commits during the rebase (e.g. new-package commit + daemon-wire-in commit + cli-wire-in commit), that's fine.

### Phase 3: push + attempt PR-create + report

Push branch: `mirror/3036-exo-stream` to `kriscendobot/endo`. Attempt:

```
gh pr create --repo endojs/endo --base master --head kriscendobot:mirror/3036-exo-stream --draft \
  --title "feat(exo-stream): Introduce Exo streams" \
  --body "<see below>"
```

PR body: cite original #3036, rebase base `bf951df3`, rationale: *"Rebased mirror of #3036 to recover the stalled exo-stream work for current master. Original sat ~9 months since extensive review (erights, jcorbin, grypez, gibson042)."* If the rebase carries reviewer feedback already (look for related comments addressed in PR), mention which.

**PR-create will likely fail** (cross-fork block per `journal/entries/2026/05/20/051910Z-result-liaison-90f5ea.md`). Don't retry — surface compare URL `https://github.com/endojs/endo/compare/master...kriscendobot:endo:mirror/3036-exo-stream?expand=1` in the report.

The gamut's subsequent stages can't run on the master mirror until a maintainer ferries the upstream PR. The llm-side sibling (96fa5a) gets the gamut directly.

## Per-action authorization

- Standing on `kriscendobot/endo`: push to `mirror/3036-exo-stream`. PR-create attempt against `endojs/endo` permitted (will likely fail).
- READ-ONLY everywhere else. No comments.

## Out of scope

- Don't touch any file outside the original PR #3036's diff (modulo conflict-resolution shape against current master).
- Don't open it un-draft. Don't merge.
- Don't try to address the 30+ comment thread (those need their own follow-up per the existing maintainer process).

## Report

≤ 400 words:
1. Original-PR scope summary (file count, package boundaries, kind of change).
2. Conflict count from `git apply --3way` and triage outcome (clean / minor / partial-mirror / fallback).
3. Whether any of the original PR's substance is already partially-satisfied on current master (e.g. daemon already migrated away from `reader-ref`).
4. Branch + head SHA pushed.
5. PR URL if create succeeded, otherwise the compare-URL fallback.
6. `yarn lint` and `yarn test` results — at minimum for `@endo/exo-stream` (new package) and any package whose source you touched.
7. One-line `Self-improvement: ...`.
