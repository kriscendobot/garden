---
title: Overview — a very small subset of the DOM
source: README.md
source_repo: gutentags/wizdom
source_commit: 35906edce3902e947c1ea73308f9c70310c960c0
source_date: 2015-03-14
source_authors: [Kris Kowal]
ingested: 2026-07-06
ingested_by: scholar
topics: [virtual-dom]
status: current
---

Abstract: Wizdom implements a very small subset of the Document Object Model — element, text, and comment nodes that maintain parent/child/sibling references through `appendChild`, `insertBefore`, and `removeChild`; each node carries an `attributes` NamedNodeMap with `getAttribute`/`setAttribute`/`removeAttribute` (the map itself exposing `getNamedItem`/`setNamedItem`/`removeNamedItem`/`item` and a maintained `length`). Unlike a native implementation, Wizdom nodes do nothing to protect their integrity — the entire reference graph is mutable properties, which affords a certain simplicity. Wizdom is the DOM substrate Koerper builds its body-node virtual document on, and is useful for any project that calls for a light-weight fully linked mutable hierarchy.

> The only true wisdom is knowing you know nothing.
> — Socrates

Wizdom implements a very small subset of the Document Object Model. A Wizdom Document has element, text, and comment nodes, all of which maintain their parent, child, and sibling references through the `appendChild`, `insertBefore`, and `removeChild` methods. Each node has an attributes NamedNodeMap and the `getAttribute`, `setAttribute`, and `removeAttribute` methods. The NamedNodeMap implements `getNamedItem`, `setNamedItem`, `removeNamedItem`, `item`, and maintains its `length` property so you can enumerate attributes. Unlike a native implementation, wizdom nodes do nothing to protect their integrity and its entire reference graph is mutable properties, which afford a certain simplicity.

```js
"use strict";
var Document = require("wizdom");
var document = new Document();
document.documentElement = document.createElement("HTML");
```

Wizdom is useful for any project that calls for a light-weight fully linked mutable hierarchy.

Source: [README.md](https://github.com/gutentags/wizdom/blob/35906edce3902e947c1ea73308f9c70310c960c0/README.md) at commit `35906ed`.
