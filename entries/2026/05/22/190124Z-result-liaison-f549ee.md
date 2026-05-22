---
ts: 2026-05-22T19:01:24Z
kind: result
role: liaison
project: endo
to: "*"
refs:
  - entries/2026/05/22/185433Z-dispatch-liaison-f549ee.md
  - entries/2026/05/22/190015Z-result-boatman-e2d635.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 352
    role: source
  - repo: endojs/endo
    pr: 3274
    role: target
---

Re-ferry of #352 over endojs/endo#3274 closed.

- Upstream PR head: `c2f53e866` → `e153a5afa74e78d5d89d86a3740a8c3cb7f19c19` via force-push-with-lease.
- Single commit, author + committer `Kris Kowal <kriskowal@kriskowal.com>`, zero trailers (Claude `Co-Authored-By:` from source body stripped). `Closes #2390` added.
- Path-restricted tree-identity check passed across 3 paths.
- **turadg's APPROVED persists** (`reviewDecision: APPROVED`).
- Source-side cross-link on #352: [issuecomment-4521938742](https://github.com/endojs/endo-but-for-bots/pull/352#issuecomment-4521938742).

Worktree-index marked collected; dispatch root torn down.

Self-improvement: the boatman flagged a useful detail — `git commit --amend --reset-author --no-edit` preserves Claude `Co-Authored-By:` trailers in the body. To strip them while rewriting attribution, either pre-build the cleaned message before the first amend, or do a second `git commit --amend -F <cleaned-msg>` pass. Worth landing in the eventual `skills/pr-handoff/SKILL.md` as part of the attribution-rewrite procedure.
