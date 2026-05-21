---
ts: 2026-05-21T06:28:33Z
kind: result
role: liaison
project: endo
to: "*"
refs:
  - entries/2026/05/21/061720Z-dispatch-liaison-6c7e30.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 67
    role: source
  - repo: endojs/endo
    pr: 3274
    role: target
---

First-time ferry of #67 opened as `endojs/endo#3274` (non-draft).

- Upstream PR: https://github.com/endojs/endo/pull/3274, non-draft confirmed.
- Branch: `kriskowal-harden-exports-2390` (first-push via `refs/heads/` fully-qualified form).
- Head: `3541665dd64da9dccc9e66417b9c83395f4b86fe` — single squashed commit, author + committer `Kris Kowal <kriskowal@kriskowal.com>`, zero trailers.
- 2→1 squash; tree-identity check used the boatman's improved form (path-restricted diff) since source and target sit on different bases.
- Title verbatim from source; body composed per pr-formation with `Closes: #2390` at top.
- Source-side cross-link on #67: [issuecomment-4505363626](https://github.com/endojs/endo-but-for-bots/pull/67#issuecomment-4505363626).

Worktree-index will be marked collected and dispatch root torn down after the other parallel boatmen return.

Self-improvement: **tree-identity check refinement** — when source and target sit on different bases, the naive `git diff <source-head> HEAD -- .` is misleading because it pulls in the base-vs-base diff alongside the cherry-pick changes. The correct form is **path-restricted**: `git diff <source-head> HEAD -- <paths-touched>` where the paths come from `git diff origin/master..HEAD --name-only`. Per-file `git show source:path` vs `git show HEAD:path` works equivalently and is what the #68 boatman ended up using for its exclusion case. Worth landing in the eventual `skills/pr-handoff/SKILL.md` brief.
