---
title: Usage and bootstrapping — loadSystem, boot.js, and the sysjs bundle
source: README.md
source_repo: gutentags/system
source_commit: 91508059e8241a53bb029592a7f0700e37bba513
source_date: 2017-06-27
source_authors: [Kris Kowal]
ingested: 2026-07-06
ingested_by: scholar
topics: [module-loader, getting-started]
status: current
---

Abstract: The three ways to run an app on System. In Node.js, `System.loadSystem(location)` returns a promise for a system whose `import("./entry")` loads the entry module. In a browser during development, a single `<script src="node_modules/system/boot.js" data-import="./entry">` tag boots the loader (with an optional `data-package="../"` when the package root is elsewhere). For deployment, `sysjs entry.js > bundle.js` produces a bundle loaded by a plain `<script src="bundle.js">` — leaving little trace of the module system in the generated bundle.

To load in Node.js:

```js
var System = require("system");
System.loadSystem(location)
.then(function (system) {
    return system.import("./entry");
});
```

To load in a browser during development:

```html
<script src="node_modules/system/boot.js" data-import="./entry"></script>
```

If the root of the package is a different directory, the module loader will need to locate it.

```html
<script
    src="node_modules/system/boot.js"
    data-import="./entry"
    data-package="../"
></script>
```

To bundle for deployment:

```
sysjs entry.js > bundle.js
```

Then to load in production:

```html
<script src="bundle.js"></script>
```

Source: [README.md](https://github.com/gutentags/system/blob/91508059e8241a53bb029592a7f0700e37bba513/README.md) at commit `9150805`.
