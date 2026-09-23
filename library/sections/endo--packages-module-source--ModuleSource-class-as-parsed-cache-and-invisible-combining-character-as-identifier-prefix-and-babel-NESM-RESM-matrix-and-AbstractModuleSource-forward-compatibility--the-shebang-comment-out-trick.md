---
title: §The-shebang-comment-out-trick
source-slug: endo--packages-module-source
section-id: ModuleSource-class-as-parsed-cache-and-invisible-combining-character-as-identifier-prefix-and-babel-NESM-RESM-matrix-and-AbstractModuleSource-forward-compatibility
url: https://github.com/endojs/endo/tree/master/packages/module-source
authors: [Endo contributors]
repo: endojs/endo
path: packages/module-source/src/{module-source.js, transform-analyze.js, transform-source.js, babel-plugin.js, parse-babel.js, hidden.js}
status: shipping
ingest-cycle: 223
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-module-source--ModuleSource-class-as-parsed-cache-and-invisible-combining-character-as-identifier-prefix-and-babel-NESM-RESM-matrix-and-AbstractModuleSource-forward-compatibility
---

```js
if (moduleSource.startsWith('#!')) {
  // Comment out the shebang lines.
  moduleSource = `//${moduleSource}`;
}
```

§A-shebang-line-handled-by-comment-prefixing. §The-shebang-prefix (`#!/usr/bin/env node`) is a §Unix-convention that JavaScript parsers reject; §prepending-`//`-converts-it-to-a-line-comment without changing the source length or column numbers.

§Borrowable-pattern: §when-you-must-pass-source-text-through-a-parser-that-rejects-the-shebang, §comment-it-out-with-`//`-prefix. §The-source-length-changes-by-two-characters; §the-line-and-column-numbers-of-the-following-lines-stay-the-same.

§Sibling to cycle 218 familiar-localhttp-protocol's §canary-DNS-resolution — both designs §minimal-prefix-that-preserves-other-properties.
