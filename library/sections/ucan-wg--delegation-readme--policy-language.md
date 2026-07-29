---
title: Policy language, selectors, and validation
source: README.md
source_repo: ucan-wg/delegation
source_commit: 1cb32dbc9d4d15a23bf9844a02515d760b81e816
source_date: 2026-07-08
source_authors: [Brooklyn Zelenka, Irakli Gozalishvili, Philipp Kruger]
ingested: 2026-07-29
ingested_by: scholar
topics: [ucan-authorization, capability-security, patterns]
status: current
---

> Abstract: UCAN Delegation's `pol` language is a deliberately bounded predicate language over invocation `args`: top-level predicates are implicitly conjoined; equality, numeric comparison, and one-wildcard glob matching compose with `and`/`or`/`not` and `all`/`any`; jq-inspired selectors navigate IPLD values without jq's computation, recursion, or streams. Missing or mistyped selections fail predicates rather than throwing, so offline validation is deterministic and total.

Policies constrain the eventual invocation arguments and are trees of tuple-shaped statements. Equality is deep IPLD equality; numeric comparisons equate numerically equivalent forms such as `1` and `1.0`; and `like` admits only `*` as wildcard, with escaped literal stars. Quantifiers range over array elements or map values, nesting as needed.

Selectors support identity, dotted and quoted map fields, collection values, positive and negative indices, slices, and an idempotent optional marker. They resolve left to right, must begin or end with one dot, and may select bytes as byte arrays. Unlike jq, they have no pipes, arithmetic, regexes, assignment, recursive descent, or value streams; optional failure returns `null`.

Validation substitutes arguments and evaluates predicates in either order. An unresolved selector or incompatible comparison is false, never an exception; arguments are taken verbatim, including arrays and objects. Flexible or side-effectful checks belong outside this syntactic language.

Source: [`README.md`](https://github.com/ucan-wg/delegation/blob/1cb32dbc9d4d15a23bf9844a02515d760b81e816/README.md) at commit `1cb32dbc`.
