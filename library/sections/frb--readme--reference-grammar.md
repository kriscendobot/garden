---
title: Reference — Grammar (the property/expression language)
source: README.md
source_repo: kriskowal/frb
source_commit: 131db347355789cf2dbb79e49b10881d9716b449
source_date: 2013-09-15
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [reactive-bindings]
status: current
notes: The grammar quoted in the README's Reference section. The actual PEG source (grammar.pegjs) is deferred to scholar-ingest-frb-3; this section is the README's prose grammar, which doubles as the readable spec of that source.
---

> Abstract: FRB's query language grammar, as the README's Reference section spells it out: a precedence-climbing expression grammar from `expression` (a logical-or) down through conditional (`? :`), logical or/and, relations (`==`, `<`, `<=`, `>`, `>=`, `<=>`), additive (`+ -`), multiplicative (`* / % rem`), exponential (`**` pow, `//` root, `%%` log), unary (`+` number, `-` neg, `!` not), to `path-expression`. A path-expression is a literal, a tuple (`[...]`), a record (`{...}`), a parenthesized expression, a property name, a piped function-call, a block-call (`map{}`, `filter{}`, ...), an element `#id`, a component `@label`, or a bare-function `&fn()`, each followed by a `tail-expression` (`.property`, a with-expression `.(...)`, or a variable-property `[expr]`). Each grammar term names the syntax-node `type` it produces, which is the bridge to the `frb--readme--reference-syntax-tree-and-language-interface` section.

The README presents the grammar with a legend: bold terms are grammar productions, `tokens` are literal syntax, italic parentheticals name the corresponding syntax-node `type`, `=` is definition, `or` is alternation, `delimited by` repeats with a separator, `?` is optional, `*` is zero-or-more, `+` is one-or-more.

- **expression** = **logical-or-expression**
- **conditional-expression** = **logical-or-expression** ( `?` **expression** `:` **expression** )?
- **logical-or-expression** = **logical-and-expression** ( `||` *(or)* **relation expression** )?
- **logical-and-expression** = **relation-expression** ( `&&` *(and)* **relation-expression** )?
- **relation-expression** = **arithmetic expression** ( **relation-operator** **arithmetic-expression** )?
  - **relation-operator** = `==` *(equals)* or `<` *(lt)* or `<=` *(le)* or `>` *(gt)* or `>=` *(ge)* or `<=>` *(compare)*
- **arithmetic-expression** = **multiplicative-expression** delimited by **arithmetic-operator**
  - **arithmetic-operator** = `+` *(add)* or `-` *(sub)*
- **multiplicative-expression** = **exponential-expression** delimited by **multiplicative-operator**
  - **multiplicative-operator** = `*` *(mul)* or `/` *(div)* or `%` *(mod)* or `rem` *(rem)*
- **exponential-expression** = **unary-expression** delimited by **exponential-operator**
  - **exponential-operator** = `**` *(pow)* or `//` *(root)* or `%%` *(log)*
- **unary-expression** = **unary-operator** ? **path-expression**
  - **unary-operator** = `+` *(number)* or `-` *(neg)* or `!` *(not)*
- **path-expression** =
  - **literal** *(literal with value)* or
  - **array-expression** *(tuple)* or
  - **object-expression** *(record)* or
  - `(` **expression** `)` **tail-expression** or
  - **property-name** **tail-expression** *(property)* or
  - **function-call** *(piped)* **tail-expression** or
  - **block-call** **tail-expression** or
  - `#` **element-id** **tail-expression** *(element by id)* or
  - `@` **component-label** **tail-expression** *(component by label)* or
  - `&` **function-call** *(bare)* **tail-expression**
- **tail-expression** = **property-expression** or **with-expression** or **variable-property-expression**
- **property-expression** = `.` **property-name** **tail-expression** *(property)*
- **with-expression** = `.`
  - `(` **expression** `)` **tail-expression** or
  - **array-expression** **tail-expression** or
  - **object-expression** **tail-expression**
- **variable-property-expression** = `[` **expression** `]` **tail-expression** *(property)*
- **array-expression** = `[` ( **expression** or `()` *(value)* ) delimited by `,` `]` *(tuple with each expression in args array)*
- **object-expression** = `{` (**property-name** `:` **expression**) delimited by `,` `}` *(record, with each expression as a value in an args object instead of array)*
- **property-name** = ( **non-space-character** )+
- **function-call** = **function-name** `(` **expression** delimited by `,` `)`
  - **function-name** = `flatten` or `reversed` or `enumerate` or `sum` or `average` or `has` or `view` or `startsWith` or `endsWith` or `contains` or `join` or `split` or `range` or `keys` or `values` or `entries` *(eponymous syntax node types)*
- **block-call** = **function-name** `{` **expression** `}`
  - **block-name** = `map` *(mapBlock)* or `filter` *(filterBlock)* or `some` *(someBlock)* or `every` *(everyBlock)* or `sorted` *(sortedBlock)* or `sortedSet` *(sortedSetBlock)* or `min` *(minBlock)* or `max` *(maxBlock)* or `group` *(groupBlock)* or `groupMap` *(groupMapBlock)* or **function-name** *(map followed by function-call)*
- **literal** = **string-literal** or **number-literal**
  - **number-literal** = **digits** ( `.` **digits** )? *(literal and value is a number)*
  - **string-literal** = `'` ( **non-quote-character** or `\` **character** ) `'` *(literal and value is a string)*

Source: [README.md](https://github.com/kriskowal/frb/blob/131db347355789cf2dbb79e49b10881d9716b449/README.md) at commit `131db347`.
