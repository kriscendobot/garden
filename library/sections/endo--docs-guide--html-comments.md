---
title: HTML comments
source: docs/guide.md
source_repo: endojs/endo
source_commit: fe81477bf88b00775bf135ce6cb3a7123a296e3e
source_date: 2025-09-25
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [hardened-javascript]
status: current
---

> Abstract: Edge case in JavaScript: HTML-style comments (<!-- and -->) are legal in JS but interact oddly with SES's frozen-intrinsics model. Documents the specific behaviors and any taming options.

## HTML comments

JavaScript parsers may not recognize HTML comments within source code, potentially causing different
behavior on different engines. For safety, the Agoric SES shim rejects any source code containing a comment
open (`<!--`) or close (`-->`) sequence. However, its filter uses a regular expression, not a full
parser. It unnecessarily rejects any source code containing either of the strings `<!--` or `-->`,
even if neither marks a comment.

### Dynamic import expressions

The "dynamic import expression" (`import('path')`) enables code to load dependencies at
runtime. It returns a promise resolving to the module namespace object. While it takes
the form of a function call, it's actually not a function call, but is instead JavaScript
syntax. As such it would let vat code bypass the shim's `Compartment`'s module map.
For safety, the SES shim rejects code that looks like it uses a dynamic import expression.

The regular expression for this pattern is safe and should never allow any use of
dynamic import, however obfuscated the usage is. Because of this, it may be confused
into falsely rejecting legitimate code.

For example, the word “import” near a parenthesis or at the end of a line inside a
comment is identified as a disallowed use of `import()` and falsely rejected:
```js
//
// This function calculates the import
// duties paid on the merchandise..
//
```

But the following obfuscated dynamic import usage is rightly rejected:
```js
sneaky = import
// comment to hide invocation
(modulename);
```


Source: [docs/guide.md](https://github.com/endojs/endo/blob/fe81477bf88b00775bf135ce6cb3a7123a296e3e/docs/guide.md) at commit `fe81477b`.
