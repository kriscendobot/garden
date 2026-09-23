---
title: Two notations for domain models
source: notes/notation.md
source_repo: dialog-db/dialog-db
source_commit: bde506d786a080291051b2e069cabe38cda769b2
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query]
status: current
---

> Abstract: Dialog describes domain models in two one-to-one-corresponding notations. **Formal notation** is the explicit representation (JSON or YAML, both interchangeable) in which every field is explicit and every reference is structural — attributes and concepts are described inline by their full definition, with no names to look up; the JSON schema (`notes/notation/schema.json`) defines it. **Abbreviated notation** is a YAML-only shorthand for human authoring that adds an addressing scheme, implicit field inference from document structure, and punning; it is an intermediate representation that expands into the formal notation. This is the conceptual anchor for the whole notation reference.

Dialog uses two notations for describing domain models.

- **Formal notation** is the explicit representation. It can be expressed in either JSON or YAML; both forms correspond one to one. Every field is explicit and every reference is structural. The JSON schema defines the formal notation.

- **Abbreviated notation** is a YAML-only shorthand for human authoring. It introduces an addressing scheme, implicit field inference from document structure, and punning. The abbreviated notation is an intermediate representation that expands into the formal notation.

In the formal notation all references are structural: attributes are described inline by their full definition `{ the, as, cardinality }` and concepts by their full set of constituent attributes. There are no names to look up; everything is self-describing. The abbreviated notation trades that explicitness for authoring convenience — inferring `the`, `cardinality`, and domains from the enclosing document structure — and every abbreviated form has a defined expansion into the formal form.

Source: [notes/notation.md](https://github.com/dialog-db/dialog-db/blob/bde506d786a080291051b2e069cabe38cda769b2/notes/notation.md) at commit `bde506d7`.
