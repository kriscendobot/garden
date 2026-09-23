---
title: Single most structurally interesting move
section-slug: garden--WORKTREES-md--second-garden-design-and-three-named-worktree-kinds-and-the-named-dash-dash-separator-discipline-and-detached-HEAD-as-discipline-and-named-standing-exceptions
source-slug: garden--WORKTREES-md
url: https://github.com/kriskowal/garden/blob/main/WORKTREES.md
authors: [Endo project (collective; the garden's authorship convention names roles not individuals)]
status: (no explicit metadata table, but YAML frontmatter declares created/updated/author = liaison)
ingest-cycle: 297
ingest-date: 2026-06-11
lane: designs
scope: full
total-lines: 168
parent: garden--WORKTREES-md--second-garden-design-and-three-named-worktree-kinds-and-the-named-dash-dash-separator-discipline-and-detached-HEAD-as-discipline-and-named-standing-exceptions
---

**§the-detached-HEAD-discipline-for-per-dispatch-checkouts** combined with **§the-named-no-branch-ownership-contention-between-orchestrator-and-subagent** — the per-dispatch worktree triple uses **detached HEAD** for all three sub-worktrees. The orchestrator owns the named branches (main + journal); the subagent operates in detached-HEAD mode and pushes back via `git push origin HEAD:<branch>`.

This generalizes a deep pattern about *concurrent git use*: **branches IS a singleton resource per checkout**, and two checkouts that both have the same branch checked out *fight over which one IS authoritative*. Detached-HEAD removes the branch-ownership question entirely: the subagent's checkout has no branch, just a commit. **§the-named-detached-HEAD-eliminates-the-branch-singleton-contention**.

The discipline generalizes far beyond the garden: any orchestrator that wants to launch many concurrent workers against the same git repo can use detached-HEAD-per-worker to avoid coordination overhead. The workers push via `git push origin HEAD:<branch>` which lets the remote's branch-update path serialize the writes naturally (with retries on rejection).

§the-named-pattern-eliminates-coordination-by-removing-the-contended-resource. The same pattern shows up in distributed-system design as **"contention reduction through removal of the singleton"** (queue-based work distribution avoids singleton-lock + CRDT-based replication avoids singleton-leader + content-addressed storage avoids singleton-name).
