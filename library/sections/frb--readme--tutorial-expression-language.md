---
title: FRB tutorial — the expression language (operators, functions, conditional, algebra, literals, tuples, records)
source: README.md
source_repo: kriskowal/frb
source_commit: 131db347355789cf2dbb79e49b10881d9716b449
source_date: 2013-09-15
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [reactive-bindings]
status: current
---

> Abstract: The scalar expression language beyond collection operators (Operators, Functions, Conditional, Algebra, Literals, Tuples, Records). FRB recognizes a precedence-ordered set of unary and binary operators (negation, numeric coercion `+`, power `**`, root `//`, logarithm `%%`, arithmetic, comparison, `&&`, `||`); the unary `+` coerces a string to a number. String functions (`startsWith`, `endsWith`, `contains`) and the algebraic `join`/`split` are supported. The ternary `?:` conditional binds in both directions. Algebraic operators are automatically inverted for two-way bindings by rotating expressions across the equation until one bindable property remains on the target side (numbers only, and only when the left-most expression is a bindable property). String and number literals are supported; tuples `[a, b]` produce fixed-length arrays and records `{k: a}` fixed-shape objects, both most useful inside `map{}`.

**Operators.** In order of precedence: unary `-` negation, `+` numeric coercion, `!` logical negation; then binary `**` power, `//` root, `%%` logarithm, `*`, `/`, `%` modulo, `%%` remainder, `+`, `-`, `<`, `>`, `<=`, `>=`, `=`/`==`, `!=`, `&&`, `||`.

```javascript
bind(object, "heightPx", {"<-": "height + 'px'"}); // "10px"
Bindings.defineBinding(object, "+number", {"<-": "string"}); // unary + coerces "10" → 10
```

**Functions.** `startsWith`, `endsWith`, and `contains` operate on strings. `join` concatenates an array of strings with a delimiter (or empty string); `split` breaks a string at every delimiter (or between every character). `join` and `split` are algebraic and can be bound as well as observed.

**Conditional.** The ternary `condition ? consequent : alternate` binds in both directions.

```javascript
Bindings.defineBindings({condition: null, consequent: 10, alternate: 20}, {
    choice: {"<->": "condition ? consequent : alternate"}
});
// condition = true → choice = 10;  choice = 30 (when false) → alternate = 30
```

**Algebra.** FRB automatically inverts algebraic operators for two-way bindings, as long as they operate strictly on the left-most expressions and both source and target left-most expressions are bindable properties. It rotates expressions from one side to the other until only one independent property (the left-most) remains on the target side:

```
convert: y <- !x      revert: x <- !y
convert: y <- x + a   revert: x <- y - a
```

This works only for numbers and only when the left-most expression is a bindable property (it cannot assign to a literal): FRB cannot yet revert `y <-> 10 + x`.

**Literals.** String literals are any characters between single quotes (escape with backslash); number literals are digits with an optional mantissa.

**Tuples and Records.** Tuples are comma-delimited, parenthesis-enclosed fixed-length arrays; records are comma-delimited, colon-separated, curly-brace-enclosed fixed-shape objects. Both are most useful inside mappings.

```javascript
bind(object, "summary", {"<-": "array.map{[length, sum()]}"});               // tuples
bind(object, "summary", {"<-": "array.map{{length: length, sum: sum()}}"});  // records
```

Source: [README.md](https://github.com/kriskowal/frb/blob/131db347355789cf2dbb79e49b10881d9716b449/README.md) at commit `131db347`.
