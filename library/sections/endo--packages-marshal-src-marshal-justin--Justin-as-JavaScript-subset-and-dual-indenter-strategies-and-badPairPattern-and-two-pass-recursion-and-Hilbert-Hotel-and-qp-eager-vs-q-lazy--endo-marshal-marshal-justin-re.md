---
title: "@endo/marshal/marshal-justin — Render Passable as a quasi-quoted Justin expression"
source-slug: endo--packages-marshal-src-marshal-justin
section-id: Justin-as-JavaScript-subset-and-dual-indenter-strategies-and-badPairPattern-and-two-pass-recursion-and-Hilbert-Hotel-and-qp-eager-vs-q-lazy
url: https://github.com/endojs/endo/blob/master/packages/marshal/src/marshal-justin.js
authors: [Endo contributors]
repo: endojs/endo
path: packages/marshal/src/marshal-justin.js
total-lines: 510
status: shipping
ingest-cycle: 229
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-marshal-src-marshal-justin--Justin-as-JavaScript-subset-and-dual-indenter-strategies-and-badPairPattern-and-two-pass-recursion-and-Hilbert-Hotel-and-qp-eager-vs-q-lazy
---

A 510-line file that decodes a marshal CapData encoding back to a §Justin expression — a JavaScript-syntactic subset that, when evaluated, reconstructs the original Passable. Provides the §`qp`-template-literal-tag for use with `Fail` / `X` / `quote` from @endo/errors to embed §unredacted-quasi-quoted-Justin-renderings in error messages.
