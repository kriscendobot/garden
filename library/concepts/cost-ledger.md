---
id: cost-ledger
aliases: ["cost ledger", "cost record", "costs.jsonl", "per-run cost record", "token ledger", "token spend ledger", "attributed cost ledger", "invoke cost", "CostRecord", "per-task cost stanza", "devoker:cost", "total_cost_usd", "token accounting"]
topics: [coding-agent-economics]
---

# cost-ledger

An **attributed cost ledger** is an append-only, per-run record of the token and
compute cost of every agent invocation, tagged at write time with enough
attribution (session / trigger / role-or-channel / task / model) that any
"where did the spend go" question is answered by **regrouping the same rows**
rather than by a new measurement. It is distinct from a **quota gate** (a
fleet-wide throttle like the garden's `usage-meter.sh`, which sums a trailing
window to decide *whether to keep spending*): a ledger answers *what was spent
and by whom*, a gate answers *may we spend more*. The two compose — a ledger can
feed a gate — but a gate alone cannot attribute spend.

unum's `evoke/costs.jsonl` is the worked example: one JSON line per run (captured
from the Claude CLI's terminal `result` event, storing both raw token counts and
the CLI-computed `total_cost_usd`), written `O_APPEND` best-effort to a gitignored
realm-runtime file, read by `invoke cost --by task|day|model` and rendered into a
per-task `## Cost` stanza on the completed-task archive and a live operator chip.
The reusable design lessons: capture attribution once at write time; group at
read time (a new axis is a new key, not a schema change); store the provider's
dollars *and* raw tokens (dollars now, tokens re-priceable forever); bake
per-unit-of-work spend into the work's durable record with an idempotent
marker-delimited regenerate; sort spend groups by dollars descending.

The garden has the **gate** half (`usage-meter.sh`) but not the **ledger** half:
it cannot yet attribute spend per job / role / model, and a completed job's
`tada/` report carries no cost block. Every gardener job is a `claude -p` run
whose transcript carries the same `usage`, and the job base is a natural
attribution key — so the pattern is directly buildable. Routed to the liaison as
a self-improvement during the unum ingest (cycle 2026-07-10).

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [unum--token-cost-ledger](../sections/unum--token-cost-ledger.md) | costs.jsonl: capturing the Claude CLI `result` event into a per-run CostRecord, gitignored under CoordRoot, O_APPEND best-effort. |
| [unum--cost-attribution-and-aggregation](../sections/unum--cost-attribution-and-aggregation.md) | Grouping the ledger by task/day/model; the three surfaces (invoke cost table, per-task TADA stanza, live chip). |

## See also

- [[coding-agent-spend]] — the spend-management *discipline* (`spend = token_cost × token_count`); the cost-ledger is the *measure-and-attribute* instrument for it.
- [[model-routing]] — a per-model ledger breakdown makes the "cheaper tokens" lever's effect visible.
- [[vigil-charge]] — the complementary *budget on proactive spend*; a ledger measures spend, a charge gates whether to incur it.
