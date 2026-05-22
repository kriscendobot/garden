---
ts: 2026-05-22T01:22:19Z
kind: dispatch
role: liaison
project: endo
to: "*"
refs:
  - entries/2026/05/21/175128Z-result-liaison-a90f09.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 64
    role: source
---

First-time ferry: `endojs/endo-but-for-bots#64` ("feat(eslint-plugin): harden-exports skips M.* pattern makers (#2632)") opens as a **non-draft** PR on `endojs/endo`. Closes upstream issue `endojs/endo#2632`.

User has set "work without stopping for clarifying questions" posture; I made reasonable calls inline.

## Source

- Repo: `endojs/endo-but-for-bots`, PR #64 (OPEN, non-draft, MERGEABLE, CHANGES_REQUESTED-addressed).
- Branch: `design/issue-2632-harden-exports-pattern-makers`
- Head: `e38cc69d73d8bd03063c768420ac344503984ef7`
- 3 commits, all already authored as `Kris Kowal <kriskowal@kriskowal.com>` (no attribution rewrite needed):
  1. `5fce579b feat(eslint-plugin): harden-exports skips M.* pattern makers (#2632)` (the substance — eslint rule update).
  2. `d4836378 feat(eslint-plugin): no-harden-pattern-maker rule (#2632)` (a complementary new rule).
  3. `e38cc69d chore: drop UNNECESSARY-HARDENS.md (moved to PR comment per #64 review)` (review-feedback cleanup).

## Upstream (new PR)

- Repo: `endojs/endo`. Target base: `master` (`bf951df346cfcf605a6709e6a5479f2fdd526113`).
- New branch: boatman picks (sensible default `kriskowal-harden-exports-pattern-makers-2632`).

## Human

`Kris Kowal <kriskowal@kriskowal.com>`. **identity_switch_authorized: true**.

## Dispatch root

`/Users/kris/garden/dispatches/boatman--ferry-pattern-makers-64--20260522-012206--a98757/`. Project worktree on `endojs/endo:origin/master` (detached at `bf951df3`).

## Boatman direction

- **Squash 3 → 1**. The new no-harden-pattern-maker rule (commit 2) is closely related to the harden-exports skip (commit 1) — they're both lint-rule changes addressing the same upstream issue #2632. Squashing presents one coherent PR. The PR title's existing subject covers the substance well; the body should mention both rules.
- Detach at `origin/master` (`bf951df3`).
- Set local `user.name='Kris Kowal'` / `user.email='kriskowal@kriskowal.com'` (the source's authorship already matches; the cherry-pick + commit will produce committer matching this identity automatically).
- `git cherry-pick --no-commit 5fce579b d4836378 e38cc69d` to stage combined diff.
- `git commit -m '<subject>' -m '<body>'`:
  - **Subject**: `feat(eslint-plugin): harden-exports skips M.* pattern makers (#2632)` — source PR title (`(#2632)` is upstream-correct).
  - **Body**: substantive content covering both lint-rule changes:
    - The harden-exports skip for `M.*` pattern makers.
    - The new `no-harden-pattern-maker` rule (warning when someone DOES call `harden()` on a pattern maker).
    - The reference to @erights's comment on #2632 (substantive context for the upstream audience; can stay).
    - `Fixes #2632` as a closing keyword.
  - **Drop**:
    - Test-plan checklists (`[x] yarn test`, etc.).
    - Any `endo-but-for-bots#64` references.
    - The `(per #64 review)` parenthetical in commit 3's subject (subsumed by squash).
    - Any `🤖 Generated with [Claude Code]` or `Co-Authored-By: Claude` trailers.

- **Path-restricted tree-identity check**: `PATHS=$(git diff origin/master..HEAD --name-only)`; `git diff e38cc69d HEAD -- $PATHS` should be empty.
- **Trailer-strip discipline**: `git interpret-trailers --parse`. Always.
- **Verify attribution**: `git log origin/master..HEAD --pretty=fuller` shows one commit, author + committer `Kris Kowal <kriskowal@kriskowal.com>`.
- Push the new branch via `git push origin HEAD:refs/heads/<new-branch>` (fully-qualified first-push form).
- **Open the upstream PR as non-draft** via `gh pr create -R endojs/endo --base master --head <new-branch> --title <new> --body <new>`.

### PR title and body

- **Title**: `feat(eslint-plugin): harden-exports skips M.* pattern makers (#2632)`.
- **Body**: per `pr-formation` using endo PR template section headings. Include `Fixes #2632`. Behavior over diff. The @erights comment quote is substantive reviewer context — keep.

- **Source-side cross-link comment** on `endojs/endo-but-for-bots#64`: post under kriskowal. Name the upstream PR URL, head SHA, the 3→1 squash, and that `Fixes #2632` was added.
- **Identity discipline on `endojs/endo`**: NO direct comments on the new upstream PR.

## Out of scope

- No changes to source-side PR #64.
- No comments posted directly on the new upstream PR.
- No marking the upstream PR draft.

## Expected report

≤300 words:
- Upstream PR number, URL, head SHA, new commit SHA, non-draft confirmed.
- Squash + path-restricted tree-identity check.
- Attribution verified.
- Source-side cross-link URL.
- Title chosen + body confirmation.
- Push-mode (first-push `refs/heads/` form).
- One-line `Self-improvement: ...`.

If blocked, message-to-liaison and stop.
