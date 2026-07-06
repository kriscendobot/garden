---
id: dialog-notation
aliases: [formal notation, abbreviated notation, notation, punning, structural reference, implicit addressing, relative addressing, attribute selector, domain slash name, "domain/name", 64-byte selector, reversed domain name, attribute address]
topics: [datalog-query]
---

# dialog-notation

Dialog's two one-to-one notations for authoring domain models (attributes, concepts, deductive rules). **Formal notation** is the explicit representation — JSON or YAML, every field explicit, every reference structural (attributes inlined as `{ the, as, cardinality }`, concepts as their full attribute set, nothing to look up); its normative shape is the JSON schema `notes/notation/schema.json`. **Abbreviated notation** is a YAML-only human-authoring shorthand that adds an addressing scheme (implicit: label ⇒ name, enclosing key ⇒ domain; relative: `.` = same name/domain, `.name` = explicit name/inferred domain; fully-qualified `domain/name`), structural field inference, and **punning** (`name: .` reuses the same-named attribute under the current domain); it expands into the formal notation. An attribute **selector** is the combined `domain/name` string, capped at 64 bytes (the storage encoding budget); domains follow a reversed-domain-name convention. Identity is structural throughout — `(the, type, cardinality)` for attributes, the sorted attribute set for concepts — with `the` the one nominal component carrying semantic intent.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [dialog-db--notes-notation--overview](../sections/dialog-db--notes-notation--overview.md) | The two one-to-one notations: formal (explicit, structural) vs abbreviated (YAML shorthand that expands into formal). |
| [dialog-db--notes-notation--structural-identity](../sections/dialog-db--notes-notation--structural-identity.md) | Attributes and concepts are structurally identified; `the` is the nominal escape hatch that keeps otherwise-identical attributes distinct. |
| [dialog-db--notes-notation--selectors-domains-and-names](../sections/dialog-db--notes-notation--selectors-domains-and-names.md) | The 64-byte selector budget, the domain and name regexps, and structural references in the formal notation. |
| [dialog-db--notes-notation--abbreviated-addressing](../sections/dialog-db--notes-notation--abbreviated-addressing.md) | Implicit, relative, and fully-qualified addressing modes in the abbreviated notation. |
| [dialog-db--notes-notation--abbreviated-attribute](../sections/dialog-db--notes-notation--abbreviated-attribute.md) | Writing attributes in the abbreviated notation: `the: ./name` and `the: domain/.` overrides. |
| [dialog-db--notes-notation--abbreviated-concept](../sections/dialog-db--notes-notation--abbreviated-concept.md) | Attribute references, punning (`name: .`), and inline attributes in the abbreviated concept notation. |
| [dialog-db--notes-notation-schema--json-schema](../sections/dialog-db--notes-notation-schema--json-schema.md) | The JSON Schema `$defs` graph that normatively defines the formal notation. |

## See also

- [[deductive-rule]] — the `deduce`/`when`/`unless` composition the notation also expresses.
- [[fact-triple]] — the `{the, of, is, cause}` claim the notation's assertions become.
- [[record-value]] — the value side of an attribute; the notation's `as` scalar-type enum.
- [[dialog-db]] — the database whose domain models this notation describes.
