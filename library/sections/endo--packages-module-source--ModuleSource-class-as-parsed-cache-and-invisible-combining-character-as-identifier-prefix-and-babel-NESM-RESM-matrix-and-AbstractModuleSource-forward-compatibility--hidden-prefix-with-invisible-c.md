---
title: §HIDDEN_PREFIX with invisible combining character (hidden.js)
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
export const HIDDEN_PREFIX = '$h͏_';
export const HIDDEN_CONST_VAR_PREFIX = '$c͏_';
export const HIDDEN_A = `${HIDDEN_PREFIX}a`;
// ...
```

§The-single-most-structurally-novel-move. §`͏` is the Unicode §Combining-Grapheme-Joiner — §a-non-displayed-combining-character. The identifier `$h͏_a` §visually-looks-like-`$h_a` but is a §different-JavaScript-identifier-from-`$h_a` because of the invisible code point.

§No-collision-with-user-code because §user-code-wouldn't-accidentally-include-U+034F-in-identifiers. §The-prefix-is-functionally-invisible-but-uniquely-recognizable-by-the-parser.

§Borrowable-pattern: §use-an-invisible-Unicode-character-in-identifier-prefixes-to-avoid-collision-with-user-code. §Different-from-`__HIDE_`-prefix (cycle 217): the §`__HIDE_`-prefix-is-visible + §the-name-collision-is-prevented-by-convention; §the-`͏`-prefix-is-invisible + §the-name-collision-is-prevented-by-implausibility.

### §HIDDEN_META sized to match `import.meta`

```js
// HIDDEN_META is used to replace `import.meta`. The value fits the original
// length so it doesn't displace the column number of following text
export const HIDDEN_META = `${HIDDEN_PREFIX}___meta`;
```

§Source-map-friendly-replacement: §the-substitution-fits-the-original-length-so-column-numbers-don't-shift. §`import.meta` is 11 characters; `$h͏____meta` is also 11 characters (counting `͏` as 1 code-point but the underscore-padding compensates).

§Borrowable-pattern: §when-you-substitute-tokens-in-source-text, §size-the-replacement-to-match-the-original-length-so-source-maps-stay-aligned. §The-cost-of-deviation-is-broken-source-maps + §the-cost-of-conformance-is-padding-the-substitute.

§Sibling to cycle 215 @endo/hex's §`c | 0x20`-fold-uppercase-onto-lowercase trick — both designs §micro-optimization-where-the-format-matters-more-than-readability.

### §HIDDEN_IDENTIFIERS as the enumerated list

```js
export const HIDDEN_IDENTIFIERS = [
  HIDDEN_A,
  HIDDEN_IMPORT,
  HIDDEN_IMPORT_SELF,
  HIDDEN_IMPORTS,
  HIDDEN_ONCE,
  HIDDEN_META,
  HIDDEN_LIVE,
];
```

§Seven-named-hidden-identifiers as the §static-allow-list. §Borrowable-pattern: §enumerate-the-complete-set-of-reserved-identifiers-as-a-named-export so consumers can §audit + §validate + §collision-check at module load.
