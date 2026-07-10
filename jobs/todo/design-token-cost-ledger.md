---
role: designer
---

# Design: an attributed per-job token-cost ledger for the garden fleet

**Garden's own repo** (`kriskowal/garden`, `main2`): this is a garden control-surface
design. Land the design under `designs/` (e.g. `designs/token-cost-ledger.md`), built
in an isolated worktree off `origin/main2` and pushed directly — **no PR** (garden's
own repo; CLAUDE.md § Conventions). Develop in your cwd worktree, never the root.

## Provenance

This design realizes a structural proposal routed from the `scholar-ingest-unum`
job (maintainer said "turn it into a design job", 2026-07-10). **Read the scholar's
library ingest first** — it is the grounding:
- concept `journal/library/` **[[cost-ledger]]**, with worked sections
  `library/sections/unum--token-cost-ledger.md` and
  `library/sections/unum--cost-attribution-and-aggregation.md`;
- adjacent concepts **[[model-routing]]** and **[[vigil-charge]]** (note as related,
  see § Out of scope).

## The gap this addresses

The garden meters token spend at exactly ONE granularity today:
`scripts/jobs/usage-meter.sh` sums the fleet's billable tokens over a trailing
weekly window (from Claude Code's own `~/.claude/projects/**/*.jsonl`) so the
foreman can back off before the weekly quota. That is a fleet-wide **quota GATE**
(plain code, no LLM) — it works and **must stay**. But it is **not an attributed
ledger**: it cannot say *which job / role / model* spent the tokens, keeps no
per-job persisted record, and gives the maintainer no "where did the spend go"
view. A completed job's `tada/` report carries no cost block.

## What to design

An attributed per-job **cost LEDGER** that **measures** spend and **complements**
(does not replace) the usage-meter **gate** — "ledger measures, gate caps." Model
it on unum's pattern (per the library sections) adapted to the garden:

1. **The record.** A per-job cost record keyed by the **job base** (the garden's
   natural analogue of unum's `task`), capturing the four token classes + the
   CLI-computed `total_cost_usd` + wall-clock + host rusage (CPU/RSS), tagged with
   **role / model / host / session / trigger**. Store BOTH provider dollars AND raw
   tokens (dollars now, tokens re-priceable later, per unum).
2. **Where it is written.** Every gardener job is a `claude -p` run whose transcript
   already carries the same `usage` block; the natural write point is the
   **`doin → tada` completion** (`scripts/jobs/complete-job.sh` path). Weigh the two
   storage shapes and choose (or combine) with rationale:
   - unum's shape — a **gitignored runtime append file** (one JSON line, `O_APPEND`
     best-effort), fast and local; but it is **per-host** and not fleet-visible.
   - a garden-native shape — a **`## Cost` stanza on the `tada/` report** (and/or a
     structured cost record under the journal), which is **shared, durable, and
     auditable across hosts** via the same journal the fleet already coordinates
     through. Address the **multi-host aggregation** question head-on: the garden is
     a leader/follower fleet and spend happens on every host, so say how a fleet-wide
     "where did the spend go" view is assembled (per-host ledgers + a rollup, or the
     journal as the shared ledger).
3. **Read-time aggregation only** (unum's key simplicity): `--by job|role|model|day|host`
   is a **group key, not a schema change**; sorted by dollars descending. Design the
   query surface (a `scripts/jobs/cost.sh` / extension to `usage-meter.sh`).
4. **Surfaces** (unum's three, garden-mapped): an **on-demand table**; a per-job
   **`## Cost` stanza** baked idempotently into the `tada/` report (HTML-comment
   marker, per unum); and a **live one-line operator chip** (a bulletin line — note
   the bulletin is a leader-only singleton).
5. **How it feeds the gate.** Show how the ledger can **feed** `usage-meter.sh`
   rather than duplicate it (the gate can read attributed sums; the ledger is the
   richer source), and how model-selection/token-budget decisions could later key on
   attributed spend — without changing the gate's plain-code, no-LLM quota role.

## Out of scope (note as follow-ons, do not design here)

- **[[model-routing]]** (per-persona/role model tiers) — the garden already has
  `skills/model-selection`; only note where the ledger's per-model attribution would
  inform it.
- **[[vigil-charge]]** (health-gated budget on PROACTIVE spend — spend initiative
  tokens as a reward for verified stability; a possible refinement to the foreman's
  idle plan-pump). Flag it as an intriguing adjacent design the ledger would enable,
  and recommend a separate design job if the maintainer wants it.

## Skills

- [design-to-pr-pipeline](../../skills/design-to-pr-pipeline/SKILL.md),
  [model-selection](../../skills/model-selection/SKILL.md),
  [library-lookup](../../skills/library-lookup/SKILL.md),
  [context-library](../../skills/context-library/SKILL.md),
  [em-dash-style](../../skills/em-dash-style/SKILL.md),
  [no-latin-shorthand](../../skills/no-latin-shorthand/SKILL.md),
  [relative-paths](../../skills/relative-paths/SKILL.md),
  [self-improvement](../../skills/self-improvement/SKILL.md).

## Done

`designs/token-cost-ledger.md` lands on `main2` defining the attributed per-job cost
ledger: the record shape and attribution keys, the write point at `doin → tada`, the
storage choice with the multi-host aggregation answer, read-time `--by` aggregation,
the three surfaces, and how it **feeds** (not replaces) `usage-meter.sh` — with
model-routing and vigil-charge noted as follow-ons and the open questions named. The
`tada` report gives the SHA, the storage decision made, and the recommended build
phasing.

<!-- garden-reaped: 1 -->
