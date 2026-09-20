---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Track quota per SUBSCRIPTION, not per host; infer rate limits; pace toward reset

Maintainer directive (kriskowal, 2026-09-20). This replaces the current
host-keyed budget model (`config/budget-pools`, `budget/live/<host>`,
`budget/manual-checkpoints/<host>.jsonl`, `budget/reset-events/<host>.jsonl`
— all currently assume one pool == one host) with a **subscription-keyed**
model, because the real ownership shape is many-to-many: some subscriptions
are exclusive to one host, one is shared across two.

## The four subscriptions (canonical names, use exactly these going forward)

- **`claude-endolin1`** — Claude Max 20x, exclusive to `endolin-garden-ece02cb4`.
- **`claude-endolin2`** — Claude Max 20x, exclusive to `endolin-garden2-5bcdff64`.
- **`claude-oros`** — Claude Max 20x, exclusive to `oros-studio-garden-ce242c49`.
- **`codex-endolin`** — Codex Pro 5x, SHARED by `endolin-garden-ece02cb4` AND
  `endolin-garden2-5bcdff64` only (never oros-studio). This is the pool
  already informally tracked as `openai-codex-shared` in
  `budget/manual-checkpoints/` — rename/migrate it to `codex-endolin`.

Host→subscription is many-to-many in general (one host can draw on several
subscriptions for different worker kinds; one subscription can serve several
hosts) — model it as an explicit mapping, not an assumed 1:1. A worker-kind's
quota gate resolves through this mapping to find the right subscription's
current state.

## Per-subscription reset tracking — independent, no calendar default, no override

Not "add a per-host override" — replace the current global
`GARDEN_TOKEN_RESET_DOW`/`_HHMM`/`_TZ` default (currently assumes Friday
20:00 Pacific for EVERYTHING) with **per-subscription, independently-tracked
reset facts**, recorded as observed/declared events in
`budget/reset-events/<subscription-id>.jsonl` (already exists for two of the
four; extend to all four, renamed to subscription ids). Concretely, per
subscription:

- **`claude-endolin1`**, **`claude-endolin2`** — both currently reset Friday
  20:00 Pacific. Record this as two INDEPENDENT observed facts (they
  coincide today; nothing enforces they always will — don't hard-link them).
- **`claude-oros`** — resets **Tuesday** (day/time not yet pinned down to
  the minute; the maintainer has confirmed the day). Seed what's known now;
  refine when a precise time is available.
- **`codex-endolin`** — reset date is **not calendar-anchored** — it changes
  whenever the maintainer manually triggers a reset, and they will
  explicitly note it when they do (a `budget/reset-events/codex-endolin.jsonl`
  append is the durable record of that manual act, not an inferred cadence).
  The reset-inference logic must NOT assume any periodicity for this
  subscription — always read the last observed reset event, never compute
  one from a day-of-week rule.

## Rate-limit inference: multiplicative rolling average

For each subscription, infer an effective **token rate limit** (tokens
unlocked per unit time) from the sequence of (percent-used, sampled-at,
reset-boundary) observations already being recorded (manual checkpoints +
live meter snapshots). Use a **multiplicative rolling average** — a
log-space / geometric update (e.g. `new_rate = old_rate^(1-alpha) *
sample_rate^alpha`), not a plain arithmetic mean — specifically because the
existing checkpoint history already contains real DISCONTINUITIES (see
`budget/manual-checkpoints/openai-codex-shared.jsonl`'s own
"DISCONTINUITY, flagged not smoothed over" entry from 2026-09-09) that a
naive average would blend through incorrectly; a multiplicative/geometric
update is more naturally robust to an occasional outlier or reset-boundary
jump without hiding it. Design the exact update rule and smoothing constant
yourself, document the rationale, and make discontinuity detection (the
existing per-checkpoint logic already flags large jumps) feed into WHETHER a
sample gets incorporated or treated as a fresh baseline, not blindly folded
in either way.

Then **aggregate across all four subscriptions** into one fleet-wide
token-unlock pace figure (e.g. tokens/day currently flowing in across
everything) — useful for macro capacity planning, distinct from any single
subscription's own state.

## Pacing lever: spend down before reset, not just back off near cap

The existing foreman/meter logic already backs OFF near a cap
(`GARDEN_TOKEN_BACKOFF_FRACTION`). Add the INVERSE: a subscription sitting on
unspent quota with its reset approaching should bias utilization UP (worker
counts, dispatch preference) rather than let quota go unused — unused weekly
quota does not roll over. This is what today's manual `claude-oros` monk
bump (2→4, done directly by the liaison, ahead of this job) was
approximating by hand; build the mechanism so this doesn't need a manual
intervention each time. Weigh both signals: percent remaining AND time
remaining until that subscription's own reset (per its independently-tracked
event, not a shared calendar assumption) — a subscription with lots of
quota left but ALSO lots of time left should not be force-maxed
immediately, only as its own reset genuinely approaches with slack still
unspent.

## Standing policy: unknown/new token sources require the maintainer, always

**This governs both the automation you're building AND the liaison's own
behavior going forward — record it in both places.** These four named
subscriptions are the complete, closed set. Any other apparent source of
inference capacity (a different API key, an unexpected available quota, a
token pool not in this list) is to be treated as **depleted / not
auto-refilling** by default. Before throttling UP on anything outside the
four named subscriptions, the automation (and the liaison, if acting
directly) must ask the maintainer to manually clarify the token count and
the target date for spending them — never infer or assume. Encode this as
an explicit refusal/ask-gate in whatever code path would otherwise scale up
an unrecognized pool, and add the same instruction to
`roles/liaison/AGENT.md`.

## Migration

This is a real data-model change touching `config/budget-pools`,
`budget/live/`, `budget/manual-checkpoints/`, `budget/reset-events/`, and
every reader (`usage-meter.sh`, `foreman.sh`, `gardener-scaler.sh`,
`append-quota-checkpoint.sh`, `quota-panel.sh`, `budget-level.sh` — grep for
`budget_pool_file`/`budget_pool_row`/`budget_fleet_status`/
`meter_quota_status` for the full call-site list). Existing host-keyed
history is real data — migrate it (rename/re-key), don't discard it; the
three exclusive Claude subscriptions map 1:1 to their existing host-keyed
files today, so that migration is a rename with subscription-id
bookkeeping; `openai-codex-shared` -> `codex-endolin` similarly. Land this
as a coherent whole — a half-migrated state (some readers subscription-aware,
some still host-only) is worse than the current state; sequence deploy
checkpoints if the change is too large for one atomic commit, mirroring how
`designs/date-sharded-tada.md` staged its own rollout.

## Report

The subscription registry (mapping + reset-tracking shape), the rate-
inference update rule with rationale, confirmation the pacing lever now
biases `claude-oros` appropriately without further manual intervention, and
explicit confirmation the ask-the-maintainer gate for unknown sources is
real code, not just a doc note.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-20T05:18:05Z
