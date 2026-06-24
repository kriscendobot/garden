---
title: §evadeCensor + §tsBlankSpace integration
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
import { evadeCensor } from '@endo/evasive-transform';
import tsBlankSpace from 'ts-blank-space';
```

§Two-named-transforms loaded at module level — §cycle 205's @endo/evasive-transform (the SES-censorship-evasion) + §ts-blank-space (TypeScript stripping).

§Borrowable-pattern: §two-third-party-transform-libraries-bundled-into-the-default-transform-pipeline. §The-bundler-is-the-place-where-static-transforms-are-applied. §Sibling to cycle 205 evasive-transform's §SES-censorship-evasion (now consumed here).
