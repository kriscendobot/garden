---
title: parseLocatedJson augments SyntaxError with location + q as direct stringify alias + SyntaxError without new
source-slug: endo--packages-check-bundle-src-json-js
source-url: https://github.com/endojs/endo/blob/master/packages/check-bundle/src/json.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/check-bundle/src/json.js
total-lines: 22
ingest-cycle: 247
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-check-bundle-src-json-js--parseLocatedJson-augments-SyntaxError-with-location-and-q-as-direct-stringify-alias-and-SyntaxError-without-new
---

[`@endo/check-bundle/src/json.js`](../sources/endo--packages-check-bundle-src-json-js.md) is a §22-line-file that exports a single function — `parseLocatedJson` — which wraps `JSON.parse` and augments any `SyntaxError` it throws with the location of the offending file. The file is a small but instructive showcase of error-augmentation discipline.
