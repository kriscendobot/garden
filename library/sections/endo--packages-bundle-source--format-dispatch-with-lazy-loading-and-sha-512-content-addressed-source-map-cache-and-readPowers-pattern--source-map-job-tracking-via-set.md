---
title: §Source-map-job-tracking via Set
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
const sourceMapJobs = new Set();
// ... writeSourceMap pushes promises into sourceMapJobs ...
await Promise.all(sourceMapJobs);
```

§Async-fan-out-with-Set-tracking. §Each-source-map-write-is-a-promise-pushed-into-the-Set + §Promise.all-at-the-end-waits-for-all-writes-to-complete.

§Borrowable-pattern: §the-fire-and-collect-async-pattern — §don't-await-each-write-individually (would serialize); §collect-promises-into-a-set + §await-them-all-at-the-end.

§Sibling to cycle 199 trampoline (the §async-trampoline-as-a-cooperative-scheduler) and cycle 132 local.js (§Set-to-deduplicate). §Same Set-data-structure for two-different-purposes: deduplication vs fan-out-tracking.
