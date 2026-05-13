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

The journal index entry is the *single* authoritative state file for a worktree. There is no per-worktree TOML cache; agents read and write the journal entry directly via `skills/journal-sync/SKILL.md`. Concurrent edits from different machines merge cleanly because each worktree has its own file.

Lifecycle:

- **Create.** When a fork worktree is added (per `WORKTREES.md` § Adding a fork worktree), the dispatcher writes a new `worktrees/<host>/<name>.md` here and pushes it.
- **Heartbeat.** The occupying agent bumps `last_heartbeat` and (if changed) `status` on each tick that produces a journal-worthy event. Pure-heartbeat ticks that bring nothing else may be skipped; the cross-machine reaper interprets a missing heartbeat against the configured idle threshold (default 1 hour) as collectable, so heartbeats need only fire often enough to stay under that threshold.
- **PR binding.** When the work in a worktree first opens or attaches to a PR (in any repo), append the `prs:` entry. PRs across multiple repos for one worktree are recorded as separate `prs:` list items.
- **Collect.** When a worktree becomes collectable per `WORKTREES.md`, set `status: collected` (do not delete the file). The journal index keeps the historical record so future cycles can answer "which worktree did we use for the X handoff" without scanning git history. Collected entries are read-only thereafter.

## Current entries

(Hand-maintained as files are added or removed. When this list passes ~20 entries, prefer per-host subindex files over a single inline list.)

| Host | Worktree | Repo | Branch | Role | Status |
|------|----------|------|--------|------|--------|
| kmkmbp2021 | [integrate--liaison--20260512-194515](./kmkmbp2021/integrate--liaison--20260512-194515.md) | endojs/endo-but-for-bots | garden | liaison | idle |
| endolinbot | [watch-endo--monitor--20260512-233305](./endolinbot/watch-endo--monitor--20260512-233305.md) | endojs/endo | master | monitor | collected |
| endolinbot | [watch-endo-but-for-bots--monitor--20260512-233307](./endolinbot/watch-endo-but-for-bots--monitor--20260512-233307.md) | endojs/endo-but-for-bots | llm | monitor | active |
| endolinbot | [watch-agoric-sdk--monitor--20260512-233309](./endolinbot/watch-agoric-sdk--monitor--20260512-233309.md) | agoric/agoric-sdk | master | monitor | collected |
| endolinbot | [watch-cosgov--monitor--20260512-233310](./endolinbot/watch-cosgov--monitor--20260512-233310.md) | dcfoundation/cosmos-proposal-builder | main | monitor | collected |
| endolinbot | [watch-garden--monitor--20260513-045844](./endolinbot/watch-garden--monitor--20260513-045844.md) | kriskowal/garden | main | monitor | collected |
