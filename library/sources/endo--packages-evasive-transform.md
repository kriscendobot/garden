---
title: "@endo/evasive-transform — source transforms for evading SES censorship"
source-slug: endo--packages-evasive-transform
url: https://github.com/endojs/endo/tree/master/packages/evasive-transform
authors: [Endo contributors]
repo: endojs/endo
path:
  - packages/evasive-transform/src/index.js
  - packages/evasive-transform/src/parse-ast.js
  - packages/evasive-transform/src/transform-ast.js
  - packages/evasive-transform/src/transform-code.js
  - packages/evasive-transform/src/transform-comment.js
  - packages/evasive-transform/src/generate.js
  - packages/evasive-transform/README.md
total-lines: 697 source (across 6 files: 112+132+43+82+247+81) + ~70 README
license: Apache-2.0
ingest-cycle: 205
ingest-date: 2026-06-06
lane: chat
status: current
---

# @endo/evasive-transform

> Source transforms for evading censorship in SES-enabled applications. The transform is meaning-preserving.

Covers §three-problematic-sequences (`import\s*\(` + `<!--` + `-->`) inside §five-syntactic-contexts (comments / strings / template-strings (not tagged) / regex-literals / code-as-`x-->y`) and §two-method-names (`import` + `eval`) as object/class method keys.

## Public API

- `evadeCensor(source, options)` — async wrapper
- `evadeCensorSync(source, options)` — sync core

Options: `sourceUrl` / `sourceMap` / `sourceType` (`'script'` or `'module'`) / `elideComments` / `onlyComments` / `customVisitor`.

## Six evasion strategies

1. **§evadeStrings** — `"import("` → `"im"+"port("` (BinaryExpression concatenation).
2. **§evadeTemplates** — `` `import(` `` → `` `im${''}port(` `` (empty-string-expression-as-divider). §TaggedTemplateExpression-excluded (§honest-deferred-work-named with PR discussion citation).
3. **§evadeRegexpLiteral** — `/import(/` → `/i\x69mport(/` (hex-escape of first character). Three replacements: `i` → `\x69`, `<` → `\x3C`, `-` → `\x2D`.
4. **§evadeMethod** — `import()` method → `['import']()` (computed-key); `EVADE_METHODS = ['import', 'eval']`.
5. **§evadeDecrementGreater** — `x-->y` → `(0,x--)>y` — §SequenceExpression-wrap as §a-meaning-preserving-lexical-sequence-breaker for the §HTML-comment-in-code edge case.
6. **§evadeComment / §elideComment** — comment-content rewriting (two-mode).

## Comment defanging

```js
// evadeComment replacements:
node.value
  .replace(HTML_COMMENT_START_RE, '<!=-')      // <!-- → <!=-
  .replace(HTML_COMMENT_END_RE, '-=>')         // --> → -=>
  .replace(IMPORT_RE, 'IMPORT$2')              // import → IMPORT
  .replace(/\*\//g, '*X/');                    // */ → *X/  (end-of-comment-marker defense)
```

§Coerces-all-comments-to-CommentBlock. §End-of-comment-marker-defense (`*/` → `*X/`) protects against block-comment-escape. §Source-comment preserves §the-homoglyph-joke: "(featuring homoglyphs for @kriskowal)".

## Comment preservation via magic prefix

```js
const markedForPreservation = comment => {
  if (comment.startsWith('!')) return true;
  if (comment.startsWith('*')) {
    return /(?:^|\n)\s*\*?\s*@(?:preserve|copyright|license|cc_on)\b/.test(comment);
  }
  return false;
};
```

