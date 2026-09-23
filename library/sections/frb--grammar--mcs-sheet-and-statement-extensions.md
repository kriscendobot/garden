---
title: MCS extensions — the sheet, block, and statement grammar
source: grammar.pegjs
source_repo: kriskowal/frb
source_commit: 2162ce7cb574f1b5aed1cf8118c1548de8b85d70
source_date: 2013-07-31
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [reactive-bindings]
status: current
notes: Productions the README's grammar section does not cover at all. The README documents only the expression language reached from `expression`; the source carries a second, declarative stylesheet grammar (sheet/block/annotation/statements/statement) under a "// MCS extensions" comment.
---

> Abstract: Below the expression grammar, `grammar.pegjs` carries a second start symbol the README never documents: `sheet`, a declarative-binding stylesheet under the comment `// MCS extensions` (MCS for Montage Component System, the framework FRB was extracted from). A sheet is a sequence of `block`s, each `@label`-named and optionally annotated with a connection kind (`<` prototype / `:` object), a module string, and an exports expression. A block body is a list of `statement`s, and a statement is one of three things: an **event listener** (`on click -> handler` / `before click -> handler`), a **binding or assignment** (`target <- source`, `target <-> source`, `target : source`, the arrow chosen from the `STATEMENTS` table, with optional trailing `, name: expression` descriptor pairs), or a **unit declaration** (`name expression`). This is the grammar of FRB's `.frb`-style declarative sheets, the form in which a whole component's bindings are written at once, as opposed to the per-binding expression strings the README's tutorial uses. Capturing it here records the productions that would otherwise be invisible from the README alone.

```
// MCS extensions

sheet
  = _ blocks:block* _ { return {type: "sheet", blocks: blocks}; }

block
  = "@" name:word _ annotation:annotation? "{" _ statements:statements "}" _ {
        return {
            type: "block",
            connection: annotation.connection,   // "prototype" | "object" | undefined
            module: annotation.module,
            exports: annotation.exports,
            label: name,
            statements: statements
        };
    }

annotation
  = connection:("<" / ":") _ module:string? _ exports:( !"{" expression )? _ {
        return {
            connection: {"<": "prototype", ":": "object"}[connection],
            module: module && module.value,
            exports: exports !== "" ? exports[1] : undefined
        };
    }
  / _ { return {}; }
```

```
statements
  = head:statement _ tail:(";" _ statement _)* ";"? _ {
        var result = [head];
        for (var i = 0; i < tail.length; i++) result.push(tail[i][2]);
        return result;
    }
  / statement:statement _ ";"? _ { return [statement]; }
  / _ { return []; }

statement
  = when:("on" / "before") " " _ type:word _ "->" _ listener:expression _ {
        return {type: "event", when: when, event: type, listener: listener};
    }
  / target:expression _ arrow:(":" / "<->" / "<-") _ source:expression _
    descriptor:("," _ name:word _ ":" _ expression:expression _)* {
        var result = {type: STATEMENTS[arrow], args: [target, source]};   // assign | bind | bind2
        if (descriptor.length) {
            var describe = {};
            for (var i = 0; i < descriptor.length; i++)
                describe[descriptor[i][2]] = descriptor[i][6];
            result.descriptor = describe;
        }
        return result;
    }
  / name:word _ expression:expression _ {
        return {type: "unit", name: name, value: expression};
    }
```

What this adds beyond the README:

- **A whole second language.** The README teaches FRB through per-binding string expressions handed to `bind`/`observe`. The sheet grammar is the bulk declarative form: one `@label { ... }` block per component, each holding many statements. A reader who only had the README would not know FRB parses this shape at all.
- **The binding arrows are statement-level, not expression-level.** `<-`, `<->`, and `:` (from `STATEMENTS`) are the connective of a `statement`, producing `bind` / `bind2` / `assign` nodes. This is why an expression string never yields a binding node (see [frb--grammar--token-tables-and-precedence-climbing](frb--grammar--token-tables-and-precedence-climbing.md)); binding direction is decided here.
- **Trailing descriptor pairs.** A statement may carry `, name: expression` pairs that populate a `descriptor` object on the node, the parse-time origin of the binding-descriptor fields (`convert`, `revert`, and so on) the README documents at the programmatic-API level.
- **Block annotations** name how the block connects to its module: `<` declares a prototype connection, `:` an object connection, with an optional module-path string and an exports expression. This is framework-integration metadata with no counterpart in the expression grammar.
- **`event` statements** (`on`/`before` ... `->` listener) are FRB's declarative event-listener form, distinct from bindings, and likewise undocumented in the README's grammar section.

Source: [grammar.pegjs](https://github.com/kriskowal/frb/blob/2162ce7cb574f1b5aed1cf8118c1548de8b85d70/grammar.pegjs) at commit `2162ce7c`.
