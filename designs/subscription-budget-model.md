---
created: 2026-09-20
updated: 2026-09-20
author: gardener
---

# Subscription-based budget model

Status: Built

Quota ownership is keyed by subscription, not machine. The closed registry has
four ids: `claude-endolin1`, `claude-endolin2`, `claude-oros`, and
`codex-endolin`. `config/budget-pools` contains one ceiling row per subscription;
`config/subscription-mapping` is the independent many-to-many relation
`subscription_id, host, worker_kind`. In particular, the two endolin hosts both
map their cleric workers to `codex-endolin`, while oros has no Codex mapping.
Claim admission resolves this relation. An external inference worker without a
mapping is refused as an unknown, depleted source and tells the operator to ask
the maintainer for a token count and target spend date.

Live state is a set of host contributions at
`budget/live/<subscription-id>/<host>`. This shape allows an exclusive Claude
subscription to have one contribution and the shared Codex subscription to have
two without attributing ownership to either host. Token totals are summed;
account-level percentages use the freshest contribution. Manual observations and
reset facts live at `budget/manual-checkpoints/<subscription-id>.jsonl` and
`budget/reset-events/<subscription-id>.jsonl`.

## Reset facts

Every subscription has its own append-only event stream. A calendar declaration
carries its weekday, optional local time, and timezone. A day-only fact uses the
end of that local day as the conservative pacing deadline until the time is
refined. `codex-endolin` has `cadence: manual`: its current window begins at the
last observed manual-reset event and the code never projects another reset from a
weekday. The former global `GARDEN_TOKEN_RESET_*` defaults are gone.

## Effective token rate

A paired observation implies a full-window allowance:

`implied allowance = metered tokens / (percent used / 100)`

Dividing that allowance by the subscription's own reset-window duration gives a
tokens/day sample. Samples update in log space with `alpha = 0.25`:

`new = exp(0.75 * log(old) + 0.25 * log(sample))`

The geometric update treats proportional error symmetrically and prevents one
large magnitude from dominating the way an arithmetic mean would. A checkpoint
whose note flags a discontinuity or window-anchor change clears the rolling
baseline before later samples are incorporated; it is never blended through.
The quota panel aggregates all four registry rows into a fleet-wide tokens/day
lower bound and marks it incomplete when a subscription lacks a token-paired
sample, rather than silently treating an unknown rate as zero.

## Spend-down pacing

The leveler keeps the existing high-water brake. It also compares quota remaining
with time remaining in each subscription's own window. Only positive slack —
remaining quota fraction greater than remaining time fraction — adds an upward
worker target, rising smoothly as reset approaches. Thus a large balance early in
a window does not force maximum concurrency, while `claude-oros` now receives an
automatic upward bias as its independently recorded Tuesday reset approaches.
The bias reweights Hamilton apportionment (up to 20x at maximum urgency), so a
six-monk fleet can shift all three discretionary slots to oros (1 to 4) while
still respecting the fleet ceiling; it does not manufacture extra workers.
