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

An optional leading `requires:` header is a comma-separated host-capability token
set (`requires: aws`). It is claim eligibility in addition to model/provider fit:
workers without every capability skip the job, then the winning worker re-probes
the same predicate after claim before running. It is capability, never authority;
authorization fields such as `identity_switch_authorized: true` remain independent.
See [`designs/host-requirements-gating.md`](../../designs/host-requirements-gating.md).

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
never completes (the docker build burns a gardener slot per cycle, then dooms).

**A build role gets a larger budget automatically (2026-08-01).** `role: builder`
and `role: web-builder` default to `GARDEN_BUILD_HANDLER_TIMEOUT` (**7200 s / 2 h**)
instead of the 2400 s fleet default, resolved by `job_handler_budget_base`
(`common.sh`) — which **both** `gardener.sh` and `reaper.sh` call, so the runner's
wall and the staleness guard cannot drift apart. Every other role is unchanged.

This exists because the header was previously the *only* remedy and the producer had
to remember it. When they forgot, the failure was expensive: the handler is
SIGTERM-killed at 2400 s on **every** requeue, makes no progress, and the reaper
dooms it as a deterministic overrun after one cycle. That is exactly how
`ebfb-pr882-bootstrap-generators` died (rc=124 at elapsed=2401 s, parked to `plan/`
with two maintainer notices); its re-post then carried `handler-timeout: 7200`. The
7200 s figure is where the fleet had already converged by hand — of the jobs then on
the board carrying an explicit header, 16 said 7200, 11 said 10800, 1 said 14000.

