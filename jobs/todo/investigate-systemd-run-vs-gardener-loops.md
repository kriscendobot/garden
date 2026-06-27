<!-- garden-promoted-from-plan: gate=deferred priority=normal at=2026-06-27T10:21:47Z -->

# PLAN: investigate systemd-run vs. the fixed 100-gardener-loop pool → garden design PR

**Advisor input (Josh Corbin):** `systemd-run` (transient units spawned on demand) might be
more useful than the garden's current count of ~100 always-running gardener loops. Investigate
and **report back with a garden design PR** proposing whether/how to adopt it. Wear the
**researcher** then **designer** role. This is deferred — investigate and propose; do NOT
re-architect the fleet without maintainer approval of the design.

## The current model (engage with its rationale)

A host runs a fixed pool of ~100 `garden-gardener@1..100` long-running loop services
(`scripts/jobs/gardener.sh`), reconciled to the journal `hosts/<host>` count by the
gardener-scaler. Per `CLAUDE.md` / `designs/job-board.md`, **the count is sized for CONCURRENCY,
not CPU**: most gardeners are cheaply **idle-blocked** waiting for a job to claim or for a
maintainer/peer message (a job can block a long time on a reply). 100 is the concurrency cap, not
100 active workers.

## Investigate

- **What `systemd-run` offers**: transient `--user` scopes/services spawned on demand, their
  lifecycle, resource accounting (cgroups), `--wait`/collection, and limits (how many transient
  units, startup cost per unit).
- **Candidate models** to compare against today's fixed pool, e.g.:
  - **Transient-per-job**: spawn a `systemd-run` gardener per claimed job; it exits on completion
    (clean isolation + failure capture per job; observability via per-unit status). How does
    claiming work — a thin dispatcher claims, then `systemd-run`s the worker?
  - **Dynamic pool**: spawn transient gardeners up to a concurrency cap as work arrives, instead
    of 100 always-resident loops.
  - **Hybrid**: keep a small resident pool for the idle-blocked-on-messages case, burst via
    `systemd-run` under load.
- **Key tensions to resolve**: the **idle-blocked-waiting-for-a-message** pattern (a long-blocked
  job — does a transient unit hold a cgroup slot for hours, vs a cheap blocked bash loop?);
  resource use (100 idle bash loops vs N transient units); startup latency per job; observability
  & failure isolation (per-unit status/logs vs one loop); how the **scaler**, **reaper**,
  **killswitch**, and **claim CAS** translate; and whether it simplifies or complicates the
  message-bus blocking model.
- Prototype-measure where cheap (e.g. cost of N idle loops vs N transient units; `systemd-run`
  startup cost) and cite real numbers, not assumptions.

## Deliverable: a garden design PR

Write a design doc (e.g. `designs/fleet-model-systemd-run.md`) weighing the options against the
current model with the concurrency-not-CPU rationale, a recommendation (adopt transient-per-job /
dynamic pool / hybrid / keep current), the migration implications (scaler, reaper, killswitch,
observability), and open questions. Open it as a **DRAFT PR against `kriskowal/garden`** (base
`main2`, bot identity) for maintainer review — the same flow as garden#4. Credit Josh Corbin's
suggestion. Do not change the live fleet model; the PR is the proposal.

## Definition of done

A researched comparison of `systemd-run`-based fleet models vs. the fixed 100-loop pool (grounded
in how systemd-run works + measured costs), with a recommendation and migration analysis, opened
as a draft garden design PR for maintainer review. Report the PR number and the recommendation.
