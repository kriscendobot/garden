---
id: vigil-charge
aliases: ["vigil charge", "vigil-charge", "charge pulse", "initiative pulse", "initiative budget", "health-gated heartbeat", "verified-quiet window", "reward for stability", "proactive-spend gate", "charge counter"]
topics: [agent-fleet-orchestration]
---

# vigil-charge

**vigil-charge** is unum's budget on *proactive* (self-initiated) agent
invocations: a counter that increments only when the health monitor completes a
round having taken no corrective action (a "verified-quiet" observation), and
that must cross a per-persona threshold before it is **spent** to fire one
initiative pulse. It reframes proactive work from *fire on a blind timer* to
*fire as a reward for verified stability* — a busy or unhealthy realm suppresses
its own proactive wakes until it settles. Because a proactive agent turn is
itself a token spend, vigil-charge is a spend-discipline for the class of work
nobody explicitly asked for, complementary to a [[cost-ledger]] (which *measures*
spend) and to a fleet quota gate (which caps *total* spend regardless of health).

The load-bearing design choices, all transferable to any stateless-per-tick
scheduler: (1) accumulate budget only over the monitor's verified-all-clear
window; (2) **decrement, not reset**, on minor convergence housekeeping, or a
lively system starves its own initiative forever (a negative-feedback stabiliser,
not a livelock); (3) reset hard only on genuine health failure / un-run work;
(4) persist the counter to disk because each monitor tick is a fresh process;
(5) make firing spend-on-drop with a TTL'd marker + an overdue once-latch, so a
hung proactive turn neither re-fires nor parks forever; (6) a staleness guard so
a stale accumulation cannot fire a spurious pulse after downtime.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [unum--vigil-charge-initiative-budget](../sections/unum--vigil-charge-initiative-budget.md) | The charge counter, the three-way action classification (reset/decrement/hold/+1), anti-storm floor, and TTL+overdue-latch liveness. |

## See also

- [[cost-ledger]] — measures spend after the fact; vigil-charge gates whether to incur proactive spend in the first place.
- [[coding-agent-spend]] — the broader spend-management discipline; vigil-charge is the "don't do work you don't need to" lever applied to a fleet's self-initiated turns.
