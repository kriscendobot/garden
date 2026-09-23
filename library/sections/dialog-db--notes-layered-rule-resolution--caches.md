---
title: Rule caches — discovery, hydration, and plan caching with their soundness disciplines
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

> Abstract: Rule resolution uses two caches with different correctness disciplines. **Discovery + hydration** (per branch, on `Branch`'s `RuleCache`): *discovery* ("which rule entities conclude concept X, committed") is keyed by concept and tagged with the branch head (`Revision`), so a head advance re-scans; *hydration* (compiled bodies) is keyed by the content-addressed rule entity, so it is never stale and is reused across concepts and head changes. The **overlay is never head-cached** — it does not move the head, so overlay rules are read fresh every query (cheap, in-memory), which structurally excludes an uncommitted `.with(rule)` being masked by a stale committed entry. **Plan** (`PlanCache`, keyed by `(rule.this(), Adornment)` → `Conjunction`) is content-addressed and never stale; it is owned by the `Branch` (not a process global), so peer branches share content-addressed plans. Soundness rests on `Adornment` being a bitmask over alphabetically-sorted parameter slots, independent of caller variable names.

Two caches with different correctness disciplines.

**Discovery + hydration** — per branch, on `Branch` (`RuleCache`, alongside `node_cache`; configured once per opened handle):

- *Discovery* ("which rule entities conclude concept X, committed") is keyed by concept and tagged with the branch head (`Revision`). A head advance — commit or pull — re-scans that concept. Read from the tree only.
- *Hydration* (compiled bodies) is keyed by the content-addressed rule entity, so an entry is never stale and is reused across concepts and head changes.

The **overlay is never head-cached**: it does not move the head, so a head-keyed "skip the scan" cache would mask an uncommitted `.with(rule)`. Overlay rules are read fresh every query (cheap — in-memory). Because the durable cache only ever holds the committed slice and the overlay is a separate layer, an overlay rule cannot be masked by a stale committed entry — the failure is structurally excluded.

**Plan** — `PlanCache` (`concept/query/plan_cache.rs`), keyed by `(rule.this(), Adornment)` → `Conjunction`. Planning a rule for a binding pattern is a pure function of `(rule body, adornment)`, so a plan is reusable across every query and concept that uses the rule, including ones that re-assemble `ConceptRules` from layers each query (where the per-instance plan map is cold every query). Content-addressed ⇒ never stale; the cache only bounds memory (SIEVE eviction, the same `sieve-cache` the node cache uses). The implicit and any attribute-bodied rule have no content identity (`try_this` returns `None`) and are planned directly, uncached.

The cache is **not a process global**: it is owned by the `Branch` (beside `node_cache` and `RuleCache`) and handed to each assembled `ConceptRules`, so its lifecycle follows the branch. Peer branches in a multi-branch query share content-addressed plans, so `execute` rides the first branch's cache (a branchless overlay-only query falls back to a private one). A standalone `ConceptRules::new` gets a private `PlanCache::default`.

*Soundness:* `Adornment` is a bitmask over alphabetically-sorted parameter slots — independent of caller variable names — so `(rule, adornment)` keys plans correctly even though `Adornment::into_environment` binds caller names into the scope. A rule's plan depends only on which of *its* parameters are bound, not the caller's names. Proven by `it_plans_independently_of_caller_variable_names`.

Source: [notes/layered-rule-resolution.md](https://github.com/dialog-db/dialog-db/blob/00b43561a10383175a7f794fee7cb0894b0222e7/notes/layered-rule-resolution.md) at commit `00b43561`.
