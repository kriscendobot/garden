---
title: Related material in the library
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

- **cycle 205 @endo/evasive-transform**: §SES-censorship-evasion sibling — directly consumed by this package.
- **cycle 7 @endo/base64**: §encodeBase64 sibling — directly consumed by this package for endoZipBase64.
- **cycle 217 @endo/errors**: §thin-dispatch-layer sibling.
- **cycle 200 worker-rust-xs**: §retention-path-notation sibling (content-addressed file references).
- **cycle 203 @endo/cache-map**: §don't-establish-entry-until-prior-steps-succeed sibling.
- **cycle 199 @endo/trampoline/memoize/nat**: §Set-data-structure-for-tracking-async-jobs sibling.
- **cycle 132 @endo/eventual-send local.js**: §Set-to-deduplicate sibling.
- **cycle 196 endoclaw + cycle 200 worker-rust-xs + cycle 218 familiar-chat-weblet-hosting**: §capability-shape-as-parameter-passing-discipline siblings.
- **cycle 220 familiar-localhttp-protocol**: §dispatch-via-protocol-handler sibling (cycle 220 is at the network layer; cycle 221 is at the module-format layer).
- **cycle 211 @endo/common**: §tree-shaking-friendly sibling (this package uses dynamic import for the same purpose).
- **cycle 215 @endo/hex**: §SHA-512-content-addressing sibling (different application — hex encodes bytes; bundle-source uses sha-512 for cache keys).