§`!`-prefix (industry-convention) + §four-JSDoc-tags (`@preserve` + `@copyright` + `@license` + `@cc_on` — Microsoft's "conditional compilation on" for IE).

## §elideComment vs §evadeComment two-mode

- §evadeComment: defang content (keep text, break lexical patterns).
- §elideComment: strip content (preserve newlines + spaces for §column-stability; well-commented artifact shrinks dramatically).

## Key design moves

- **§adoptStartFrom-with-zero-width-end** — sets target.loc.end = target.loc.start so the (shorter) new node doesn't claim too much real estate; §honest-comment names §"trusting in recovery of the actual location immediately afterwards" (Babel source-map generator recovers true span via following nodes).
- **§JSON-roundtrip-to-sever-references** — `JSON.parse(JSON.stringify(srcLoc))` for deep-clone of serializable AST location data.
- **§Try/catch-purely-opportunistic** — adoptStartFrom wrapped in try/catch; failure-mode is soft (source-maps might be imperfect but the code still works).
- **§Sync-and-async-API-pair** — `evadeCensor` is a trivial async wrapper around `evadeCensorSync`; §API-symmetry for callers preferring either shape.
- **§Three-overloads-with-JSDoc-narrowing** — return type depends on whether `sourceUrl` is provided (`TransformedResultWithSourceMap` vs `TransformedResult`).
- **§Babel-traverse-default-import-workaround** — `babelTraverse.default || babelTraverse` for §CJS-ESM-interop in `node -r esm` environments; §TODO names two-possible-resolutions (Agoric/agoric-sdk#8671 OR upgrade to Babel 8).
- **§customVisitor escape-hatch** — consumers can add their own Babel visitor function to the standard transforms.
- **§Vestigial-useLocationUnmap-option** marked "deprecated, vestigial" in the typedef — §inline-typedef-deprecation-marker.
- **§Meaning-preserving-transform** as §the-load-bearing-discipline named in README.
- **§Source-map-update discipline** — original source map can be passed in to be updated with the transform's mappings.
- **§One-purpose-per-file** across six source files (index / parse-ast / transform-ast / transform-code / transform-comment / generate) with §named-inter-file-dependencies — §a-layered-module-pattern-not-flat-utility-cluster.

## Three problematic sequences

```js
const evadeRegexp = /import\s*\(|<!--|-->/g;
```

§Three-sequences-SES-rejects: §dynamic-`import()` (SES disallows dynamic imports for confinement); §HTML-comment-open `<!--`; §HTML-comment-close `-->`. §The-regex-is-shared-across-evadeStrings + evadeTemplates + evadeRegexpLiteral; §the-three-context-specific-transforms apply context-appropriate breaking.

## Ingest scope

Cycle 205 (chat-lane): full ingest of the six source files + README. One section because §the-package-is-structurally-one-purpose (SES-censorship-evasion) with §six-strategies-as-orchestrated-pieces.

## Related material in the library

- **cycle 189 endo--packages-marshal-src-marshal-justin-and-marshal-stringify-js**: §SGML-comment-injection-defense at a different layer — both designs defend against HTML-comment-formation. Cycle 189 defends against §HTML-comment-formation-in-rendered-output; cycle 205 defends against §HTML-comment-sequences-in-source-rejected-by-SES.
- **cycle 183 endo--packages-init-and-lockdown**: SES bootstrap substrate that evasive-transform serves.
- **cycle 199 endo--packages-trampoline-memoize-nat-trio**: §sync/async-two-color-sharing-via-generator-trampoline sibling — evasive-transform's sync/async pair is the simpler shape (trivial async wrapper) because the operation is genuinely synchronous.
- **cycle 195 endo--packages-cli-src-utility-cluster**: §one-purpose-per-file sibling pattern (cycle 195: flat utility cluster; cycle 205: layered module pattern with inter-file deps).
- **cycle 203 endo--packages-cache-map**: §deepCopyJsonable + freezingReviver — JSON-roundtrip-as-deep-clone sibling. Cycle 203 adds freeze pass via reviver; cycle 205 omits the freeze.
- **cycle 201 endo--packages-immutable-arraybuffer**: §Purposeful-Violation section sibling — evasive-transform's `*/` → `*X/` end-of-comment-marker defense is §deliberate-fidelity-violation for §SES-safety.
- **cycle 200 worker-rust-xs**: §engine-level-confinement-vs-SES-shim-source-rewriting — cycle 205 is one of the SES shim's source-rewriting tools that cycle 200 would obsolete with native Compartment enforcement.
- **cycle 175 endo--packages-harden-make-selector**: §race-to-install-with-pin pre-lockdown discipline sibling.
- **`@endo/compartment-mapper`** (the consumer): uses evasive-transform to prepare bundles for SES.
