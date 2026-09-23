---
ts: 2026-05-20T21:55:39Z
kind: dispatch
role: builder
project: endo
to: builder
---

# Dispatch: builder d7878e — mirror endojs/endo#2887 on kriscendobot, run the gamut

Dispatch root: `dispatches/builder--d7878e/`. Project worktree on `kriscendobot/endo` with local ref `refs/heads/upstream-master` set to `endojs/endo@master` head `ec3dcbc0`.

Maintainer directive (2026-05-20T21:50Z): *"Please dispatch a builder to create a mirror of [https://github.com/endojs/endo/pull/2887](https://github.com/endojs/endo/pull/2887) and run the gamut."*

## The source PR (#2887)

- Title: *fix(compartment-mapper): Correct moduleSpecifier/moduleLocation naming mistakes*
- Author: kriskowal, opened 2024-12 era (still OPEN, sat since approval 2025-07-15)
- Head: `kriskowal-naming-module-location-specifier` at `09874b70932001981ba938f6fdd996c33cf57f48`
- Base: `endojs/endo@master`
- Reviews: boneskull APPROVED 2025-07-15
- Body: *"These should be obvious in hindsight. These changes have no operation impact, just improvements in communicating the distinction between a specifier and a location (URL string)."*

The PR is rename-discipline / clarity work in `@endo/compartment-mapper`. No behavior change. Approved-but-not-merged for ~10 months — likely lapped by other compartment-mapper churn (the package shipped @1.2.x → @2.1.0 since).

## Task

Three commits / phases:

### Phase 1: extract the PR's diff

`gh pr diff 2887 --repo endojs/endo --patch > /tmp/2887.patch`. Inspect the patch to understand the scope: which files, which renames, how many lines.

### Phase 2: rebase onto current master

Branch from `refs/heads/upstream-master`. Apply the patch via `git apply --3way /tmp/2887.patch` (preferred — preserves authorship intent and shows conflicts). If conflicts exist (likely, given 10 months of drift), resolve by re-applying the *intent* of the original change against the current shape of `@endo/compartment-mapper`. The original PR is a rename — the renames should still be applicable, but the surrounding code may have moved. Resolve conflicts conservatively.

If `git apply --3way` is hopeless (more than a third of hunks reject), fall back to: read the patch as a guide, re-do the renames by hand against current master. The intent is *what kriskowal would have done if rebasing this himself today*.

Preserve kriskowal's authorship by using `--author "Kris Kowal <kris@cendos.com>"` on the rebased commit(s); the bot identity remains the committer. Commit subject should match the original PR's subject (`fix(compartment-mapper): Correct moduleSpecifier/moduleLocation naming mistakes`).

### Phase 3: open the mirror PR (draft) + run the gamut

Push branch `mirror/2887-naming-module-location-specifier` to `kriscendobot/endo`. Attempt `gh pr create --repo endojs/endo --base master --head kriscendobot:mirror/2887-naming-module-location-specifier --draft --title "<original subject>" --body <see below>`.

PR body cites the original #2887, the current head SHA of master your rebase was against (`ec3dcbc0`), and the rationale: *"Rebased mirror of #2887 to recover the stalled rename work for current master."*

**Likely PR-create failure**: kriscendobot cross-fork PR-create on endojs/endo has been blocked (see `journal/entries/2026/05/20/051910Z-result-liaison-90f5ea.md` for the canonical reference). If it fails: don't retry — surface the compare URL `https://github.com/endojs/endo/compare/master...kriscendobot:endo:mirror/2887-naming-module-location-specifier?expand=1` in the report. The liaison will request a maintainer ferry to land the upstream PR. The gamut continues from the *upstream* PR's number, which only the maintainer can provide.

This builder's deliverable ends at "branch pushed (+ PR if create succeeds, otherwise compare URL)" — the gamut's subsequent stages (cleaner / judge / fixer / un-draft) need the upstream PR number and are queued for the liaison to dispatch as separate steps once the maintainer ferries.

## Per-action authorization

- Standing on `kriscendobot/endo`: push to `mirror/2887-naming-module-location-specifier`. PR-create attempt against `endojs/endo` permitted (will likely fail; surface).
- READ-ONLY everywhere else. No comments. No identity switch — bot identity is the committer.

## Out of scope

- Don't touch any file outside the scope of the original PR #2887's diff.
- Don't add changesets if the rebase doesn't require new behavior (rename-only).
- Don't merge or un-draft.
- Don't run the rest of the gamut (cleaner/judge/fixer/un-draft) — that's the liaison's next dispatch.

## Report

≤ 350 words:
1. Original-PR scope summary (file count, line count, kind of change).
2. Conflict count from `git apply --3way` and resolution shape (clean / minor / restated-from-intent).
3. Branch + head SHA pushed to `kriscendobot/endo`.
4. PR URL if create succeeded, otherwise the compare-URL fallback.
5. `yarn lint` (or whatever subset is feasible — at minimum `yarn workspace @endo/compartment-mapper lint`) result.
6. One-line `Self-improvement: ...`.
