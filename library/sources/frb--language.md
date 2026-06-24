---
source: language.js
source_repo: kriskowal/frb
source_commit: 700193977f54da05024751adb5cabf35b6dbb7b4
source_date: 2013-06-03
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
section_count: 1
status: current
---

> Abstract: `language.js` is FRB's operator-metadata module: it exports `precedenceLevels`, a `precedence` map (each operator type → the `Set` of looser-binding types), and the `operatorTokens` / `operatorTypes` token↔type maps. Its sole consumer is `stringify.js`, which renders a syntax tree back to source text and needs precedence for minimal parenthesization. This source-index also records a correction to the `scholar-ingest-frb-3` job's framing: `language.js` is **not** "the module tying parse and compile together." The README's module names (`frb/parse`, `frb/compile-observer`, `frb/compile-binder`) are accurate, and the parse → compile → live-binding assembly lives in `bind.js` and `observe.js`. `language.js` is the round-trip's return leg (tree → source), the stringifier's table.

| Section | Topics | Status |
|---------|--------|--------|
| [operator-precedence-and-token-tables](../sections/frb--language--operator-precedence-and-token-tables.md) | reactive-bindings | current |
