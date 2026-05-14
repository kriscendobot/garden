---
title: Smallcaps Cheatsheet
source: packages/marshal/docs/smallcaps-cheatsheet.md
source_repo: endojs/endo
source_commit: b024b06c7b80
source_date: 2026-02-02
source_authors: [Mark S. Miller]
ingested: 2026-05-14
ingested_by: scholar
topics: [marshal, pass-style]
status: current
---

> Abstract: Quick-reference for the smallcaps wire format. Smallcaps extends JSON with **reserved single-character string prefixes** that mark non-JSON values: `#` for special primitives (`#undefined`, `#NaN`, `#Infinity`, `#-Infinity`), `+`/`-` for BigInt (`+7`, `-3`), `%` for passable Symbols (`%foo`), `$` for remotables (`$0.tag` — slot index + optional interface tag), `&` for promises (`&1` — slot index), and `!` as the escape prefix when a real string happens to start with a reserved sigil character (so `!hello` round-trips back to `hello` only when its leading character would otherwise be interpreted). Errors use a tagged-object form. For values JSON can already round-trip with no special-prefix strings, smallcaps output is **byte-identical to JSON** — the wire-compat invariant. Replaces the older `@qclass` tagged-object form with shorter prefix sigils. One-screen lookup card for anyone reading or writing smallcaps-encoded data.

# Smallcaps Cheatsheet

An example-based summary of the Smallcaps encoding of the OCapN [Abstract Syntax](https://github.com/ocapn/ocapn/blob/main/draft-specifications/Model.md).

| pass-style name  | OCapn name    | JS example            | JSON encoding        |
| -----------------|---------------|-----------------------|----------------------|
| undefined        | Undefined     | `undefined`           | `"#undefined"`       |
| null             | Null          | `null`                | `null`               |
| boolean          | Boolean       | `true`<br>`false`     | `true`<br>`false`    |
| bigint           | Integer       | `7n`<br>`-7n`         | `"+7"`<br>`"-7"`     |
| number           | Float64       | `Infinity`<br>`-Infinity`<br>`NaN`<br>`-0`<br>`7.1` | `"#Infinity"`<br>`"#-Infinity"`<br>`"#NaN"`<br>`"#-0"` // unimplemented<br>`7.1` |
| string           | String        | `'#foo'`<br>`'foo'`   | `"!#foo"` // special strings<br>`"foo"` // other strings |
| byteArray        | ByteArray     | `buf.toImmutable()`   | // undecided & unimplemented |
| passable symbols | Symbol        | `passableSymbolForName('foo')` | `"%foo"` // in transition |
| copyArray        | List          | `[a,b]`               | `[<a>,<b>]`          |
| copyRecord       | Struct        | `{foo:a,'#foo':b}`    | `{"!#foo":<b>,"foo":<a>}` // keys sorted  |
| tagged           | Tagged        | `makeTagged(t,p)`     | `{"#tag":<t>,"payload":<p>}` |
| remotable        | Target        | `Far('foo', {})`      | `"$0.foo"`           |
| promise          | Promise       | `Promise.resolve()`   | `"&1"`               |
| error            | Error         | `TypeError(msg)`      | `{"#error":<msg>,"name":"TypeError"}` |

* The `-0` encoding is defined as above, but not yet implemented in JS.
* In JS, passable symbols are in transition from JavaScript symbols to their own representation
* The number after `"$"` or `"&"` (for remotable/Target or promise/Promise) is an index into a separate slots array.
* ***Special strings*** begin with any of the `!"#$%&'()*+,-` characters.
* `<expr>` is nested encoding of `expr`.
* To be passable, arrays, records, and errors must also be hardened.
* Structs [can only have string-named properties](https://github.com/endojs/endo/blob/master/packages/pass-style/doc/copyRecord-guarantees.md).
* Errors can also carry an optional `errorId` string property.
* We expect to expand the optional error properties over time.
* The ByteArray encoding is not yet designed or implemented.

## Readability Invariants

For every JSON encoding with no special strings, the JSON and smallcaps decodings are the same.

If a value `v` round-trips through `JSON.parse(JSON.stringify(v))` and contains no special strings, then the smallcaps encoding of `v` is identical to `JSON.stringify(v)`.

In other words, for these simple values, ***you can ignore the differences between smallcaps and JSON***.

Source: [packages/marshal/docs/smallcaps-cheatsheet.md](https://github.com/endojs/endo/blob/b024b06c7b80/packages/marshal/docs/smallcaps-cheatsheet.md) at commit `b024b06c`.
