---
source_kind: web-essay
source_url: https://www.scattered-thoughts.net/writing/against-sql
source_author: Jamie Brandon
source_date: 2021-07-09
source_fetched_via: direct
source_content_sha256: 79cb5821969fd6e073171a6f3acd099495ba3e9c081ea201d8f6b2a3698955be
retrieved: 2026-07-06
ingested: 2026-07-06
ingested_by: scholar
section_count: 7
status: current
notes: |
  OUTSIDER OPINION — one external essay, tagged opinion, not a normative source.
  Do not cite as authority; cite as a well-argued external critique. Fetched
  direct (source_fetched_via=direct) via scripts/jobs/fetch-source.sh 2026-07-06;
  idempotency anchor is source_content_sha256 (a live page, mutable in principle —
  re-fetch and compare the hash to detect drift). Curated for the SQL-critique
  domain per job scholar-ingest-against-sql. See "Relevance to Endo's sqlite use"
  below for the deliberate cross-reference to the daemon-persistence /
  endo-rust-sqlite material.
---

## Abstract

*Against SQL* (Jamie Brandon, Scattered Thoughts, 2021-07-09) is a widely-cited **opinion essay** arguing that the **relational model is excellent but SQL — its only widely-used implementation — is a bad language and interface**, along three axes: **inexpressive** (no sum types, linear-only recursion, no portable extension/library mechanism, verbose foreign-key joins, subquery cliffs that force whole-query restructuring), **incompressible** (can't name a scalar without a `select`, column names are part of types and aren't first-class, three disjoint expression kinds that can't be substituted for one another), and **non-porous** (per-database C calling conventions, runtime extensions, and wire protocols are all unportable, so the spec must "eat the whole world"). It develops two downstream effects — a **complexity drag** (a 1732-page-and-still-incomplete spec with ~411 implementation-defined behaviors, undefined type inference and evaluation order, gated implementation-level innovation, mythical portability) and a mandatory **application layer** (ORMs with n+1 bugs and feral concurrency; GraphQL and Firebase as evidence that people want rich client-issued queries) — and closes with a four-axis **prescription for a relational successor** (modern expression-based structure, a simple/complete spec, compressibility via first-class functions/columns, porousness via wasm plugins and API-exposed plans) plus adoption strategies (piggy-back on an existing runtime, or grow from a niche à la sqlite). This is the framing document for the library's `query-languages` topic.

## Relevance to Endo's sqlite use

Curatorial cross-reference (scholar, not the essay's own words), so a designer weighing sqlite in Endo can find the counterpoint. Endo and its neighbours use SQLite as an **embedded, programmatic storage backend**, not as a user-facing query language: the daemon's cross-peer-GC `retention` table and the daemon-persistence four-table retention design ([[persistence]]), the ocap-kernel's SQLite-backed baggage and savepoint-wrapped crank buffering, and the [`endo-but-for-bots--llm-designs-daemon-endo-rust-sqlite`](endo-but-for-bots--llm-designs-daemon-endo-rust-sqlite.md) design that exposes **typed SQLite host functions** (five SQLite types ↔ five canonical passable JS types, passable-by-construction, `$bigint`/`$bytes` tags confined to the FFI layer) to XS workers rather than SQL strings.

Two ways the essay bears on those designs:

- **Most of the essay's complaints don't bite Endo's usage.** The inexpressiveness-for-analytics, cross-vendor-portability, and application-layer-coalescing arguments target SQL as an *interactive query language across many vendors*. Endo pins one embedded engine (rusqlite / node:sqlite), issues a small fixed set of CRUD/retention statements, and never exposes SQL to an adversary or across vendors — so the "eat the whole world" and "portability is a myth" costs are largely paid down by scope.
- **Where it *does* bear, Endo already leans the way the essay prescribes.** The essay's porousness prescription — "expose plans/hints via API, not strings" and "storage/transaction/execution as APIs the server runs [code] against" — is close to the endo-rust-sqlite design's choice to present **typed host functions over a typed value shape** instead of a SQL-string surface, and to the discipline of keeping tag-encoding confined to internal plumbing while values remain passable-by-construction. A designer tempted to widen Endo's SQLite surface into a general SQL-string interface (for a user-facing agent query capability, say) should weigh this essay's interface-level critique: SQL-as-text is hard to secure against adversarial input, hard to embed/validate/escape, and mandates coalescing round-trips — the same reasons the essay gives for why the relational vision needed an application layer. Keep the surface typed and narrow.

Treat this as *one external opinion* informing a tradeoff, not a normative rule.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/web--brandon-against-sql--overview.md) | query-languages, persistence | current |
| [inexpressive](../sections/web--brandon-against-sql--inexpressive.md) | query-languages | current |
| [incompressible](../sections/web--brandon-against-sql--incompressible.md) | query-languages | current |
| [non-porous](../sections/web--brandon-against-sql--non-porous.md) | query-languages | current |
| [complexity-drag](../sections/web--brandon-against-sql--complexity-drag.md) | query-languages | current |
| [application-layer](../sections/web--brandon-against-sql--application-layer.md) | query-languages | current |
| [after-sql-successor-design](../sections/web--brandon-against-sql--after-sql-successor-design.md) | query-languages | current |
