scripts/jobs/reputation.sh

# Wallclock as a cost proxy for arms whose dollar ledger is censored

Work-around for the censored-cost blocker found while validating kimi-k3 dispatch
(2026-07-28). Garden change on `main2` (direct push, no PR).

**Companion job:** `fix-censored-events-frozen-reputation-arm` unfreezes the
*acceptance* side (censored events currently never increment `attempts`/`accepts`).
Its § 2 explicitly defers the **cost-side** decision — *this job is that decision*.
If that job is still open, coordinate; the two touch the same reducer/auction path
and should not land conflicting edits. Neither strictly blocks the other, but the
cost proxy is only meaningful once acceptance updates.

## The opportunity: we already track time

No new measurement is needed. **`duration_secs` is present on all 1365 reputation
events** — 100% coverage — and `complete-job.sh:89` emits it **unconditionally**,
right beside the dollar fields that fail open to `censored`. It is never censored,
because it is measured by the garden rather than reported by a provider CLI.

So every arm that has no dollar evidence still has a complete, uncensored cost
*signal*. For the mystic/moonshot/kimi-k3 arm specifically: 3 events, all
`accepted: true`, durations **17s, 19s, 27s** — a tight, usable distribution sitting
right next to `attempts: 0, accepts: 0, mean_dollars: 0.000000`.

## What to build

**A wallclock-derived cost estimate that stands in for censored dollars, clearly
marked as an estimate.**

1. **Derive an estimated cost** as `duration_secs × rate(provider, model,
   thoughtfulness)` when `agentic_dollars` is `censored`, and feed *that* into the
   cost estimators the Thompson draw consumes (`mean_dollars`, `m2`).
2. **Never let an estimate impersonate a measurement.** Keep the raw
   `agentic_dollars: censored` on the event, and record the derived figure in a
   distinct field (e.g. `estimated_dollars:` + `cost_source: wallclock|ledger`). An
   arm should be able to report how much of its cost evidence is real. Preserve the
   existing `censored: N` count.
3. **Prefer the real ledger whenever it exists.** The proxy applies only where
   `usage/<base>.jsonl` is absent. An arm must not get worse estimates as a
   consequence of this change.
4. **Create the rate table.** `reputation/rate-card.md` and `config/auction.md` are
   referenced by [skills/bid-auction/SKILL.md](../../skills/bid-auction/SKILL.md) as
   optional config layered over the env defaults in `reputation.sh`/`auction.sh` —
   **neither file currently exists.** The rate card is the natural home for
   per-`(provider, model, thoughtfulness)` dollars-per-second. Seed it with the
   arms in use and a documented default for unknown arms. Because it is journal
   state, a rate can be corrected later without a code change — which is the whole
   point of a coarse proxy.

## Calibration anchor (maintainer-supplied, 2026-07-28)

Record this datapoint durably — in the rate card or alongside it — **with its
provenance**, so a later, better aggregate measurement can supersede rather than
silently coexist with it:

> **$0.20365** spent as of **2026-07-28T06:39Z**, over roughly **18 minutes**
> (~1090s) of this liaison session. That is ≈ **$0.00019/second** (≈ $0.68/hour).

Use it as a **coarse anchor, not a fitted parameter**, and be explicit in the rate
card about what it does and does not cover:

- It is an **Anthropic Opus liaison session**, so it calibrates *that* arm. It is
  **not** a Moonshot/kimi-k3 rate — applying it there would invent a number for a
  provider it never measured. If kimi-k3 needs a starting rate, derive it from
  Moonshot's published pricing and mark it as such.
- An **interactive liaison session is idle-heavy** — wallclock includes time waiting
  on a human. An autonomous worker grinding a build has a very different
  dollars-per-second. Treat this anchor as an upper bound on idleness and a weak
  prior for worker arms.
- The maintainer's framing: *"a coarse calibration if we have better aggregate
  tracking later."* Build so that better tracking **replaces** this cleanly —
  the rate card should carry a `source:` and `measured_at:` per entry.

## Guard against the failure mode the companion job flagged

An arm with no cost evidence must not bid **$0** and thereby win every auction on
price. Confirm that a wallclock-derived estimate actually prevents this, and state
in the report what an arm bids when it has *neither* dollars nor a rate-card entry.
That fallback path is the one most likely to be wrong.

## Optional refinement (do not let this expand the job)

`duration_secs` records only the **final** attempt. **255 of 1365 events (~19%)
have `attempts` > 1**, so wallclock burned on failed attempts is absent — yet the
skill specifies that cost-per-accepted *"amortizes failed attempts."* The journal
commit log does retain those spans (`claim(<base>) <host>/<worker>` → `tada(<base>)`;
e.g. the 2026-07-25 canary shows a 25s claim→tada span against a recorded
`duration_secs: 19`, the difference being claim and commit overhead). If amortizing
failed attempts matters, that is where the data is. **This is a refinement, not the
mechanism** — implement the `duration_secs` path first and report whether the
refinement is worth a follow-up.

## Constraints

- The reducer stays deterministic, no LLM, idempotent, and the sole writer of
  `arms/`; leader-only scheduling unchanged.
- Arms are a derived projection — recomputed from events, never hand-edited.

## Definition of done

- A censored-dollar event yields a wallclock-derived cost estimate feeding the
  Thompson cost terms; the raw `censored` state and count remain visible.
- `reputation/rate-card.md` exists, carries the arms in use with `source:` and
  `measured_at:` per entry, and records the $0.20365 anchor with its caveats.
- Arms with a real ledger are numerically unchanged — show a before/after on one.
- The no-evidence bid is bounded, not $0; the report states what it is.
- Reducer run twice is a no-op on the second pass.
- Pushed to `main2`; `tada` report quotes the mystic/moonshot/kimi-k3 arm before and
  after, and says plainly whether kimi-k3 can now accumulate auction-relevant
  evidence.

<!-- garden-reaped: 2 -->

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 8
  worker_kind: gardener
  claimed_at: 2026-07-28T12:39:09Z
