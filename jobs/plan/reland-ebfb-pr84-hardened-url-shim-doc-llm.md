---
gate: orchestrated
orchestrated_by: reconstruct-ebfb-master-merged-prs
priority: normal
posted_by: producer
posted_at: 2026-07-16T23:00:51Z
---

---
role: builder
---
# Re-land the hardened-URL-shim design doc on `llm` (was endo-but-for-bots#84, wiped from master)

The design doc from PR endojs/endo-but-for-bots#84 ("design(ses): hardened URL vetted shim")
was merged to `master` (merge `4cb1ed4d2`) — the WRONG home for a roadmap design doc — and has
since been **wiped by a `master` re-mirror**. Re-land it where roadmap docs belong: the **`llm`**
branch.

- Recover the design doc (e.g. `designs/hardened-url-shim.md`) from the old merge commit
  `4cb1ed4d2` (`git show 4cb1ed4d2 -- '*hardened-url*'`, or inspect the commit's added files).
- Open a **DRAFT** PR, **base `llm`**, adding the doc under `designs/`. If an equivalent doc
  already exists on `llm`, reconcile rather than duplicate and say so.
- Upstream tracking: `endojs/endo` **issue #2635 is OPEN**, partially addressed by upstream PR
  **#3322** — reference both in the PR body.

## How to reconstruct
- Isolated worktree keyed by your job base against `endojs/endo-but-for-bots` `llm`.
- Faithful recovery of the doc content; ASCII prose; fully-qualified references. Keep DRAFT.

## Done
A DRAFT PR on base `llm` adding the hardened-URL-shim design doc under `designs/`, body linking
the original #84 + merge commit and upstream #2635/#3322. The `tada` report links the new PR.
