---
title: Functional Reactive Bindings (overview)
source: README.md
source_repo: kriskowal/frb
source_commit: 131db347355789cf2dbb79e49b10881d9716b449
source_date: 2013-09-15
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [reactive-bindings]
status: current
---

> Abstract: `frb` (Functional Reactive Bindings) gives the illusion that two object properties are the same value: changing one changes the other. Beyond simple property mirroring it binds long property paths and the *contents of collections*, and incrementally maintains chains of queries (map, flatten, sum, average, sorted, group) so derived state stays consistent as inputs change. A binding is declared with a tiny query language and a direction operator (`<-` one-way, `<->` two-way). FRB was extracted from the Montage web-application framework.

In their simplest form, bindings provide the illusion that two objects have the same property: changing the property on one object causes the same change in the other. This is useful for coordinating state between views and models and among other entangled objects (type into a text field, the same text lands in the database record).

```javascript
bind(object, "a.b", {"<->": "c.d"});
```

Functional Reactive Bindings go farther. They can gracefully bind long property paths and the *contents of collections*. They can incrementally update the results of chains of queries including maps, flattened arrays, sums, and averages, and add and remove elements from sets based on changes to a flag. FRB makes it easy to incrementally ensure consistent state.

```javascript
bind(company, "payroll", {"<-": "departments.map{employees.sum{salary}}.sum()"});
bind(document, "body.classList.has('dark')", {"<-": "darkMode", source: viewModel});
```

FRB is built from a combination of functional and generic building blocks, which (in the project's framing) makes it reliable, easy to extend, and easy to maintain. It is a CommonJS package suitable for Node.js or the browser. The fundamental promise of a binding is that it can be recursively detached from everything it observes by calling the cancel function it returns.

Source: [README.md](https://github.com/kriskowal/frb/blob/131db347355789cf2dbb79e49b10881d9716b449/README.md) at commit `131db347`.
