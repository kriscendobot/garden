---
title: §Two-parser-defaults from @endo/compartment-mapper
source-slug: endo--packages-bundle-source
section-id: format-dispatch-with-lazy-loading-and-sha-512-content-addressed-source-map-cache-and-readPowers-pattern
url: https://github.com/endojs/endo/tree/master/packages/bundle-source
authors: [Endo contributors]
repo: endojs/endo
path: packages/bundle-source/src/{bundle-source.js,zip-base64.js,script.js,endo.js,fs.js,main.js,is-entrypoint.js,tool.js,index.js}
status: shipping
ingest-cycle: 221
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-bundle-source--format-dispatch-with-lazy-loading-and-sha-512-content-addressed-source-map-cache-and-readPowers-pattern
---

```js
import { defaultParserForLanguage as transformingParserForLanguage }
  from '@endo/compartment-mapper/archive-parsers.js';
import { defaultParserForLanguage as transparentParserForLanguage }
  from '@endo/compartment-mapper/import-parsers.js';
```

§Two-different-default-parser-tables-with-the-same-name-imported-with-aliases. §Borrowable-pattern: §the-import-aliases-encode-the-semantics:
- `transformingParserForLanguage` — for archive-mode bundling (parses + transforms).
- `transparentParserForLanguage` — for import-mode (parses without transforming).

§Two-different-parsers-for-two-different-use-cases. §The-archive-bundle-needs-static-analysis + §the-import-bundle-needs-direct-evaluation.
