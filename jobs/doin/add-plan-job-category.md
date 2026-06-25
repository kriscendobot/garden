# Add a "plan" job-board category for jobs gated on maintainer go-ahead or deferred by priority

Wear the **mentor/gardener** role. Extend the job-board contract with a new **`jobs/plan/`**
category for postings that are **NOT yet ready to be claimed**: either **gated on a maintainer's
go-ahead** or **deferred for selection by priority/urgency**. Infrastructure on `main2` (bot
identity; isolated worktree off `origin/main2`; scratch via `$GARDEN_SCRATCH`). Update the design
(`designs/job-board.md`), the contract (`journal/jobs/README.md`), and the scripts under
`scripts/jobs/`.

## The category

- **`jobs/plan/`** sits alongside `todo/doin/tada` but **gardeners never claim from it** — they
  claim only from `todo/`. A plan job is a proposal/parked item, invisible to the worker pool
  until promoted.
- A plan job carries metadata: a **gate reason** — `go-ahead` (needs maintainer authorization
  before any work) or `deferred` (parked, to be selected by priority/urgency) — plus a
  **priority/urgency** field (and, where applicable, the roadmap item / milestone it serves, so
  selection can use the plan-in-journal roadmap once it lands).

## Why a job goes to plan (producers)

Producers post to `plan/` instead of `todo/` when work should not auto-run: expensive/risky work
needing the maintainer's go-ahead; proposals from a designer/scholar/foreman; or work deferred
behind higher-priority items. A `post-plan.sh <base> [body]` primitive (or `post-job.sh --plan`)
writes `jobs/plan/<base>.md` with the gate reason + priority. Idempotent on basename like
`post-job.sh`.

## How a plan job becomes work (promotion → todo)

A `promote-plan.sh <base>` moves `plan/<base>` → `todo/<base>` (then a gardener claims it
normally). Two promotion paths:
1. **Maintainer go-ahead** — the **liaison** (and the **proxy** within its bounds) promotes a
   `go-ahead`-gated plan job when the maintainer authorizes it ("go ahead on X"). A `go-ahead`
   job is **only** ever promoted by maintainer authorization — never auto-selected.
2. **Priority/urgency selection** — a **`deferred`** plan job may be promoted automatically by the
   **foreman** (the idle-pump) when the board is idle / has capacity: pick the highest
   priority/urgency `deferred` plan job (using the roadmap for priority when available) and
   promote it. This is how deferred work gets selected without flooding the active board.

## Integrate

- **Gardeners/reaper**: claim/reap only `todo/doin` — `plan/` is never claimed or reaped (parked
  jobs don't go stale). Document this.
- **Foreman**: extend its idle-pump to prefer promoting the top `deferred` plan job over
  generating a new one, when one exists.
- **Bulletin**: add a section surfacing **plan** jobs awaiting go-ahead (so the maintainer sees
  what needs authorization) and the deferred queue (top by priority), with the gate reason.
- **Liaison/proxy vocabulary**: "go ahead on X" / "promote X" → `promote-plan.sh`; "defer X" /
  "park X" → `post-plan.sh … --deferred`. Note these in the liaison role.

## Tests & verification

- `post-plan.sh` writes to `plan/` and gardeners do NOT claim it; `promote-plan.sh` moves
  plan→todo and then it IS claimable; a `go-ahead` job is never auto-promoted by the foreman while
  a `deferred` one can be; the reaper ignores `plan/`. `shellcheck`/`bash -n` clean.

## Definition of done

The `plan/` category added to the board contract + design, `post-plan.sh`/`promote-plan.sh`
primitives, gardeners/reaper scoped to todo/doin, foreman promotion of deferred plan jobs by
priority, bulletin surfacing of the plan queue, and the liaison/proxy vocabulary — committed/pushed
to `origin/main2`, tests added. Report the SHA, the metadata schema, and the promotion paths. If
blocked, report diagnosis + ready-to-apply change.

Posted by the liaison on behalf of the maintainer.

---
claim:
  host: endolinbot
  gardener: 67
  claimed_at: 2026-06-25T18:50:46Z
