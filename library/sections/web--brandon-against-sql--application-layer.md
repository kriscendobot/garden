---
title: "Against SQL — The application layer: ORM, n+1, GraphQL, Firebase"
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

The essay's second downstream effect. The original relational vision was to query the database directly from the client; the web killed it (SQL is too complex to secure against adversarial input, its cache invalidation is too hard, there's no way to spawn background tasks like image resizing or to talk to the outside world like sending email, and SQL itself was an unappealing target for adding those). So we added an **application layer** — a process in a reasonable language living between database and client — and invented **ORMs** to patch over SQL's incompressibility. This was necessary but costly: ORMs are prone to **n+1 query bugs and feral concurrency** (bad at exactly the two things relational databases are good at — efficient querying and transactions), and the hand-written application layer is error-prone boilerplate (manual REST endpoints, manual cache invalidation, the fine-grained-vs-coarse-grained endpoint dilemma, no way to auto-notify clients when a query result changes). **GraphQL**'s success shows the pain is real and people *do* want rich client-issued queries: versus SQL it's easier to implement, cache, and secure, has union types, follows foreign keys and returns nested results easily, has first-class foreign-code/outside-world hooks, and embeds easily. **Firebase** likewise dropped the whole application layer (streaming client-query updates, built-in access control, client-side caching) and competed with little runtime innovation by recognizing that database + SQL + ORM + application-layer is a historical accident that can be dramatically simplified. The author's warning: the lesson is **not** "relations bad, object-graphs good" — GraphQL *is* still basically relational (Hasura wraps mature relational runtimes). The real win was fixing SQL's flaws and **unbundling the query language from a single monolithic storage/execution engine**, not abandoning relations.

## Why the application layer exists, and what it costs

The relational vision (query directly from the client) died with the web: SQL is hard to secure against adversarial input, its cache invalidation is hard, it can't spawn background tasks or reach the outside world, and it was an unappealing target for adding those. So the application layer (a process in a reasonable language between database and client) plus ORMs (to patch SQL's incompressibility) appeared. Necessary but costly: **ORMs cause n+1 query bugs and feral concurrency** — bad at efficient querying and at transactions, the two core relational features. The application layer itself is error-prone boilerplate: converting queries to REST endpoints by hand, hand-managing cache invalidation, the too-fine (multiple round-trips) vs too-coarse (wasted bandwidth) endpoint dilemma, and no hope of auto-notifying clients when a query result changes.

## GraphQL and Firebase as evidence

GraphQL's success shows people want to issue rich queries directly from the client. Versus SQL it's substantially easier to implement, easier to cache, has a much smaller attack surface, has pattern-compression mechanisms, follows foreign keys and returns nested results easily, has first-class mechanisms for foreign code and the outside world, has a rich type system (with union types), and embeds easily. Firebase (pre-Google) dropped the entire application layer — streaming updates to client-side queries, built-in access control, client-side caching — and competed despite little runtime innovation, by treating database + SQL + ORM + application-layer as a historical accident to be simplified.

## The warning: relations aren't the problem

The NoSQL vibe was "relations bad, objects good"; the risk now is a minor update, "relations bad, object-graphs good." That's a mistake. GraphQL is still essentially relational (it's typically backed by wrappers like Hasura that exploit mature relational runtimes). Its win wasn't doing away with relations but recognizing and fixing the real SQL flaws hobbling relational databases, and unbundling the query language from a single monolithic storage and execution engine.

Source: [Against SQL](https://www.scattered-thoughts.net/writing/against-sql) by Jamie Brandon, published 2021-07-09; content SHA-256 `79cb5821969fd6e073171a6f3acd099495ba3e9c081ea201d8f6b2a3698955be`.
