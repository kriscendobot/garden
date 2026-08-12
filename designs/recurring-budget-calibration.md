---
created: 2026-08-12
updated: 2026-08-12
author: designer (job budgeted-campaign-phase2-weekly-bucket-design)
---

# Recurring capacity calibration and the token bucket

| Created | 2026-08-12 |
| Author | designer (job `budgeted-campaign-phase2-weekly-bucket-design`) |
| Status | Proposed |
| Extends | [`budgeted-campaign-dispatch.md`](budgeted-campaign-dispatch.md) (phase 1) |

Phase 1 ([`budgeted-campaign-dispatch.md`](budgeted-campaign-dispatch.md)) gives one
orchestration a fixed `--budget-tokens N` the maintainer supplies by hand each time.
This week's `N` (2,080,000) came from a one-off manual back-calculation against a
maintainer-reported quota percentage. That does not scale to "just keep campaigns
running with good accounting." This document designs the recurring mechanism that
replaces the manual step: a scheduled, deterministic weekly calibration that measures
real capacity, a journal-backed weekly-capacity ledger that keeps the history, a
derived token-bucket capacity estimate, and a persistent shared balance a campaign
draws from instead of a hand-supplied number.

This is a **separate document, not a section in phase 1's**, for two reasons. Phase 1
is already at the upper edge of the one-to-three-screen norm, and it already owns a
section titled "Phase 2: account-aware and transitive campaigns" that tracks a
different follow-on axis (per-account caps and transitive membership). Adding a second
"Phase 2" there would collide on the name and push the document past readable length.
The two follow-on tracks compose (see the last section) but are decided independently.

## What phase 1 already settled and this reuses

- **Spend is derived, never a stored counter.** Phase 1 has no persistent "spent"
  field. Cumulative spend is folded fresh from the `usage/<base>.jsonl` CostRecord
  ledger ([`token-cost-ledger.md`](token-cost-ledger.md)) at read time, so a stale
  counter can never disagree with the source. This design keeps that principle for
  both the capacity estimate and the bucket balance.
- **Billable tokens are the enforced quantity**: `input_tokens + output_tokens +
  cache_creation_tokens`, cache reads excluded, matching `usage-meter.sh`'s default.
- **Notional dollars are a display proxy, not money.** The fleet bills through flat
  Claude Max subscriptions, so the CLI's `total_cost_usd` is API-list-price notional.
  Real subscription cost is flat and sunk. This design prices real cost from journal
  config, never a hardcoded constant.
- **Fail-closed admission.** An unmetered (`source: none`) or malformed row in a spend
  fold that governs promotion stops the campaign rather than counting zero.

## 1. The weekly calibration: cadence, and why it is deterministic

**Cadence.** `weekly-at-Fri-21:00-America/Los_Angeles`, set through
`scripts/jobs/set-schedule.sh` ([`schedule`](../skills/schedule/SKILL.md)). This
anchored weekly form already exists, is DST-aware through zoneinfo, and is drift-free
(it pins the fire to the wall-clock anchor and stamps `last_dispatched` to the anchor
instant, so a late tick never creeps the weekly time forward). The anchor is exactly
the confirmed Friday 9 p.m. Pacific subscription-quota reset that phase 1 records
(2026-08-07T21:00:00-07:00, or 2026-08-08T04:00:00Z), so each calibration lines up
with a real quota reset.

