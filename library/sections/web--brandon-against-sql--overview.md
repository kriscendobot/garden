---
title: "Against SQL — thesis: the relational model is great, SQL is not"
source_kind: web-essay
source_url: https://www.scattered-thoughts.net/writing/against-sql
source_content_sha256: 79cb5821969fd6e073171a6f3acd099495ba3e9c081ea201d8f6b2a3698955be
source_author: Jamie Brandon
source_date: 2021-07-09
ingested: 2026-07-06
ingested_by: scholar
topics: [query-languages, persistence]
status: current
notes: "OUTSIDER OPINION — one external essay, tagged opinion, not a normative source. Critiques SQL-as-a-language/interface, not the relational model, which the author praises."
---

## Abstract

Jamie Brandon's thesis: the **relational model** is excellent (a shared universal data model, normalization, physical data independence, declarative constraints, no false data dependencies — which makes it a good match for modern hardware, auto-parallelizable, and amenable to incremental maintenance), **but SQL — the only widely-used implementation of that model — is inexpressive, incompressible, and non-porous.** These are not a constant 20%-overhead tax; they have dramatic downstream effects: complexity is a massive drag on runtime/tooling quality and innovation, and the need for an application layer with hand-written database↔client coordination renders useless most of the best features of relational databases. The core message: there is potentially huge value in **replacing SQL** and in rethinking where the lines are drawn between databases, query languages, and programming languages. This is an opinion essay; it is the framing document for the three critiques (inexpressive / incompressible / non-porous), the complexity-drag argument, the application-layer diagnosis, and the successor-design prescription that follow.

## The relational model is great

A shared universal data model allows cooperation between programs written in many different languages, running on different machines and with different lifespans. Normalization allows updating data without worrying about forgetting to update derived data. Physical data independence allows changing data-structures and query plans without changing all your queries. Declarative constraints clearly communicate application invariants and are automatically enforced. Unlike imperative languages, relational query languages don't have false data dependencies created by loop counters and aliasable pointers. This makes relational languages a good match for modern machines (data can be rearranged for compact layouts and compression; operations reordered for cache locality, pipeline-friendly hot loops, SIMD), amenable to automatic parallelization, and amenable to incremental maintenance.

## But SQL is the only widely-used implementation of it, and it is:

- **Inexpressive** — many simple types and computations can't be expressed at all; others require far more typing than they need to; and the structure is fragile (small changes to a computation can force large changes to the code).
- **Incompressible** — SQL frustrates the programming-101 tools of variables, functions, and expression substitution.
- **Non-porous** — the mechanisms databases use to extend themselves (new types, functions, indexes, protocols) are almost never portable, so the SQL spec is left trying to "eat the whole world."

The two downstream effects the essay develops: (1) **complexity is a massive drag** on quality and innovation in runtime and tooling; (2) the mandatory **application layer** — hand-written coordination between database and client — renders useless most of the best features of relational databases.

Source: [Against SQL](https://www.scattered-thoughts.net/writing/against-sql) by Jamie Brandon, published 2021-07-09; content SHA-256 `79cb5821969fd6e073171a6f3acd099495ba3e9c081ea201d8f6b2a3698955be`.
