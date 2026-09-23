---
title: The cost function — tier table and cardinality-one winner verification
source: notes/query-cost-model.md
source_repo: dialog-db/dialog-db
source_commit: f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query]
status: current
---

> Abstract: Cost is a greedy, index-aware function: for each premise, determine which of `{the, of, is}` are bound, pick the best index by longest contiguous prefix, and assign a tier — `LOOKUP` 100 (near point lookup), `RANGE_READ` 200, `RANGE_SCAN` 1000, `INDEX_SCAN` 5000, `VERIFY` 100 (per-match secondary lookup) — as relative ordering weights, not latency predictions. The full table keys on *which* slots are bound and the attribute cardinality: `{of,the}` on EAV is a 129-byte prefix (LOOKUP/RANGE_READ), `{the,is}` on VAE is 97 bytes (RANGE_READ, plus a VERIFY for Cardinality::One), `{the}` alone is expensive (RANGE_SCAN/INDEX_SCAN) because attributes are shared across many entities, and `{of,is}` costs the same as `{of}` because no index places entity and value adjacent so the value is post-filtered. **Cardinality-one verification:** only the write-race winner per (entity, attribute) should be yielded — a *sliding window* (buffer the group, emit the winner at the boundary) when results are grouped by (entity, attribute) in key order (EAV scans, AEV with attribute known), or a *secondary lookup* (scan EAV with the 129-byte `[entity][attribute]` prefix per candidate) when not grouped (VAE scans).

## Decision

Use a greedy algorithm with an index-aware cost function. At each step, estimate the cost of every remaining premise given currently bound variables, pick the cheapest, execute it, extend the bindings, and repeat.

### Cost function

For a given premise, determine which of `{the, of, is}` are bound, select the best index by longest contiguous prefix, and assign a cost from the following tiers:

```
LOOKUP     = 100      1-2 tree nodes, near point-lookup
RANGE_READ = 200      small bounded range, a few nodes
RANGE_SCAN = 1000     broader range, multiple segments
INDEX_SCAN = 5000     large portion of an index
VERIFY     = 100      per-match secondary lookup for cardinality-one verification
```

These are relative weights for ordering, not latency predictions. The full cost table:

```
Known       Index   Prefix    ONE                    MANY
---------   -----   ------    -------------------    ---------------
{the,of,is} EAV     162B      LOOKUP        (100)    LOOKUP     (100)
{of,the}    EAV     129B      LOOKUP        (100)    RANGE_READ (200)
{the,is}    VAE      97B      RANGE_READ+V  (300)    RANGE_READ (200)
{of}        EAV      65B      RANGE_READ    (200)    RANGE_SCAN (1000)
{of,is}     EAV      65B      RANGE_READ    (200)    RANGE_SCAN (1000)
{the}       AEV      65B      RANGE_SCAN    (1000)   INDEX_SCAN (5000)
{is}        VAE      34B      INDEX_SCAN+V  (5100)   INDEX_SCAN (5000)
```

Notable details:

- `{of, is}` costs the same as `{of}` alone. No index places entity and value adjacent, so the value constraint is post-filtered and does not reduce tree traversal.
- `{the, is}` with `Cardinality::One` incurs a VERIFY cost. The VAE index does not group results by (entity, attribute), so each candidate needs a secondary EAV lookup to confirm it is the write-race winner.
- `{the}` is expensive despite having one field bound because attributes are shared across many entities ("person/name" applies to every person).

### Cardinality-one winner verification

When an attribute has `Cardinality::One`, only the write-race winner for each (entity, attribute) pair should be yielded. The verification strategy depends on whether the scan index groups results by (entity, attribute):

**Sliding window** — when results are grouped by (entity, attribute) in key order, buffer the group and emit the winner at the boundary. Applies to EAV scans and AEV scans with attribute known.

**Secondary lookup** — when results are not grouped, verify each candidate individually by scanning EAV with the `[entity][attribute]` prefix (129 bytes) and checking whether the winner's value matches. Applies to VAE scans.

```
sliding_window = entity_known OR (attribute_known AND NOT value_known)
```

Source: [notes/query-cost-model.md](https://github.com/dialog-db/dialog-db/blob/f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53/notes/query-cost-model.md) at commit `f777fe7c`.
