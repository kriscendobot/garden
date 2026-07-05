<!-- garden-promoted-from-plan: gate=deferred priority=low at=2026-07-05T22:49:44Z -->

# design/build: timezone-anchored scheduler cadence (fix daily-progress-summary firing at the wrong time)

**Repo:** garden-infra on `main2` (isolated worktree off `origin/main2`).

## Gap (observed 2026-07-02 by the daily-progress-summary periodical)

`schedules/daily-progress-summary.md` declares `cadence: daily` and its body specifies "fires every day at
00:00 America/Los_Angeles (DST-aware)" with a forward-computed, non-drifting anchor. But the v2 scheduler
(`scripts/jobs/scheduler.sh`) only supports **fixed elapsed-interval** cadences (`daily`→86400s from
`last_dispatched`), so it (a) **drifts** — `last_dispatched` advances to each actual fire time — and (b) is
**not anchored** to Pacific midnight. Proof: this fired at 2026-07-02T19:12:37Z (12:12 PDT), not local
midnight.

## Recommended fix (approach (a), the faithful translation)

Extend `scheduler.sh` with a **wall-clock / timezone-anchored cadence kind**: compute the most-recent
local-midnight boundary in a named TZ (DST-aware); a schedule is due if `last_dispatched` < that boundary.
No drift, DST-aware, no churn between boundaries. (Alternative (b): a short-cadence preflight gate that
fires only when the Pacific calendar date of `last_dispatched` is behind now's — simpler but commits on
every gated tick.) Update the schedule spec + scheduler to agree.

## Definition of done

`daily`-with-TZ schedules fire at the intended local boundary without drift; a test or documented repro
shows daily-progress-summary firing at Pacific midnight. Land on `main2`.
