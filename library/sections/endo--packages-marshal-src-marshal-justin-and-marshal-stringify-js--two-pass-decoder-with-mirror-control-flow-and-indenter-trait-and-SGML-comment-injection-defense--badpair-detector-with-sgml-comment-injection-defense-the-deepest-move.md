---
source: packages/marshal/src/marshal-justin.js + packages/marshal/src/marshal-stringify.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/tree/master/packages/marshal/src
source_path: packages/marshal/src/marshal-justin.js, packages/marshal/src/marshal-stringify.js
section_kind: source
ingested: 2026-06-04
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
  - Mark S. Miller (prompted)
topics:
  - marshal
  - pass-style
  - errors
genre: §endo-source-comment-fragment §canonical-passable-rendering-pair
cycle: 189
lane: chat
status: current
title: §badPair-detector with SGML-comment-injection-defense (the deepest move)
parent: endo--packages-marshal-src-marshal-justin-and-marshal-stringify-js--two-pass-decoder-with-mirror-control-flow-and-indenter-trait-and-SGML-comment-injection-defense
---

```js
/**
 * If the last character of one token together with the first character
 * of the next token matches this pattern, then the two tokens must be
 * separated by whitespace to preserve their meaning. Otherwise the
 * whitespace in unnecessary.
 *
 * The `<!` and `->` cases prevent the accidental formation of an
 * html-like comment. I don't think the double angle brackets are actually
 * needed but I haven't thought about it enough to remove them.
 */
const badPairPattern = /^(?:\w\w|<<|>>|\+\+|--|<!|->)$/;
```

§Six-bad-pair-cases:

1. **§`\w\w`**: identifier or number continuation (e.g.,
   `if`+`true` → `iftrue` would be a different identifier).
2. **§`<<` / §`>>`**: prevent left/right-shift token formation.
3. **§`++` / §`--`**: prevent increment/decrement token
   formation.
4. **§`<!` / §`->`**: §prevent-accidental-formation-of-html-
   like-comment.

§The-§SGML-comment-injection-defense (`<!` and `->`) is the
§deepest-move. §An-HTML-comment is `<!-- ... -->`. §If-tokens-
that-end-in-`<` and start with `!` appear adjacent (e.g.,
`x < !y` minified to `x<!y`), the §parser-might-interpret as
the start of an HTML comment. §Same-with `--` followed by `>`
forming the comment's closing `-->`.

§The-comment-named-the-uncertainty: "I don't think the double
angle brackets are actually needed but I haven't thought about
it enough to remove them." §Honest-uncertainty-named-in-source.
§Compare-to-cycle-184-metering's §"It just occurred to me"
design-evolution disclosure. §Both-are-§honest-known-unknowns.

§Why-this-matters: a §minified-JS-renderer that doesn't
separate `<!` could produce code that breaks in HTML-embedded
JavaScript contexts. §The-defense-is-cheap (one regex check
per token).

§Compare-to-cycle-181-base64's §padding-acceptance-permissive-
per-RFC-4648-§3.5 with-citation. §Both-are-§named-defense-with-
named-context. §Cycle-189-cites-the-HTML-comment-risk; cycle
181-cites the RFC.

§Tier-1-borrowing: §SGML-comment-injection-defense applies
wherever a minified-renderer could output code that lands in
an HTML-context. §The-`<!`-and-`->`-pair-check is the
canonical guard.
