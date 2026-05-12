# Worktree index

A cross-machine index of every garden-managed worktree. One file per worktree at:

```
worktrees/<hostname>/<worktree-name>.md
```

`<hostname>` is the short hostname (`hostname -s` on the host where the worktree lives). `<worktree-name>` matches the directory name under that host's `garden/worktrees/<owner>-<repo>/` (the same `<purpose>--<role>--<timestamp>` form documented in `WORKTREES.md`). The journal worktree itself and the garden's `main` checkout are not indexed here; only fork worktrees added via the fork-worktree procedure.

## Frontmatter schema

```yaml
---
hostname: kmkmbp2021                 # host the worktree lives on
worktree: <name>                     # matches the directory basename
path: /absolute/path/on/that/host    # for `cd` and disambiguation
repo: <owner>/<repo>                 # upstream repo
branch: <branch>                     # branch checked out
role: <role>                         # primary occupying role
status: active                       # active | idle | reserved | collectable | collected
created_at: <ISO>
last_heartbeat: <ISO>                # bumped each tick by the occupying agent
task: "<one-line description>"
prs:                                 # optional, list any PRs the work spans
  - repo: <owner>/<repo>             # may be the same as the worktree's repo or different
    pr: <number>
    role: source                     # source | target | related
    title: "<optional snapshot>"
---

<optional prose body: progress notes, blockers, follow-ups, links>
```

## Maintenance

The journal index is the authoritative cross-machine record. Each worktree also has a per-worktree `.garden/worktree.toml` for fast in-worktree reads (the occupying agent updates its own heartbeat there); the toml is a cache and the journal entry is the source of truth.

Lifecycle:

- **Create.** When a fork worktree is added (per `WORKTREES.md` § Adding a fork worktree), the dispatcher writes both the per-worktree toml *and* a new `worktrees/<host>/<name>.md` here, then commits and pushes the journal entry per `skills/journal-sync/SKILL.md`.
- **Heartbeat.** The occupying agent bumps `last_heartbeat` and `status` in both files on each tick. The journal write goes through journal-sync; multiple heartbeat-only updates in a row that bring no other change can be batched (one push per N ticks) to avoid noise, but the per-worktree toml update is always immediate.
- **PR binding.** When the work in a worktree first opens or attaches to a PR (in any repo), append the `prs:` entry. PRs across multiple repos for one worktree are recorded as separate `prs:` list entries.
- **Collect.** When a worktree becomes collectable per `WORKTREES.md`, set `status: collected` (do not delete the file). The journal index keeps the historical record; the per-worktree toml goes away with the worktree.

A `status: collected` entry is intentionally retained: future cycles often need to find "what worktree did we use for the X handoff" without scanning git history. Collected entries are read-only thereafter.

## Current entries

(Hand-maintained as files are added or removed. When this list passes ~20 entries, prefer per-host subindex files over a single inline list.)

| Host | Worktree | Repo | Branch | Role | Status |
|------|----------|------|--------|------|--------|
| kmkmbp2021 | [integrate--liaison--20260512-194515](./kmkmbp2021/integrate--liaison--20260512-194515.md) | endojs/endo-but-for-bots | garden | liaison | idle |
