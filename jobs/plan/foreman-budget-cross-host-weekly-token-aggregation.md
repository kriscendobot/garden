---
gate: go-ahead
priority: normal
posted_by: liaison
posted_at: 2026-06-27T16:40:35Z
---

# PLAN: deterministic cross-host weekly token-spend aggregation for the foreman budget

Map: **build** (garden infra) on the garden's own repo, branch main2. Builds on
`foreman-meter-from-claude-code-session-logs` (the per-host meter) and
`foreman-token-quota-backoff` (the gate). Go-ahead gated — architectural; promote
with "go ahead on foreman-budget-cross-host-weekly-token-aggregation".

## Problem
The Max x20 subscription has ONE global weekly token allowance shared by the whole
fleet. A per-host sum of `~/.claude/projects/**/*.jsonl` only sees THIS host's spend.
To gate the foreman on the real global weekly total, every host's local total must be
aggregated deterministically into a shared, week-bucketed place.

## Design
1. **A periodic systemd service per host** (timer-driven oneshot, e.g.
   `garden-budget-reporter`) that each tick:
   - Computes this host's total billable tokens consumed SINCE the start of the current
     quota week, from the Claude Code session logs (the ccusage-style source the
     per-host meter already parses; reuse that code).
   - Writes (overwrite, not append — idempotent) that total to a journal location keyed
     by hostname and the current week:
       `budget/weeks/<week-id>/<host>`
     containing the host's current-week total (+ a breakdown and a `reported_at`
     stamp). Each host writes only its own file → no CAS contention.
2. **The foreman meter reads the bucket, sums all hosts.** Re-point `meter_window_total`
   to read `budget/weeks/<current-week-id>/*` and sum every host's file → the GLOBAL
   current-week token total. Files under a non-current week-id are ignored (and pruned).
3. **Deterministic week boundary (the crux).** The quota week resets **Friday 21:00
   America/Los_Angeles** (currently — make it CONFIGURABLE, journal-tracked, since the
   maintainer said "currently"). Compute the current week's start = the most recent
   Friday 21:00 in `America/Los_Angeles` (use `TZ=America/Los_Angeles` so DST is handled
   by the zone, not by hand). The **week-id** is that boundary's local date (e.g.
   `2026-06-26`). Every host computes the SAME boundary from the same wall-clock rule, so
   all hosts bucket into the same week-id regardless of their own timezone. Session-log
   lines are filtered to `timestamp >= boundary` when summing the host's current-week
   total.

## Key properties
- Deterministic + plain code (no LLM): jq over the JSONL; `TZ`-based boundary math;
  per-host overwrite. `require_tools jq`.
- Self-healing window: each tick recomputes the host total for the current week from
  scratch, so a missed tick or a clock skew self-corrects on the next tick.
- Reset = a new week-id directory appears; the foreman automatically reads the new
  bucket. Old week directories are pruned after a grace period.
- The reset rule (`Friday 21:00 America/Los_Angeles`) lives in journal config so it can
  change without a code edit; the reporter and the meter both read it.

## Open questions (for the maintainer)
- The exact Max x20 WEEKLY TOKEN ALLOWANCE (the quota number the high-water mark is a
  fraction of) — set it from config; do not guess.
- "Billable" token definition for the Max plan (input + output + cache_creation? does
  cache_read count?) — pick a definition, document it, make it adjustable.
- Whether the reset cadence should track a server-side signal (Claude Code `/usage`
  shows the actual reset) rather than the hardcoded Friday-9pm-Pacific rule, if that
  becomes machine-readable.

## Tests
Extend run-test.sh: boundary math returns the right week-id across a DST transition and
across the Friday-21:00 edge; a fixture of two hosts' bucket files sums to the global
total; current-week files are summed and prior-week files ignored; a missing bucket
fails OPEN (logged warning, never wedges the pump).

Deliverable: a `garden-budget-reporter` service + journal `budget/weeks/<week-id>/<host>`
layout + a foreman meter that gates on the GLOBAL weekly total, with the reset boundary
deterministic and configurable.

## Bulletin surfacing (maintainer extension 2026-06-27)

The aggregated weekly budget must ALSO be CAPTURED IN THE BULLETIN as a deterministic
dashboard section (no LLM), so the maintainer sees the garden's token-budget standing at
a glance. Add a section (e.g. `## Token budget`) rendered by `compute_dashboard` in
`scripts/jobs/bulletin.sh` that shows three things:

