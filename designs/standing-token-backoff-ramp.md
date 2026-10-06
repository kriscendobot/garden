# Standing token-backoff ramp: reserve at reset, release toward the next

| | |
| --- | --- |
| Created | 2026-09-28 |
| Author | designer (job `design-standing-token-backoff-ramp`) |
| Status | Accepted |

## Directive

Maintainer directive (kriskowal, 2026-09-28), verbatim:

> Let's codify the practice of giving the foreman 50% of all freshly released
> token budgets, then increase that gradually to 100% as we approach a reset.
> That should be standing instructions going forward and I expect not to need
> to manually adjust the foreman's threshold or use the foreman's brake,
> leaving these only as control surfaces for interventions rather than
> regular operation. The control surface going forward should be the
> foreman's initial reserve upon reset, starting now at 50%.

## Problem

The high-water fraction (`GARDEN_TOKEN_BACKOFF_FRACTION`, read from journal
`config/token-backoff-fraction` by `resolve_token_backoff_fraction` in
`scripts/jobs/usage-meter.sh`) is one fleet-wide scalar that a person edits.
From 2026-09-26 the liaison has ramped it by hand: 0.50 on 09-26, 0.65 on
09-28, and three one-shot schedules (`schedules/token-backoff-ramp-{080,095,100}.md`)
that set it to 0.80, 0.95, and 1.00. The directive makes that ramp standing and
automatic. The one knob left for regular operation is the **initial reserve**,
the fraction admitted right after a reset.

## Decision: per subscription, computed when read, never written

### Per subscription, option (a)

The fraction becomes a function of the subscription being admitted against.
It reuses the reset-window math that `budget-level.sh` already relies on.

Evidence from today's journal. `config/budget-pools` lists three Anthropic
weekly-tokens subscriptions whose windows do not line up.
`subscription_pacing_window` gives:

| subscription | window start | deadline | linear ramp at 2026-09-26T18:06Z (the hand ramp set 0.50) |
| --- | --- | --- | --- |
| `claude-endolin1`/`2` | 2026-09-26T03:00Z (calendar, Fri 20:00 PT) | 2026-09-30T03:00Z (planned manual reset) | 0.58 |
| `claude-oros` | 2026-09-23T06:59Z (calendar, Tue end of day PT) | 2026-09-30T06:59Z | 0.75 |

When the global value was set to 0.50 for the endolin reset, oros was already
halfway through its own window, so the hand ramp held oros back for no reason.
One global scalar cannot express "just reset" and "reset imminent" at once.

The change to call sites is smaller than the job brief feared. Every reader
of the fraction already has a pool in hand:

- `meter_quota_status [pool] [dir]` resolves a pool itself when none is passed
  (`budget_pool_for_provider_host anthropic "$GARDEN"`). That covers the
  claim gate `pool_admits` in `claim-job.sh`, the foreman's gate in
  `foreman.sh`, `gauntlet.sh`, `deadline-nudge.sh`, `budget-refresh.sh`, the
  `mentor-claude.sh`/`foreman-claude.sh` handler backstops, and `quota-panel.sh`.
  It passes the fraction on to `meter_verdict` as the default third argument.
- `budget-level.sh` reads `$GARDEN_TOKEN_BACKOFF_FRACTION` inside its
  per-pool loop (the `mv`/`uncalibrated` target line), where `$pool` is in scope.

So the host->subscription question is already answered by
`budget_pool_for_provider_host` and `config/subscription-mapping`. The new
function takes a pool, and each caller passes the one it already has.

### Computed when read, not ticked (a change from the brief's suggestion)

The brief suggested a 5-minute writer that CAS-writes
`config/token-backoff-fraction`. This design proposes no writer. The fraction
is a pure function of `(pool, now, journal)`, and every reader already syncs
the journal and has those inputs. A writer would need one file per
subscription to be per subscription at all. It would lag its readers by up to
one tick, add a steady stream of CAS commits to `journal2`, and fail as a
separate thing ("the ramp daemon stopped"). Computing the value on read has
none of those problems and needs no timer. It also snaps back correctly on
its own: the value is derived from the current window, so it cannot drift
from it. For visibility, the value and how it was derived appear in the
existing decision reasons (below) instead of a journal file.

