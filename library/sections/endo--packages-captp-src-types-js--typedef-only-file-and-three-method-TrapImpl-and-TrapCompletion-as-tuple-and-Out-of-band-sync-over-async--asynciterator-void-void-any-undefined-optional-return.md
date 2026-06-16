---
title: §`AsyncIterator<void, void, any> | undefined` — optional return
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

§The-`TrapHost`-can-return-an-AsyncIterator-or-undefined. §The-undefined-case-IS-the-no-iterator-needed-signal — §when-the-transfer-completes-synchronously-no-iterator-is-needed.

§Sibling-pattern-to-cycle-239's-`InterfaceGuard<...> | undefined` (the get-interface-guard meta-method can return undefined) — §two-cycles-with-explicit-undefined-as-no-value-or-no-feature signal. §When-a-protocol-method-can-return-no-value-meaningfully, §encode-the-no-value-case-as-`| undefined`-not-as-null-or-throw.

§Two-different-meanings-of-the-undefined-return: §cycle-239 undefined-means-no-interface-guard-is-defined + §cycle-249 undefined-means-no-iterator-needed-for-this-transfer. §Two-different-no-value-semantics-encoded-by-the-same-type.
