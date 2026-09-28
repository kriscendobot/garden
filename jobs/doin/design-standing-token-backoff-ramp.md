---
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Design: a standing, automatic token-backoff-fraction reset-to-reset ramp

## Maintainer directive (kriskowal, 2026-09-28), verbatim

> Let's codify the practice of giving the foreman 50% of all freshly released
> token budgets, then increase that gradually to 100% as we approach a reset.
> That should be standing instructions going forward and I expect not to need
> to manually adjust the foreman's threshold or use the foreman's brake,
> leaving these only as control surfaces for interventions rather than
> regular operation. The control surface going forward should be the
> foreman's initial reserve upon reset, starting now at 50%.

Translate this into: `config/token-backoff-fraction` (journal2) starts each
subscription's fresh weekly window at 0.50 and ramps deterministically toward
1.00 as that window's reset approaches — continuously, automatically, forever
— with NO recurring manual step from the liaison or maintainer.
`brake-foreman.sh` and any direct edit of the fraction become genuine
INTERVENTION-only tools (an operator override for an incident), not the
regular-operation lever they were through 2026-09-17 through this weekend.

## Do not build this from scratch — it already exists, mostly

Read `scripts/jobs/usage-meter.sh`'s `subscription_pacing_bias()` (and its
neighbors `subscription_pacing_window`, `subscription_pacing_summary`,
`subscription_allocation_weight`) in full before designing anything. It
already computes, per subscription, a deterministic `[0,1]` "how urgently
should this subscription accelerate spend" signal from real reset-window math
(`time = left/duration`, `quota = (cap-spent)/cap`, `slack = quota - time`,
`bias = slack/(time+.15)`) — this is already consumed by `budget-level.sh` to
weight worker-count apportionment (`subscription_allocation_weight`,
oros-studio's 0.85-0.97 bias during 2026-09-27's weekend ramp was this exact
function). This is very close to what "gradually increase toward 100% as we
approach a reset" needs. The central design question is whether the new
mechanism should:

(a) **Generalize this existing per-subscription bias into the fraction
    directly** (e.g. `fraction = 0.5 + 0.5 * f(bias-or-time-fraction)` per
    subscription), reusing the SAME reset-window math budget-level.sh already
    trusts, rather than inventing a second notion of "how close to reset";
    or
(b) keep `config/token-backoff-fraction` as ONE global fleet-wide scalar
    (its current shape) and drive it from ONE fleet-representative
    time-to-reset signal.

Investigate and decide with evidence, not assumption. Ground truth to weigh:
`config/budget-pools` currently lists THREE Anthropic weekly-tokens
subscriptions (`claude-endolin1`, `claude-endolin2`, `claude-oros`) whose
reset instants are not guaranteed to coincide (the maintainer has manually
triggered off-cycle resets before — see `journal/budget/reset-events/` and
the manual-quota-checkpoint work from 2026-09-24/25) — a single global
fraction cannot simultaneously be "just reset, be conservative" for one
subscription and "reset imminent, spend it down" for another. But
`GARDEN_TOKEN_BACKOFF_FRACTION` today is read as ONE value by
`usage-meter.sh`'s `resolve_token_backoff_fraction`/`meter_quota_status` (the
actual per-claim admission gate, fleet-wide) AND by `budget-level.sh`'s
per-pool target formula — changing its shape to per-subscription is a real
architectural change touching both call sites, not a config tweak. If (a) is
right, work out how a per-claim admission check (which runs on a specific
host claiming for a specific subscription) resolves the RIGHT subscription's
fraction — the mapping already exists (`budget_pool_for_provider_host`,
`config/subscription-mapping`) and should be reused, not reinvented.

## What "reset" means for the ramp's restart

The ramp must snap back to 0.50 at the START of each subscription's fresh
window, not just monotonically climb forever. `subscription_pacing_window`
already resolves window boundaries — read it to confirm it gives you a clean
"time since this window started" you can map the 0.50->1.00 ramp across,
rather than re-deriving reset detection. If it doesn't cleanly give you that,
say so and scope the gap rather than guessing.

## The ramp curve itself

The maintainer's own ask names two points (0.50 at reset, 1.00 approaching
the next reset) but not the shape between them. A straight linear ramp
across the window is the obvious default; `subscription_pacing_bias`'s
existing `slack`-based curve is a defensible alternative since it already
responds to ACTUAL spend (not just elapsed time) — pick one, justify it, and
say plainly if this is an open question for the maintainer rather than
deciding it unilaterally.

## Mechanism: where does this tick?

Needs a deterministic (no-LLM), cheap, recurring evaluation — likely folded
into an EXISTING cadence-driven script (`budget-refresh.sh`,
`budget-level.sh` itself, or a small new sibling on the existing
`garden-budget-refresh.timer` 5-minute cadence) rather than a new standalone
timer, unless you find a reason a new one is cleaner. It should CAS-write
`config/token-backoff-fraction` only when the computed value has genuinely
moved (mirroring `set-token-backoff-fraction.sh`'s CAS-write shape, which you
should read and likely retire/fold in rather than leave as a second, now
dead, writer).

## Retire the weekend stopgap

`schedules/token-backoff-ramp-{080,095,100}.md` are three one-time schedule
entries the liaison hand-created this weekend (2026-09-26) as a manual
stopgap ramp, each dispatching a trivial job that runs
`scripts/jobs/set-token-backoff-fraction.sh <value>`. Once the standing
mechanism lands and is confirmed running, these become redundant (and
could fight the new automatic writer). Say in your design whether to let
them fire out naturally (they're self-deleting one-shots, so they vanish on
their own by 2026-09-30) or have the liaison cancel them immediately — your
call, but don't leave them contradicting the new mechanism silently.

## Land

This almost certainly carries open questions (at minimum: global vs.
per-subscription, the ramp curve shape) — land per the frozen-base-branch
open-questions carve-out (a review PR against `main2`), not bare, so the
maintainer can decide before it becomes standing automated behavior
controlling real spend, unattended, indefinitely.

<!-- garden-transient-elapsed: kind=signature through=0 values=5 -->

<!-- garden-reaped: 1 -->
<!-- garden-plain-retry-not-before: 2026-09-28T08:16:15Z -->

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-28T08:28:49Z
