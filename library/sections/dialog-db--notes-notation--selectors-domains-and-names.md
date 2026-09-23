---
title: Selectors, domains, and names
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

> Abstract: The lexical rules for naming relations. An attribute **selector** is the combined `domain/name` string, whose total length must not exceed **64 bytes** (the storage-layer encoding budget). A **domain** groups related attributes and may use dot-separated segments for hierarchy, following a reversed-domain-name convention to avoid collisions (`^[a-z][a-z0-9.-]*[a-z0-9]$|^[a-z]$`). A **name** is lowercase kebab-case with no dots (`^[a-z][a-z0-9-]*[a-z0-9]$|^[a-z]$`). In the formal notation all **references** are structural (definitions inlined, nothing to look up); a relation is nonetheless referenced by its qualified `domain/name` form with `/` as separator, still bound by the 64-byte selector budget.

Consolidates four small building blocks of the formal notation (selector, domain, name, references), preserving each heading inline for grep-based lookup.

### Selector

An attribute selector is the combined `domain/name` string. The total length must not exceed **64 bytes**, which is the storage-layer encoding budget.

### Domain

A domain groups related attributes. Domains may use dot-separated segments for hierarchical organization, following a reversed domain name convention to avoid collisions between independently developed schemas.

**Rules:** lowercase ASCII letters, digits, hyphens, and dots; must start with a letter; must not end with a dot or hyphen; at least one character.

```
person
diy.cook
io.gozala.person
org.example.hr
```

**Regexp:** `^[a-z][a-z0-9.-]*[a-z0-9]$|^[a-z]$`

### Name

The name component of an attribute uses lowercase kebab-case.

**Rules:** lowercase ASCII letters, digits, and hyphens (no dots); must start with a letter; must not end with a hyphen; at least one character.

```
quantity
ingredient-name
recipe-step
```

**Regexp:** `^[a-z][a-z0-9-]*[a-z0-9]$|^[a-z]$`

### References

In the formal notation, all references are structural: attributes are described inline by their full definition `{ the, as, cardinality }` and concepts by their full set of constituent attributes. There are no names to look up; everything is self-describing.

A relation is referenced by its qualified form `domain/name` with `/` as separator. The combined selector must not exceed 64 bytes:

```
person/name
diy.cook/quantity
diy.cook/ingredient-name
io.gozala.person/name
```

Source: [notes/notation.md](https://github.com/dialog-db/dialog-db/blob/bde506d786a080291051b2e069cabe38cda769b2/notes/notation.md) at commit `bde506d7`.
