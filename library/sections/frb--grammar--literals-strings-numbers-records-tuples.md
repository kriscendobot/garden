---
title: Literals — strings, numbers, tuples, records, whitespace
source: grammar.pegjs
source_repo: kriskowal/frb
source_commit: 2162ce7cb574f1b5aed1cf8118c1548de8b85d70
source_date: 2013-07-31
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [reactive-bindings]
status: current
notes: The literal/collection-constructor productions, modeled on the JSON PEG.js example. Captures the tuple-args-array vs record-args-object distinction at its parse source and the escape/number grammar the README summarizes in one line.
---

> Abstract: FRB's literal grammar is lifted, by the author's own comment, from the JSON PEG.js example. A `string` is single- or double-quoted with a shared escape table (`\n`, `\t`, `\uXXXX`, and so on) and becomes a `literal` node. A `number` matches an int / int-frac / int-exp / int-frac-exp pattern and becomes a `literal` whose value is coerced with unary `+`. The two collection constructors are where the syntax tree's two `args` shapes originate: an `array` (`[a, b, c]`) becomes a `tuple` node whose `args` is an **array** of expressions, while an `object` (`{a: x, b: y}`) becomes a `record` node whose `args` is an **object** mapping each property name to its expression. This is the parse-time root of the README's "record carries an args object instead of an args array" rule. The `_` whitespace rule (whitespace or line-terminator, zero-or-more) is threaded between tokens throughout the grammar.

```
string "string"
  = "'" chars:tickedChar* "'" { return {type: "literal", value: chars.join("")}; }
  / '"' chars:quotedChar* '"' { return {type: "literal", value: chars.join("")}; }

escape
  = "\\\\" { return "\\"; } / "\\/" { return "/"; }
  / "\\b" { return "\b"; } / "\\f" { return "\f"; } / "\\n" { return "\n"; }
  / "\\r" { return "\r"; } / "\\t" { return "\t"; } / "\\0" { return "\0"; }
  / "\\u" digits:$(hexDigit hexDigit hexDigit hexDigit) {
        return String.fromCharCode(parseInt(digits, 16));
    }
```

```
array
  = "[" _ "]"                       { return {type: "tuple", args: []}; }
  / "[" expressions:expressions "]" { return {type: "tuple", args: expressions}; }   // args is an ARRAY

object
  = "{" _ "}" _                 { return {type: "record", args: []}; }
  / "{" _ pairs:pairs "}" _     { return {type: "record", args: pairs}; }            // args is an OBJECT

pairs
  = head:pair tail:( "," _ pair )* {
        var result = {};
        result[head[0]] = head[1];
        for (var i = 0; i < tail.length; i++) result[tail[i][2][0]] = tail[i][2][1];
        return result;
    }
pair = name:word ":" _ value:expression { return [name, value]; }
```

```
// literals closely modeled after the JSON PEGJS example
number "number" = parts:$(numberPattern) { return {type: "literal", value: +parts}; }
numberPattern   = int frac exp / int frac / int exp / int
int             = digit19 digits / digit / "-" digit19 digits / "-" digit
frac            = "." digits
exp             = e digits

// white space and comments defined as in the JavaScript PEGJS example
_           = ( whiteSpace / lineTerminator )*
comment     = "/*" comment:$(!"*/" . )* "*/" { return comment; }
```

What the source clarifies:

- **The `record` empty case (`{}`) returns `args: []` (an empty array), not an empty object** — a small inconsistency with the non-empty case's object shape, harmless because an empty record has no keys to read either way.
- **`word` is liberal:** `[a-zA-Z_0-9-]+`, so property names may contain hyphens and digits. This is why DOM-style names (`data-foo`) parse as bare property words.
- **A `comment` production exists** (`/* ... */`) but is not wired into `_`; comments are recognized by the rule but only consumed where a grammar rule explicitly references them (the MCS sheet grammar), not interleaved with general whitespace.

Source: [grammar.pegjs](https://github.com/kriskowal/frb/blob/2162ce7cb574f1b5aed1cf8118c1548de8b85d70/grammar.pegjs) at commit `2162ce7c`.
