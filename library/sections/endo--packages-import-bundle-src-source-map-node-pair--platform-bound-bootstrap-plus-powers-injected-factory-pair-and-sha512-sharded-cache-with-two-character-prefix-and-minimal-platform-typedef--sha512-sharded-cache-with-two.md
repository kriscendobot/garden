---
title: §sha512-sharded cache with two-character prefix
source-slug: endo--packages-import-bundle-src-source-map-node-pair
section-slug: platform-bound-bootstrap-plus-powers-injected-factory-pair-and-sha512-sharded-cache-with-two-character-prefix-and-minimal-platform-typedef
source-url: https://github.com/endojs/endo/blob/master/packages/import-bundle/src/source-map-node.js
source-repo: endojs/endo
source-path: packages/import-bundle/src/source-map-node.js + source-map-node-powers.js
source-author: Endo project (collective)
total-lines: 45 (10 + 35)
ingest-cycle: 276
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-import-bundle-src-source-map-node-pair--platform-bound-bootstrap-plus-powers-injected-factory-pair-and-sha512-sharded-cache-with-two-character-prefix-and-minimal-platform-typedef
---

Lines 28-32 carry the §sha512-sharded-cache-with-two-character-prefix discipline:

```js
const whereSourceMap = ({ sha512 }) => {
  const sha512Head = sha512.slice(0, 2);
  const sha512Tail = sha512.slice(2);
  return `${cacheLocation}/source-map/${sha512Head}/${sha512Tail}.map.json`;
};
```

§First-explicit-observation in library: **§sha512-sharded-cache-with-two-character-prefix-and-remaining-tail — §the-first-two-characters-of-the-hash-IS-the-directory-shard + §the-remaining-characters-IS-the-filename + §the-shard-prevents-filesystem-fanout (one directory holding 100k+ files is slow on many filesystems)**.

§Sibling-pattern to git's loose-object storage (the-`.git/objects/ab/cdef...`-shape); §two-named-content-addressed-storage-with-sha-sharding-disciplines (git's loose objects + Endo's source-map cache); §the-discipline-IS-canonical-across-systems.

§The-cache-IS-keyed-by-sha512-not-sha256 (cycle 275's weblet-application used SHA-256 for blob-storage; cycle 276's source-map cache uses SHA-512). §two-named-content-addressed-storage-hashes-in-the-cluster (SHA-256 + SHA-512); §sibling-pattern to many systems that use SHA-256 for content addressing but SHA-512 for source-maps + secure caches.

§First-explicit-observation in library: **§the-cluster-uses-named-different-hash-sizes-for-different-content-addressed-storage-uses (SHA-256 for blobs in cycle 275 + SHA-512 for source-maps in cycle 276)**.
