---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Design a proportional worker-leveling policy across the fleet's hosts, replacing
today's per-host-independent leveling for the Anthropic pools and adding a
separate, appropriately different rule for the shared codex pool.

## Current state (read `scripts/jobs/budget-level.sh` before designing —
don't rediscover its mechanics)

`budget-level.sh` levels each host's `monk` count **independently** against
that host's own spend-vs-cap headroom fraction, within the same fixed range
(`GARDEN_BUDGET_LEVEL_MIN=1` .. `GARDEN_BUDGET_LEVEL_MAX=4`) **regardless of
how large that host's own cap is**. Today's two calibrated Anthropic pools:

```
endolin-garden-ece02cb4   : 143,000,000 tokens/wk
endolin-garden2-5bcdff64  :  64,000,000 tokens/wk
```

roughly a 2.2:1 ratio. Current monk counts happen to be 2:1 — but that's
coincidental (each host independently landed there via its own headroom
fraction), not a designed cross-host proportion. Nothing today would stop
garden2 from climbing to the same absolute ceiling (4) as ece02cb4 despite
having less than half its budget.

## What to design

1. **A proportional cross-host rule for `monk`**, sized by each host's
   *actual* calibrated weekly cap (`config/budget-pools`), not a flat 1-4
   range applied identically everywhere. Work out the concrete formula (e.g.
   total fleet worker budget allocated by cap-share, or a per-host ceiling
   scaled by cap-share against a fleet-wide baseline) and how it composes with
   the EXISTING per-host headroom-fraction leveling (cybernetics-audit.md's
   confirm-before-move dwell logic must not be thrown away — proportionality
   sets the *ceiling* each host levels toward, not a replacement for the
   already-working up/down confirmation logic).
2. **A separate, need-based rule for `cleric`.** The codex subscription behind
   `cleric` is ONE shared account across both hosts (see the
   `openai-codex-shared` manual-checkpoints log) — there is no "garden2's own
   codex budget" for a proportional-to-cap rule to apply to. Design a
   different basis for how cleric counts should split between hosts (relative
   throughput/need, queue depth, or another defensible signal) — do not
   force-fit the monk rule onto it.
3. **Interaction with the still-open session-vs-weekly gap.** `designs/
   session-budget-pace.md` already proposes effective cap = min(weekly pace,
   session pace) and is unimplemented. Note explicitly whether this
   proportional-leveling design should wait on that, compose with it, or is
   independent — don't silently ignore a design that already touches the same
   controller.
4. **Bounds and safety.** Keep the existing fail-safe behaviors intact: the
   provenance gate (never actuate on an uncalibrated cap — this was a real bug
   fixed 2026-09-04), the fleet-drain skip, and the dwell/confirm-before-move
   throttling against a stale sensor. A proportional rule must not remove any
   of these; it changes the TARGET the existing safeguards level toward.

## Landing

Write this as a `designs/*.md` doc naming the exact formula, the cleric-split
rule, and the interaction with `session-budget-pace.md`. This job is design
only — a mentat-tier review follows, then a build job implements it; do not
implement here.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-09T19:38:43Z
