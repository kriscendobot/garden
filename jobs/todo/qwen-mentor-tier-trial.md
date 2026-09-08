---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Maintainer directive (kriskowal, 2026-09-08): run a bounded, monitored trial
admitting the local `hermit`/`qwen3.6` worker to `mentor`-tier work, reusing
the existing verified-demerit probe mechanism to gather real capability
evidence — not a blanket promotion, a controlled experiment to produce more
data.

## Why this is a trial, not a reclassification

`scripts/jobs/model-tier-inventory.tsv` has exactly one `local` row
(`qwen3.6`, `minion`), and per `designs/sysop-local-model.md`, "a routing
override cannot classify a new tier" — the closed inventory is the only
place tier is decided, there is no per-instance escape hatch. Its accumulated
reputation-arm record (`reputation/arms/hermit/local/qwen3.6/`) is genuinely
strong at `minion` — 51 attempts across 11 work classes (including `build:l`,
`build:m` x5), 100% acceptance, zero verified demerits ever recorded — but
that's evidence at the CURRENT ceiling, not evidence it can handle
`mentor`-shaped work, since the closed inventory has never let it attempt
any. This job's job is to generate that evidence deliberately, without
committing the fleet's automatic routing to an unproven tier.

**Precedent to follow, not reinvent**: `openrouter-promo` (the "cloaked/stealth
lane") already solved "how do we let something risky/unproven run without
touching the reviewed closed inventory" — explicit-model-only (never
auto-dispatched), its own namespace and reputation arm so a bad outcome never
pools with the proven lane, and cadence-gated so it fails closed automatically
if unattended. Read `designs/openrouter-provider.md` and
`context/operations/openrouter.md` § the promo lane for the exact shape and
adapt it, rather than inventing new trial machinery from scratch.

## What to design (and build, since the core measurement machinery already
exists — this is mostly wiring, not new mechanism)

1. **A bounded trial admission path.** Local/qwen3.6 gets a way to attempt a
   CAPPED number of `mentor`-tier-shaped jobs (pick a concrete cap and
   rationale — e.g. N attempts or a time-boxed window) WITHOUT changing its
   `model-tier-inventory.tsv` classification and without it winning ordinary
   `mentor`-tier auction bids at large. Candidate mechanisms, cheapest/safest
   first:
   - Explicit canary pins on a curated set of real `mentor`-tier-difficulty
     jobs (mirroring how `openrouter`/`openrouter-promo`/`ollama-cloud` are
     "explicit-model-only" — reachable only via a `provider: local` +
     specific-model pin, never automatic).
   - A capped exploration slice of real auction traffic, if the auction
     mechanism can express "admit this arm at this tier for up to N attempts,
     then require review" without a tsv change (check
     `weekly-capacity-calibration.sh`-style journal-ledger patterns already
     used elsewhere in this garden for bounded, auditable, journal-backed
     experiments before inventing a new one).
2. **Reuse the existing demerit probe as the signal**, unchanged in mechanism —
   the counterfactual (does a capable reference model succeed where
   local/qwen3.6 fails on a real `mentor`-shaped job) is exactly right for
   this too. Confirm the probe's own gating (kill switch, budget-brake freeze,
   once-per-base dedup) covers the trial's job set the same way it covers
   ordinary hermit work — don't build a parallel probe.
3. **A distinct reputation arm for the trial** (do not let trial attempts pool
   into the existing `minion`-tier `hermit/local/qwen3.6` arm data — a
   `mentor`-tier failure and a `minion`-tier success are different questions;
   conflating them corrupts both signals). Follow the
   `openrouter`/`openrouter-promo` split-arm precedent for how to keep them
   separately attributable.
4. **A clear review/exit condition.** Name what ends the trial and what
   happens next: a demerit-rate threshold that stops it early (fails closed,
   like the promo lane's stale-recheck), and/or a fixed attempt count after
   which the accumulated arm data gets read and a real tier decision — keep,
   don't promote, or promote for real via a reviewed `model-tier-inventory.tsv`
   change with the trial data as its justification comment (matching the style
   of the other reviewed rows) — gets made explicitly, not left to drift.
5. **Cost/quota awareness**: `mentor`-tier work is real, substantive work
   (builds, fixes, panel-adjacent tasks) — the trial spends real reference-model
   probe cost too (the demerit probe runs a capable reference model on every
   real failure). Size the cap with that in mind; this is not free to run
   indefinitely.

## Coordination with the sibling job

A separate job (`receipt-backfill-and-qwen-cost-analysis`) is investigating
whether hermit-carried PRs run cheaper or more expensive overall once
maintainer-review cost is counted. If its findings land first, read them —
they may usefully inform how aggressively to size this trial's cap (e.g., if
hermit's `minion`-tier work already shows elevated maintainer-review cost,
that's a reason to keep this trial's cap conservative until that's
understood, not a reason to skip the trial).

## Landing

This changes real fleet routing/measurement infrastructure — land per the
garden's own conventions, with the trial's cap, exit condition, and reasoning
written up clearly enough that anyone reading the journal later understands
it was a deliberate, bounded experiment, not an accidental promotion.
