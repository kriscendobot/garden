---
source: README.md
source_repo: gutentags/koerper
source_commit: 16e26cc0c08382a22d0d6e99d562d140b5bcf18a
source_date: 2016-10-26
source_authors: [Kris Kowal]
ingested: 2026-07-06
ingested_by: scholar
section_count: 2
status: current
---

The README of Koerper (`gutentags/koerper`), the virtual DOM that gives Guten Tag its container-free *body nodes*. Built on Wizdom, Koerper adds a "body" node type and proxies attributes and event listeners through the actual document, letting a component encapsulate a region of a document without a wrapper element — the enabling substrate behind the gutentag README's "body nodes and no wrapper element" and "virtual document (Koerper)" sections. The document covers the motivation (why body nodes matter for `repeat`/`reveal` and flex-box peers) and the body-node API (`new Document(actualElement)`, `createBody()`, nesting, and container-free text interpolation).

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/koerper--readme--overview.md) | virtual-dom, html-modules | current |
| [body-node-api](../sections/koerper--readme--body-node-api.md) | virtual-dom, html-modules | current |
