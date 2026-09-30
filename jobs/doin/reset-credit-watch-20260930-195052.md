---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
**Role: accountant.** Weekly **reset-credit watch**: keep an eye on the garden's manual quota-reset credits, work out how best to use them, and send the maintainer **one recommendation in the maintainer inbox** (`message-user.sh <your-base>`).

Standing maintainer direction (kriskowal, 2026-09-30): "We should plan to use these resets mid-week before they expire."

**Inputs (read first):**
- `journal2:projects/garden/reset-credits.md` is the credit inventory, expiries and use log. It is the source of truth for what credits exist; only the maintainer creates credits.
- The latest dashboard checkpoints (`budget/manual-checkpoints/*.jsonl`), the live meter (`budget/live/*`), reset events (`budget/reset-events/*.jsonl`) and the true-cap estimates (`fit-quota-calibration.sh --dry-run`).
- Natural boundaries:
  - Claude endolin subscriptions reset Friday 20:00 America/Los_Angeles.
  - codex-endolin resets on a rolling 7 days from its last reset.

**Policy:** the target is to spend a subscription to **90%, never 100%**, then reset. The last 10% is maintainer discretion. A credit is worth the most when it is used **mid-week**, once the subscription reaches about 90% well before its natural reset, and **before the credit expires**. A credit used just before a natural reset is mostly wasted. A credit that expires unused is fully wasted.

**Each week:**
1. Reconcile the inventory against this week's evidence (any maintainer messages, reset events).
   - If a credit looks used or expired, update `reset-credits.md` with `scripts/jobs/land-journal-edit.sh projects/garden/reset-credits.md`.
   - Never invent credits.
2. For each subscription with a live credit, estimate from current pace when it will cross 90% and how that compares with its natural reset and the credit's expiry.
3. **Recommend** a concrete plan: which credit, which subscription, and a target day and time window, for example "burn claude-endolin2 to 90% by Wed, reset Wed evening PT; the credit expires Oct 22".
   - Say whether the fleet should **accelerate** first (a near planned deadline via `append-reset-event.sh --type expected-next-scheduled`, plus worker counts) to reach 90% in time.
   - Say whether a credit is at risk of expiring unused.
   - Include a one-line status for every subscription (current %, pace, natural reset, credits and expiries).
4. **Send the recommendation** with `message-user.sh`, one concise message. **Do not actuate:** do not change budget pools, backoff fraction, worker counts or reset events yourself. The maintainer decides, and the liaison executes.
5. Complete the job, noting whether the recommendation needs a timely decision (for example a credit expiring within 10 days).

Keep it short: one screen. If nothing is actionable (no live credits, or none near expiry), send a one-line "no action this week" status and finish.

---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-30T20:55:09Z
