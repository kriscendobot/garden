---
source: packages/marshal/src/marshal-justin.js + packages/marshal/src/marshal-stringify.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/tree/master/packages/marshal/src
source_path: packages/marshal/src/marshal-justin.js, packages/marshal/src/marshal-stringify.js
section_kind: source
ingested: 2026-06-04
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
  - Mark S. Miller (prompted)
topics:
  - marshal
  - pass-style
  - errors
genre: §endo-source-comment-fragment §canonical-passable-rendering-pair
cycle: 189
lane: chat
status: current
title: Two-pass decoder with mirror control flow, indenter trait with two implementations, SGML-comment-injection defense, and badArray proxy rejecting all slot positions
parent: endo--packages-marshal-src-marshal-justin-and-marshal-stringify-js--two-pass-decoder-with-mirror-control-flow-and-indenter-trait-and-SGML-comment-injection-defense
---

> §Chat-lane after cycle 188's designs-lane. §The-twenty-
> third-consecutive designs/chat alternation cycle (166-189).
> §The CLAUDE.md diagnostic discipline cites
> `passableAsJustin` from `@endo/marshal` as the recommended
> replacement for `JSON.stringify` when rendering passable
> values for log messages; §this-cycle-ingests-its-source.

`packages/marshal/src/marshal-justin.js` (510 lines) +
`packages/marshal/src/marshal-stringify.js` (69 lines) = 579
lines forming the §canonical-passable-rendering-pair: the
mechanism behind `passableAsJustin` (for human-readable
diagnostic output) and `stringify`/`parse` (for the no-slot
JSON-stringify-compatible path).

§The-single-most-structurally-interesting-move is §two-pass-
decoder-with-mirror-control-flow + §indenter-trait-with-two-
implementations + §SGML-comment-injection-defense + §badArray-
proxy-rejecting-all-slot-positions. §Four-named-moves in one
579-line family.
