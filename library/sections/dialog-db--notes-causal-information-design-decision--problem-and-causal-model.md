---
title: The problem and Dialog's causal model
source: notes/causal-information-design-decision.md
source_repo: dialog-db/dialog-db
source_commit: 6cc234ab767985e44b68090143ac33027fafb158
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [change-propagation, datalog-query]
status: current
---

> Abstract: When a tool queries Dialog and reads records, it probably wants to capture the `Cause` of what it read, so that when it submits an edit it can communicate its assumptions to the transactor and the transactor can verify consistency — essentially **compare-and-swap**: if you change a counter from 3 to 5 but the current value is 4, the transactor can tell your assumption is stale. The challenge is that the derive macros produce clean domain structs (`#[derive(Concept)] struct Employee { name: Name, role: Role }`) with no place to attach a `Cause`. The note then sketches Dialog's (planned, not-yet-implemented) causal model: every claim in the associative layer carries a `Provenance { origin: Did, period: usize, moment: usize }` — `origin` a unique site identifier, `period` a coordinated time (last sync cycle), `moment` an uncoordinated local counter. This plays a role similar to Automerge's logical timestamps: `origin` is the actor ID, and the `(period, moment)` pair is like a Lamport counter except it captures whether changes happened within a single offline session or across multiple synced sessions — a distinction a plain Lamport counter conflates. **Causal assertions** (from the "Modeling Cardinality" note) let a writer express intent — "I mean to succeed *this specific prior claim*" — which the transactor uses, with the current claim set, to resolve cardinality across tools that disagree about whether an attribute holds one value or many.

## The problem

When a tool queries Dialog and gets results, it probably wants to capture the `Cause` of the records it read. That way, when it submits an edit, it can communicate its assumptions to the transactor, and the transactor can verify consistency. This is basically compare-and-swap: if you change a counter from 3 to 5 but the current value is 4, the transactor can tell your assumption is stale.

The challenge is that the current derive macros produce clean domain structs with no place to stick a `Cause`:

```rs
mod employee {
    #[derive(Attribute)] pub struct Name(String);
    #[derive(Attribute)] pub struct Role(String);
    #[derive(Concept)]
    pub struct Employee { pub name: Name, pub role: Role }
}
```

## Context: Dialog's causal model

> ⚠️ This is not what is currently implemented, but it is the current plan.

Every claim in the associative layer carries a `Provenance`:

```rs
pub struct Provenance {
    pub origin: Did,   // unique site identifier
    pub period: usize, // coordinated time (last sync cycle)
    pub moment: usize, // uncoordinated local counter
}
```

This plays a structural role similar to logical timestamps in Automerge. The `origin` is the direct equivalent of an **actor ID**. The `(period, moment)` pair is similar to a Lamport counter, except it captures whether changes happened within a single offline session or across multiple sessions with syncs between them — which a Lamport counter conflates.

Causal assertions (described in "Modeling Cardinality") let a writer express intent: "I mean to succeed *this specific prior claim*." The transactor uses this, along with the current claim set, to resolve cardinality across tools that may disagree about whether an attribute holds one value or many.

Source: [notes/causal-information-design-decision.md](https://github.com/dialog-db/dialog-db/blob/6cc234ab767985e44b68090143ac33027fafb158/notes/causal-information-design-decision.md) at commit `6cc234ab`.
