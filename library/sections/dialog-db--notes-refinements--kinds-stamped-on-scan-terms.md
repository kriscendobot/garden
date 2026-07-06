---
title: Refinements — transport, kinds stamped on scan terms
source: notes/refinements.md
source_repo: dialog-db/dialog-db
source_commit: d8c90b907a6c726e3db38199cb1b9908ddbfc64d
source_date: 2026-07-01
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query]
status: current
---

> Abstract: How refinements reach the scan. The planner already stamped rule-level kinds onto the scan's value term (`with_type`); the attribute and entity terms now get the same treatment (`with_subject_kinds`). Their descriptors (`Symbol`, `EntityType`) graduated from unit structs to carrying an `Option<Type>`, normalized to `None` whenever the kind says no more than the static type — so unnarrowed terms compare, hash, and serde-roundtrip exactly as before (the wire format already had a `type` field per variable that previously dropped on deserialize and is now preserved). The alternative considered — stamping refinements onto the query struct as plan-time decoration fields — was rejected because kinds live on terms everywhere else and the wire `type` slot already existed, so a parallel channel would have been a second source of truth.

## Transport: kinds stamped on scan terms

The planner already stamped rule-level kinds onto the scan's value term (`with_type`). The attribute and entity terms now get the same treatment (`with_subject_kinds`): their descriptors (`Symbol`, `EntityType`) graduated from unit structs to carrying an `Option<Type>`, normalized to `None` whenever the kind says no more than the static type — so unnarrowed terms compare, hash, and serde-roundtrip exactly as before (the wire format already had a `type` field per variable; it previously dropped on deserialize, now it is preserved).

Alternative considered: stamping refinements onto the query struct as plan-time decoration fields. Rejected — kinds live on terms everywhere else, and the wire `type` slot already existed; a parallel channel would have been a second source of truth.

Source: [notes/refinements.md](https://github.com/dialog-db/dialog-db/blob/d8c90b907a6c726e3db38199cb1b9908ddbfc64d/notes/refinements.md) at commit `d8c90b90`.
