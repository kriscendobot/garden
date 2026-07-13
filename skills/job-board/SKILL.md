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

- **Post** (`post-job.sh [--identity <key>] <base> [body]`): write
  `jobs/todo/<base>.md`, push; idempotent on the basename; retry-with-backoff on
  contention. **Directive-identity dedup:** basename idempotency only collapses
  re-posts of the *same* base — it does NOT catch two producers naming *different*
  jobs for the *one* directive (the PR #58 comment-watcher-vs-peer collision that
  clobbered a working tree). Pass `--identity <owner>/<repo>#<pr>:comment:<cid>`
  (or `…:review:<review_id>`, or set `GARDEN_JOB_IDENTITY`) when posting a
  PR/comment-directive job: it is deduped against a `jobs/index/<hash>` map so ONE
  directive maps to at most one OPEN job, whatever each producer named it. The
  watchers pass it automatically; when omitted it is best-effort derived from a
  single canonical GitHub comment URL in the body.
- **Claim** (`claim-job.sh <id>`): fetch+reset to tip, `git mv todo→doin`
  (`<base>.md`), stamp claim metadata, create `work/<base>` + `inbox/<base>/`,
  commit, **push — the accepted push is the claim**. On rejection, re-sync; if the
  job already moved, **back off to another candidate (never blind-retry a claim)**.
- **Bid auction (opt-in)**: a job carrying `market: bid` frontmatter is claimed
  through the decentralized bid auction ([`bid-auction`](../bid-auction/SKILL.md))
  instead of the race — a bounded bid window, then a deterministic Thompson-draw
  award every worker computes identically from the committed journal, resolved by
  the SAME todo→doin push CAS. Everything else (including every `priority: urgent`
  job) stays on the untouched race. The auction adds `bid_window` latency and one
  push per bidder; it degrades to the race for 0/1 bidders and after its staged
  liveness window. See `scripts/jobs/auction.sh` + `reputation.sh`.
- **Complete** (`complete-job.sh <id> <base> <report>`): remove
  `doin/<base>.md`/`work/<base>`/`inbox/<base>`, write `tada/<base>.md`, sweep
  `jobs/bids/<base>/`, record the `reputation/` event, push.
  Touches only your own basename, so **retry with backoff until it lands**.
- **Reap** (`reaper.sh`): requeue `doin/` claims older than `GARDEN_CLAIM_TTL`.

## Per-job handler budget — build-heavy jobs (`handler-timeout:`)

A gardener kills its handler at the default wall-clock budget
`GARDEN_HANDLER_TIMEOUT` (2400 s = **40 min**). A job that legitimately runs longer —
the paradigm case is a **cold `docker build`**, which can take a few hours — must
declare its own budget or it is SIGTERM-killed at 40 min on **every** requeue and
never completes (the docker build burns a gardener slot per cycle, then poisons).

**The producer stamps the budget.** Put a `handler-timeout: <seconds>` line in the
**job body** at post time (`post-job.sh <base> <body-with-header>`). The gardener
reads it and runs the handler at that budget in place of the 40-min default; the
reaper reads the same header so it never requeues the still-live long handler. There
is no auto-classifier — **whoever posts a build-heavy job is responsible for the
header** (the liaison for a `build`, an orchestration for a build child, a re-post of
a poisoned docker job). Rule of thumb: any job that runs a container/image build, a
full-from-scratch compile, or another step known to exceed ~40 min needs it.

```
handler-timeout: 10800      # 3h — a cold docker image build
<the rest of the job body: repo, PR/comment URL, task>
```

**Cap.** The header is honored up to `budget_max = GARDEN_CLAIM_TTL −
GARDEN_HANDLER_KILL_AFTER − 1` (≈ **14339 s / 3.98 h** at the defaults); a larger
request is clamped to that max and the maintainer is alerted, because a handler that
needs longer than one claim can hold cannot be claim-scoped (it must run detached or
be split into claim-sized stages). To raise the ceiling, raise `GARDEN_CLAIM_TTL`
(and keep `gardener.sh` and `reaper.sh` in sync) so the single-owner invariant
`budget + GARDEN_HANDLER_KILL_AFTER < GARDEN_CLAIM_TTL` still holds.

**Deterministic overrun surfaces fast.** A job that hits its wall with **no
progress** is a deterministic overrun (it will overrun identically on every requeue);
the reaper poisons it after **one** such cycle (`GARDEN_REAP_OVERRUN_THRESHOLD=1`),
parking it held with a maintainer notice rather than churning ~5× the budget. A
long job that makes progress each cycle (a per-job worktree HEAD advances — the
sanctioned resume treadmill) is exempt and never poisons on that basis.

## Plan category — parked work, not claimable until promoted

`jobs/plan/` sits **alongside** `todo/doin/tada` but **outside** the claim
lifecycle: gardeners claim only from `todo/`, and the reaper scans only `doin/`,
so a plan job is invisible to the worker pool and never goes stale. A plan job is
a **proposal / parked item**, parked for one of these reasons (its **gate**):

- **`go-ahead`** — needs the maintainer's **authorization** before any work runs.
- **`deferred`** — parked behind higher-priority items, to be **selected by
  priority/urgency**.
- **`blocked`** — parked behind an **artifact** (a PR or another job) named in
  `blocked_on:`; promoted only by the **unblock watcher** when the blocker
  completes.
- **`orchestrated`** — a **child sub-job of an orchestration** (`orchestrated_by:`
  names the owning orchestration); promoted only by the deterministic
  **orchestrate.sh** watcher per its `serial`/`parallel` order. Invisible to both
  the foreman and the unblock watcher. See the
  [orchestration](../orchestration/SKILL.md) skill.

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

`post-job.sh` and `post-plan.sh` (and every other producer) serialize on a
per-clone `journal.lock` next to the shared producer clone, so producers should
post **sequentially**, not fan out concurrent posts against one clone. The lock
is stale-aware (it self-recovers from a crashed/hung holder after a bounded wait;
see `common.sh` § per-clone serialization), but concurrent fan-out still
needlessly contends — drive batch posts one at a time.
