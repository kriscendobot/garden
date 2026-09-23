The job is complete and recorded on the board (`jobs/tada/scholar-ingest-against-sql.md`, `doin` cleared).

## Completion report

**Ingested** Jamie Brandon's essay *Against SQL* (Scattered Thoughts, published 2021-07-09) into the cross-cutting library, curated explicitly as an **outsider opinion** — tagged "opinion, not a normative source" in the source frontmatter/notes and on every section and index row.

**What was created:**
- **Source** `web--brandon-against-sql` — `source_kind: web-essay`, fetched **direct** via `scripts/jobs/fetch-source.sh` (`source_fetched_via=direct`, content SHA-256 `79cb5821…`, the idempotency anchor). No hand-rolled fetch.
- **7 sections** capturing the argument faithfully: overview (thesis: relational model good, SQL bad), inexpressive (sum types, recursion, verbose joins, subquery cliffs), incompressible (variables/functions/expression-substitution), non-porous (language/runtime/interface levels), complexity-drag (spec size, undefined type-inference/eval-order), application-layer (ORM/n+1/GraphQL/Firebase), and after-sql-successor-design (the four-axis prescription).
- **New topic** `query-languages` — the SQL-critique domain was uncovered, so I added a new topic rather than bending `persistence`/`data-structures`. Slug prefix verified with `library-slug-prefix-check.sh --propose`.
- **New concept** `sql-language-critique` + 15 keyword lines.

**Cross-reference to Endo's sqlite material (the job's framing):** the source file, the concept page, and `persistence.md`'s See-also all carry the counterpoint a designer weighing SQLite should find — Endo/ocap-kernel use SQLite as an *embedded, programmatic storage backend* (retention tables, baggage, savepoint crank buffering, the `endo-but-for-bots--llm-designs-daemon-endo-rust-sqlite` typed-host-functions design), not a user-facing SQL query language. So most of the essay's complaints don't bite Endo's narrow single-engine usage, while its porousness prescription ("expose APIs, not strings") actually matches the endo-rust-sqlite choice. Framed as one opinion informing a tradeoff, with the caution to keep the SQLite surface typed and narrow.

**Indexes:** updated `sources/README.md`, `topics/README.md`, `concepts/README.md`, `keywords.md`, and `persistence.md` (cross-filed section row + See-also). **Integrity gate (step 8): PASS.** **Projected indexes (step 9):** `regenerate-sections-index.sh` and `regenerate-topics-counts.sh` both landed and re-verified clean.

**Follow-ups:** none — the single essay fit one cycle; no backlog, no deferred remainder.
