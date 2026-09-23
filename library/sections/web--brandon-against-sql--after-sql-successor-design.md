---
title: "Against SQL — After SQL? Prescriptions for a relational successor"
source_kind: web-essay
source_url: https://www.scattered-thoughts.net/writing/against-sql
source_content_sha256: 79cb5821969fd6e073171a6f3acd099495ba3e9c081ea201d8f6b2a3698955be
source_author: Jamie Brandon
source_date: 2021-07-09
ingested: 2026-07-06
ingested_by: scholar
topics: [query-languages]
status: current
---

## Abstract

The constructive close. The relational idea of modelling data with a **declarative, disorderly language** is still valuable — perhaps more than ever given hardware trends — so what should a successor learn from SQL's mistakes? Roughly, negate every listed mistake while retaining the ability to produce and optimize query plans, along four axes. **(1) Start with the structure modern languages converged on:** everything is an expression; compact variable/function syntax; few keywords (most things are stdlib functions, not builtin syntax); one explicit type system rather than disjoint scalar-vs-table-expression syntax; the substitution guarantee (replace any expression with another of equal type and value); a non-implementation-specific system for distributing/loading/**unloading** libraries. **(2) Keep the spec simple and complete:** simple denotational semantics; fully specified type inference and error semantics; an experienced engineer should be able to build a slow-but-correct interpreter in a week or two; ship a model-checker/theorem-prover encoding to test optimizations; lean on **wasm as the extension language** to avoid re-speccing arithmetic/strings. **(3) Make it compressible:** functions take relations and other functions (erasable by specialization before planning, à la Rust/Julia); polymorphic relation functions; first-class column names/orderings/collations/window specs (staging à la Zig comptime where planning-time constancy is needed); compact syntax for simple joins; true recursion/fixpoints. **(4) Make it porous:** wasm plugins for new types/functions/indexes/plan-operators (calling convention in the spec); expose plans/hints via API not strings; spec both human and tooling encodings (text vs binary, like wasm) with an embeddable parser/type-inferencer; ergonomic nested-structure return (or at least multiple relations); a verifiable "runs in reasonable time" subset; GraphQL-like authorization rules to expose that subset to clients. Plus **better layering** (embeddable libraries à la pg_query; storage/transaction/execution as APIs the server runs wasm against; a distributable parser/planner/compiler). Adoption is the hard part: taking the whole stack at once is risky (RethinkDB died, Datomic was acquihired); safer routes are piggy-backing on an existing runtime (EdgeDB on postgres, Logica compiling to SQL) or growing from an untapped niche (à la sqlite starting as a Tcl extension), then expanding the runtime outward.

## The idea is still valuable; negate the mistakes

Modelling data with a declarative, disorderly language remains valuable (more so given hardware trends). We can get far by negating every mistake while retaining plan production/optimization, along four axes.

**Start with the structure modern languages converged on.** Everything is an expression; variables and functions have compact syntax; few keywords (most things stdlib functions, not builtin syntax); an explicit type system rather than disjoint scalar-vs-table syntax; always able to replace an expression with another of the same type and value; a non-implementation-specific system for distributing and loading (and *unloading*) libraries.

**Keep the spec simple and complete.** Simple denotational semantics for the core; completely specified type inference and error semantics; an experienced engineer should throw together a slow-but-correct interpreter in a week or two; ship a model-checker/theorem-prover encoding of the semantics (to test optimizations) *with* the spec; lean on **wasm as the extension language** to avoid speccing arithmetic/strings if defined as a library over a bits type.

**Make it compressible.** Functions that take relations and other functions as arguments (erasable by specialization before planning, à la Rust/Julia); functions that operate on relations polymorphically (without fixing columns/types at definition); first-class column names, orderings, collations, window specifications (staging à la Zig comptime if planning-time-constant); compact syntax for simple joins (snowflake schemas, graph traversal); true recursion/fixpoints (for iterative algorithms like parsing).

**Make it porous.** New types/functions/indexes/plan-operators via wasm plugins (calling convention in the spec); expose plans/hints via API, not strings; spec both a human-friendly and a tooling-friendly encoding (text vs binary like wasm) and ship an embeddable parser/type-inferencer; make returning nested structures (JSON) ergonomic, or at least allow returning multiple relations; a subset easily verified to run in reasonable time (no table scans, no nested loops); GraphQL-like authorization rules to expose that subset to clients.

**Better layering.** Separate as much as possible into embeddable libraries (à la pg_query); expose storage, transaction, execution as APIs, so the server just receives and executes wasm against them; distribute the parser/planner/compiler as a library so clients can produce wasm with modified versions.

## Adoption strategies

Getting people to use it is harder than designing it. Tackling the whole stack at once is challenging (RethinkDB died; Datomic lives but the company was acquihired; Neo4j, oddly, is catnip for investors). Safer: piggy-back on an existing runtime first (EdgeDB on the postgres runtime, Logica compiling to SQL, GraphQL compiling to many query languages). Or find an untapped relational-ish niche (pandas → data cleaning; Datascript → front-end database; Bloom → distributed-systems algorithms; Semmle → code analysis; embedded databases à la fossil's sqlite use; incremental state→UI functions; querying as an interface to complex program state) and expand the runtime outward — the way sqlite started as a Tcl extension and became the de-facto embedded database, a data-publishing format, and a data-processing backend.

## FAQ (selected)

The author rebuts common objections: JSON-in-the-database matters because many use-cases must return disparate data that doesn't fit one relation (a dashboard, a logged-in landing page) without a coalescing side-process; "that belongs in the application layer" begs the question (if the query language isn't the right tool for querying data, that's the problem); SQL isn't "the natural way" to express relational queries (LINQ, Spark, Flink, Kafka Streams, pandas, dataframes are expression-based language-embedded relational approaches; Logica, LogiQL, differential datalog, Semmle, Datomic are commercially-deployed datalog-based ones); transactions/data-independence/plan-optimization come from the **relational model**, not from SQL (LogicBlox, Datomic have them with far simpler, more orthogonal languages); and while JavaScript improved dramatically toward cross-vendor compatibility, SQL vendors have no incentive to make a "SQL STRICT MODE" because SQL is their moat. It closes with Michael Stonebraker: "My biggest complaint about System R is that the team never stopped to clean up SQL... SQL will be the COBOL of 2020."

Source: [Against SQL](https://www.scattered-thoughts.net/writing/against-sql) by Jamie Brandon, published 2021-07-09; content SHA-256 `79cb5821969fd6e073171a6f3acd099495ba3e9c081ea201d8f6b2a3698955be`.
