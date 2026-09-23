---
title: Rule writes and cache-invariant tests
source: notes/layered-rule-resolution.md
source_repo: dialog-db/dialog-db
source_commit: 00b43561a10383175a7f794fee7cb0894b0222e7
source_date: 2026-07-01
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query]
status: current
---

> Abstract: Rule writes have no separate path: `tx.assert(rule)`, `tx.retract(rule)`, and `.with(rule)` all go through the existing `Statement` impl that writes/removes the `db.rule/*` facts, and the layer holding those facts (committed → durable, overlay → transient) surfaces them via resolution. Cache and invalidation invariants are covered in `session.rs` (`mod rule_tests`): committed resolves, overlay resolves, overlay resolves after a prior query at the same head, head-move re-scan adds, retract re-scan removes, distinct rule bodies do not share a hydrated body, a stale handle keeps its cached discovery, multi-branch unions, overlay rules do not leak into a later plain query, and no rules yields empty.

## Writes

`tx.assert(rule)`, `tx.retract(rule)`, and `.with(rule)` all go through the existing `Statement` impl that writes/removes the `db.rule/*` facts. There is no separate rule-write path: the layer holding the facts (committed → durable, overlay → transient) surfaces them via resolution.

## Tests

Cache and invalidation invariants are covered in `session.rs` (`mod rule_tests`): committed resolves, overlay resolves, overlay resolves after a prior query at the same head, head-move re-scan adds, retract re-scan removes, distinct rule bodies don't share a hydrated body, a stale handle keeps its cached discovery, multi-branch unions, overlay rules don't leak into a later plain query, and no rules → empty.

Source: [notes/layered-rule-resolution.md](https://github.com/dialog-db/dialog-db/blob/00b43561a10383175a7f794fee7cb0894b0222e7/notes/layered-rule-resolution.md) at commit `00b43561`.
