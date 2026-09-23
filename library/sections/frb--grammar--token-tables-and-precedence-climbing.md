---
title: Token tables and the precedence-climbing rule chain
source: grammar.pegjs
source_repo: kriskowal/frb
source_commit: 2162ce7cb574f1b5aed1cf8118c1548de8b85d70
source_date: 2013-07-31
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [reactive-bindings]
status: current
notes: The PEG source behind the README's prose grammar (frb--readme--reference-grammar). This section captures what the source adds: the literal token→type tables and the explicit per-level precedence-climbing rules the README renders only as a precedence ladder.
---

> Abstract: The header block of `grammar.pegjs` and its expression-rule chain are the source-of-truth for FRB's operator precedence. The README renders precedence as a ladder; the source realizes it as one PEG rule per precedence level, each rule consuming the next-tighter level as its operands. Four initializer tables map surface tokens to syntax-node `type` strings: `BINARY` (including the binding tokens `<-`→`bind`, `<->`→`bind2`, `:`→`assign` that the README's expression grammar omits), `UNARY`, `BLOCKS`, and `STATEMENTS`. The climb runs `if` → `or` → `and` → `comparison` → `arithmetic` → `multiplicative` → `exponential` → `default` → `unary` → `pipe`, so binding tightness is encoded purely in which rule calls which. Two edge cases the README prose elides: `!=` has no node and is rewritten in the `comparison` action to `not(equals(...))`, and the `<` comparison operator carries a negative lookahead `"<" !("-")` so that `<-` (the bind arrow) is never mis-lexed as a less-than.

PEG.js runs the initializer block once; these tables are closed over by every rule action.

```javascript
var BINARY = {
    "**": "pow",  "//": "root", "%%": "log",
    "*": "mul",   "/": "div",   "%": "mod",   "rem": "rem",
    "+": "add",   "-": "sub",
    "<": "lt",    ">": "gt",    "<=": "le",   ">=": "ge",
    "==": "equals", "<=>": "compare",
    "??": "default", "&&": "and", "||": "or",
    "<-": "bind", "<->": "bind2", ":": "assign"
};
var UNARY = { "+": "toNumber", "-": "neg", "!": "not", "^": "parent" };
var BLOCKS = {
    "map": "mapBlock", "filter": "filterBlock", "some": "someBlock",
    "every": "everyBlock", "sorted": "sortedBlock", "sortedSet": "sortedSetBlock",
    "group": "groupBlock", "groupMap": "groupMapBlock",
    "min": "minBlock", "max": "maxBlock"
};
var STATEMENTS = { ":": "assign", "<-": "bind", "<->": "bind2" };
```

The expression entry point and the climb (abbreviated; every binary level shares the same left-fold shape):

```
expression "expression" = if

if = condition:or _ tail:( "?" _ expression _ ":" _ expression )? {
    // tail present  -> {type: "if", args: [condition, consequent, alternate]}
    // tail absent    -> condition
}

or  = head:and        tail:( _ "||" _ and )*         { /* left-fold into BINARY["||"]=="or"  nodes */ }
and = head:comparison tail:( _ "&&" _ comparison )*  { /* left-fold into BINARY["&&"]=="and" nodes */ }

comparison
    = left:arithmetic tail:( _ operator:$( "<=>" / "<=" / ">=" / "<" !("-") / ">" / "==" / "!=" ) _ right:arithmetic )? {
        if (!tail) return left;
        var operator = tail[1], right = tail[3];
        if (operator === "!=")
            return {type: "not", args: [{type: "equals", args: [left, right]}]};
        return {type: BINARY[operator], args: [left, right]};
    }

arithmetic     = head:multiplicative tail:( _ $( "+" / "-" )            _ multiplicative )* { /* left-fold */ }
multiplicative = head:exponential    tail:( _ $( "*" / "/" / "%" / "rem") _ exponential )*  { /* left-fold */ }
exponential    = head:default        tail:( _ $( "**" / "//" / "%%" )   _ default )*        { /* left-fold */ }
default        = head:unary          tail:( _ "??" _ unary )*                                { /* left-fold */ }
```

Notes the source makes explicit that the README's ladder does not:

- **Binding tokens live in `BINARY` but not in the `expression` climb.** `<-`, `<->`, and `:` resolve to `bind`/`bind2`/`assign` only through the MCS `statement` rule (see [frb--grammar--mcs-sheet-and-statement-extensions](frb--grammar--mcs-sheet-and-statement-extensions.md)) and the `STATEMENTS` table, not through `expression`. A plain `parse(text)` over an expression never produces a `bind`/`assign` node; those arise from the sheet/statement grammar.
- **`!=` is sugar.** It compiles to `not(equals(...))` at parse time, which is why the syntax tree has no `notEquals` node and why the algebraic binder machinery never needs a not-equals inverse. (`language.js`'s `operatorTokens` still lists `"!=": "notEquals"` for the stringifier's benefit, a small surface where the two tables disagree; see [frb--language--operator-precedence-and-token-tables](frb--language--operator-precedence-and-token-tables.md).)
- **The `<` lookahead.** `"<" !("-")` stops the comparison operator from swallowing the `<` of a `<-` arrow, disambiguating `a < -b` style input from a binding statement at the lexical level.

### Source-vs-README drift: `+`(unary) node type

`UNARY` maps the unary `+` to **`toNumber`**, and `operators.js` exports `toNumber` (no `number` operator or observer exists). But the README's `frb--readme--reference-grammar` and `frb--readme--reference-syntax-tree-and-language-interface` sections both label the unary `+` node as `number`. The runtime node type is `toNumber`; `number` is a README-prose label that does not match the source. Low-stakes documentation drift, surfaced here per the scholar's notice/investigate/propose discipline; recorded for a possible README correction rather than acted on.

Source: [grammar.pegjs](https://github.com/kriskowal/frb/blob/2162ce7cb574f1b5aed1cf8118c1548de8b85d70/grammar.pegjs) at commit `2162ce7c`.
