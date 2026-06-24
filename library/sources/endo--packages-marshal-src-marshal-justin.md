---
title: "@endo/marshal/marshal-justin — Render Passable as quasi-quoted Justin (a JavaScript-subset expression)"
source-slug: endo--packages-marshal-src-marshal-justin
url: https://github.com/endojs/endo/blob/master/packages/marshal/src/marshal-justin.js
authors: [Endo contributors]
repo: endojs/endo
path: packages/marshal/src/marshal-justin.js
total-lines: 510
status: shipping
ingest-cycle: 229
ingest-date: 2026-06-08
lane: chat
---

# @endo/marshal/marshal-justin

A 510-line file that decodes CapData encoding back to §Justin — a JavaScript-syntactic-subset expression that, when evaluated, reconstructs the original Passable. Provides the §`qp`-template-literal-tag for embedding unredacted quasi-quoted Justin in error messages alongside `q` from @endo/errors.

## Key design moves

- **§Justin-as-a-JavaScript-subset** — the output IS valid JavaScript.
- **§Dual-indenter-strategies** (makeYesIndenter + makeNoIndenter) with §five-method-shared-Indenter-interface (open + line + next + close + done).
- **§badPairPattern regex** encoding §six-named-token-pair-cases that must be separated (preserving meaning + preventing accidental HTML-like comment formation).
- **§Honest-comment admitting some regex cases might be unnecessary** but haven't been investigated.
- **§Two-pass-recursion** (prepare + decode) with §the-co-maintenance-constraint-documented-in-the-source.
- **§QCLASS-discrimination switch** with §eleven-named-cases + §unrecognized-qclass-throws-TypeError default.
- **§The-Hilbert-Hotel-encoding for records containing the special @qclass key** (sibling to cycle 148's symbol Hilbert-Hotel).
- **§Nested-render-with-indenter-swap** via §closure-captures-mutable-state + §try-finally-restore.
- **§`[__proto__]:`-bracket-notation-to-preserve-JSON-meaning** + §identifier-pattern unquoted + §JSON.stringify quoted.
- **§`qp`-template-literal-tag** as the quasi-quoting domain API.
- **§`qp`-eager-vs-`q`-lazy comparison** with §honest-disclosure-of-layering-constraint.
- **§Three-named-not-yet-implemented-cases** acknowledged with `Fail` (error cause + AggregateError + error errors).
- **§The-co-maintain-doc-comment-and-test-module instruction**.
- **§Four-output-shapes for slot-rendering** depending on §slot-index-bound vs §iface-defined.

## Section files

- [§Justin-as-JavaScript-subset + §dual-indenter-strategies + §badPairPattern + §two-pass-recursion + §Hilbert-Hotel + §qp-eager-vs-q-lazy](../sections/endo--packages-marshal-src-marshal-justin--Justin-as-JavaScript-subset-and-dual-indenter-strategies-and-badPairPattern-and-two-pass-recursion-and-Hilbert-Hotel-and-qp-eager-vs-q-lazy.md) — full source ingest.

## Ingest scope

Cycle 229 (chat-lane): full 510-line ingest. §The-marshal-package-now-substantially-ingested across six cycles (74 + 69 + 81 + 84 + 158 + 229). The Justin renderer is the §JavaScript-expression-source-form complement to cycle 158's marshal-stringify.js.
