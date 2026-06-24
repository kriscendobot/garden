---
ts: 2026-05-21T12:18:35Z
kind: result
role: boatman
repo: endojs/endo
project: endo
refs:
  - entries/2026/05/21/121500Z-dispatch-liaison-e93248.md
---

Re-ferried `endojs/endo-but-for-bots#332` over `endojs/endo#2901` ("refactor: Embrace default chaining"). Same shape as the just-finished #334 ferry: substance + changesets, recompute-from-master, force-push-with-lease.

- Upstream PR: https://github.com/endojs/endo/pull/2901
- New upstream head SHA: `2e333c0725a1e5e88ea3489adaf17bcb4271df6f`
- Previous upstream head: `b42fac9e70b6f8e7d641c2fa677a0e0dd64fd24b` (single commit, `kris@agoric.com`).
- Recomputed onto fresh master: `bf951df346cfcf605a6709e6a5479f2fdd526113`.
- 2 commits, both attributed to `Kris Kowal <kriskowal@kriskowal.com>`:
  - `610189b281bb3a6d310b81484f095e3164c5c411` refactor: Embrace default chaining
  - `2e333c0725a1e5e88ea3489adaf17bcb4271df6f` chore: Add patch changesets for default-chaining refactor
- Attribution verified: `git log origin/master..HEAD --pretty=fuller` shows both commits with author and committer set to `Kris Kowal <kriskowal@kriskowal.com>`. `git interpret-trailers --parse` empty on both.
- Path-restricted tree-identity: `git diff 3dd65412 HEAD -- $(git diff origin/master..HEAD --name-only)` empty. Five files: 2 changesets, `packages/captp/src/finalize.js`, `packages/compartment-mapper/src/bundle-lite.js`, `packages/compartment-mapper/src/bundle.js`.
- Pre-flight ancestor/lease check: `origin/kriskowal-embrace-default-chaining` still at `b42fac9e70b6f8e7d641c2fa677a0e0dd64fd24b` immediately before push.
- Push mode: `--force-with-lease=kriskowal-embrace-default-chaining:b42fac9e70b6f8e7d641c2fa677a0e0dd64fd24b`. Accepted.
- Approval-persistence check: `gh pr view 2901 -R endojs/endo --json reviewDecision,reviews` reports `reviewDecision: APPROVED`; erights' `LGTM` review on `b42fac9e` retained (branch unprotected).
- Source-side cross-link: https://github.com/endojs/endo-but-for-bots/pull/332#issuecomment-4508186049
- Identity discipline on `endojs/endo#2901`: no direct comments posted.
- Title/body on #2901: untouched.

Self-improvement: nothing this time.
