---
title: "@endo/marshal/marshal-justin — §Justin-as-JavaScript-subset + §dual-indenter-strategies-with-shared-Indenter-interface + §badPairPattern-prevents-html-like-comments + §two-pass-recursion (prepare + decode) + §Hilbert-Hotel-encoding-for-records-containing-@qclass + §qp-eager-vs-q-lazy + §nested-render-with-indenter-swap + §three-named-TODO-cases-acknowledged-with-Fail"
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
kind: index
section_count: 19
---

Sections:

- [@endo/marshal/marshal-justin — Render Passable as a quasi-quoted Justin expression](endo--packages-marshal-src-marshal-justin--Justin-as-JavaScript-subset-and-dual-indenter-strategies-and-badPairPattern-and-two-pass-recursion-and-Hilbert-Hotel-and-qp-eager-vs-q-lazy--endo-marshal-marshal-justin-re.md)
- [§Justin-as-a-JavaScript-subset](endo--packages-marshal-src-marshal-justin--Justin-as-JavaScript-subset-and-dual-indenter-strategies-and-badPairPattern-and-two-pass-recursion-and-Hilbert-Hotel-and-qp-eager-vs-q-lazy--justin-as-a-javascript-subset.md)
- [§Dual-indenter-strategies-with-shared-Indenter-interface](endo--packages-marshal-src-marshal-justin--Justin-as-JavaScript-subset-and-dual-indenter-strategies-and-badPairPattern-and-two-pass-recursion-and-Hilbert-Hotel-and-qp-eager-vs-q-lazy--dual-indenter-strategies-with.md)
- [§The-`badPairPattern` regex](endo--packages-marshal-src-marshal-justin--Justin-as-JavaScript-subset-and-dual-indenter-strategies-and-badPairPattern-and-two-pass-recursion-and-Hilbert-Hotel-and-qp-eager-vs-q-lazy--the-badpairpattern-regex.md)
- [§Two-pass-recursion (prepare + decode)](endo--packages-marshal-src-marshal-justin--Justin-as-JavaScript-subset-and-dual-indenter-strategies-and-badPairPattern-and-two-pass-recursion-and-Hilbert-Hotel-and-qp-eager-vs-q-lazy--two-pass-recursion-prepare-decode.md)
- [§QCLASS-discrimination switch with §nine-named-cases](endo--packages-marshal-src-marshal-justin--Justin-as-JavaScript-subset-and-dual-indenter-strategies-and-badPairPattern-and-two-pass-recursion-and-Hilbert-Hotel-and-qp-eager-vs-q-lazy--qclass-discrimination-switch-with-nine-named-cases.md)
- [§The-Hilbert-Hotel-encoding for records containing `@qclass` key](endo--packages-marshal-src-marshal-justin--Justin-as-JavaScript-subset-and-dual-indenter-strategies-and-badPairPattern-and-two-pass-recursion-and-Hilbert-Hotel-and-qp-eager-vs-q-lazy--the-hilbert-hotel-encoding-for.md)
- [§Nested-render-with-indenter-swap](endo--packages-marshal-src-marshal-justin--Justin-as-JavaScript-subset-and-dual-indenter-strategies-and-badPairPattern-and-two-pass-recursion-and-Hilbert-Hotel-and-qp-eager-vs-q-lazy--nested-render-with-indenter-swap.md)
- [§`[__proto__]:`-bracket-notation-to-preserve-JSON-meaning](endo--packages-marshal-src-marshal-justin--Justin-as-JavaScript-subset-and-dual-indenter-strategies-and-badPairPattern-and-two-pass-recursion-and-Hilbert-Hotel-and-qp-eager-vs-q-lazy--proto-bracket-notation-to-preserve-json-meaning.md)
- [§`qp` — quasi-quotes-Justin-template-literal-tag](endo--packages-marshal-src-marshal-justin--Justin-as-JavaScript-subset-and-dual-indenter-strategies-and-badPairPattern-and-two-pass-recursion-and-Hilbert-Hotel-and-qp-eager-vs-q-lazy--qp-quasi-quotes-justin-template-literal-tag.md)
- [§`qp`-eager-vs-`q`-lazy comparison](endo--packages-marshal-src-marshal-justin--Justin-as-JavaScript-subset-and-dual-indenter-strategies-and-badPairPattern-and-two-pass-recursion-and-Hilbert-Hotel-and-qp-eager-vs-q-lazy--qp-eager-vs-q-lazy-comparison.md)
- [§Three-named-TODO-cases-acknowledged-with-Fail](endo--packages-marshal-src-marshal-justin--Justin-as-JavaScript-subset-and-dual-indenter-strategies-and-badPairPattern-and-two-pass-recursion-and-Hilbert-Hotel-and-qp-eager-vs-q-lazy--three-named-todo-cases-acknowledged-with-fail.md)
- [§The-co-maintain-doc-comment-and-test-module instruction](endo--packages-marshal-src-marshal-justin--Justin-as-JavaScript-subset-and-dual-indenter-strategies-and-badPairPattern-and-two-pass-recursion-and-Hilbert-Hotel-and-qp-eager-vs-q-lazy--the-co-maintain-doc-comment-an.md)
- [§slotToVal-render-when-slot-is-bound + §slot-render-when-not-bound](endo--packages-marshal-src-marshal-justin--Justin-as-JavaScript-subset-and-dual-indenter-strategies-and-badPairPattern-and-two-pass-recursion-and-Hilbert-Hotel-and-qp-eager-vs-q-lazy--slottoval-render-when-slot-is.md)
- [§The-passableAsJustin convenience](endo--packages-marshal-src-marshal-justin--Justin-as-JavaScript-subset-and-dual-indenter-strategies-and-badPairPattern-and-two-pass-recursion-and-Hilbert-Hotel-and-qp-eager-vs-q-lazy--the-passableasjustin-convenience.md)
- [§Library-scope](endo--packages-marshal-src-marshal-justin--Justin-as-JavaScript-subset-and-dual-indenter-strategies-and-badPairPattern-and-two-pass-recursion-and-Hilbert-Hotel-and-qp-eager-vs-q-lazy--library-scope.md)
- [Related material in the library](endo--packages-marshal-src-marshal-justin--Justin-as-JavaScript-subset-and-dual-indenter-strategies-and-badPairPattern-and-two-pass-recursion-and-Hilbert-Hotel-and-qp-eager-vs-q-lazy--related-material-in-the-library.md)
- [§Three-cycles-on-honest-acknowledgment-of-architectural-asymmetry](endo--packages-marshal-src-marshal-justin--Justin-as-JavaScript-subset-and-dual-indenter-strategies-and-badPairPattern-and-two-pass-recursion-and-Hilbert-Hotel-and-qp-eager-vs-q-lazy--three-cycles-on-honest-acknowl.md)
- [§Two-cycles-on-tests-as-the-documentation-pattern](endo--packages-marshal-src-marshal-justin--Justin-as-JavaScript-subset-and-dual-indenter-strategies-and-badPairPattern-and-two-pass-recursion-and-Hilbert-Hotel-and-qp-eager-vs-q-lazy--two-cycles-on-tests-as-the-documentation-pattern.md)
