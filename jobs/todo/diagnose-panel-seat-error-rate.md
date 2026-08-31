---
role: builder
tier: mentor
fallback-tier: minion
handler-timeout: 10800
dispatch: automatic
---
# Diagnose why all seven panel seats error together (~20% of panel runs)

This is the ROOT CAUSE of the largest gauntlet failure class. Diagnosis first —
do NOT ship a speculative fix.

## The evidence already gathered (do not re-derive)

Across `journal2` `panel-runs/`: **87 of 444 recorded panel runs (19.6%)
terminate with `disposition: error`, `must_fix_total: 0`, and ALL SEVEN seats
reporting `error`** — e.g. `panel-runs/endojs-endo-but-for-bots-1018/fe4630bc00e2.md`:

    seat verdicts (7): copyeditor=error critic=error decomplector=error \
      ergonomist=error novice=error pedant=error skeptic=error

These are **spread thinly across the whole month** (2-4 per hour-bucket on many
different days, 2026-07-29 through 2026-08-31), so this is a PERSISTENT
BACKGROUND RATE, not a single provider outage. That is the key constraint on any
explanation: whatever you propose must explain a steady ~20%, not one incident.

## Why it matters

Gauntlet halts since 2026-07-29 number 89. **70 are STRANDED** — a stage job
doomed or vanished — and 40 of those are at the `panel` stage. Of 37 doomed
gauntlet stage jobs, **26 are `requeue-exhausted`** (15 at panel): "its handler
appears to fail every time; the reaper stopped requeueing it" after 5 cycles.

The plausible chain is: all seats error -> the panel produces no verdict -> the
stage cannot emit a `gauntlet-stage-result` marker -> the handler fails ->
identical failure 5x -> reaper dooms it -> `gauntlet.sh` sees `child_state`
`failed` and halts the whole gauntlet.

**Verify or refute that chain before fixing anything.** It is inference from
records, not an established fact. In particular, confirm whether an all-seats-error
run actually fails its stage handler, or whether the panel retries internally and
recovers (a retried `panel-1` is why #1018 has 7 panel-run records for 6 panel
stages — do not mistake a successful retry for a failure).

## What to find out

1. What is the actual error each seat reports? Seat dispatch is in
   `scripts/jobs/gardening/panel.sh`. Get at the underlying per-seat failure —
   provider error, timeout, empty output, policy refusal, a malformed prompt, a
   missing input file.
2. Why do all seven fail TOGETHER? Seven independent dispatches failing at once
   points at something shared: a common input (the PR diff/base ref), a shared
   setup step before fan-out, a concurrency/rate limit, or a single guard that
   aborts the whole round.
3. Is it correlated with anything observable — PR size, `panel_kind` (`design`
   vs code), host, provider, time of day, a specific base ref?

## Definition of done

A written root cause with real evidence (cite the runs, logs and commands), plus
a recommended fix. If the cause is a shared input or setup step, say exactly
which. If you cannot establish it, report what you ruled OUT and what evidence
would settle it — a well-bounded negative result is a good outcome here and much
more useful than a guess. Only implement a fix if the cause is established and
the fix is small; otherwise propose it.

<!-- garden-transient-elapsed: kind=signature through=0 values=4 -->

<!-- garden-reaped: 1 -->
