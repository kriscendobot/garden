---
title: dialog-query — overview and information model
source: rust/dialog-query/README.md
source_repo: dialog-db/dialog-db
source_commit: ebd8f73989dd785697e58d31495dbb056c9f6c8b
source_date: 2026-07-01
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query]
status: current
notes: Crate-doc (Rust API) companion to the notes/concept.md and notes/architecture-overview.md prose; this file's value is the concrete Rust surface (derive macros, Session/Query, install), cross-referenced there.
---

Abstract: `dialog-query` is Dialog's Datalog-inspired query engine, operating over the associative model's claim store to provide typed pattern matching, deductive rules, and built-in formulas. Its information model has two layers: an **associative** layer that stores and replicates information as an immutable, append-only history of claims with no enforced schema, and a **semantic** layer that provides modeling primitives (attributes, concepts, rules, formulas) for describing a domain, whose statements are decomposed into claims in the associative model. This is the crate-doc (Rust API) face of the model the `notes/concept.md` and `notes/architecture-overview.md` prose describes conceptually.

# dialog-query

Datalog-inspired query engine for Dialog. Operates over the associative model's claim store, providing typed pattern matching, deductive rules, and built-in formulas.

For a worked explanation of optional fields, `Absent`, negation, and the rationale behind the scalar/semantic layering, see the guide (`notes/guide.md`, ingested as the `dialog-db--notes-guide--*` sections).

## Information Model

The information model is layered:

- **Associative.** Stores and replicates information as an immutable, append-only history of claims. There is no schema enforced at this level. (See § Claims and § Relations.)
- **Semantic.** Provides modeling primitives for describing a domain: attributes, concepts, rules, and formulas. Statements made here are decomposed into claims in the associative model. (See § Attributes, § Concepts, § Deductive Rules, § Formulas.)

The associative layer is where facts live and replicate; the semantic layer is where a domain is *modeled*, reading typed shapes back out of the raw claims (schema-on-read). The rest of this crate doc walks the two layers bottom-up.

Source: [rust/dialog-query/README.md](https://github.com/dialog-db/dialog-db/blob/ebd8f73989dd785697e58d31495dbb056c9f6c8b/rust/dialog-query/README.md) at commit `ebd8f73`.