**The producer still stamps anything unusual.** A `handler-timeout: <seconds>` line
in the **job body** at post time (`post-job.sh <base> <body-with-header>`) still
wins, in either direction, over whatever the role defaults to. Reach for it when a
job runs a container/image build, a full-from-scratch compile, or another step known
to exceed the role default — a cold `docker build` still wants `10800`. A non-build
role doing build-shaped work (a `fixer` that must run the full test suite, a staged
gauntlet doing a clean build) gets **no** automatic boost and still needs the header.

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
the reaper dooms it after **one** such cycle (`GARDEN_REAP_OVERRUN_THRESHOLD=1`),
parking it held with a maintainer notice rather than churning ~5× the budget. A
long job that makes progress each cycle (a per-job worktree HEAD advances — the
sanctioned resume treadmill) is exempt and never dooms on that basis.

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
<the work body — becomes the todo job on promotion, minus cycle markers>
```

- **Park** (`post-plan.sh [--go-ahead|--deferred] [--priority L] [--roadmap I]
  [--by R] <base> [body]`): write `jobs/plan/<base>.md`. Default gate `--deferred`.
  Idempotent on the basename (no-op if `<base>` is anywhere in plan/todo/doin/tada),
  retry-with-backoff like `post-job.sh`. It **clears the reaper/gardener cycle
  markers** from the body it parks — the same family the promote path clears (below)
  — because a producer that RE-PARKS a body it read off the board would otherwise
  smuggle a stale `garden-deadline-overrun` counter into `plan/`, where it re-dooms
  the job on its first evaluation after promotion. What it cleared is recorded in a
  `cleared:` frontmatter field, emitted **only** when something actually was, so an
  ordinary post's frontmatter is unchanged. The strip is idempotent and drops only
  whole cycle-marker lines (a body's own `---` rules and other HTML comments survive).
- **Annotate** (`annotate-plan.sh [--note TEXT] [--key K] [--priority L]
  [--roadmap I] [--role R] [--by R] [--if-parked] <base> [body-file]`): append a
  note to a job **already parked** in `plan/`, and/or retune its selection
  metadata. `post-plan.sh` is **idempotent-only** (a re-post of the same basename
  is a deliberate no-op, so a re-running producer can never fork a parked item),
  so this is the sanctioned way to say "that parked job just learned
  something new" (a follow-up review comment, a narrowed scope, a priority bump)
  instead of hand-rolling a sync -> edit -> commit -> push CAS loop against the
  shared producer clone. Same retry-with-backoff as the other own-basename
  writes. Properties worth knowing:
  - **Dedup by key.** Each annotation lands under a
    `<!-- garden-annotation: key=... by=... at=... -->` marker; a key already present
    in the file is a **no-op success**, so a requeued producer never
    double-appends. The default key is a content hash of the note + metadata
    change (identical re-annotation collapses for free); pass `--key` for a
    stable external identity (a comment id) or to append the same text again
    deliberately.
  - **Field updates are in place.** `priority`/`roadmap`/`role` are rewritten
    within the leading frontmatter (inserted if absent); every other key passes
    through untouched, including the execution pins `model:` /
    `handler-timeout:` / `requires:`.
  - **The note is sanitized.** The appended text goes through the same
    cycle-marker strip as a park and a promotion, so a producer piping a live job
    body as a note ("here is what the last cycle reported") cannot re-introduce a
    stale `garden-deadline-overrun` counter into `plan/` behind both of those
    strips. What it cleared is recorded as a `cleared=` token on the annotation
    marker, emitted **only** when something actually was; a note that is
    *entirely* cycle markers has nothing left to say and is refused (exit 1).
  - **Gate fields are NOT settable here.** `gate:`, `blocked_on:`, and
    `orchestrated_by:` carry the promotion invariants (who may promote this job,
    and when); re-gating is a different act with its own primitives
    (`promote-plan.sh`, `block-job.sh`, `post-orchestration.sh`).
  - **Plan-only, and loud about it.** A `<base>` that has left `plan/` exits
    **3** ("no longer parked") rather than silently writing into a claimed job;
    `--if-parked` downgrades that to a quiet exit 0 for a producer that races the
    foreman. Coverage: `scripts/jobs/test/annotate-plan-test.sh`.
  - **The comment-watcher is its first automated caller.** A watcher-derived base
    is not comment-unique (the mechanical verbs key on `(PR,verb)`, a review on its
    review id), so a follow-up comment can land on a base that is currently parked.
    Both producer primitives no-op there by basename, which used to lose the
    comment entirely — the primary path even misread the deliberate no-op as a lost
    push and froze the cursor below that comment forever. `comment-watcher.sh` now
    annotates instead, on both the primary and the retrospective (second-loop)
    paths, `--key`ed on the **directive identity**
    (`<repo>#<pr>:comment:<id>`, or `…:review:<id>[:retro]`) so a re-poll of the
    same comment is a deduped no-op success while a genuinely new comment appends
    once. The note carries only deterministic metadata (verb, surface, author, URL,
    identity) and never an excerpt of the untrusted body. `mention-watcher.sh` has
    the same branch on the same identities (the two watchers already share the
    identity scheme so a doubly-observed comment collapses onto one job). Coverage:
    the `PK`/`PKR` cases in `scripts/jobs/test/comment-watcher-test.sh` and `PK` in
    `scripts/jobs/test/mention-watcher-test.sh`.
- **Promote** (`promote-plan.sh <base>`): move `plan/<base>` → `todo/<base>`,
  stripping the plan frontmatter so the todo job is the clean work body; then a
  gardener claims it normally. It also **clears the reaper/gardener cycle markers**
  (`garden-reaped`, `garden-deadline-overrun`, and the per-cycle `garden-reap-now` /
  `garden-productive-cycle` / `garden-outage-cycle` hints) and records the cleared
  set in the `garden-promoted-from-plan` provenance comment, so a job the reaper
  DOOM-PARKED gets a genuinely fresh run instead of being re-doomed on its first
  cycle off the stale counter. No manual "clear it before promoting" step is needed.
  (This is the **promotion** half; `post-plan.sh` above is the **parking** half. Both
  call the same `strip_cycle_markers` / `cycle_marker_summary` helpers in
  `scripts/jobs/common.sh`, so the family has one spelling. Coverage:
  `scripts/jobs/test/promote-plan-doom-reset-test.sh`.)
  Touches only its own basename, so it retries with backoff like a completion. Two
  promotion paths:
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
