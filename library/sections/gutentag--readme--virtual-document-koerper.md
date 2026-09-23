---
title: The virtual document (Koerper)
source: README.md
source_repo: gutentags/gutentag
source_commit: 38cdebb355f9c09ffbc9b0dcc8bb13a9421dfc88
source_date: 2017-03-07
source_authors: [Kris Kowal]
ingested: 2026-07-06
ingested_by: scholar
topics: [html-modules, web-frontend]
status: current
---

Abstract: Guten Tag runs against a virtual document rather than the real DOM directly. Every virtual node has an `actualNode` and proxies common DOM methods and properties — `innerHTML`, `innerText`, `getAttribute`, `setAttribute`, `hasAttribute`, `removeAttribute` — but does not emulate anything fancy. The virtual document, with its support for body nodes (the container-free document-fragment points the structural tags govern), is provided by the Koerper module.

Every node of the virtual document has an `actualNode` and proxies common DOM
methods and properties including `innerHTML`, `innerText`, `getAttribute`,
`setAttribute`, `hasAttribute`, and `removeAttribute`, but does not emulate
anything fancy.

The virtual document, with its support for body nodes, is provided by the
[Koerper] module.

[Koerper]: https://github.com/kriskowal/koerper

Source: [README.md](https://github.com/gutentags/gutentag/blob/38cdebb355f9c09ffbc9b0dcc8bb13a9421dfc88/README.md) at commit `38cdebb`.
