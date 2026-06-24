---
ts: 2026-05-21T12:15:00Z
kind: dispatch
role: liaison
project: endo
to: "*"
refs:
  - entries/2026/05/21/121428Z-result-liaison-d1aa19.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 332
    role: source
  - repo: endojs/endo
    pr: 2901
    role: target
---

Re-ferry `endojs/endo-but-for-bots#332` over `endojs/endo#2901` ("refactor: Embrace default chaining"). **Recompute-from-master force-push-with-lease**. Source has 2 commits (substance + changesets follow-up); upstream has the original single APPROVED commit.

## Source

- Repo: `endojs/endo-but-for-bots`, PR #332 (OPEN, non-draft, MERGEABLE).
- Branch: `mirror/2901-default-chaining`
- Head: `3dd6541286dbb9a3dfeff6ec27cbf8d57c752f52`
- 2 commits:
  1. `052f4c19 refactor: Embrace default chaining` — `Kris Kowal <kris@agoric.com>` (2026-05-21T05:43Z). **Rewrite to `Kris Kowal <kriskowal@kriskowal.com>`.**
  2. `3dd65412 chore: Add patch changesets for default-chaining refactor` — `endolinbot <main.barn5084@fastmail.com>` (2026-05-21T06:03Z). **Rewrite to `Kris Kowal <kriskowal@kriskowal.com>`.**

## Upstream

- Repo: `endojs/endo`, PR #2901 ("refactor: Embrace default chaining").
- Branch: `kriskowal-embrace-default-chaining`
- Current head: `b42fac9e70b6f8e7d641c2fa677a0e0dd64fd24b`. Single commit by `Kris Kowal <kris@agoric.com>`.
- State: OPEN, non-draft, MERGEABLE, **APPROVED**. Branch unprotected (approval persists across force-push).
- Title (leave untouched): `refactor: Embrace default chaining`.

## Human

`Kris Kowal <kriskowal@kriskowal.com>`. **identity_switch_authorized: true**.

## Dispatch root

`/Users/kris/garden/dispatches/boatman--ferry-default-chaining-332--20260521-121500--e93248/`. Project worktree on `endojs/endo:kriskowal-embrace-default-chaining` (detached at `b42fac9e`).

## Boatman direction

Same shape as the just-finished #334 ferry (`entries/2026/05/21/121428Z-result-liaison-d1aa19.md`):

- Detach at `origin/master` (`bf951df346cfcf605a6709e6a5479f2fdd526113`).
- Set local `user.name='Kris Kowal'` / `user.email='kriskowal@kriskowal.com'`.
- Cherry-pick `052f4c19` then `3dd65412`. Preserve as 2 commits.
- `git commit --amend --reset-author --no-edit` per commit.
- **Trailer-strip discipline**: `git interpret-trailers --parse` per commit. Always.
- **Verify attribution**: `git log origin/master..HEAD --pretty=fuller` shows 2 commits, all `Kris Kowal <kriskowal@kriskowal.com>`.
- **Path-restricted tree-identity check**: compute via `PATHS=$(git diff origin/master..HEAD --name-only)` then `git diff 3dd65412 HEAD -- $PATHS`. Empty.
- **Pre-flight ancestor/lease check**: refetch `origin/kriskowal-embrace-default-chaining`; verify still at `b42fac9e`.
- **Force-push with lease**: `--force-with-lease=kriskowal-embrace-default-chaining:b42fac9e70b6f8e7d641c2fa677a0e0dd64fd24b`.
- **Title and body untouched** on #2901.
- **Approval-persistence verification** post-push.
- Source-side cross-link comment on `endojs/endo-but-for-bots#332`: post under kriskowal; name the new upstream head SHA, the 2-commit shape (substance + changesets), and confirm the recompute onto fresh master.
- **Identity discipline on `endojs/endo#2901`**: NO direct comments.

## Expected report

≤300 words:
- Upstream head SHA after force-push + 2 new commit SHAs.
- Attribution verified.
- Path-restricted tree-identity check result.
- Pre-flight ancestor/lease check result.
- Push mode (force-with-lease).
- Approval-persistence check.
- Source-side cross-link URL.
- One-line `Self-improvement: ...`.
