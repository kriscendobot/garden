---
source: grammar.pegjs
source_repo: kriskowal/frb
source_commit: 2162ce7cb574f1b5aed1cf8118c1548de8b85d70
source_date: 2013-07-31
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
section_count: 4
status: current
---

> Abstract: `grammar.pegjs` is FRB's PEG.js grammar: the source-of-truth for the query language the README's `frb--readme--reference-grammar` section describes in prose. It defines two start symbols. `expression` is the precedence-climbing expression language (one rule per precedence level, leaf path-expressions with the `@`/`$`/`#`/`&`/`^` special-character prefixes, and JSON-modeled literals). `sheet` is a second, declarative-binding stylesheet grammar under a `// MCS extensions` comment that the README does not document at all: `@label`-named blocks of `target <- source` / `on event -> handler` / unit statements. The four sections below split the grammar by mechanism; together they capture what the source adds over the README prose: the literal token→type tables, the function-returning `tail`/`chain` mechanism, the implicit-`mapBlock` rewrite, the `inline: true` bare-function flag, the `!=`→`not(equals)` and `<`-lookahead edge cases, and the entire sheet/statement sub-language.

| Section | Topics | Status |
|---------|--------|--------|
| [token-tables-and-precedence-climbing](../sections/frb--grammar--token-tables-and-precedence-climbing.md) | reactive-bindings | current |
| [path-expressions-pipe-and-tail](../sections/frb--grammar--path-expressions-pipe-and-tail.md) | reactive-bindings | current |
| [literals-strings-numbers-records-tuples](../sections/frb--grammar--literals-strings-numbers-records-tuples.md) | reactive-bindings | current |
| [mcs-sheet-and-statement-extensions](../sections/frb--grammar--mcs-sheet-and-statement-extensions.md) | reactive-bindings | current |
