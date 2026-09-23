---
title: Path expressions — pipe, chain, tail, and value
source: grammar.pegjs
source_repo: kriskowal/frb
source_commit: 2162ce7cb574f1b5aed1cf8118c1548de8b85d70
source_date: 2013-07-31
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [reactive-bindings]
status: current
notes: The PEG productions behind the README's path-expression / tail-expression prose. Captures the function-returning chain mechanism and the special-character value prefixes the README lists only as bullet points.
---

> Abstract: How FRB parses a property path like `foo.bar.map{x * 2}.sum()` into a left-leaning syntax tree. The mechanism the README prose hides is that each `tail` and `chain` production returns a **function** `previous => node`, and the `pipe` rule left-folds the head value through that list of functions, so `a.b.c` builds `property(property(property(value, "a"), "b"), "c")` by threading the accumulated node as the left argument of the next. The `tail` rule has a three-way branch on `word{expression}`: a known block name (`map`, `filter`, ...) builds the `*Block` node directly; a block whose body is the bare `value` (`this`) builds a plain function-call node; any other block body is wrapped in an implicit `mapBlock` first, which is the source of FRB's "`x.foo{bar}` means `x.map{foo{bar}}`" shorthand. The `value` rule is where the special-character prefixes resolve: `@label`→component, `$name`/`$`→parameters, `#id`→element, `&fn()`→inline function-call (carrying an `inline: true` flag the README does not mention), `^value`→parent, `this`→value, and `true`/`false`/`null` literals.

```
unary = operator:$("!" / "+" / "-") arg:unary { return {type: UNARY[operator], args: [arg]}; }
      / pipe

pipe = head:value tail:chain* {
    for (var i = 0; i < tail.length; i++) head = tail[i](head);   // left-fold the functions
    return head;
}

chain = "." tail:tail { return tail; }
      / "[" arg:expression "]" { return function (previous) {
            return {type: "property", args: [previous, arg]};      // a.[expr] -> variable-key property
        }; }
```

The `tail` rule (each alternative returns a `previous => node` function):

```
tail
  = name:word "{" expression:expression "}" {
        if (BLOCKS[name])               return prev => ({type: BLOCKS[name], args: [prev, expression]});
        else if (expression.type === "value")
                                        return prev => ({type: name, args: [prev]});
        else                            return prev => ({type: name, args: [
                                            {type: "mapBlock", args: [prev, expression]}]});  // implicit map
    }
  / name:word args:args        { return prev => ({type: name, args: [prev].concat(args)}); }  // f(a, b)
  / index:digits               { return prev => ({type: "property",
                                     args: [prev, {type: "literal", value: +index.join("")}]}); }  // numeric index
  / name:word                  { return prev => ({type: "property",
                                     args: [prev, {type: "literal", value: name}]}); }         // .name
  / expression:array           { return prev => ({type: "with", args: [prev, expression]}); }  // .[...]  with-expr
  / expression:object          { return prev => ({type: "with", args: [prev, expression]}); }  // .{...}  with-expr
  / "(" expression:expression ")" { return prev => ({type: "with", args: [prev, expression]}); }  // .(expr)
```

The `value` rule, the leaf and special-character entry point:

```
value
  = array / object / string / number
  / "this"  { return {type: "value"}; }
  / "true"  { return {type: "literal", value: true}; }
  / "false" { return {type: "literal", value: false}; }
  / "null"  { return {type: "literal", value: null}; }
  / "@" name:word         { return {type: "component", label: name}; }
  / "$" name:word         { return {type: "property", args: [{type: "parameters"}, {type: "literal", value: name}]}; }
  / "$"                   { return {type: "parameters"}; }
  / "#" name:word         { return {type: "element", id: name}; }
  / "&" name:word args:args { return {type: name, args: args, inline: true}; }   // bare inline call
  / "^" value:value       { return {type: "parent", args: [value]}; }
  / "(" expression:expression ")" { return expression; }
  / tail:tail             { return tail({type: "value"}); }   // a leading .name applies tail to the source value
  / { return {type: "value"}; }                               // empty path -> the source itself
```

Points the source settles that the prose leaves implicit:

- **`$name` desugars at parse time** to `property(parameters, "name")`; there is no `$name` node type. Likewise a leading bare `name` (no `@`/`$`/`#`) reaches the final `tail:tail` alternative and becomes `property(value, "name")`, which is why `foo` and `this.foo` parse identically.
- **`&fn()` carries `inline: true`.** The README documents bare functions but not the flag; downstream compilation reads it to distinguish an inline (argument-spreading) call from a piped one.
- **The empty-path rule (`{ return {type: "value"} }`)** is the grammar-level basis for the README's "an empty path implies the source value" rule: a binding with `""` as its path parses to a lone `value` node.
- **Implicit `mapBlock` wrapping** is a pure parse-time rewrite: `collection.criterion{expr}` becomes `criterion(mapBlock(collection, expr))`, so the block operators compose without the user spelling out the map.

Source: [grammar.pegjs](https://github.com/kriskowal/frb/blob/2162ce7cb574f1b5aed1cf8118c1548de8b85d70/grammar.pegjs) at commit `2162ce7c`.