1. **Weekly quota — as reasoned by the garden.** The quota value the meter is currently
   gating on, WITH its source/derivation (the configured Max-x20 weekly allowance, or a
   value the garden derived), so it is explicit what number the garden believes its
   weekly ceiling to be.
2. **Aggregate usage this week.** The GLOBAL sum across all hosts'
   `budget/weeks/<week-id>/*` files for the current week (the same number the foreman
   gates on), plus the `week-id` and the reset time (the next Friday 21:00
   America/Los_Angeles boundary).
3. **Pace — how far ahead or behind.** Compare the USAGE fraction (`usage / quota`)
   against the ELAPSED-WEEK fraction (`(now − week-boundary) / 7d`), and render the signed
   delta in plain language, e.g.:
   `usage 68% of quota at 52% through the week → +16pp AHEAD of pace (straight-line
   projection ≈131% by reset — over-run)` or `… → −9pp behind (comfortable)`. Include the
   straight-line projected end-of-week usage vs. the quota so an over/under-run is obvious
   at a glance. Sign convention: AHEAD = burning faster than the week is elapsing (at
   risk); BEHIND = under-pacing (headroom).

**Determinism + push-gate.** Every input is journal2-sourced (`budget/weeks/`, the quota
config) — so a budget-reporter post advances journal2 and the bulletin recomputes under
the EXISTING push-gate (no new external-drift source is introduced, unlike the parked-PR
queue). Critically, the pace line is time-derived and would otherwise churn a commit every
tick: EXCLUDE the volatile "elapsed-fraction / projection / as-of" parts from the
change-compare (the same `stable()` mechanism that drops `_As of` and `(waiting <age>)`),
and round usage/quota/pace to INTEGERS, so only a real usage or quota change rewrites the
bulletin — a ticking clock alone never does.

**Deliverable (revised):** in addition to the cross-host meter, the budget work renders a
deterministic `## Token budget` bulletin section showing (1) the garden-reasoned weekly
quota + its source, (2) the aggregate current-week usage + week-id + reset time, and
(3) the ahead/behind pace delta + straight-line projection — all push-gate-safe (no
clock-driven commit churn). Extend the bulletin run-test.sh subtest to cover the section:
correct quota/usage/pace math on a fixture, and NO commit churn from an advancing clock
alone.

## Determinism mandate (maintainer amendment 2026-06-27)

Watching and aggregating the quota is **just math** — the whole system service must be as
DETERMINISTIC as possible: identical inputs always yield identical outputs and identical
bytes, with NO LLM anywhere on this path and no nondeterministic ordering.

- **Prefer `jq` over shell for ALL math.** Shell has no floats and is error-prone for the
  arithmetic this needs. Do every numeric step in `jq`: summing per-session/per-host token
  counts, the global current-week total, the `usage/quota` fraction, the elapsed-week
  fraction, the signed pace delta, the straight-line projection, and all rounding. The
  budget-reporter parses the session JSONL with `jq` and sums in `jq`; the aggregator sums
  the per-host bucket files in `jq`; the bulletin computes the pace line in `jq`. Shell is
  only the glue (file globbing, `git` CAS, invoking jq) — not the calculator.
- **`require_tools jq`** at the top of every script on this path — a missing jq must fail
  LOUD, never silently produce an empty/zero total (the 2026-06-24 silent-jq-outage
  lesson; see silent_empty_output_check_missing_external_tool).
- **Deterministic ordering + dedup.** When listing host bucket files or session lines,
  sort with `LC_ALL=C sort` and dedup by a stable key (message id / line), so the sum is
  order-independent and a re-read never double-counts.
- **The only non-jq, non-shell input is the time boundary**, and it too is deterministic:
  derive the week-id and the elapsed fraction from `TZ=America/Los_Angeles date` against
  the Friday-21:00 rule, so every host computes the SAME `week-id` from the same wall
  clock regardless of its own timezone. No locale/format drift (`LC_ALL=C`, explicit
  `+%s` / `+%F`).
- **Integer, byte-stable outputs.** Round usage/quota/pace to integers in `jq` so the
  bulletin line is byte-identical across recomputations of the same state — the push-gate
  stays stable and a sub-unit tick never rewrites the bulletin. The reporter writes its
  per-host bucket file with `jq -S` (sorted keys) for byte-stable diffs.

This makes the reporter, the aggregator, the boundary math, and the bulletin pace line a
pure, reproducible `jq` computation over journal2-sourced data — testable with fixed
fixtures that assert exact numeric outputs.
