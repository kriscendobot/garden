---
ts: 2026-05-20T22:55:13Z
kind: dispatch
role: builder
project: endo-but-for-bots
to: builder
---

# Dispatch: builder 96fa5a — mirror endojs/endo#3036 onto endojs/endo-but-for-bots@llm (PR-create works; gamut to follow)

Dispatch root: `dispatches/builder--96fa5a/`. Project worktree on `endojs/endo-but-for-bots` with local ref `refs/heads/upstream-llm` set to `endojs/endo-but-for-bots@llm` head `37dce60ef414256346c61f5dc694e9e7880cd1c5`.

Maintainer directive (2026-05-20T22:54Z): *"Please create mirrors of [https://github.com/endojs/endo/pull/3036](https://github.com/endojs/endo/pull/3036) both on master and llm branches and run them through the gauntlet."*

This dispatch handles the **llm** mirror onto `endojs/endo-but-for-bots`. A sibling builder (e1d015) is handling the **master** mirror on `kriscendobot/endo` in parallel.

## The source PR (#3036)

- Title: *feat(exo-stream): Introduce Exo streams*
- Author: kriskowal, head `ce7293d677956d3937f8ed9c8afd62cb7ec2639d`, base `endojs/endo:master`
- 63 files. Heavy review (erights ×25+, jcorbin, grypez, gibson042 through Feb 2026). Sat ~9 months. Still OPEN.
- Substance: new `@endo/exo-stream` package (4 exports: `streamIterator`, `iterateStream`, `streamBytesIterator`, `iterateBytesStream` — symmetric local-↔-remote conversions for async-iterator streams over CapTP). Refactors `@endo/daemon` and `@endo/cli` to use it; removes daemon's `reader-ref.js` / `ref-reader.js`. Plus `PROTOCOL.md` for OCapN collaboration.

## Important context: llm has substantial divergence from master

`endo-but-for-bots@llm` is the maintainer's daily-work branch with bot-related features ahead of upstream endo's master. `@endo/daemon`, `@endo/cli`, and surrounding packages have evolved differently here than on upstream master. The original PR #3036 was opened against `endojs/endo:master`; rebasing onto `llm` will likely produce **more** conflicts than the master-side sibling, since llm carries an extra year of bot-focused work.

Survey llm-side first: does daemon already have an exo-stream module? Has the `reader-ref` / `ref-reader` removal already landed? If so, the mirror's substance may be largely subsumed; report that rather than blindly applying.

## Task

### Phase 1: extract the diff and survey

`gh pr diff 3036 --repo endojs/endo --patch > /tmp/3036-llm.patch`. Then survey llm-side state:

```sh
ls packages/exo-stream/ 2>/dev/null  # does the package already exist?
git -C . log --all --oneline -S "exo-stream" -- packages/ 2>/dev/null | head -20
grep -r "reader-ref\|ref-reader" packages/daemon/src/ 2>/dev/null | head
grep -r "streamIterator\|iterateStream" packages/daemon/src/ packages/cli/src/ 2>/dev/null | head
```

Report what survives in the report's "llm-side baseline" section.

### Phase 2: rebase onto current llm (head `37dce60e`)

Branch from `refs/heads/upstream-llm`. Apply via `git apply --3way /tmp/3036-llm.patch`. Expect heavy conflicts (likely worse than master-side). Same triage shape as the sibling builder e1d015:

- **New `@endo/exo-stream/` package files**: keep verbatim if they don't already exist on llm; flag as already-present (and skip) if they do.
- **`@endo/daemon/src/*.js` wire-ins**: re-do against current llm shape.
- **`@endo/cli/src/commands/*.js` wire-ins**: re-do against current llm shape.
- **Module-organization shifts** (deletion of `reader-ref.js`, etc.): check llm-side first; may already be done.

If `git apply --3way` rejects more than ~40% of hunks, fall back to: do the new-file additions verbatim, then re-do the wire-ins by hand. **Don't get stuck rebasing — partial-mirror is fine if you surface the gaps.**

Preserve kriskowal's authorship on commits; bot identity is the committer. Subject `feat(exo-stream): Introduce Exo streams`. Split into multiple commits if natural (new-package / daemon / cli).

### Phase 3: push + open the PR + report

Push branch `mirror/3036-exo-stream` to `endojs/endo-but-for-bots`. **The bot has direct push permission here** — no fork needed.

Open a draft PR upstream directly:

```
gh pr create --repo endojs/endo-but-for-bots --base llm --head mirror/3036-exo-stream --draft \
  --title "feat(exo-stream): Introduce Exo streams" \
  --body "<see below>"
```

PR body: cite original `endojs/endo#3036`, rebase base `endo-but-for-bots@llm` head `37dce60e`, rationale: *"Rebased mirror of endojs/endo#3036 onto endo-but-for-bots@llm. Original sat ~9 months on endo with extensive review (erights, jcorbin, grypez, gibson042). Note: scope/shape may need adaptation to llm-side patterns — see report for divergences."*

If PR-create succeeds (likely): note the PR number. The gamut's downstream stages (cleaner / judge / fixer / un-draft) will be dispatched by the liaison as a follow-up against this PR number.

## Per-action authorization

- Standing on `endojs/endo-but-for-bots`: push to `mirror/3036-exo-stream`, create draft PR against `llm`.
- READ-ONLY on `endojs/endo` and everywhere else. No comments.

## Out of scope

- Don't touch any file outside the original PR #3036's diff (modulo conflict-resolution against current llm).
- Don't open it un-draft. Don't merge.
- Don't try to address the 30+ comment thread on the upstream PR.
- Don't run the gamut's downstream stages.

## Report

≤ 400 words:
1. **llm-side baseline** survey: does `@endo/exo-stream` already exist? Has daemon/cli already migrated? Any partial overlap with PR #3036's substance?
2. Conflict count from `git apply --3way` and triage outcome (clean / minor / partial-mirror / fallback / mostly-already-done).
3. Branch + head SHA pushed.
4. PR URL (this should succeed — flag if it doesn't).
5. `yarn lint` and `yarn test` results — at minimum for `@endo/exo-stream` (new package) and any package whose source you touched.
6. One-line `Self-improvement: ...`.
