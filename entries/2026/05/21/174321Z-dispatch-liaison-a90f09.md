---
ts: 2026-05-21T17:43:21Z
kind: dispatch
role: liaison
project: endo
to: "*"
refs:
  - entries/2026/05/21/121936Z-result-liaison-e93248.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 336
    role: source
---

First-time ferry: `endojs/endo-but-for-bots#336` ("fix(ses): cyclic star export with renaming reexport (issue #59)") opens as a **draft** PR on `endojs/endo`. Bug fix for upstream issue `endojs/endo#59` (OPEN since 2019, no existing upstream PR for this fix).

Source is itself a draft with CHANGES_REQUESTED addressed via subsequent commits; opening upstream as draft mirrors the source posture (the user can mark ready when satisfied with the upstream rendering).

## Source

- Repo: `endojs/endo-but-for-bots`, PR #336 (OPEN, **DRAFT**, MERGEABLE, CHANGES_REQUESTED-addressed).
- Branch: `fix/issue-59-star-export-cycle`
- Head: `f89a2361e99d6c684035444322a1cda1bb4d2ab1`
- 3 commits, all `endolinbot <main.barn5084@fastmail.com>` (need attribution rewrite to `Kris Kowal <kriskowal@kriskowal.com>`):
  1. `f6c2f281 fix(ses): resolve cyclic star-export reexport rename (#59)` (2026-05-20T22:04Z) — the substance: `wireUpExportNotifier` deferred-forwarding-notifier fix in `packages/ses/src/module-instance.js`.
  2. `2df948c1 test(compartment-mapper): port issue #59 regression to compartment-mapper with Node.js parity (#336)` (2026-05-21T12:11Z) — compartment-mapper test port. The `(#336)` suffix is bot-internal source-PR-number; strip on the squashed commit's subject.
  3. `f89a2361 test(compartment-mapper): rename cycle-rename fixture modules; restore SES gauntlet test` (2026-05-21T17:38Z) — recent rename/restore follow-up.

The `(#59)` in commit 1's subject is the upstream issue reference — upstream-correct, keep in the squashed commit's subject.

## Upstream (new PR)

- Repo: `endojs/endo`. Target base: `master` (`bf951df346cfcf605a6709e6a5479f2fdd526113`).
- New branch: boatman picks (sensible default `kriskowal-star-export-cycle-rename`).

## Human

`Kris Kowal <kriskowal@kriskowal.com>` (current default). **identity_switch_authorized: true**.

## Dispatch root

`/Users/kris/garden/dispatches/boatman--ferry-star-export-cycle-336--20260521-174309--a90f09/`. Project worktree on `endojs/endo:origin/master` (detached at `bf951df3`).

## Boatman direction

- **Squash 3 → 1**. The 3 commits are: substance (fix) + tests (compartment-mapper) + tests (rename/restore). Upstream reviewers see the final shape as one logical fix + tests.
- Detach at `origin/master` (`bf951df3`).
- Set local `user.name='Kris Kowal'` / `user.email='kriskowal@kriskowal.com'`.
- `git cherry-pick --no-commit f6c2f281 2df948c1 f89a2361` to stage the combined diff.
- `git commit -m '<subject>' -m '<body>'`:
  - **Subject**: `fix(ses): cyclic star export with renaming reexport (issue #59)` — verbatim from the source PR title. The `(issue #59)` is the upstream issue reference, upstream-correct.
  - **Body**: substantive content covering:
    - The defect (cycle + renaming reexport → `TypeError: notify is not a function` at `packages/ses/src/module-instance.js:364`; note that the original 2019 issue described it as a `SyntaxError` but the failure mode has evolved).
    - The fix (`wireUpExportNotifier` installs a deferred forwarding notifier when a re-export's upstream notifier is not yet present).
    - The regression tests (`packages/ses/test/import-gauntlet.test.js` adds `cyclic star export with renaming reexport (issue #59)`; compartment-mapper test port).
    - `Fixes #59` as a closing keyword.
  - **Drop**:
    - `Refs: endojs/endo#59` line (substituted by `Fixes #59`).
    - Any `endojs/endo-but-for-bots#336` references.
    - The `(#336)` suffix from commit 2's subject (subsumed by the squash).
    - The "Verification" section's bot-internal "builder dispatch 8e2aba" framing.
    - Any `🤖 Generated with [Claude Code]` or `Co-Authored-By: Claude` trailers.

- **Path-restricted tree-identity check**: `PATHS=$(git diff origin/master..HEAD --name-only)`; `git diff f89a2361 HEAD -- $PATHS` should be empty. Per the standing lesson from the parallel-batch ferries.
- **Trailer-strip discipline**: `git interpret-trailers --parse`. Always.
- **Verify attribution**: `git log origin/master..HEAD --pretty=fuller` shows one commit, `Kris Kowal <kriskowal@kriskowal.com>`.
- Push the new branch via `git push origin HEAD:refs/heads/<new-branch>` (fully-qualified `refs/heads/` for first-push).
- **Open as DRAFT** via `gh pr create --draft -R endojs/endo --base master --head <new-branch> --title <new> --body <new>`.

### PR title and body

- **Title**: `fix(ses): cyclic star export with renaming reexport (issue #59)` (source's title; already upstream-native).
- **Body**: per `pr-formation` with endo PR template section headings (Description / Security / Scaling / Documentation / Testing / Compatibility / Upgrade). Behavior over diff. Include `Fixes #59` (upstream issue). No checklists.

- **Source-side cross-link comment** on `endojs/endo-but-for-bots#336`: post under kriskowal. Name the upstream PR URL, head SHA, the 3→1 squash, the draft state.
- **Identity discipline on `endojs/endo`**: NO direct comments on the new upstream PR.

## Out of scope

- No changes to source-side PR #336.
- No comments posted directly on the new upstream PR.
- No marking the upstream PR ready-for-review (the user can do that when satisfied).

## Expected report

≤300 words:
- Upstream PR number, URL, head SHA, new commit SHA, **draft state confirmed**.
- Squash + path-restricted tree-identity check.
- Attribution verified (`kriskowal@kriskowal.com`).
- Source-side cross-link URL.
- Title chosen + body-per-`pr-formation` confirmation.
- Push-mode (first-push `refs/heads/` form).
- One-line `Self-improvement: ...`.

If blocked, `message`-to-liaison and stop.
