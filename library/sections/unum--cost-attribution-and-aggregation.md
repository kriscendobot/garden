---
title: Cost attribution, aggregation, and surfacing
source: devoker/cmd/devoker/cmd_cost.go
source_repo: jcorbin.tngl.sh/unum
source_commit: e489be2fd0e5ae9301d4495e4b288c9d0e724a80
source_date: 2026-07-05
source_authors: [jcorbin]
ingested: 2026-07-10
ingested_by: scholar
topics: [coding-agent-economics]
status: current
---

## Abstract

Given the per-run ledger ([costs.jsonl](./unum--token-cost-ledger.md)), unum
answers the operator's "where did the tokens / dollars go" question three ways,
all reading the same rows: an on-demand aggregate command (`invoke cost`), a
per-task cost stanza auto-appended to the `TADA/` archive file, and a live
one-line usage chip on the Telegram status surface. The unifying idea is that
**attribution is captured once at write time** (session / trigger / channel /
task / model), and every surface is just a different **grouping** of the same
immutable rows — dollars, tokens, and host compute all fold the same way. This
section covers the aggregation model and the three surfaces; the record schema
and capture are in the [companion section](./unum--token-cost-ledger.md).

## Aggregation model

`AggregateCosts(recs, keyOf)` folds records into per-key `CostGroup`s plus a
grand total, where `keyOf` chooses the axis. `CostGroup.fold` sums the four token
classes, dollars, duration, and CPU, but takes **peak RSS as a high-water mark
(max, not sum)** — resident memory does not accumulate across sequential runs —
and counts folded runs **per model id** so a group can report which model(s)
spent its tokens (relevant once per-persona tiers split spend across models).
Groups are returned sorted by **descending dollar cost** — the operator's
"what cost the most" ordering — ties broken by key for stable output.

`invoke cost` exposes the axis as `--by task|day|model` (default `task`), with
`--since <date-prefix>` (a lexicographic compare against the RFC3339 `started_at`,
valid because that format sorts as strings, so no date parsing) and `--task
<slug>` filters, plus `--json` for machine output and `--compute` to swap the
token/dollar columns for the host-compute (CPU + peak-RSS) table. A channel turn
(no task) groups under `(channel)`; a pre-model-tier row groups under
`(unknown)`. Example (`--by day`, nested tasks):

```
2026-06-25  5 sessions  62.4k in  18.1k out  34.2k cached  4m 12s
  task 623  2 sessions  24.1k in   6.8k out  14.1k cached  1m 34s
  steward   2 sessions  20.0k in   5.9k out  10.1k cached  1m 36s
```

## The three surfaces

1. **On-demand aggregate — `invoke cost`.** The table above; the auditor's view.
   Reads the whole ledger, filters, groups, prints a per-group table plus a grand
   `TOTAL` row leading with the headline all-classes token count and the dollar
   cost.
2. **Per-task cost stanza in the `TADA/` archive.** On archival, `taskCostStanza`
   aggregates every ledger row for the task slug into a `## Cost` block appended
   to the task file — distinct sessions, run count, input tokens (with the cached
   portion called out), output tokens, dollar cost, wall-clock, and (when the
   ledger carried rusage) CPU and peak RSS. It is delimited by an HTML-comment
   marker `<!-- devoker:cost -->` so a re-archive **strips and regenerates** it
   idempotently without disturbing the authored body; a task that spent no tokens
   gets no stanza rather than a misleading all-zero one. A real example, from the
   archived task file for the per-persona-tier work itself:

   ```
   ## Cost
   - Sessions: 1 (1 run)
   - Input: 6.2k tokens (11.0M cached)
   - Output: 53.8k tokens
   - Cost: $16.7371
   - Wall-clock: 33m 27s
   - CPU: 5m 31s user, 1m 14s sys
   - Peak RSS: 597 MB
   ```

   This bakes the spend of the work **into the durable record of the work** — the
   completed-task archive carries what it cost, permanently and greppably.
3. **Live operator chip.** A terminal task notice renders a one-line summary
   `✅ Task done · N tools · N↑ N↓ N♻ · $cost · wall · CPU · RSS · model`, each
   chip omitted when absent, and the dollar chip suppressed below a cent (a
   sub-cent run reads as `$0.00` noise). Channel turns get a compact footer tail
   `12.8k↑ 3.4k↓ 4.6k♻`. The cache-read `♻` is the operator-relevant cache chip
   (cache writes are decoded but not shown). A usage-less notice (old invoker,
   shell-mode) renders byte-identical to the legacy form — the accounting is
   purely additive.

## Design lessons transferable to the garden

- **Capture attribution at write time; group at read time.** Every surface is a
  regrouping of one immutable append-only ledger; adding a new axis (`--by model`
  arrived with per-persona tiers) is a new `keyOf`, not a schema change.
- **Sort spend groups by dollars descending.** The operator's first question is
  "what cost the most," so make that the default ordering.
- **Bake per-unit-of-work spend into the work's durable record.** The
  `<!-- devoker:cost -->` marker + strip-and-regenerate keeps the stanza
  idempotent across re-archival. The garden's analogue would be a cost block on a
  completed job's `tada/` report or the bulletin, keyed by job base.
- **Store the provider's computed dollars *and* raw tokens.** Dollars now, no
  local rate table; raw tokens as the durable re-priceable truth. See
  [[cost-ledger]] and [[coding-agent-spend]].

Source: [`devoker/cmd/devoker/cmd_cost.go`](https://tangled.org/jcorbin.tngl.sh/unum) at commit `e489be2` (with `devoker/internal/invoke/cost_record.go` @ `e489be2`, `devoker/internal/televoke/task_observer.go`, and `TADA/devoker/626` @ `f98ff13`), unum on tangled.org.
