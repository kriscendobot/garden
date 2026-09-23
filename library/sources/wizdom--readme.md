---
source: README.md
source_repo: gutentags/wizdom
source_commit: 35906edce3902e947c1ea73308f9c70310c960c0
source_date: 2015-03-14
source_authors: [Kris Kowal]
ingested: 2026-07-06
ingested_by: scholar
section_count: 2
status: current
---

The README of Wizdom (`gutentags/wizdom`), the minimal DOM subset Koerper builds its body-node virtual document on. Wizdom is element/text/comment nodes with parent/child/sibling links and a NamedNodeMap of attributes, deliberately doing nothing to protect its own integrity — a light-weight fully linked mutable hierarchy. The document covers the node model and the surrounding utilities: constructing documents from HTML text via a parse5 driver (`wizdom/parse5`) and serializing them back via `wizdom/inner-text`, `wizdom/inner-html`, and `wizdom/outer-html`.

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/wizdom--readme--overview.md) | virtual-dom | current |
| [parsing-and-stringifying](../sections/wizdom--readme--parsing-and-stringifying.md) | virtual-dom | current |
