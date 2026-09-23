---
title: Operator precedence and token tables (the stringifier's side)
source: language.js
source_repo: kriskowal/frb
source_commit: 700193977f54da05024751adb5cabf35b6dbb7b4
source_date: 2013-06-03
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [reactive-bindings]
status: current
notes: Corrects the job's framing. language.js is NOT the module that ties parse and compile together; it is the operator-precedence and token↔type tables consumed only by stringify.js (the inverse of parse). The parse↔compile assembly lives in bind.js and observe.js.
---

> Abstract: `language.js` is FRB's operator-metadata module, not a parse/compile orchestrator. It exports four things derived from one ordered list: `precedenceLevels` (an array of arrays grouping node types from loosest-binding `tuple`/`record` down to tightest `if`), `precedence` (a `Dict` mapping each operator type to the `Set` of all operators in looser levels, so a stringifier can decide when to parenthesize), `operatorTokens` (token string → node-type, the lexer-direction map), and `operatorTypes` (node-type → token, the inverse). The sole consumer is `stringify.js`, which turns a syntax tree back into source text and needs precedence to insert minimal parentheses and the token↔type maps to render operators. Verifying the job's stated assumption: there is **no** single "language module tying parse/compile together." The README's named entry points are accurate (`frb/parse` is `parse.js`, `frb/compile-observer` and `frb/compile-binder` are their own files), and the actual assembly of parse → compile → live binding happens in `bind.js` and `observe.js`, each of which requires `parse` plus the compilers directly. `language.js`'s job is the round-trip's return leg: source → tree (parse) and tree → source (stringify, via these tables).

```javascript
var Set = require("collections/set");
var Dict = require("collections/dict");

var precedence = exports.precedence = Dict();
var levels = exports.precedenceLevels = [
    ["tuple", "record"],
    ["literal", "value", "parameters", "property", "element", "component",
     "mapBlock", "filterBlock", "sortedBlock", "groupBlock", "groupMapBlock", "with"],
    ["not", "neg", "number", "parent"],
    ["scope"],
    ["default"],
    ["pow", "root", "log"],
    ["mul", "div", "mod", "rem"],
    ["add", "sub"],
    ["equals", "lt", "gt", "le", "ge", "compare"],
    ["and"],
    ["or"],
    ["if"]
];

levels.forEach(function (level) {
    var predecessors = Set(precedence.keys());          // every type already placed in a looser level
    level.forEach(function (operator) {
        precedence.set(operator, predecessors);         // this type's "looser-than" set
    });
});

var operatorTokens = exports.operatorTokens = Dict({
    "**": "pow", "//": "root", "%%": "log",
    "*": "mul", "/": "div", "%": "mod", "rem": "rem",
    "+": "add", "-": "sub",
    "<": "lt", ">": "gt", "<=": "le", ">=": "ge",
    "==": "equals", "<=>": "compare", "!=": "notEquals",
    "??": "default", "&&": "and", "||": "or",
    "?": "then", ":": "else"
});

exports.operatorTypes = Dict(operatorTokens.map(function (type, token) {
    return [type, token];
}));
```

What this settles and what it adds beyond the README:

- **The job's "language.js ties parse/compile together" framing is wrong, and this is the correction.** `language.js` is consumed only by `stringify.js`. The parse/compile assembly is in `bind.js`/`observe.js`. Recorded explicitly so a future reader does not re-acquire the misconception.
- **Precedence is built as predecessor-sets, not numeric levels.** Each operator's precedence value is the `Set` of every operator type defined in a looser level (`Set(precedence.keys())` snapshots all earlier-placed types). The stringifier parenthesizes a child when the child's type is in (or not above) its parent's predecessor set, a comparison cheaper and more robust than numeric-rank arithmetic.
- **This table is the third copy of the operator map, with two deliberate differences from the grammar.** The grammar's `BINARY` (see [frb--grammar--token-tables-and-precedence-climbing](frb--grammar--token-tables-and-precedence-climbing.md)) is the parse-direction source-of-truth; `language.js` carries the stringify-direction map. It lists `"!=": "notEquals"` and `"?": "then"` / `":": "else"` as tokens — types the parser never emits (the parser rewrites `!=` to `not(equals)` and builds `if` directly). These extra entries exist so the stringifier can render or recognize those surface tokens even though no `notEquals`/`then`/`else` node ever reaches it. The mild redundancy across `grammar.pegjs`, `operators.js`, and `language.js` is reconciled by construction, not by a shared constant.
- **`scope` and `number` appear in the precedence ladder** though they are not in the grammar's surface operator set, reserving precedence slots for internally-generated node types (`number` is the unary-`+` coercion type the grammar calls `toNumber`; the README, this table, and the grammar each spell that node slightly differently, a known low-stakes drift noted in the grammar section).

Source: [language.js](https://github.com/kriskowal/frb/blob/700193977f54da05024751adb5cabf35b6dbb7b4/language.js) at commit `70019397`.
