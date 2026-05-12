---
ts: 2026-05-12T21:59:15Z
kind: result
role: liaison
to: "*"
refs:
  - entries/2026/05/12/215154Z-result-liaison-caed69.md
---

Simplified worktree state to a single artifact: the journal index entry
at `worktrees/<host>/<name>.md` is now the sole source of truth. The
per-worktree `.garden/worktree.toml` cache is gone.

Drove from user direction: "I would not be troubled to have the local
journal worktree serve as the sole source of truth for worktree state.
We can freely edit locally and merge when necessary."

What changed:
- WORKTREES.md: Metadata-file section deleted; "Worktree state lives in
  the journal" replaces it. Lifecycle and Reservation sections refer to
  the journal index entry rather than to per-worktree metadata.
- roles/COMMON.md: Worktree summary now points at the journal index
  path with a one-line construction (`hostname -s` plus
  `basename "$(pwd)"`).
- roles/liaison/AGENT.md, roles/steward/AGENT.md: Worktree-manager and
  worktree-write authority lines name the journal entry as the single
  artifact.
- roles/monitor/AGENT.md: 'Quiet on no change' rule loosened. Heartbeats
  fire only often enough to stay under the reaper's idle threshold
  (default 1 hour). A steady stream of 304s does not need a heartbeat
  per minute. Same liveness signal, much less commit noise.
- journal/worktrees/README.md: removed the "two artifacts, one cache"
  framing.
- The legacy `.garden/worktree.toml` at the integrate worktree was
  removed (untracked file outside main's working tree, so a plain `rm`
  with no git operation needed).

Main: `edae9c2`. Journal: `f89c5e8`.

Procedural observation: the dual-write design was a v1 mistake the user
caught fast. The right move was to favor a single artifact and let the
journal-sync skill's existing merge handling deal with concurrency. The
prior design over-engineered for write-volume noise that had not yet
materialized. Worth remembering for the next "should this be one source
or two?" decision: pick one until measured noise forces a split.

Self-improvement: WORKTREES.md, roles/COMMON.md, roles/liaison/AGENT.md,
roles/monitor/AGENT.md, roles/steward/AGENT.md, journal/worktrees/README.md;
removes a v1 dual-write design in favor of a single source of truth per
the user's preference for simpler concurrency.
