# Skill: job-board

The journal-backed job board: how producers post, how concurrent consumers
claim safely, and how jobs complete. Full architecture in
[`designs/job-board.md`](../../designs/job-board.md).

## Purpose

Coordinate many gardeners across many hosts on one shared queue without a lock
service, using the `git push` to `origin/journal2` as a compare-and-swap.

## Inputs / state

The journal branch `journal2` (directory `journal/`): `jobs/{todo,doin,tada}/`,
`work/<base>`, and per-job `inbox/<base>/`. Per-instance journal clones live
under `GARDEN_STATE` (never a shared worktree). Scripts under `scripts/jobs/`.

## Procedure

Board files are markdown and carry `.md`; the **basename `<base>` is the
extensionless spine**. Scripts append `.md` for board files and strip it for the
`work/`/`inbox/` keys.

- **Post** (`post-job.sh <base> [body]`): write `jobs/todo/<base>.md`, push;
  idempotent on the basename; retry-with-backoff on contention.
- **Claim** (`claim-job.sh <id>`): fetch+reset to tip, `git mv todo→doin`
  (`<base>.md`), stamp claim metadata, create `work/<base>` + `inbox/<base>/`,
  commit, **push — the accepted push is the claim**. On rejection, re-sync; if the
  job already moved, **back off to another candidate (never blind-retry a claim)**.
- **Complete** (`complete-job.sh <id> <base> <report>`): remove
  `doin/<base>.md`/`work/<base>`/`inbox/<base>`, write `tada/<base>.md`, push.
  Touches only your own basename, so **retry with backoff until it lands**.
- **Reap** (`reaper.sh`): requeue `doin/` claims older than `GARDEN_CLAIM_TTL`.

## Plan category — parked work, not claimable until promoted

`jobs/plan/` sits **alongside** `todo/doin/tada` but **outside** the claim
lifecycle: gardeners claim only from `todo/`, and the reaper scans only `doin/`,
so a plan job is invisible to the worker pool and never goes stale. A plan job is
a **proposal / parked item**, parked for one of two reasons (its **gate**):

- **`go-ahead`** — needs the maintainer's **authorization** before any work runs.
- **`deferred`** — parked behind higher-priority items, to be **selected by
  priority/urgency**.

Metadata is leading YAML frontmatter:

```
---
gate: go-ahead | deferred
priority: urgent | high | normal | low      # selection key (urgency: accepted as a synonym)
roadmap: <milestone/item>                    # optional; what it serves, for roadmap-aware selection
posted_by: <role>
posted_at: <iso8601>
---
<the work body — becomes the todo job verbatim on promotion>
```

- **Park** (`post-plan.sh [--go-ahead|--deferred] [--priority L] [--roadmap I]
  [--by R] <base> [body]`): write `jobs/plan/<base>.md`. Default gate `--deferred`.
  Idempotent on the basename (no-op if `<base>` is anywhere in plan/todo/doin/tada),
  retry-with-backoff like `post-job.sh`.
- **Promote** (`promote-plan.sh <base>`): move `plan/<base>` → `todo/<base>`,
  stripping the plan frontmatter so the todo job is the clean work body; then a
  gardener claims it normally. Touches only its own basename, so it retries with
  backoff like a completion. Two promotion paths:
  1. **maintainer go-ahead** — the **liaison** (or the **proxy** within its
     bounds) promotes a `go-ahead` job when the maintainer authorizes it. A
     `go-ahead` job is **only ever** promoted this way — never auto-selected.
  2. **priority/urgency selection** — the **foreman** auto-promotes the top
     `deferred` plan job (highest priority, FIFO within a priority) when the board
     is idle, preferring it over generating a brand-new step.

## Output

A completed job leaves exactly one `tada/<base>.md` report; `doin`, `work`, and the
inbox for that basename are gone.

## Notes

Claims back off; completions/posts retry — because a retried claim could steal a
job, but a completion/post only ever fast-forwards its own files. Randomized
`backoff` breaks lockstep livelock (a fixed no-backoff retry stranded a job under
8-way contention; see the design doc's test section).
