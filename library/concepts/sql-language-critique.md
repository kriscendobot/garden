---
id: sql-language-critique
aliases: [against SQL, SQL critique, SQL is bad, why SQL is bad, inexpressive incompressible non-porous, porous languages, porousness, Some Were Meant For C, Jamie Brandon SQL, Scattered Thoughts SQL, relational model vs SQL, SQL successor, after SQL, SQL COBOL of 2020]
topics: [query-languages, persistence]
---

# sql-language-critique

The thesis of Jamie Brandon's opinion essay *Against SQL* (2021): the **relational model is excellent, but SQL — its only widely-used implementation — is a bad language and interface**, being **inexpressive** (no sum types, linear-only recursion, no portable extension/library mechanism, verbose foreign-key joins, subquery cliffs), **incompressible** (can't name a scalar without a `select`; column names are part of types and aren't first-class; three disjoint expression kinds that can't be substituted), and **non-porous** (per-database C calling conventions, runtime extensions, and wire protocols are all unportable, so the spec must "eat the whole world"). The downstream costs are a **complexity drag** (a 1732-page, still-incomplete, ~411-implementation-defined-behavior spec that gates implementation quality and innovation and makes portability a myth) and a mandatory **application layer** (ORMs, n+1 bugs, GraphQL/Firebase as evidence). One external essay, tagged **opinion** — a well-argued critique, not a normative source.

## Relevance to Endo's SQLite use

Endo and neighbours use SQLite as an **embedded, programmatic storage backend** (daemon retention tables, ocap-kernel baggage / savepoint crank buffering, and the endo-rust-sqlite design's **typed host functions** over a typed passable value shape), *not* as a user-facing SQL-string query language. So most of the essay's complaints (analytics expressiveness, cross-vendor portability, application-layer coalescing) don't bite Endo's narrow single-engine usage — while the essay's porousness prescription ("expose APIs, not strings") actually matches the endo-rust-sqlite choice of typed host functions over a SQL surface. The counterpoint a designer should take from it: keep the SQLite surface **typed and narrow**; do not widen it into a general SQL-string interface (SQL-as-text is hard to secure against adversarial input and mandates coalescing round-trips). See the [source's "Relevance to Endo's sqlite use"](../sources/web--brandon-against-sql.md) note.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [web--brandon-against-sql--overview](../sections/web--brandon-against-sql--overview.md) | Thesis: relational model good, SQL inexpressive/incompressible/non-porous; two downstream effects. |
| [web--brandon-against-sql--inexpressive](../sections/web--brandon-against-sql--inexpressive.md) | Can't-express (sum types, recursion, extensions), verbose (fk joins), fragile (subquery cliffs). |
| [web--brandon-against-sql--incompressible](../sections/web--brandon-against-sql--incompressible.md) | Variables, functions, and expression substitution all frustrated by SQL. |
| [web--brandon-against-sql--non-porous](../sections/web--brandon-against-sql--non-porous.md) | Unportable extensions at language, runtime, and interface levels. |
| [web--brandon-against-sql--complexity-drag](../sections/web--brandon-against-sql--complexity-drag.md) | Enormous, incomplete, under-specified spec; quality/innovation/portability costs. |
| [web--brandon-against-sql--application-layer](../sections/web--brandon-against-sql--application-layer.md) | ORMs, n+1, GraphQL, Firebase; unbundle language from engine, don't abandon relations. |
| [web--brandon-against-sql--after-sql-successor-design](../sections/web--brandon-against-sql--after-sql-successor-design.md) | Four-axis prescription for a relational successor + adoption strategies. |

## See also

- [[persistence]] — where Endo/ocap-kernel actually use SQLite (the storage axis this critique is the language counterpoint to).
- The [`endo-but-for-bots--llm-designs-daemon-endo-rust-sqlite`](../sources/endo-but-for-bots--llm-designs-daemon-endo-rust-sqlite.md) source — typed SQLite host functions for XS workers; the design that leans the way this essay's porousness prescription points (APIs over strings).
