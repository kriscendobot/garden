---
title: The parse entry point and the array-as-tuple shorthand
source: parse.js
source_repo: kriskowal/frb
source_commit: 700193977f54da05024751adb5cabf35b6dbb7b4
source_date: 2013-06-03
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [reactive-bindings]
status: current
notes: The frb/parse module the README's language interface names. Tiny wrapper around the generated grammar; included to verify the README's module path and to capture the array-input shorthand and the error-annotation the wrapper adds.
---

> Abstract: `parse.js` is the `frb/parse` module the README's language interface names, and it is a thin wrapper around the PEG.js-generated `grammar.js` (compiled from [grammar.pegjs](frb--grammar--token-tables-and-precedence-climbing.md)). It does two things the raw grammar does not. First, if the input is an **array** of strings rather than a single string, it parses each element and assembles a single `tuple` node, so callers can pass a list of path expressions and get one combined syntax tree (the programmatic counterpart to writing `[a, b, c]` in the surface syntax). Second, it wraps `grammar.parse` in a try/catch that rewrites the thrown error's message to append `" on line N column M"`, trimming trailing whitespace and periods first, so parse failures carry source position. It also pulls in `collections/shim` as a side effect, which is what makes the `Function.identity` / `Function.noop` / `Object.empty` helpers the compilers rely on available process-wide. Verifying the job's question: the README's `frb/parse` path is accurate, and this module is the genuine entry point; there is no separate "language module" in the parse path.

```javascript
require("collections/shim");
var grammar = require("./grammar");          // PEG.js-generated from grammar.pegjs

module.exports = parse;
function parse(text, options) {
    if (Array.isArray(text)) {
        return {
            type: "tuple",
            args: text.map(function (text) { return parse(text, options); })   // list of paths -> one tuple
        };
    } else {
        try {
            return grammar.parse(text, options || Object.empty);
        } catch (error) {
            error.message = (
                error.message.replace(/[\s\.]+$/, "") + " " +
                " on line " + error.line + " column " + error.column
            );
            throw error;
        }
    }
}
```

What the source adds beyond the README:

- **The README's module path checks out.** `frb/parse` is this file; `frb/compile-observer` and `frb/compile-binder` are their own files. The job's worry that the path might have drifted is unfounded for the parse side.
- **Array input is a real overload.** `parse(["a", "b"])` returns a `tuple` node, parallel to the surface `[a, b]` array syntax. Callers assembling several paths programmatically need not concatenate strings.
- **Errors gain position.** The wrapper is the reason FRB parse errors read `... on line N column M`; PEG.js supplies `error.line`/`error.column`, and this is where they are folded into the message.
- **The `collections/shim` import is load-bearing.** It installs the `Function.identity`, `Function.noop`, and `Object.empty` globals that `compile-observer.js` (`mapContent: Function.identity`) and `compile-binder.js` (`Function.noop`) close over. Requiring `frb/parse` therefore implicitly prepares those compilers; importing a compiler without the shim would fail on the missing helpers.

Source: [parse.js](https://github.com/kriskowal/frb/blob/700193977f54da05024751adb5cabf35b6dbb7b4/parse.js) at commit `70019397`.
