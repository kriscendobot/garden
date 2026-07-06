---
title: Overview — a singleton that ensures only one component has focus
source: README.md
source_repo: gutentags/kamera
source_commit: 09b81cc16b40ce22f09337f5bba6a66fbd1bdc8c
source_date: 2015-09-07
source_authors: [Kris Kowal]
ingested: 2026-07-06
ingested_by: scholar
topics: [focus-management, html-modules]
status: current
---

Abstract: The **kamera** is a singleton that ensures only one component has focus at a time. When a component takes the focus, the kamera blurs the prior focal component and stores the new one to be blurred later. For Guten Tag components it is a dependency injected at the **root scope**, so it is shared by all child components and all their widgets — the same dependency-injection pattern by which a Guten Tag scope shares its animator (Blick) and module loader (System). This makes single-focus enforcement an application-wide invariant rather than something each widget must coordinate pairwise.

The kamera is a singleton that ensures that only one component has focus. When a component takes the focus, the kamera blurs the prior focal component and stores the new focal component to be blurred later.

For Guten Tag components, the kamera is a dependency we inject at the root scope to be shared by all child components and all their widgets:

```js
var Kamera = require("kamera");
var Scope = require("gutentag/scope");
var scope = new Scope();
scope.attention = new Kamera();
```

Source: [README.md](https://github.com/gutentags/kamera/blob/09b81cc16b40ce22f09337f5bba6a66fbd1bdc8c/README.md) at commit `09b81cc`.
