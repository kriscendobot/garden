---
ts: 2026-05-21T06:17:20Z
kind: dispatch
role: liaison
project: endo
to: "*"
refs:
  - entries/2026/05/20/231831Z-result-liaison-f97683.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 67
    role: source
---

First-time ferry: `endojs/endo-but-for-bots#67` ("fix(eslint-plugin): harden-exports handles destructuring patterns (#2390)") opens as a **non-draft** PR on `endojs/endo`. Bug fix for upstream issue `endojs/endo#2390`.

## Side observation

Upstream master is now at `bf951df346cfcf605a6709e6a5479f2fdd526113`, which is `feat(syrup-frame): add @endo/syrup-frame package and opt-in syrup framing for OCapN TCP-for-testing (#3256)` — **the syrup-frame PR (#3256) merged**! The eight-ferry sequence of #109 paid off.

## Source

- Repo: `endojs/endo-but-for-bots`, PR #67.
- Branch: `design/issue-2390-harden-exports-patterns`
- Head: `7ddcfa486ee9c65348098f3bc0d62fcdbba7e55c`
- Base: `master` at `c513f1ab` (an older master tip; the boatman recomputes onto current).
- State: OPEN, non-draft, MERGEABLE, no reviews yet. CI: 26 SUCCESS / 0 FAILURE.
- Two commits, both already authored as `Kris Kowal <kriskowal@kriskowal.com>` — **no attribution rewrite needed**:
  1. `9f30cbd4 fix(eslint-plugin): harden-exports handles destructuring patterns (#2390)` (2026-04-29).
  2. `7ddcfa48 fix(eslint-plugin): address review on harden-exports destructuring (#2390)` (2026-05-01).

The `(#2390)` suffix refers to `endojs/endo#2390` (an upstream issue) — upstream-correct, **keep it** in the squashed commit's subject.

## Upstream (new PR)

- Repo: `endojs/endo`. Target base: `master` (`bf951df3`).
- New branch: boatman picks (sensible default `kriskowal-harden-exports-2390`).

## Human

`Kris Kowal <kriskowal@kriskowal.com>` (current default; also already on the source commits). **identity_switch_authorized: true**.

## Dispatch root

`/Users/kris/garden/dispatches/boatman--ferry-harden-exports-67--20260521-061739--6c7e30/`. Project worktree on `endojs/endo:origin/master` (detached at `bf951df3`).

## Boatman direction

- **Squash 2 → 1**. Commit 2 ("address review") addresses source-side review feedback that no upstream reviewer has seen; upstream reviewers should see the final shape as a single commit. Apply the squash sub-procedure from `entries/2026/05/18/235615Z-result-liaison-a71656.md` (or the cleaner `git cherry-pick --no-commit` + single `git commit` pattern from `entries/2026/05/20/231831Z-result-liaison-f97683.md`).
- Detach at `origin/master` (`bf951df3`).
- `git cherry-pick --no-commit 9f30cbd4 7ddcfa48` to stage the combined diff.
- Set local `user.name='Kris Kowal'` / `user.email='kriskowal@kriskowal.com'` (already matches the source commits' attribution).
- `git commit -m '<subject>' -m '<body>'` with the composed message.
- **Subject**: `fix(eslint-plugin): harden-exports handles destructuring patterns (#2390)` — verbatim from commit 1; the `(#2390)` is the upstream issue reference, upstream-correct.
- **Body**: take the substantive content from the source PR body (the description of mishandled `export const` destructuring shapes, the `pushDeclaredNames` recursive helper, the binding-shape table, the test fixtures). **Drop**:
  - Test-plan checklists (`[x] yarn test`, `[x] yarn lint`, etc.).
  - Any `endo-but-for-bots#67` references if present.
  - The "address review" framing from commit 2's subject (the squash subsumes it).
  - Any `🤖 Generated with [Claude Code]` or `Co-Authored-By:` trailers anywhere in either commit's body.
- **Tree-identity check**: `git diff 7ddcfa48 HEAD -- .` should be empty after the squash. Verify before pushing.
- **Trailer-strip discipline**: `git interpret-trailers --parse`. Always.
- **Verify attribution**: `git log origin/master..HEAD --pretty=fuller` shows one commit, author + committer `Kris Kowal <kriskowal@kriskowal.com>`.
- Push to a fresh upstream branch via `git push origin HEAD:refs/heads/<new-branch>` (use the fully-qualified `refs/heads/` form for first-push per the #329 lesson surfaced in `entries/2026/05/20/231721Z-result-boatman-9aae6f.md`).
- **Open the upstream PR as non-draft** via `gh pr create -R endojs/endo --base master --head <new-branch> --title <new> --body <new>`.

### PR title and body

- **Title**: `fix(eslint-plugin): harden-exports handles destructuring patterns (#2390)` — verbatim from source.
- **Body**: compose per `pr-formation` using endo's PR template section headings (Description / Security / Scaling / Documentation / Testing / Compatibility / Upgrade). Behavior over diff. No checklists. No file-by-file callouts (except for the test fixture file path, which is load-bearing for reviewer reproduction).
  - Include the substantive bug-shape table (Identifier / shorthand / alias / rest / nested / array / etc.) — useful reviewer context.
  - Include the regression-test note (the contributor-checklist verification by temporarily removing the `RestElement` branch). It's substantive and signals reviewer-confidence in the test coverage.
  - Mention `Fixes #2390` (the upstream issue) as a closing keyword in the body — useful for upstream issue tracking.

- **Source-side cross-link comment** on `endojs/endo-but-for-bots#67`: post under kriskowal. Name the upstream PR URL, head SHA, and confirm the 2→1 squash.
- **Identity discipline on `endojs/endo`**: NO direct comments on the new upstream PR.

## Out of scope

- No changes to source-side PR #67.
- No comments posted directly on the new upstream PR.
- No marking the upstream PR draft.

## Expected report

≤300 words:
- Upstream PR number, URL, head SHA, new commit SHA, non-draft confirmed.
- Squash + tree-identity verification.
- Attribution verified (already-kriskowal@kriskowal.com; no rewrite needed since source authors match).
- Source-side cross-link URL.
- Title chosen + body-per-`pr-formation` confirmation.
- Push-mode note (`refs/heads/` first-push form).
- One-line `Self-improvement: ...`.

If blocked, `message`-to-liaison and stop.
