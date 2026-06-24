---
section: in-memory-zip-as-exo-readable-tree-with-asymmetric-by-design-read-API-and-resolved-questions-trail
source: endo-but-for-bots--llm-designs-exo-zip-package
topics: [exo, daemon, marshal]
status: current
title: "The §load-bearing-context — PR #128's anti-pattern"
parent: endo-but-for-bots--llm-designs-exo-zip-package--in-memory-zip-as-exo-readable-tree-with-asymmetric-by-design-read-API-and-resolved-questions-trail
---

PR #128 (`endo checkin` / `endo checkout`) implements the
`-z` flag by *extracting the zip into a temporary directory*
and then walking that directory with `makeLocalTree`. The
maintainer flagged three costs:

1. **Temp directory + try/finally cleanup + partial-extraction
   recovery** — significant ceremony.
2. **Doubled I/O** — every byte written to disk and
   immediately re-read.
3. **Conflated concerns** — `checkin.js` carries zip-decoding
   *and* tree-walking *fused together*; neither is reusable
   alone.

The §enumerate-the-costs methodology: rather than "this is
suboptimal," the design *names three concrete costs*. Each is
independently defensible; the union *justifies* the new
package.

The §desired-shape preview shows the result-of-fix in one
snippet:

```js
const exoTree = makeExoZip(zipBytes);
await E(agent).storeTree(exoTree, parsedName);
```

The §show-the-collapse pattern: a *before* (try/finally with
extractZipToTemp) and *after* (single-call) demonstration
makes the design's value visible *before* the implementation
details.
