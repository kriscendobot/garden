---
role: builder
tier: mentor
fallback-tier: minion
handler-timeout: 10800
dispatch: automatic
---
# Make a doomed gauntlet stage recoverable instead of instantly fatal

Today one doomed stage job kills an entire gauntlet. In `scripts/jobs/gauntlet.sh`
the child-state transition is:

    failed)
      halt_gauntlet "$base" "stage '$child' ($stage) failed or vanished from the
        board (doomed/declined). A stranded PR mid-gauntlet halts loudly rather
        than stalling."

Halting loudly rather than stalling was the right call versus a silent stall.
But it is absolute: there is no re-post, no budget, no distinction between "this
stage is unrunnable" and "this stage lost a fight with the reaper".

## The cost, measured

89 gauntlet halts since 2026-07-29. **70 (79%) are this class** — 40 at `panel`,
15 at `fix`, 15 at `clean`. By comparison the panel/fix loop's own
non-convergence accounts for only 18. Of 37 doomed gauntlet stage jobs, 26 are
`requeue-exhausted` — the reaper gave up after 5 identical handler failures.

Each of those 70 is a PR abandoned mid-flight, with a maintainer-inbox message
to triage.

## What to build

Give the gauntlet a BOUNDED stage-retry budget, separate from `max_iterations`:

- On a `failed` child, re-post the SAME stage (same basename discipline) rather
  than halting, up to `max_stage_retries` (suggest 2; make it a field on the
  gauntlet record, like `max_resumes` already is — see `post-gauntlet.sh`).
- Record each retry on the gauntlet record so the history is auditable, exactly
  as `resumes` is today.
- Halt only when the retry budget is exhausted, and say so in the halt reason
  ("stage X failed N times") so the message distinguishes a genuinely unrunnable
  stage from transient reaper loss.
- A stage doomed for a DETERMINISTIC reason must NOT be retried — re-running it
  would repeat an identical failure and waste the budget. `policy-refusal` is
  explicitly deterministic (the reaper says so and does not requeue). Treat
  `requeue-exhausted` as retryable ONLY if you can show the underlying handler
  failure was transient; if you cannot distinguish, prefer NOT retrying and say
  why in the halt reason.

Note the interaction: `resume_stage` already exists for a `still-pending` stage
result. This is a different axis — that is "the stage asked for more time", this
is "the stage died". Do not conflate them or reuse the same counter.

## Coordinate, do not duplicate

A sibling job `diagnose-panel-seat-error-rate` is finding the ROOT cause of the
panel-stage failures (~20% of panel runs error with all seven seats erroring).
This job is the containment half: even with the root cause fixed, a doomed stage
should not vaporize a gauntlet. Do not attempt the seat diagnosis here.

## Definition of done

Landed on `main2` with a test in `tests/checks/` that pins the new behaviour: a
stage that fails once is retried and the gauntlet proceeds; a stage that fails
past the budget halts with the new reason; a deterministically-doomed stage is
not retried at all. Prove the test can fail — mutate each guard and show it is
caught — and record that in the test header. Real-execution evidence, with
commands and output.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-31T21:27:53Z
