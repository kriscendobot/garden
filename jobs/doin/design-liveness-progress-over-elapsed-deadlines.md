---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# designer: replace elapsed-deadline reaping with liveness + progress, and budget-aware deferral

Maintainer directive (kriskowal, 2026-08-12), verbatim:

> We may need to look at this problem as one of detecting liveliness and progress
> rather than simply elapsed deadlines. We might want to have a threshold after
> which we do not sweep the [job], but rather assess whether we have run over the
> job's notional token budget and instead park a go-ahead plan to be triggered
> when the token budget refreshes.

Produce a DESIGN (`designs/…md`), not an implementation. The migration path and
its staging are part of the deliverable.

## The problem, with its precipitating evidence

Today a claim is killed on **elapsed wall-clock** alone: `applied_handler_budget`
(`scripts/jobs/common.sh`) fixes a per-role budget, `gardener.sh` runs the handler
under `timeout`, and `reaper.sh` counts overruns and dooms the job at
`GARDEN_REAP_OVERRUN_THRESHOLD`. Nothing in that path asks whether the job was
*doing anything*.

`endojs/endo-but-for-bots` PR #903 is the worked example — the same review
directive, three instances, two killed:

- `…-review-1ec51e37` (review 4871446371) — doomed 2026-08-06, `deadline-overrun`.
- `…-review-6ea43da5` (review 4911019892) — doomed 2026-08-11, `deadline-overrun`.
- `…-review-024fa540` (review 4913075771) — overran 2400s at the wall (rc=124,
  elapsed 2404s) and then COMPLETED on a later cycle, resolving all 5 items,
  replying to 4 inline comments, and pushing `a1a18e3f7..78f65eae7`.

The load-bearing sentence is in that completion report:

> A prior run of this job had done extensive, high-quality work in the persisted
> project worktree but never committed or pushed it (the job had been requeued).

That is the failure mode in one line. The job was **live and progressing** when the
deadline killed it. The work survived only because the project worktree happens to
persist; it was invisible to the reaper, uncommitted, unpushed, and a later cycle
had to spend a second full engagement re-verifying it before it could finish. Two
sibling instances got no such rescue and are parked doomed.

A wall-clock budget cannot tell these apart:
- a wedged handler blocked on a dead socket, burning nothing;
- a handler in a tight retry loop, burning tokens, achieving nothing;
- a handler doing exactly the work it was asked to do, on a job that is simply big.

All three look identical at 2400s. Only the third is common on the expensive roles,
and it is the one the current design punishes hardest.

## What to design

**1. Liveness and progress as first-class signals.** Define what the fleet can
observe cheaply and deterministically (no LLM in the detector — this must run in
the same plain-code spine as the reaper). Candidates to evaluate, not a menu to
implement wholesale: handler heartbeat/lifetime signals; token/engagement spend
deltas from the per-job usage record (`usage/<base>.jsonl`, already machine-stamped
into every tada Cost block); commits or file mutations in the per-job project
worktree; tool-call or turn counters; PR/API side effects. For each: what it costs
to sample, what it proves, and how it is spoofed or goes silently stale. A progress
signal that a wedged job can keep emitting is worse than none.

**2. The threshold and what replaces the sweep.** Past the threshold the reaper
should stop treating "still running" as "broken". Design what happens instead:
assess spend against the job's **notional token budget**, and on an over-budget
job, park a **`--go-ahead` plan** to be triggered when the budget refreshes, rather
than dooming it. Specify: where the notional budget per job/role comes from; what
"refreshes" means concretely and what deterministic trigger promotes the parked
plan when it does; and how this composes with the existing token-bucket work rather
than duplicating it — `083cfb95ff` (bound serial campaigns by token budget),
`67e6b0d882` + `eebadff6f3` (campaign dispatch budget, capacity calibration and the
token bucket), and `876d09d902` (claimed-job deadline nudges) are all already in
the deployed tree. Read them first; this design extends that family.

**3. Preserving the invariant the wall-clock budget actually protects.** The
budget is not only a liveness heuristic — `job_handler_budget_base`'s comment is
explicit that gardener and reaper must compute the SAME budget or the reaper
requeues a base onto a second gardener while the first still runs, giving duplicate
concurrent execution on one worktree. Any progress-based scheme must keep an
unambiguous, conservatively-safe answer to "may this claim be requeued now?".
Say plainly how it does. This is the constraint most likely to sink a naive design.

**4. Losing less work at the boundary.** The #903 rescue was luck. Consider whether
a job approaching its limit should be asked to checkpoint (commit/push WIP, write
what it has established) before the wall, so a requeue inherits a legible state
rather than an archaeological dig. The deadline-nudge machinery (`876d09d902`) is
the obvious carrier.

**5. Migration.** How this rolls out without a flag day: what ships first, what
stays wall-clock-bounded as a backstop, what the failure mode is if the progress
signal itself breaks (it must fail toward the current conservative behaviour, never
toward "never reap"), and how an operator diagnoses it.

## Definition of done

- A design doc covering all five sections, linked from `designs/README.md`.
- An explicit account of what it does NOT solve, and any place it makes the fleet
  more permissive than today, with the argument for why that is acceptable.
- The #903 case walked end to end under the proposed design, showing which signal
  would have kept each of the three instances alive — or correctly killed it.
- Pushed to `main2`. Do NOT implement; if the design implies staged jobs, name them
  so the liaison can post them.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-12T16:46:55Z
