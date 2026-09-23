---
title: "Against SQL — Non-porous: language, runtime, and interface levels"
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

The third critique, borrowing the term **porous** from Stephen Kell's *Some Were Meant For C* (C endures because of its extreme openness to other systems — foreign memory, FFI, dynamic linking — versus managed languages that wall themselves off). Non-porous languages must "eat the whole world" to succeed; porous ones interoperate with what already exists. Applied to SQL databases: individual databases are often porous, but the mechanisms are **almost never portable**, so extensions can't be shared and the spec is still left trying to eat the whole world. Three levels: **(1) Language level** — new types/functions can be defined via C, but the C interface and calling convention are *not* in the spec, so they aren't portable. **(2) Runtime level** — new index types, storage methods (e.g. PostGIS), and optimizer hints are database-specific and deeply entangled with runtime design (SQL/MED for querying non-owned data exists but isn't widely/portably implemented); notably, if these *were* portable much of the spec would not need to exist. **(3) Interface level (the worst)** — every database has a different wire protocol, all ordered/synchronous, returning one relation at a time, many without pipelining, nested structures long unsupported and still verbose; this **mandates an application layer** to coalesce multiple round-trips and reassemble nested structure by hand, duplicating what the database is meant to do. Metadata comes back as unspecified text with no parser; queries are submitted as the same complex text the programmer types (hard to embed/validate/escape, and parameters don't cover varying query *structure*); and databases are monolithic — you can't send a query plan to Postgres or call its planner as a library (cf. the value `pg_query` unlocks).

## Language level

Most databases have language-level escape hatches to define new types/functions in a mature language (usually C). The SQL-side `CREATE FUNCTION ... LANGUAGE C` declaration is in the spec, but the C interface and calling convention (`PG_MODULE_MAGIC`, `PG_FUNCTION_INFO_V1`, `PG_GETARG_INT32`, ...) are not — so these are not portable across databases.

## Runtime level

Runtime-level extension mechanisms create new index types and storage methods (e.g. PostGIS) and supply optimizer hints; these aren't portable, and at this level it's hard to see how they could be, since they entangle with runtime design decisions. Worth noting: if they *were* portable, much of the SQL spec wouldn't need to exist. SQL/MED (querying data the database doesn't own) exists in the spec but isn't widely or portably implemented.

## Interface level

The status quo here is much worse. Each database has a completely different interface protocol; the familiar ones are ordered, synchronous, and return only one relation at a time, and many don't even support pipelining. SQL long lacked any way to return nested structures, and even with JSON it's incredibly verbose. So returning, say, user profiles *and* their followers means multiple round-trips — infeasible over distance — which **practically mandates an application layer** whose main job is to coalesce multiple queries and reassemble their nested structure with hand-written joins, duplicating work the database should do well. Protocols return metadata as text in an unspecified format with no parser (even with a binary value protocol, metadata is often a 1-row 1-column string), making external tooling harder than necessary (e.g. parsing plans to verify no table scans). SQL is submitted as text identical to what the programmer types; the complex syntax makes it hard for other languages to embed, validate, escape, and type-infer (query parameters aren't a panacea — you often need to vary query *structure*, not just values). And databases are monolithic: you can't send a query plan directly to Postgres, or call the planner as a library for operational forecasts. `pg_query` hints at how much could be gained by exposing more of the innards.

Source: [Against SQL](https://www.scattered-thoughts.net/writing/against-sql) by Jamie Brandon, published 2021-07-09; content SHA-256 `79cb5821969fd6e073171a6f3acd099495ba3e9c081ea201d8f6b2a3698955be`.