**Why the work runs with no LLM.** The scheduler service that honors this cadence is
itself plain code (no `claude`), a leader-only singleton. Its `preflight:` hook runs a
named script in that same deterministic path before it would dispatch any agent. This
design hosts the entire calibration in that preflight script,
`weekly-capacity-calibration.sh`, wired with
`GARDEN_SCHEDULE_PREFLIGHT=weekly-capacity-calibration.sh set-schedule.sh
weekly-capacity weekly-at-Fri-21:00-America/Los_Angeles ...`. On each due tick the
script does the full fold, append, and refill (below), then returns **exit 2** ("no
work"), so the scheduler advances the anchor and posts **nothing** to the board. No
gardener ever claims it and no model runs. This honors both constraints at once: the
maintainer's blessed anchored cadence drives it, and the work stays deterministic.

The preflight's fail-open behavior becomes a safety net rather than a hazard. If the
calibration script errors (any exit other than 0 or 2), the scheduler treats the tick
as work-present and dispatches the schedule's job body, whose text is a short
instruction to a gardener: "the deterministic weekly capacity calibration failed;
investigate the usage fold and the bucket refill." A silent failure surfaces as an
investigation job instead of vanishing.

**Idempotency is mandatory.** The preflight runs **inside the scheduler's CAS retry
loop**: if the scheduler loses the race to stamp `last_dispatched` (a gardener pushed a
usage row in the same instant, which is common), it re-syncs and re-runs the preflight.
The calibration must therefore be idempotent per anchor. The weekly ledger append is an
upsert keyed on `(host, anchor)` (skip if a row for this host and anchor already
exists), and the bucket refill is skipped when `bucket.json`'s `refilled_at` already
equals this anchor. This also makes a late tick, an overlapping tick, or a leader
handoff safe: the calibration for a given anchor happens exactly once regardless of how
many times the script is invoked. The script operates on its own freshly synced journal
clone with the same discipline `usage-append.sh` and `cost.sh` already use.

**The fold.** Over the window `[prior_anchor, this_anchor)`, read `usage/*.jsonl` and
group by `host` (the `host` field is the account proxy: the fleet's two Claude
subscriptions map one-to-one to its two hosts, as established this session). Per host,
sum billable tokens and notional `total_cost_usd`, and count engagements, unpriced
rows (tokens but no dollars), and unmetered rows (`source: none`). This is the same
`jq` fold phase 1 documents, windowed to one week. Because this is measurement and
reporting (not admission), an unmetered row is **counted and recorded** in the row's
metadata rather than failing the fold closed; the honesty is in surfacing the count,
matching how `cost.sh` reports "N unmetered."

## 2. Real cost as journal config

The notional-to-real calibration ratio needs each account's real monthly subscription
cost. That is genuine fleet configuration (accounts can be added, removed, or repriced),
so it lives in the journal, not in a `$200 x 2` constant baked into a script. Following
the `config/fork-owners` and `config/sysop-issuers` precedent (one commented file, CAS
push discipline), add `config/claude-subscriptions` as a small TSV, one row per account:

```
# config/claude-subscriptions — real monthly cost of each Claude subscription, keyed
# by the host that account maps to (one account per host today). Columns, tab-separated:
#   host                       monthly_usd   account_label(optional)
# '#' comments and blank lines ignored. CAS-write with set-claude-subscription.sh.
endolin-garden-ece02cb4        200           max-account-a
endolin-garden2-5bcdff64       200           max-account-b
```

A small `set-claude-subscription.sh <host> <monthly_usd> [label]` setter CAS-races a
row onto the journal (mirroring `set-bot-identity.sh`); the file may also be hand-edited
and pushed like `fork-owners`. Real weekly cost per account is `monthly_usd * 12 / 52`
(the amortization phase 1 already uses: $46.15 per $200 account). A host that is present
in the usage fold but **absent** from this config is a real gap: the calibration records
its tokens but omits its notional-to-real index and names it in the row's metadata, so a
newly added account cannot silently distort the fleet ratio.

## 3. The weekly-capacity ledger

Append (never rewrite in place, so the trailing-window statistic below has history) one
record per account per week to `budget/weekly-capacity/<host>.jsonl`, the same
per-key append-only JSONL shape `usage/<base>.jsonl` already proved out. The
per-host file keeps CAS contention on the account's own stream, exactly as phase 1's
per-base files do.

```jsonc
{
  "anchor": "2026-08-08T04:00:00Z",       // Fri-21:00-PT anchor (UTC); the (host,anchor) upsert key
  "window_start": "2026-08-01T04:00:00Z",
  "window_end": "2026-08-08T04:00:00Z",
  "host": "endolin-garden2-5bcdff64",
  "billable_tokens": 6377205,             // input + output + cache_creation over the window
  "notional_usd": 205.15,                 // sum of total_cost_usd (list-price, notional)
  "real_weekly_usd": 46.15,               // monthly_usd * 12 / 52 from config
  "notional_to_real_index": 4.4453,       // notional_usd / real_weekly_usd; omitted if account unconfigured
  "engagements": 120,
  "unpriced": 0,
  "unmetered": 3,
  "computed_at": "2026-08-08T04:01:12Z"
}
```

## 4. The token-bucket capacity estimate: max over the trailing four records

The capacity estimate is a **plain read-time computation over the ledger**, not a
separately maintained running counter that could drift from its source (the same
"derived, not a new write path" principle the fleet-telemetry and phase-1 designs
already established for this codebase). Per account, take the **maximum**, not the
average, of the last four weekly `billable_tokens` records.

**Rationale (the maintainer's explicit reasoning, recorded here so it is not silently
traded for a different statistic).** The fleet can under-spend a week not because quota
ran out but because there was not enough queued work to spend it on. Averaging in quiet
weeks would bias the estimated true capacity downward. The maximum of the last four
weekly totals is a better gauge of the real ceiling: a week that came close to the
quota reveals more about the ceiling than three idle weeks do. It is still imperfect,
and this design says so plainly. If the true quota fell between two observed weeks, the
max under-estimates it; if one week was an anomalous spike (for example a backfill), the
max over-estimates for three more weeks until the spike ages out of the window; and with
fewer than four weeks of history the max is taken over whatever records exist, so early
estimates are noisier. The maximum is the least-bad simple statistic for "the real
ceiling," not a claim of accuracy.

**Combined capacity is the sum of the per-account maxima**, not the max of the combined
weekly totals. The two subscriptions are independent quotas: a job on one host draws
only that host's quota. Each account's own max-over-four is its independent ceiling
estimate, and the fleet's combined weekly capacity is their sum, even when each account's
peak fell in a different week. (Max-of-combined-weekly would understate capacity whenever
the two accounts peaked in different weeks.)

## 5. The persistent token bucket and how it is drawn down

Today's `--budget-tokens N` is scoped entirely to one campaign and supplied fresh each
time. This design adds a persistent, shared, journal-backed balance a campaign draws
from instead. `budget/bucket.json`, **rewritten in place** at each weekly refill:

```jsonc
{
  "capacity": 9262245,                    // sum of per-account max-over-4-weeks billable
  "refilled_at": "2026-08-08T04:00:00Z",  // the anchor this refill is for; the refill idempotency key
  "per_account_capacity": {               // the component maxima, for transparency
    "endolin-garden-ece02cb4": 2885040,
    "endolin-garden2-5bcdff64": 6377205
  },
  "computed_at": "2026-08-08T04:01:12Z"
}
```

Consistent with phase 1, **spend is not stored in the bucket.** The remaining balance is
derived fresh at read time:

```
remaining = capacity - (billable tokens across usage/*.jsonl with ts >= refilled_at)
```

**Draw-down is total fleet spend since the refill, not campaign-only spend, and this is
a deliberate consistency choice.** The capacity figure was calibrated from **total**
weekly billable per account (the fold in section 1 sums every job's tokens, not only
campaign jobs). To keep the estimate and the draw-down in the same units, the balance
must be decremented by the same total measure. Drawing down only campaign-tagged spend
against a capacity calibrated from all spend would mismatch units and the bucket would
never realistically empty. The honest reading of the bucket is "how much of this week's
real quota headroom is left," and every job the fleet runs consumes that headroom. A
useful consequence: because the bucket sees all spend, it correctly accounts for
auto-gauntlet descendants and other jobs whose basenames a campaign could not enumerate
when it was posted, which phase 1's per-campaign membership explicitly could not gate.

**Composition with phase 1's flag.** Add `post-orchestration.sh --from-bucket`, mutually
exclusive with `--budget-tokens N`. It records `budget_source: bucket` on the
orchestration record instead of a fixed `budget_tokens`. At each serial promotion,
`orchestrate.sh` reads `bucket.json`, computes `remaining` as above, and promotes the
next parked child only while `remaining > 0`; at or below zero it terminates the campaign
with `orchestration-status: bucket-exhausted`, using phase 1's non-sweeping terminal
renderer (the parked remainder stays parked). This reuses phase 1's fail-closed
discipline: a malformed usage row in the draw-down fold stops promotion with
`budget-meter-incomplete`, because the draw-down is admission, not reporting.

**`--budget-tokens` does not become a silent default to the bucket.** Phase 1's
invariant is that a record without `budget_tokens` keeps today's unbounded behavior, and
silently redirecting every existing unbudgeted orchestration to draw from the bucket
would break that byte-for-byte guarantee. So the bucket is an explicit opt-in
(`--from-bucket`) now. The hands-off end state ("just keep campaigns running") is reached
later through a fleet-config toggle, `config/campaign-default-bucket`, which when present
makes an omitted budget default to `--from-bucket`. Shipping the toggle off preserves
backward compatibility while making the default flippable in one journal write once the
mechanism has run a few live weeks.

Multiple concurrent `--from-bucket` campaigns share the one balance automatically,
because each derives `remaining` from the same fleet-wide fold. No per-campaign
reservation or allocator is introduced, matching phase 1's rejection of a pool ledger.

## 6. Recovering unspent budget

With the persistent bucket, unspent tokens from an under-run campaign need **no explicit
recovery step**, and this is sufficient, for two distinct time horizons:

- **Within a week**: an under-run campaign simply spent less, so `remaining` is larger,
  and the next campaign that week draws from that larger balance automatically. There is
  no sweep, transfer, or "return to pool" event to perform. This is phase 1's
  "unspent budget is permission never exercised" made continuous.
- **Across the weekly refill**: unspent tokens correctly do **not** carry, because the
  refill is absolute (the bucket is reset to the fresh max-over-four capacity, not
  capacity plus carryover). This is not a lost recovery; it is correctness. The refill
  anchor is the real subscription-quota reset (Friday 9 p.m. Pacific), and the real quota
  also resets to a fresh weekly allowance rather than adding last week's unused quota on
  top. Carrying unspent tokens across the refill would manufacture fictional headroom the
  real subscription does not grant.

So phase 1's explicit unspent-surfacing (a `tada` line and a maintainer notice) is no
longer needed for a bucket-drawing campaign: the unspent tokens are already the bucket's
balance, visible as `capacity - spend` at any read. A bucket-drawing campaign's terminal
report still prints `capacity`, `refilled_at`, spend since refill, and remaining, so the
accounting stays legible.

## Build slice (design only in this job; no build here)

1. `set-schedule.sh` invocation for the `weekly-at-Fri-21:00-America/Los_Angeles`
   schedule with the `preflight:` wired to `weekly-capacity-calibration.sh`, and a short
   fallback job body for the fail-open path.
2. `weekly-capacity-calibration.sh`: the deterministic fold, the `(host,anchor)`-upsert
   append to `budget/weekly-capacity/<host>.jsonl`, the max-over-four read, and the
   idempotent `budget/bucket.json` rewrite. Exit 2 on success.
3. `config/claude-subscriptions` seeded with the two current accounts, plus
   `set-claude-subscription.sh`.
4. A read helper (in `common.sh` or a small `bucket-remaining.sh`) that returns the
   derived `remaining`, reused by `orchestrate.sh` and any report.
5. `post-orchestration.sh --from-bucket` (record field, mutual exclusion with
   `--budget-tokens`) and the `orchestrate.sh` draw-down check plus the `bucket-exhausted`
   terminal state, alongside phase 1's `budget-exhausted`.
6. The optional `config/campaign-default-bucket` toggle.
7. Tests: per-anchor idempotency under a simulated CAS re-run; unconfigured-account
   handled; max-over-four with fewer than four records; combined = sum of per-account
   maxima; draw-down stops at exhaustion; malformed row fails the draw-down closed;
   within-week unspent stays available; refill does not carry across the anchor.

## How this composes with phase 1's other "Phase 2" (account-aware campaigns)

Phase 1's own "Phase 2: account-aware and transitive campaigns" section proposes stable
transitive membership and **per-account** caps keyed on `host`. This document produces a
**combined** capacity figure and a combined bucket, which matches phase 1's current
combined `--budget-tokens` cap and needs no change to the claim race. The two tracks
meet cleanly: `per_account_capacity` in `bucket.json` is already the per-account ceiling
the account-aware track would enforce, so when that track lands a host-aware reservation
in the claim path, it can draw each account's sub-balance from this same ledger without a
second source of truth. The account mapping should become explicit journal config rather
than assuming one account per host forever; `config/claude-subscriptions` is keyed on
`host` today for exactly that reason and is the natural place to grow an
account-identity column.

## Alternatives considered

- **A dedicated leader-only systemd timer** (a `garden-budget-calibration.timer` running
  the script directly, cadence via systemd `OnCalendar` with a timezone). Rejected: the
  maintainer's directive is to use `set-schedule.sh`'s anchored cadence and not invent
  scheduling, and the preflight path gets the leader-only singleton, the DST-aware
  anchoring, and the drift-free weekly instant for free from machinery that already
  exists. A second timer would duplicate all of it.
- **A stored running "spent" counter on the bucket**, decremented per completion.
  Rejected for the same reason phase 1 rejected it: it duplicates CostRecord facts and
  needs transactional updates across every completion and requeue path. Fresh aggregation
  has one source of truth.
- **Average (or median) over the trailing window** instead of max. Rejected on the
  maintainer's stated rationale: quiet weeks with too little queued work bias the average
  below the true ceiling.
- **Carrying unspent tokens across the weekly refill.** Rejected: the real subscription
  quota resets rather than accumulating, so carryover would manufacture headroom that
  does not exist.
- **Drawing the bucket down by campaign-tagged spend only.** Rejected: the capacity is
  calibrated from total weekly spend, so the draw-down must use the same total measure to
  stay in the same units; campaign-only draw-down against total-calibrated capacity would
  never empty realistically.
- **Silently defaulting an omitted `--budget-tokens` to the bucket.** Deferred behind a
  config toggle rather than made the default, to preserve phase 1's byte-for-byte
  unbudgeted behavior until the mechanism has proven out live.

## Open questions

- **Is hosting the calibration in the scheduler's `preflight:` hook the right vehicle, or
  should it be a dedicated leader-only timer?** The preflight path honors "use
  set-schedule.sh" and reuses the anchored cadence and leader-only singleton for free, but
  it repurposes a hook documented as a work-present gate into a hook that does the work and
  always returns "no work." The idempotency-under-CAS-retry requirement is handled by the
  `(host,anchor)` upsert and the `refilled_at` guard regardless of vehicle, so this is a
  clarity-versus-reuse call for the maintainer and builder, not a correctness one.
- **Should the draw-down measure be total fleet spend or campaign-tagged spend?** This
  design recommends total fleet spend for units-consistency with the calibration and to
  capture unenumerable descendants. If the maintainer wants the bucket to represent
  campaign headroom specifically, the calibration fold would need to narrow to
  campaign-tagged usage as well, which depends on the stable-membership tag from phase 1's
  account-aware track.
- **How many trailing weeks?** Four is the maintainer's stated choice. A longer window is
  steadier but slower to reflect a real quota change (a subscription upgrade); a shorter
  one tracks changes faster but is noisier. Revisit if quotas change often.
- **What should happen when fewer than four weekly records exist** (the first month after
  launch)? This design takes the max over whatever records exist, so early buckets are
  noisier. An alternative is to withhold `--from-bucket` until four records accrue and
  keep requiring explicit `--budget-tokens` in the interim; the maintainer's call.
- **Should `config/claude-subscriptions` grow a durable account-identity column now**, so
  a host that changes subscriptions does not rewrite ledger history? Phase 1's own open
  questions raise the same account-identity-versus-host question; deciding it once serves
  both tracks.
