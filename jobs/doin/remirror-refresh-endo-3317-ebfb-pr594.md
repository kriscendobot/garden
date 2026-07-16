---
role: weaver
---
# Remirror upstream endojs/endo#3317 into fork PR #594 and refresh onto a fresh frozen base

Upstream **endojs/endo#3317** — "chore(lint): lint per package to avoid the typescript-eslint
project-service ceiling" (OPEN, base `master`, head `chore/lint-eslint-per-package-batches`) — is
mirrored on the fork as **endojs/endo-but-for-bots#594** (same head branch, same title). #594
currently targets the **moving `master`**, which is exactly the base-drift the frozen-base
convention prevents. Remirror it from the latest upstream and refresh it onto a frozen anchor.

## Task
1. **Remirror.** Fetch the current head of upstream `endojs/endo#3317`
   (`chore/lint-eslint-per-package-batches`) and bring fork #594's head branch up to that latest
   upstream content, so the mirror reflects the *current* upstream PR, not a stale snapshot.
   Verify the upstream head/state before pinning (`skills/verify-upstream-state-before-pinning/SKILL.md`).
2. **Refresh onto a fresh frozen base** (`skills/frozen-base-branch/SKILL.md`). Snapshot the CURRENT
   upstream `master` as `master-<7-char-sha>`, push it to the fork, rebase the remirrored head onto
   it, and **move #594's base field to that frozen anchor**. Do NOT target the moving `master`
   (and do not push to / recreate the mutable `master` — anchor branch only).
3. Keep #594 otherwise intact (title, draft state, description); push the refreshed head. Record any
   rebase-conflict resolution.

## Skills
`skills/frozen-base-branch/SKILL.md`, `skills/verify-upstream-state-before-pinning/SKILL.md`,
`skills/rebase-before-followup/SKILL.md`.

## Done
Fork #594's head reflects the latest upstream `endojs/endo#3317`, rebased onto a fresh frozen
`master-<sha>` anchor, with #594's base field pointing at that anchor (not moving `master`). The
`tada` report links #3317 and #594, names the new frozen-base sha, and notes any conflicts resolved.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 8
  worker_kind: cleric
  claimed_at: 2026-07-16T23:13:29Z
