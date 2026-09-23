---
title: Associative — Claims
source: rust/dialog-query/README.md
source_repo: dialog-db/dialog-db
source_commit: ebd8f73989dd785697e58d31495dbb056c9f6c8b
source_date: 2026-07-01
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query]
status: current
---

Abstract: A **statement** is a set of `{the, of, is}` associations; asserting a statement stores new associations as **claims** with an added `cause` logical timestamp, and retracting evicts matching claims. A claim `{the, of, is, cause}` reads as natural language — _the_ **role** _of_ **alice** _is_ **"cryptographer"** — with `of` the entity (subject), `the` the relation (`domain/name`), `is` the value (string, number, boolean, bytes, entity, etc.), and `cause` the provenance establishing causal order. Claims are immutable and content-addressed; an entity's state is the set of all claims about it. This is the crate-doc statement of the `{the, of, is, cause}` fact model.

## Claims

A statement is a set of `{the, of, is}` associations. A concept conclusion is a statement that decomposes into the attribute statements it is comprised of, each corresponding to a single association. When statements are asserted, new associations are stored as claims with an added `cause` logical timestamp. When retracted, matching claims are evicted.

A claim takes the form `{the, of, is, cause}`, corresponding to natural language: _the_ **role** _of_ **alice** _is_ **"cryptographer"**.

```
{ the: "employee/role", of: alice, is: "cryptographer", cause }
```

- **Entity** (`of`) — the subject of the claim.
- **Relation** (`the`) — categorizes the claim by the kind of association being established, in `domain/name` format (e.g. `employee/role`).
- **Value** (`is`) — the value being linked through the relation (string, number, boolean, bytes, entity, etc.).
- **Cause** — provenance describing who produced the claim and when, establishing causal order.

Claims are immutable and content-addressed. An entity's state is the set of all claims about it.

Source: [rust/dialog-query/README.md](https://github.com/dialog-db/dialog-db/blob/ebd8f73989dd785697e58d31495dbb056c9f6c8b/rust/dialog-query/README.md) at commit `ebd8f73`.
