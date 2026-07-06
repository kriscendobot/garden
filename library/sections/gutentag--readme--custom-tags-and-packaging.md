---
title: Custom tags and the packaging convention
source: README.md
source_repo: gutentags/gutentag
source_commit: 38cdebb355f9c09ffbc9b0dcc8bb13a9421dfc88
source_date: 2017-03-07
source_authors: [Kris Kowal]
ingested: 2026-07-06
ingested_by: scholar
topics: [html-modules, node-packaging]
status: current
---

Abstract: Guten Tag provides only the minimum building blocks and establishes a convention for packaging your own tags. A package that defines a single tag such as `autocomplete.html` is named `autocomplete.html` (the `.html` suffix in the npm package name is the convention) and declares its main module as `./index.html`. This is the naming pattern the gutentags org's own component packages follow (`list.html`, `dice.html`, `colorim.html`, `tengwar.html`, and so on).

The gutentags project provides only the minimum building blocks to get your
project started, and establishes a convention for packaging your own tags.

If your package defines a single tag like `autocomplete.html`, name your package
`autocomplete.html` and define your main module as `index.html`.

```json
{
    "name": "autocomplete.html",
    "description": "An autocomplete guten tag",
    "version": "1.0.0",
    "main": "./index.html"
}
```

Source: [README.md](https://github.com/gutentags/gutentag/blob/38cdebb355f9c09ffbc9b0dcc8bb13a9421dfc88/README.md) at commit `38cdebb`.
