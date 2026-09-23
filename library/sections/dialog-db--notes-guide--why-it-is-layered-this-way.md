---
title: Why it is layered this way — absence as a claim about a completely examined range
source: notes/guide.md
source_repo: dialog-db/dialog-db
source_commit: 3cd6607aa9e6f70d65bafe7692e1a52b953e1faf
source_date: 2026-07-01
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query]
status: current
---

> Abstract: The closing rationale for keeping the associative layer scalar and pushing all optionality into one semantic-layer construct — not tidiness, but three concrete wins. **One place to be correct:** the optional lookup's contract (entity bound, mismatch is not absence, claims are checked) lives in one operator rather than being distributed across runtime guards inside every scan where plan reordering could break it. **Types that tell the truth:** set-widening appears in exactly the schemas that can deliver `Absent` (the optional lookup, a concept's optional fields), so the inference's verdict about a variable is also a fact about runtime — derivability ("this premise produces the binding") and absence ("the value may not exist") are kept apart, and only the latter is ever expressed in types. **A future hook:** "we looked at range R for entity E and found nothing" is precisely the event an incremental subscription must record so a later fact in R can flip `Absent` to `Present`, and compiling the optional lookup as a single operator lets that demand-tracking attach to one node instead of reverse-engineering scattered guards. The deeper principle, which also governs negation and the planned replication work: **absence is a claim about a completely examined range** — the engine asserts `Absent` only relative to a bound entity (a finite, checkable range), consumes it only through explicit operators (`Coalesce`), and treats it as matching nothing everywhere else. Design history: `scalar-associative-layer.md`, `optional-fields.md`, `query-engine-design.md`.

Keeping the associative layer scalar and pushing all optionality into one semantic-layer construct is not just tidiness. It buys three things:

1. **One place to be correct.** The optional lookup's contract (entity bound, mismatch is not absence, claims are checked) lives in one operator instead of being distributed across runtime guards inside every scan, where plan reordering could break it.
2. **Types that tell the truth.** Set-widening appears in exactly the schemas that can deliver `Absent` (the optional lookup, a concept's optional fields), so the inference's verdict about a variable is also a fact about runtime. Derivability ("this premise produces the binding") and absence ("the value may not exist") are kept apart; only the latter is ever expressed in types.
3. **A future hook.** "We looked at range R for entity E and found nothing" is precisely the event an incremental subscription must record so a later fact in R can flip `Absent` to `Present`. With the optional lookup compiled as a single operator, the future demand-tracking work attaches to one node instead of reverse-engineering scattered guards.

The deeper principle, which also governs negation and the planned replication work: **absence is a claim about a completely examined range**. The engine only ever asserts `Absent` relative to a bound entity (a finite, checkable range), only consumes it through explicit operators (`Coalesce`), and treats it as matching nothing everywhere else.

For the design history see [`scalar-associative-layer.md`](https://github.com/dialog-db/dialog-db/blob/3cd6607aa9e6f70d65bafe7692e1a52b953e1faf/notes/scalar-associative-layer.md), [`optional-fields.md`](https://github.com/dialog-db/dialog-db/blob/3cd6607aa9e6f70d65bafe7692e1a52b953e1faf/notes/optional-fields.md), and [`query-engine-design.md`](https://github.com/dialog-db/dialog-db/blob/3cd6607aa9e6f70d65bafe7692e1a52b953e1faf/notes/query-engine-design.md).

Source: [notes/guide.md](https://github.com/dialog-db/dialog-db/blob/3cd6607aa9e6f70d65bafe7692e1a52b953e1faf/notes/guide.md) at commit `3cd6607a`.
