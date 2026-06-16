---
title: §Why @endo/check-bundle needs location-aware parsing
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

§check-bundle-reads-bundle-files-from-disk + §each-bundle-is-a-JSON-document + §a-parse-failure-without-location-context-IS-useless-when-many-bundles-are-being-loaded. §The-location-IS-the-key-to-which-bundle-failed. §The-augmentation-IS-the-difference-between-"some-JSON-failed"-and-"`./foo.bundle`-failed".

§When-a-utility-processes-many-files-and-might-fail-on-any-of-them, §the-error-must-name-the-file-or-the-debug-experience-is-broken. §The-`parseLocatedJson`-name-itself-encodes-the-discipline + §the-parameter-`location`-IS-the-required-context.
