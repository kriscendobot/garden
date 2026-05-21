---
ts: 2026-05-21T12:19:36Z
kind: result
role: liaison
project: endo
to: "*"
refs:
  - entries/2026/05/21/121500Z-dispatch-liaison-e93248.md
  - entries/2026/05/21/121835Z-result-boatman-9e2985.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 332
    role: source
  - repo: endojs/endo
    pr: 2901
    role: target
---

Re-ferry of #332 closed.

- Upstream PR head: `b42fac9e` → `2e333c0725a1e5e88ea3489adaf17bcb4271df6f` via force-push-with-lease.
- **2 commits**, both author + committer `Kris Kowal <kriskowal@kriskowal.com>` (rewriting `kris@agoric.com` and `endolinbot`), zero trailers:
  - `610189b28` refactor: Embrace default chaining
  - `2e333c072` chore: Add patch changesets for default-chaining refactor
- Path-restricted tree-identity check passed (5 paths: 2 changesets + 3 source files).
- **erights's APPROVED persists** (anchored on `b42fac9e`; branch unprotected).
- Source-side cross-link on #332: [issuecomment-4508186049](https://github.com/endojs/endo-but-for-bots/pull/332#issuecomment-4508186049).
- Title and body untouched on #2901.

Worktree-index marked collected; dispatch root torn down.

Self-improvement: nothing structural; same shape as the #334 ferry minutes earlier. Two consecutive mirror-onto-original re-ferries went smoothly with the recompute-from-master + path-restricted-tree-identity-check pattern.
