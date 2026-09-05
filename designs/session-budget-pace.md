---
created: 2026-09-04
updated: 2026-09-04
author: gardener
---

# Session quota as a second budget pace

This addendum extends [`live-budget-admission.md`](live-budget-admission.md) for
subscription accounts that have both a weekly quota and a five-hour session
quota. It also composes with the reset capture in
[`quota-throttle.md`](quota-throttle.md): a provider refusal remains the reactive
backstop, while this mechanism slows admission before either quota is exhausted.

## Decision

Keep one row per account in `config/budget-pools` and append four optional TSV
columns after the existing weekly provenance:

```
session_ceiling  session_window_seconds  session_calibrated_from  session_calibrated_at
```

`session_ceiling` uses the same billable-token basis as the weekly ceiling.
`session_window_seconds` is 18000 for the current five-hour quota. Empty columns
mean that the session sensor is not calibrated, so the existing weekly behavior
is unchanged. Extending the row keeps the account-to-host topology in one place
and avoids pretending that one account's weekly and session constraints are two
independent pools. The setter must preserve and validate these columns when the
actuation slice lands.

Publish a second live snapshot per account containing the meter spend since the
dashboard-confirmed `session_resets_at`, its reset epoch, and the session cap.
The manual checkpoint ingester can calibrate the cap from spend deltas between
two readings that share one session reset epoch and one uninterrupted meter
anchor. It must reject a pair that crosses either reset, just as the weekly fit
rejects an anchor change. The current checkpoint log does not have enough clean
pairs to set this number: the usable pairs are sparse, cross an oscillating weekly
meter anchor, or imply incompatible caps under different workload mixes.

For each constraint, compute the remaining sustainable pace:

```
weekly_pace  = max(0, weekly_cap  - weekly_spend)  / seconds_to_weekly_reset
session_pace = max(0, session_cap - session_spend) / seconds_to_session_reset
allowed_pace = min(weekly_pace, session_pace)
```

Admission and `budget-level.sh` use `allowed_pace`. A calibrated session
constraint in backoff therefore declines a claim even when the weekly constraint
has headroom. Leveling converts the lesser pace into the worker target using an
observed trailing tokens-per-worker-second rate, with hysteresis; until that rate
exists, it may use the current headroom bands independently for both constraints
and take the lower worker target. Missing or stale session telemetry fails open to
the weekly constraint and emits one deduplicated warning, matching the existing
meter policy. A confirmed provider refusal still writes the self-expiring throttle
marker from `quota-throttle.md`.

## Actuation slice

1. Extend `set-budget-pool.sh` and its parser tests to preserve the optional
   session columns.
2. Publish anchored session spend beside the weekly live snapshot.
3. Extend checkpoint ingestion and fitting to require matching session reset and
   meter anchors, then promote only a converged session cap.
4. Make admission and leveling evaluate both constraints and select the lower
   verdict or worker target.

The weekly calibration can operate before this slice because absent session
columns are explicitly transparent. A session cap must not be invented from the
current percentages alone.
