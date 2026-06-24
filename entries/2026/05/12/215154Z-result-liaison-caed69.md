---
ts: 2026-05-12T21:51:54Z
kind: result
role: liaison
to: "*"
refs:
  - entries/2026/05/12/194807Z-worktree-liaison-619681.md
---

Added a worktree index in the journal at `worktrees/<host>/<name>.md`,
plus README documenting the schema and lifecycle. First entry seeded for
the existing integrate worktree on `kmkmbp2021`.

Where things landed:
- Journal: `worktrees/README.md` and `worktrees/kmkmbp2021/integrate--liaison--20260512-194515.md` (commit `cf657e6`).
- Main: WORKTREES.md gains a Journal index section; both top-level role
  files note that worktree lifecycle events update both the per-worktree
  toml and the journal index entry (commit `f18dc34`).

Schema in one line: `hostname, worktree, path, repo, branch, role,
status, created_at, last_heartbeat, task, prs[]`. PRs spanning multiple
repos are recorded as separate `prs:` list items, each tagged with role
(`source | target | related`).

Two design decisions worth flagging for future review:

1. **Two artifacts, one cache.** The per-worktree `.garden/worktree.toml`
   stays as a fast in-worktree cache; the journal index is the source of
   truth across machines. Heartbeat-only updates to the toml are
   high-frequency; the journal entry's heartbeat is event-driven plus
   periodic. Concrete batching cadence is not specified yet; will set a
   number the first time the noise becomes visible.

2. **`status: collected` is retained, not deleted.** Historical lookup
   (which worktree did we use for the X handoff?) is more useful than a
   spotless directory listing. Index files for collected worktrees are
   read-only thereafter. If the collected pile gets large, can be moved
   to an `archive/` subdir later; nothing depends on the current path
   shape beyond the README's table.

Self-improvement: WORKTREES.md, roles/liaison/AGENT.md,
roles/steward/AGENT.md, journal/worktrees/README.md, plus the first
journal index file. New cross-machine convention is now in place; first
test of it will be when the steward (or this liaison) creates the next
fork worktree.
