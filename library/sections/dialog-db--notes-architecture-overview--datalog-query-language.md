---
title: Datalog query language and time-travel
source: notes/architecture overview.md
source_repo: dialog-db/dialog-db
source_commit: f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query]
status: current
---

> Abstract: DialogDB uses **Datalog** as its query language, well-suited to graph-structured facts. A query is a `match` head naming output variables over a `when` body of `case` patterns, each a `{the, of, is}` triple with `{"?": "var"}` variable holes that unify across cases (a conjunction / join on the shared entity variable). Datalog's advantages: declarative semantics (say what, not how), natural graph traversal, recursion over arbitrary-depth paths, concise pattern matching, and reusable logical rules. Combined with the causal temporal model, queries also support **time-travel** (as-of any point in a causal timeline) and query-time merge-strategy selection.

DialogDB uses **Datalog** as its query language, particularly well-suited to working with graph-structured facts. A query has a `match` (the head, naming the variables it returns) over a `when` body of `case` clauses, each a fact-triple pattern with `{"?": "name"}` variable holes:

```json
{
  "match": {
    "name": {"?": "name" },
    "email": {"?": "email" }
  },
  "when": [
    "case": [
        {
          "the": "person/name",
          "of": { "?": "person" },
          "is": {"?": "name" }
        },
        {
          "the": "person/email",
          "of": { "?": "person" },
          "is": {"?": "email" }
        }
    ]
  ]
}
```

The shared `person` variable joins the two cases, so the query returns `{name, email}` pairs for each entity that has both a `person/name` and a `person/email` fact — a conjunction expressed by variable co-occurrence, the same conjunction the concept model realizes in its typed `Query::<T>` form.

Datalog's advantages for a fact database: declarative semantics, graph traversal, recursion (arbitrary-depth paths), pattern matching, and logical rules (reusable query components).

The schema-on-query approach is fundamentally different from schema-on-write: it enables evolution without migration, multiple interpretations, **temporal queries** (access data as-of specific points in causal timelines), conflict resolution at query time, access-pattern flexibility, and zero schema planning. (The full query-engine design — planning, adornment, cost model, operator IR, DBSP incremental evaluation — lives in the `notes/query-engine-design.md`, `notes/planning-adornment-and-cost.md`, `notes/operator-ir.md`, and `notes/dbsp.md` documents, deferred to a follow-on ingest.)

Source: [notes/architecture overview.md](https://github.com/dialog-db/dialog-db/blob/f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53/notes/architecture%20overview.md) at commit `f777fe7c`.