New helper in `usage-meter.sh`:

```sh
# token_backoff_fraction_for <pool> [journal-dir] [now]
#   prints "<fraction>\t<source>", source in env|override|ramp|fallback
```

Precedence, highest first:

1. **env**: an explicit `GARDEN_TOKEN_BACKOFF_FRACTION` in the environment
   still wins. Tests and unit-level pins keep working.
2. **override**: `config/token-backoff-fraction` on `journal2`, **now meaning
   an intervention pin**. When the file exists it pins every pool, fleet-wide,
   and every reader logs `source=override` so a forgotten pin shows up.
   `set-token-backoff-fraction.sh` stays as the tool that writes this
   override. It gains `--clear` (delete the file) and `--until <instant>`.
   An override with an `until` gate remains in force until that instant even
   when quota is otherwise available to spend; at and after the instant,
   readers ignore it and resume the ramp. There is no availability-based
   early expiration. The scalar file remains valid indefinitely for backward
   compatibility; the optional gated form is `fraction: <value>` followed by
   `until: <RFC3339 instant>`. The writer's commit message changes from
   "weekend ramp" to "intervention override". It is not retired, because it
   is the intervention writer. `brake-foreman.sh` is unchanged.
3. **ramp**: `r0 + (1 - r0) * elapsed / duration` over the pool's
   `subscription_pacing_window` (start -> deadline), clamped to `[r0, 1]`.
   `r0` comes from new journal file `config/token-backoff-initial` (default
   `0.50`; same validation as the fraction). This file is the directive's
   "control surface going forward".
4. **fallback**: when no window can be resolved, fall back to `0.95`. This is
   intentionally close to full admission while still retaining a small
   reserve until the reset time is clarified.

`resolve_token_backoff_fraction` keeps working for callers that have no pool,
and sets the global to the local host's Anthropic pool's value.
`meter_quota_status` calls the new helper for the pool it resolved and passes
the result to `meter_verdict` explicitly. `budget-level.sh` replaces both uses
of `$GARDEN_TOKEN_BACKOFF_FRACTION` in its per-pool target line with the
per-pool value and appends `backoff=<f>(<source>)` to the reason it already
records. The foreman's `note_once` "token-backoff" message prints the pool's
value and source.

### Curve: linear in elapsed window time

Recommended: linear in time. The brief offered `subscription_pacing_bias`'s
slack curve as an alternative. It is the wrong tool for a ceiling, because it
goes down as spend goes up (`quota` shrinks, so `slack` shrinks). A ceiling
that fell as the fleet spent would feed back into admission and oscillate:
spend lowers the ceiling, admission stops, spend stalls, the ceiling rises
again. The two signals do separate jobs and should stay separate:

- **Ceiling** (this design): how much of the window's quota may be spent by
  now. It depends only on time, rises steadily, and never depends on spend.
- **Accelerator** (existing `subscription_pacing_bias` ->
  `subscription_allocation_weight` / `pace_target` in `budget-level.sh`):
  how hard to push *within* the ceiling when spend is behind. It responds to
  spend. It is unchanged.

The linear curve matches the hand ramp the maintainer approved (endolin
window, 2026-09-26T03:00Z -> 2026-09-30T03:00Z):

| instant | hand value | linear (r0 = 0.50) |
| --- | --- | --- |
| 2026-09-28T01:31Z | 0.65 | 0.74 |
| 2026-09-28T18:00Z | 0.80 | 0.83 |
| 2026-09-29T18:00Z | 0.95 | 0.95 |
| 2026-09-30 before the reset | 1.00 | -> 1.00 |

The hand ramp only started at 0.50 fifteen hours into the window. Linear from
the window start is slightly more generous early on and converges from there.

## Gaps in the existing window math (scoped, must fix in the build)

`subscription_pacing_window` gives a clean `(start, deadline)` for
calendar-cadence pools while a planned reset is still in the future. It does
**not** snap back when a planned manual reset passes:

