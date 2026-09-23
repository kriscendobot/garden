---
ts: 2026-05-20T21:55:39Z
kind: dispatch
role: builder
project: endo
to: builder
---

# Dispatch: builder 8d44fd — mirror endojs/endo#2901 on kriscendobot (rebased to current master), run the gamut

Dispatch root: `dispatches/builder--8d44fd/`. Project worktree on `kriscendobot/endo` with local ref `refs/heads/upstream-master` set to `endojs/endo@master` head `ec3dcbc0`.

Maintainer directive (2026-05-20T21:55Z): *"Please dispatch a builder to create a mirror of [https://github.com/endojs/endo/pull/2901](https://github.com/endojs/endo/pull/2901) and run it through the gamut, based on current master."*

## The source PR (#2901)

- Title: *refactor: Embrace default chaining*
- Author: kriskowal, opened 2024-12 era (still OPEN)
- Head: `kriskowal-embrace-default-chaining` at `b42fac9e70b6f8e7d641c2fa677a0e0dd64fd24b`
- Base: `endojs/endo@master`
- Reviews: erights COMMENTED ×3 (2025-07-17), kriskowal replied (2025-07-18), erights APPROVED 2025-09-26
- Body: *"Follow-up upon #1514 completion. We left several notes to our future selves to embrace default chaining when we could."*

Refactor work — embracing optional chaining (`?.`) and `?? ` defaults across endo where TODOs were left for future selves. No behavior change. Approved but not merged for ~8 months.

## Task

Same shape as builder d7878e for PR #2887, parameterized for #2901:

### Phase 1: extract the diff

`gh pr diff 2901 --repo endojs/endo --patch > /tmp/2901.patch`. Inspect.

### Phase 2: rebase onto current master (head `ec3dcbc0`)

Branch from `refs/heads/upstream-master`. Apply via `git apply --3way /tmp/2901.patch`. Where conflicts exist, the intent is *to use default chaining / nullish coalescing in place of TODO-marked alternatives*. Resolve conservatively against the current shape of the affected files.

Preserve kriskowal's authorship via `--author`. Commit subject `refactor: Embrace default chaining` (or split into per-package commits if the original was structured that way — the patch will tell you).

### Phase 3: open the mirror PR (draft) + report

Push branch `mirror/2901-default-chaining` to `kriscendobot/endo`. Attempt `gh pr create --repo endojs/endo --base master --head kriscendobot:mirror/2901-default-chaining --draft --title "refactor: Embrace default chaining" --body <see below>`.

PR body: cite original #2901, rebase base SHA `ec3dcbc0`, and the rationale: *"Rebased mirror of #2901 to recover the stalled refactor for current master. Approved by erights 2025-09-26 on the original PR."*

PR-create will likely fail (cross-fork block per `journal/entries/2026/05/20/051910Z-result-liaison-90f5ea.md`). Surface the compare URL `https://github.com/endojs/endo/compare/master...kriscendobot:endo:mirror/2901-default-chaining?expand=1` in the report.

This builder's deliverable ends at "branch pushed (+ PR if create succeeds, otherwise compare URL)". The gamut's subsequent stages (cleaner / judge / fixer / un-draft) are the liaison's next dispatch once the upstream PR exists.

## Per-action authorization

- Standing on `kriscendobot/endo`: push to `mirror/2901-default-chaining`. PR-create attempt against `endojs/endo` permitted (will likely fail; surface).
- READ-ONLY everywhere else. No comments.

## Out of scope

- Don't touch any file outside the scope of the original PR #2901's diff.
- Don't add changesets unless the original PR carried them.
- Don't merge or un-draft.
- Don't run the rest of the gamut.

## Report

≤ 350 words:
1. Original-PR scope summary (packages touched, line count).
2. Conflict count from `git apply --3way` and resolution shape.
3. Branch + head SHA pushed.
4. PR URL if create succeeded, otherwise the compare-URL fallback.
5. `yarn lint` (or feasible subset) result.
6. One-line `Self-improvement: ...`.
