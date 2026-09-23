---
title: "Against SQL — Complexity drag: an enormous, incomplete, unportable spec"
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

The synthesis of the three critiques into an industry-level argument. Because SQL is inexpressive, incompressible, and non-porous, it **never developed a library ecosystem**: any regularly-needed functionality gets added to the spec, often with custom syntax, so a new implementation must reimplement the entire ecosystem from scratch. This yields an **enormous spec** (SQL:2016 part 2 alone is 1732 pages — versus JavaScript 2021's 879 and C++ 2020's 1853) that is **not even complete** (~411 occurrences of implementation-defined behavior, including basic features: type inference is undefined, so basic arithmetic differs across sqlite/postgres/mariadb; evaluation order is undefined, so a query can start erroring tomorrow on the same data if the optimizer replans). The complexity has concrete costs: **(1) implementation quality suffers** (Materialize took ~128kloc and ~15-20 engineer-years — SQL→logical-plan alone is ~27kloc, larger than all of differential dataflow — and still ships name-resolution bugs; every SQL database has terrible syntax errors because the grammar has 1732 non-terminals and hundreds of keywords usable as identifiers); **(2) implementation-level innovation is gated** (incremental maintenance, parallel execution, provenance, equivalence checking, query synthesis produce toy-relational-algebra demos then plummet down the missing step to real SQL); **(3) portability is a myth** (no DBMS claims full Core SQL:2016 conformance; the average body of SQL queries needs serious editing to move databases and still won't produce the same answers — so SQL's network effects are far weaker than a programming language's). Even if every listed flaw were fixed, the workaround-complexity already eaten will never leave the spec.

## No ecosystem, so everything goes in the spec

In modern languages a small set of primitives is combined into libraries; a new JavaScript interpreter gets the whole ecosystem for free. Because SQL is inexpressive/incompressible/non-porous it never developed libraries, so new functionality is added to the spec (often with custom syntax) and a new implementation must build the entire ecosystem from scratch — users can't implement it themselves.

## An enormous, incomplete, under-specified spec

SQL:2016 part 2 (of 9) alone is **1732 pages** (JS 2021: 879; C++ 2020: 1853), and still isn't complete: a grep finds **~411 occurrences of implementation-defined behavior**, including basic features. Type inference is undefined, so arithmetic results are implementation-defined — the same expression yields `2402` in sqlite, `2607.93…` in postgres, and a syntax error in mariadb. Evaluation order is undefined, so an operation the spec says should error may or may not, depending on the plan: `select count(foo.bar / 0) from (select 1 as bar) as foo where foo.bar = 0` returns `0` in sqlite/mariadb but `ERROR: division by zero` in postgres — and a query that runs today can error tomorrow on the same data if the optimizer replans. Despite its size the spec is anemic enough that every database bolts on non-standard extensions.

## Quality, innovation, portability

**Quality:** subqueries add needed expressiveness but are usually discouraged because most databases optimize them poorly; Materialize (~128kloc, ~15-20 engineer-years; SQL→logical-plan ~27kloc alone > all of differential dataflow's ~16kloc) passes 7M+ tests yet still finds name-resolution bugs; syntax errors are universally terrible because the grammar has 1732 non-terminals, hundreds of keywords, keywords usable as identifiers, and many ambiguities that make typos into valid-but-nonsensical SQL. **Innovation:** incremental maintenance, parallel execution, provenance, equivalence checking, and query synthesis produce demos on toy relational algebras then disappear down the missing step between toy algebra and real SQL — the PL world has a smooth research→industrial-tool pipeline; the database world doesn't. **Portability:** no DBMS claims full Core SQL:2016 conformance (postgres alone lists dozens of departures); tools that emit SQL still maintain per-dialect backends; users carry some knowledge but no code or libraries — so SQL's network effects are far weaker than a language's, which makes it surprising there's a bounty of programming languages but only one relational database language.

Source: [Against SQL](https://www.scattered-thoughts.net/writing/against-sql) by Jamie Brandon, published 2021-07-09; content SHA-256 `79cb5821969fd6e073171a6f3acd099495ba3e9c081ea201d8f6b2a3698955be`.