1. **A passed planned reset does not start a new window.**
   `subscription_reset_fact` drops `expected-next-scheduled` rows, and
   `_subscription_window_start` then falls back to the calendar anchor. For
   `claude-endolin1` at 2026-09-30T04:00Z, one hour after the planned reset,
   the window it reports is 2026-09-26T03:00Z -> 2026-10-03T03:00Z. That puts
   the ramp at **0.79, not 0.50**. The fix is in the ramp helper only: take
   the window start to be `max(window_start, latest planned reset <= now)`.
   Do **not** change `_subscription_window_start` itself. It also sets the
   `subscription_used_percent`/meter cutoff, and moving that on a planned
   (not observed) reset could hide real usage if the reset never happened.
   Treating an unconfirmed planned reset as a fresh window errs toward the
   0.50 reserve, which is the safe direction for the ceiling. Whether the
   meter cutoff should also move is out of scope (to be filed).
2. **Manual-cadence pools get no window.** `subscription_next_reset_epoch`
   returns failure for `cadence: manual`, so `codex-endolin` (a percent pool)
   has no pacing window even though it has a pending `expected-next-scheduled`
   row (2026-10-03T17:20Z). Proposed: when a pool is manual and has a pending
   planned reset, use `(last observed reset, planned reset)` as its ramp
   window. Otherwise use the 0.95 fallback and request an updated reset time.

Reset phase is tracked per subscription and reset event rather than inferred
globally. A Claude manual reset preserves the subscription's weekly calendar
phase; it changes the observed usage cutoff but not the next calendar deadline.
A Codex manual reset shifts the phase, so the observed reset becomes the next
window's start and its supplied next-reset time becomes the deadline. When an
event does not make the next reset time clear, the implementation must not
guess: it uses the 0.95 fallback and surfaces that the reset time needs an
update.

## Rollout and the weekend stopgap

Under the new meaning, **any** `config/token-backoff-fraction` file is an
intervention pin that disables the ramp fleet-wide. The file holding 0.65
today, and each of the three stopgap schedules if one fires after the build
deploys, would **silently pin** the fleet. So:

- **Until the build deploys:** leave the stopgap schedules alone. They are
  the maintainer-approved current regime and delete themselves on firing:
  080 at 2026-09-28T18:00Z, 095 at 2026-09-29T18:00Z, 100 at
  2026-09-30T06:30Z.
- **At deploy (one journal commit, done by the build):** remove any remaining
  `schedules/token-backoff-ramp-*.md`, remove `config/token-backoff-fraction`,
  and write `config/token-backoff-initial` = `0.50`. Removing schedules that
  already fired is a no-op. The build confirms the change after deploy with
  one `budget-level` tick whose reasons show `backoff=...(ramp)` for every
  Anthropic pool.

## Test plan (for the build)

Deterministic tests using `GARDEN_USAGE_NOW` and a fixture journal:
calendar pool at its start, midpoint, and just before the deadline (0.50 /
0.75 / nearly 1.00); a pending planned reset shortening the window; a
**passed** planned reset snapping back to 0.50; a Claude manual reset
preserving phase; a Codex manual reset shifting phase; a manual pool with and
without a pending plan; the 0.95 unknown-window fallback; indefinite and
`until`-gated overrides; override and env precedence; malformed
`token-backoff-initial` falling back to 0.50 with a WARN; and
`meter_quota_status` for two pools at different points in their windows giving
different verdicts for the same used percentage.

## Accepted decisions

1. Compute the ramp per subscription. Subscription windows can be assumed to
   be out of phase except for coincidences.
2. Use a linear curve from the initial reserve to 1.00.
3. Compute the fraction when read. Non-linear spending outcomes are acceptable
   and should be measured after deployment.
4. Use 0.95 when no reset window can be resolved.
5. Allow an explicit `until` gate on an intervention override and honor it
   until its instant even when quota is available. Do not expire an override
   early from an availability signal.
6. Track phase per subscription and reset event. Claude manual resets preserve
   phase; Codex manual resets shift it. Request an updated reset time whenever
   the next deadline is unclear rather than inferring one.
