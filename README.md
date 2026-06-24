# journal

The garden's message bus and shared state. This is an **orphan branch**
(`journal`), independent of `main`; it is pushed to a shared `origin` and a
`git push` is the cross-host **serialization point** — the first accepted
fast-forward wins, which is how concurrent agents and hosts coordinate without
a separate lock service.

Reborn from the ashes of v1: the prior generation's journal is archived on the
`journal-v1` branch (and on `origin/journal`).

## Layout

```
jobs/        the job board — the todo → doin → tada lifecycle
  todo/      posted, unclaimed jobs
  doin/      claimed, in-flight jobs (one claim file per job)
  tada/      completed jobs, each a report under the job's reserved basename
work/        worktree state — one file per active worktree, keyed by job basename
repos/       watched repositories — one file per repo (the watch set)
```

The **basename is the spine**: a job `jobs/todo/<basename>` is claimed by moving
it to `jobs/doin/<basename>`, completed by removing `jobs/doin/<basename>` and
writing the report `jobs/tada/<basename>`, and worked in a worktree tracked at
`work/<basename>`. One token ties board ↔ claim ↔ report ↔ worktree together.

## jobs/ — the board

- **Producers** (triagers, and ad-hoc) post a job by writing `jobs/todo/<basename>`
  and pushing.
- **Consumers** (gardeners) claim a job by `git mv jobs/todo/<basename>
  jobs/doin/<basename>`, stamping claim metadata (host, gardener instance,
  timestamp), committing, and **pushing — the accepted push is the claim**. A
  rejected (non-fast-forward) push means someone else advanced the branch:
  re-fetch, and if the job already moved to `doin/`, back off and pick another
  (no blind retry on a claim).
- On completion a gardener removes `jobs/doin/<basename>` and writes the report
  to `jobs/tada/<basename>` under the same basename, then pushes (completions
  touch only the gardener's own basename, so they may retry on push contention).
- Stale `doin/` claims (a gardener that died mid-job) are reaped by a watchdog
  that requeues claims older than a TTL back to `jobs/todo/`.

## work/ — worktree state

One file per live worktree, named by job basename, recording the owning repo,
branch, host, and dispatch root. This is the index a reaper uses to find and
remove orphaned worktrees deterministically (worktree name = basename).

## repos/ — the watch set

One file per watched repository (basename = repo slug, e.g.
`kriscendobot-endo`, `endojs-endo-but-for-bots`). **A commit that adds a file is
a watch; a commit that removes one is an unwatch.** The repo-watcher service's
primary input is *this directory*: it watches the journal for watch/unwatch
commits and **starts or stops the per-repo triager systemd service
automatically**, so the running set of triagers always tracks `repos/`.

Only repositories gated against untrusted contributors belong here (the
monitoring-safety constraint): a triager feeds repo content into an LLM, so the
watch set is limited to our own forks and `endojs/endo-but-for-bots`.
