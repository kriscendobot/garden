---
section: in-memory-zip-as-exo-readable-tree-with-asymmetric-by-design-read-API-and-resolved-questions-trail
source: endo-but-for-bots--llm-designs-exo-zip-package
topics: [exo, daemon, marshal]
status: current
title: The §three-component package skeleton
parent: endo-but-for-bots--llm-designs-exo-zip-package--in-memory-zip-as-exo-readable-tree-with-asymmetric-by-design-read-API-and-resolved-questions-trail
---

§Package layout:

```
packages/exo-zip/
  package.json
  README.md
  index.js
  src/
    exo-zip.js          // makeExoZip(zipBytes)
    exo-zip-tree.js     // internal ReadableTree exo
    exo-zip-blob.js     // internal ReadableBlob exo
  test/
    exo-zip.test.js
  tsconfig.json
  tsconfig.build.json
```

§Dependency list: `@endo/exo`, `@endo/far`, `@endo/harden`,
`@endo/zip`, `@endo/stream`, `@endo/platform`. The §explicit-
dependency-list discipline names what comes in.

The §pure-ECMAScript-no-Node-builtins discipline:

> *The package is pure ECMAScript with no Node built-ins, so
> it is loadable in XS, browsers, and SES realms.*

§Portability-as-constraint: the package must run in *every
realm @endo supports*. This drives Design Decision 6 (use
`Uint8Array` + `TextDecoder`, not Node's `Buffer`).
