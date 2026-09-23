---
title: §The semicolon and the `CapTPSlot = string`
source-slug: endo--packages-captp-src-types-js
source-url: https://github.com/endojs/endo/blob/master/packages/captp/src/types.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/captp/src/types.js
total-lines: 49
ingest-cycle: 249
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-captp-src-types-js--typedef-only-file-and-three-method-TrapImpl-and-TrapCompletion-as-tuple-and-Out-of-band-sync-over-async
---

```js
/** @typedef {string} CapTPSlot */
```

§The-`CapTPSlot` type is just `string`. §Branded-string-IS-a-named-string-with-a-distinct-type-name. §When-a-string-has-a-domain-specific-meaning, §brand-it-as-a-named-typedef-not-just-use-`string`-directly.

§The-typedef-IS-the-documentation — §the-name-tells-the-reader-this-is-a-CapTP-slot-identifier-not-an-arbitrary-string. §When-a-protocol-uses-strings-for-multiple-purposes, §each-purpose-gets-its-own-branded-typedef-so-the-reader-doesn't-have-to-track-which-string-is-which.

§Sibling-pattern-to-cycle-237's-`@template T`-constraint — §two-cycles-with-named-type-aliases-for-domain-specific-string-meanings.
