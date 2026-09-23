---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-06T13:42:24Z
---
result: scholar-ingest-against-sql — ingested the "Against SQL" essay into the library

**Source ingested.** `web--brandon-against-sql` (Jamie Brandon, *Against SQL*,
Scattered Thoughts, 2021-07-09) — `source_kind: web-essay`, fetched **direct**
via `fetch-source.sh` (`source_fetched_via=direct`, content SHA-256 `79cb5821…`),
idempotency anchor is the content hash. Curated explicitly as an **outsider
opinion** (tagged opinion in source frontmatter/notes and on every section and
index row), not a normative source. **7 sections** written:
overview, inexpressive, incompressible, non-porous, complexity-drag,
application-layer, after-sql-successor-design.

**New topic.** Added `query-languages` (the query-language / database-interface
design axis — SQL and its critics, datalog, GraphQL, dataframes). The
SQL-critique domain was not covered by the existing taxonomy, so a new topic was
added rather than bending `persistence`/`data-structures`. Slug prefix verified
with `library-slug-prefix-check.sh --propose` (new host `scattered-thoughts.net`,
bare `web--` prefix, OK).

**Concept + keywords.** New concept page `sql-language-critique` (aliases:
against SQL, porousness, Some Were Meant For C, SQL successor, …) with a
`## Relevance to Endo's SQLite use` framing; 15 keyword lines appended to
`keywords.md`.

**Cross-reference to Endo's sqlite material (the job's framing).** The overview
section is cross-filed under `persistence`; the source file, the concept page,
and `persistence.md`'s See-also carry the counterpoint a designer weighing
SQLite should read: Endo/ocap-kernel use SQLite as an **embedded, programmatic
storage backend** (daemon retention tables, baggage, savepoint crank buffering,
the `endo-but-for-bots--llm-designs-daemon-endo-rust-sqlite` **typed host
functions** design) — not as a user-facing SQL query language. So most of the
essay's complaints (analytics expressiveness, cross-vendor portability,
application-layer coalescing) don't bite Endo's narrow single-engine usage, while
the essay's porousness prescription ("expose APIs, not strings") actually matches
the endo-rust-sqlite choice of typed host functions over a SQL surface. Framed as
*one external opinion informing a tradeoff*, with the explicit caution: keep the
SQLite surface typed and narrow; don't widen it into a general SQL-string
interface.

**Indexes touched (hand-maintained):** `sources/README.md` (web-essays table
row), `topics/README.md` (Index row), `concepts/README.md` (bullet),
`keywords.md`, `persistence.md` (section row + See-also).

**Integrity gate (step 8): PASS.** `library-link-check.sh --source-slug
web--brandon-against-sql` → OK (every section-table target, sections/README block
row, and the endo-rust-sqlite cross-ref resolve to committed files);
`regenerate-topics-counts.sh --check` → current.

**Projected indexes regenerated (step 9):** `regenerate-sections-index.sh` and
`regenerate-topics-counts.sh` both landed (sections index picked up the 7 new
sections; topics counts reconciled the new `query-languages` count and the
`persistence` +1). Re-verified clean at the final tip.

**Follow-on jobs:** none — the single essay fit in one cycle (well under budget).
Backlog: none.

Self-improvement: The `query-languages` topic is now a seeded home for future
query-language material (datalog, GraphQL, dataframe-embedded relational APIs);
if that domain grows, the essay's `sql-language-critique` concept and the
`persistence` cross-link are the anchor. No structural lesson to route to
mentor/liaison this cycle — the web-essay conventions and `fetch-source.sh`
covered the ingest cleanly.
