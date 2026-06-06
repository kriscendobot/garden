---
title: §SES-censorship-evasion via §six-evasion-strategies + §comment-defanging-with-three-patterns + §HTML-comment-in-code-edge-case (`x-->y` → `(0,x--)>y`) + §adoptStartFrom-with-zero-width-end + §JSON-roundtrip-to-sever-references + §sync-and-async-API-pair + §three-overloads-with-JSDoc-narrowing + §Babel-traverse-default-import-workaround-for-node-r-esm-compat + §EVADE_METHODS-list (import + eval) + §comment-preservation-via-magic-prefix-and-jsdoc-tags + §elideComment-vs-evadeComment-two-mode + §honest-deferred-work-on-TaggedTemplateExpression + §customVisitor-escape-hatch — @endo/evasive-transform
source: endo packages/evasive-transform/{src/*.js,README.md}
source-slug: endo--packages-evasive-transform
ingest-cycle: 205
ingest-date: 2026-06-06
lane: chat
authors: [Endo contributors]
related:
  - endo--packages-marshal-src-marshal-justin-and-marshal-stringify-js (cycle 189: §SGML-comment-injection-defense at a different layer; both defend against HTML-comment-formation)
  - endo--packages-init-and-lockdown (cycle 183: SES bootstrap substrate that evasive-transform serves)
  - endo--packages-trampoline-memoize-nat-trio (cycle 199: §sync/async-two-color-sharing-via-generator-trampoline sibling — evasive-transform's sync/async pair is the simpler shape)
  - endo--packages-cli-src-utility-cluster (cycle 195: §one-purpose-per-file sibling; evasive-transform has six source files each with named purpose)
  - endo-but-for-bots--llm-designs-hardened-url-shim (cycle 200; §two-specific-hazards-named — evasive-transform addresses §SES-censorship-hazards via §six-evasion-strategies)
  - endo--packages-immutable-arraybuffer (cycle 201: §Purposeful-Violation section sibling — evasive-transform's "*X/" end-of-comment-marker defense is §deliberate-fidelity-violation for §SES-safety)
keywords:
  - SES-censorship-evasion
  - six-evasion-strategies (evadeStrings + evadeTemplates + evadeRegexpLiteral + evadeMethod + evadeDecrementGreater + evadeComment/elideComment)
  - three-problematic-sequences (import\s*\( + <!-- + -->)
  - comment-defanging-with-three-patterns (<!-- → <!=-, --> → -=>, import → IMPORT)
  - homoglyphs-for-@kriskowal joke preserved in comment
  - HTML-comment-in-code edge case (`x-->y` → `(0,x--)>y`)
  - end-of-comment-marker defense (*/ → *X/) against block-comment escape
  - adoptStartFrom-with-zero-width-end (target appears shorter than source)
  - JSON-roundtrip-to-sever-references (deep-clone loc via stringify+parse)
  - try/catch-purely-opportunistic
  - sync-and-async-API-pair (evadeCensor wraps evadeCensorSync trivially)
  - three-overloads-with-JSDoc-narrowing (return type depends on sourceUrl presence)
  - Babel-traverse-default-import-workaround (babelTraverse.default || babelTraverse for node -r esm compat)
  - TaggedTemplateExpression excluded (honest-deferred-work-named)
  - customVisitor escape-hatch
  - EVADE_METHODS list (import + eval)
  - comment-preservation-via-magic-prefix (! prefix) and JSDoc tags (@preserve/@copyright/@license/@cc_on)
  - elideComment-vs-evadeComment two-mode
  - coerces-all-comments-to-CommentBlock
  - vestigial-useLocationUnmap-option marked deprecated
  - source-map-update discipline
  - meaning-preserving-transform discipline
  - one-purpose-per-file (six source files)
  - cycle 205 chat-lane
  - twenty-first-member of small-files-with-large-knowledge-density family
  - thirty-ninth consecutive designs/chat alternation cycle 166-205
---

# @endo/evasive-transform — §SES-censorship-evasion + §six-evasion-strategies + §comment-defanging + §HTML-comment-in-code edge case + §adoptStartFrom-with-zero-width-end + §sync-and-async-API-pair + §honest-deferred-work-on-TaggedTemplateExpression

## Source

- `endo packages/evasive-transform/src/{generate,index,parse-ast,transform-ast,transform-code,transform-comment}.js` — 697 lines across 6 source files (112 + 132 + 43 + 82 + 247 + 81)
- `endo packages/evasive-transform/README.md` — ~70 lines (with worked example)
- Cycle 205 of `/loop resume the librarian work.` (chat-lane; alternates from cycle 204's designs-lane weblet-next; §thirty-ninth consecutive designs/chat alternation cycle 166-205)

§Twenty-first-member of §small-files-with-large-knowledge-density family (cycles 165-205 chat-lane).

## Single most structurally interesting move

§SES-censorship-evasion via §six-evasion-strategies named-and-exported separately, each targeting §a-specific-Babel-AST-node-type, combined in §a-single-traversal-pass. §Three-problematic-sequences (`import\s*\(`, `<!--`, `-->`) detected via §a-single-shared-evadeRegexp + §three-context-specific-transforms (strings / templates / regex-literals) + §two-special-cases (method-name-as-computed-key + the §HTML-comment-in-code edge case `x-->y`).

§The-transform-is-meaning-preserving — §the-load-bearing-discipline. §Every-transform-must-preserve-runtime-semantics while breaking the §lexical-sequences that SES rejects.

## §Six evasion strategies

### Strategy 1: §evadeStrings — `"import("` → `"im"+"port("`

```js
const evadeRegexp = /import\s*\(|<!--|-->/g;

const evadeStrings = p => {
  if (p.node.type !== 'StringLiteral') return;
  // ... break the string into BinaryExpression concatenation of substrings
  // ... such that the problematic 2-char sequence is split across the boundary
};
```

§BinaryExpression-concatenation breaks §"import" into §"im" + "port"; the §`+ 2` index offset cuts §between-the-first-two-characters of the matched sequence. §Splitting-at-character-2 ensures both halves are safe.

### Strategy 2: §evadeTemplates — `` `import(` `` → `` `im${''}port(` ``

```js
const evadeTemplates = p => {
  // ... split TemplateLiteral.quasis into multiple quasis separated by empty-string expressions
};
```

§Empty-string-expression as §a-divider that breaks the lexical sequence. §TaggedTemplateExpression-excluded because the transform would not be meaning-preserving — the tag function receives the cooked/raw arrays and would see different shapes.

§Honest-deferred-work-named:

> The transform is only meaning-preserving if not part of a TaggedTemplateExpression, so these need to be excluded until a motivating case shows up. It should be possible to wrap the tag with a function that omits expressions we insert, but that's a lot of work to do preemptively. https://github.com/endojs/endo/pull/3026#discussion_r2632507228

§The-comment-cites-the-PR-review-discussion where the deferred-work was discussed. §Sibling-pattern to cycle 197 panic's §three-named-future-extensions and cycle 204 weblet-next's §Note-on-the-Next-Rendition.

### Strategy 3: §evadeRegexpLiteral — `/import(/` → `/i\x69mport(/`

```js
const regexpReplacements = {
  i: '\\x69',
  '<': '\\x3C',
  '-': '\\x2D',
};

const evadeRegexpLiteral = p => {
  // ... replace the first character of each matched sequence with its hex escape
};
```

§Hex-escape-of-the-first-character of each matched sequence. §The-rest-of-the-sequence-stays-intact — only the first character is escaped. §The-replacement-collection-must-be-maintained-together-with-the-evadeRegexp (explicit comment).

§Three-hex-replacements for §three-leading-characters: `i` → `\x69` (for `import`), `<` → `\x3C` (for `<!--`), `-` → `\x2D` (for `-->`).

### Strategy 4: §evadeDecrementGreater — `x-->y` → `(0,x--)>y` — the §HTML-comment-in-code edge case

```js
const evadeDecrementGreater = p => {
  const { node } = p;
  if (
    node.type === 'BinaryExpression' &&
    node.operator === '>' &&
    node.left.type === 'UpdateExpression' &&
    node.left.operator === '--' &&
    !node.left.prefix
  ) {
    // Wrap the UpdateExpression in a SequenceExpression: (0, x--)
    node.left = {
      type: 'SequenceExpression',
      expressions: [{ type: 'NumericLiteral', value: 0 }, node.left],
    };
  }
};
```

§The-fascinating-edge-case. §`if (a-->b)` is valid JavaScript that means `if ((a--) > b)` — but it lexically contains `-->` which is §HTML-comment-close-marker that SES rejects.

§Defense: §SequenceExpression-wrap (`(0, x--)`) inserts §a-comma-and-a-numeric-literal between `x--` and `>`. §The-runtime-semantics-are-preserved (SequenceExpression evaluates left-to-right and returns last value). §The-lexical-sequence-`-->` is broken by `)>`.

§Borrowable-pattern: §SequenceExpression-wrap as §a-meaning-preserving-lexical-sequence-breaker.

### Strategy 5: §evadeMethod — `import()` method → `['import']()`

```js
const EVADE_METHODS = ['import', 'eval'];

const evadeMethod = p => {
  const isMethod = p.isObjectMethod() || p.isClassMethod();
  if (isMethod && node.key.type === 'Identifier' && EVADE_METHODS.includes(node.key.name)) {
    node.computed = true;
    node.key = { type: 'StringLiteral', value: node.key.name };
  }
};
```

§Two-method-names-evaded: `import` and `eval`. §Convert-from-Identifier-key-to-StringLiteral-computed-key — the method name becomes `['import']()` syntactically, which doesn't match the SES regex.

### Strategy 6: §evadeComment / §elideComment — comment-content rewriting

```js
// transform-comment.js
const HTML_COMMENT_START_RE = /<!--/g;
const HTML_COMMENT_END_RE = /-->/g;
const IMPORT_RE = /\b(import)(\s*(?:\(|\/[\/*]))/sg;

export function evadeComment(node) {
  node.type = 'CommentBlock';
  node.value = node.value
    .replace(/^\s+/gm, ' ')                      // strip extraneous comment whitespace
    .replace(HTML_COMMENT_START_RE, '<!=-')      // <!-- → <!=-
    .replace(HTML_COMMENT_END_RE, '-=>')         // --> → -=>
    .replace(IMPORT_RE, 'IMPORT$2')              // import → IMPORT
    .replace(/\*\//g, '*X/');                    // */ → *X/
}
```

§Three-defanging-replacements: `<!--` → `<!=-` (insert `=` to break), `-->` → `-=>` (insert `=` to break), `import` → `IMPORT` (uppercase to break case-sensitive regex).

§Plus-end-of-comment-marker-defense `*/` → `*X/` — §protects-against-block-comment-escape. §If-a-block-comment-contains-`*/`-and-the-coercion-to-CommentBlock-happens, §the-`*/`-inside-the-comment-would-close-the-comment-early; §inserting-`X`-breaks-this.

§The-homoglyph-joke preserved in a comment: "(featuring homoglyphs for @kriskowal)" — actually it's just uppercase IMPORT not homoglyphs. §Source-comment-as-affectionate-joke for the maintainer kriskowal.

§Coerces-all-comments-to-CommentBlock: `node.type = 'CommentBlock'` is the §first-line of the transform. §A-single-comment-block-can-absorb-formerly-line-comments without changing runtime behavior.

### §elideComment vs §evadeComment — two-mode

```js
export const elideComment = node => {
  if (node.type === 'CommentBlock') {
    if (!markedForPreservation(node.value)) {
      node.value = node.value.replace(/[^\n]+\n/g, '\n').replace(/[^\n]/g, ' ');
    }
  } else {
    node.value = '';
  }
};
```

§Two-mode:
- §evadeComment: defang the content (keep text but break lexical patterns).
- §elideComment: strip the content (preserve newlines + spaces for column-stability; the artifact shrinks but line/column positions don't shift).

§The-elideComment-discipline: §replace-non-newlines-before-last-line + §replace-non-newlines-with-spaces-on-last-line. §Result: §the-comment's-line-count-stays-the-same; §the-text-becomes-mostly-whitespace; §a-well-commented-artifact-shrinks-dramatically.

§Comment-preservation-via-magic-prefix:

```js
const markedForPreservation = comment => {
  if (comment.startsWith('!')) return true;
  if (comment.startsWith('*')) {
    return /(?:^|\n)\s*\*?\s*@(?:preserve|copyright|license|cc_on)\b/.test(comment);
  }
  return false;
};
```

§`!`-prefix: §canonical-non-elision-marker (industry convention — `/*!` is "preserve this").
§Four-JSDoc-tags: §`@preserve` + §`@copyright` + §`@license` + §`@cc_on` (Microsoft's "conditional compilation on" for IE — historical curiosity preserved).

§Borrowable-pattern: §named-preservation-prefixes-with-industry-convention for §elision-with-explicit-opt-out.

## §`adoptStartFrom`-with-zero-width-end + §JSON-roundtrip-to-sever-references

```js
const adoptStartFrom = (target, src) => {
  try {
    const srcLoc = src.loc;
    if (!srcLoc) return;
    const loc = JSON.parse(JSON.stringify(srcLoc));
    const start = loc?.start;
    target.loc = loc;
    if (start) target.loc.end = { ...start };  // zero-width end
  } catch (_err) {
    // Ignore errors; this is purely opportunistic.
  }
};
```

§Two-honest-design-moves:

1. §JSON-roundtrip-to-sever-references — `JSON.parse(JSON.stringify(srcLoc))` is the canonical deep-clone for serializable data. §Sibling-pattern to cycle 203 cache-map's §deepCopyJsonable + freezingReviver — same JSON-roundtrip-as-deep-clone pattern.
2. §Zero-width-end — the new (shorter) AST node §appears-zero-width by setting end=start. §Honest-comment names §why:

> Text of the new node is likely shorter than text of the old (e.g., "import(<url>)" -> "im"), and in such cases we don't ever want rendering of the new node to claim too much real estate so we future-proof by making it appear to be zero-width and trusting in recovery of the actual location immediately afterwards.

§Trusting-in-recovery-of-the-actual-location — §the-Babel-source-map-generator will recover the true span via §the-following-AST-nodes. §This-is-an-honest-disclosure-of-the-trick.

§Try/catch-purely-opportunistic — the entire function is wrapped in try/catch. §If-anything-fails, §ignore-it; the transform proceeds without the location adoption. §Failure-mode-is-soft: §source-maps-might-be-imperfect-but-the-code-still-works.

§Borrowable-pattern: §JSON-roundtrip-to-sever-references + §zero-width-end + §try/catch-purely-opportunistic as §three-disciplines-for-AST-location-adoption.

## §Sync-and-async-API-pair

```js
export function evadeCensorSync(source, options) {
  // ... synchronous implementation
}

export async function evadeCensor(source, options) {
  return evadeCensorSync(source, options);
}
```

§Trivial-async-wrapper for §API-symmetry. §Sibling-pattern to cycle 199 trampoline's §sync/async-two-color-sharing-via-generator — but cycle 205's shape is §simpler (just an async wrapper that delegates) because §the-transform-is-genuinely-synchronous.

§The-purpose: §callers-that-prefer-async can use `evadeCensor`; §callers-that-prefer-sync can use `evadeCensorSync`. §Both-have-identical-semantics.

§Borrowable-pattern: §sync-and-async-API-pair with §trivial-async-wrapper when §the-underlying-operation-is-synchronous-but-the-caller-might-want-async-for-uniformity.

## §Three-overloads-with-JSDoc-narrowing

```js
/**
 * @overload
 * @param {string} source
 * @param {EvadeCensorOptions & {sourceUrl: string}} options
 * @returns {TransformedResultWithSourceMap}
 */

/**
 * @overload
 * @param {string} source
 * @param {EvadeCensorOptions} [options]
 * @returns {TransformedResult}
 */

/**
 * @param {string} source
 * @param {EvadeCensorOptions} [options]
 */
export function evadeCensorSync(source, options) { ... }
```

§Three-JSDoc-overloads: §two-explicit-overloads + §one-implementation-signature. §The-narrowed-return-type depends on §whether-sourceUrl-is-provided: §presence-of-sourceUrl gives §TransformedResultWithSourceMap; §absence-gives-TransformedResult.

§Borrowable-pattern: §JSDoc-overloads with §narrowing-based-on-option-presence for §APIs-that-return-different-shapes-based-on-arguments.

## §Babel-traverse-default-import-workaround

```js
import babelTraverse from '@babel/traverse';

// TODO The following is sufficient on Node.js, but for compatibility with
// `node -r esm`, we must use the pattern below.
// Restore after https://github.com/Agoric/agoric-sdk/issues/8671.
// OR, upgrading to Babel 8 probably addresses this defect.
// const { default: traverse } = babelTraverse;
const traverse = babelTraverse.default || babelTraverse;
```

§The-CJS-ESM-interop-workaround. §Some-environments (notably `node -r esm`) §double-wrap-the-default-export; §the-clean-form fails there. §The-fallback-chain `babelTraverse.default || babelTraverse` works in both.

§TODO-with-named-future-resolution — §two-possible-fixes-named: (1) Agoric/agoric-sdk#8671 resolution; (2) upgrade to Babel 8. §Honest-named-future-conditions.

§Sibling-pattern to cycle 199 @endo/nat's §freeze-as-harden-substitute-pending-PR-#3008 — both packages have §workaround-pending-future-resolution disciplines.

§Borrowable-pattern: §CJS-ESM-interop-workaround with §named-future-resolutions in the source comment.

## §customVisitor escape-hatch

```js
export function transformAst(ast, { elideComments, onlyComments, customVisitor }) {
  traverse(ast, {
    enter(p) {
      // ... apply standard transforms ...
      if (!onlyComments) {
        // ... evadeStrings/Templates/RegexpLiteral/Method/DecrementGreater ...
        customVisitor?.(p);
      }
    },
  });
}
```

§Standard-transforms-plus-optional-custom. §The-customVisitor-receives-the-same-path-argument-as-a-normal-Babel-visitor — §full-Babel-API-access for §consumer-extensions.

§Borrowable-pattern: §customVisitor-escape-hatch for §library-extensibility without §forking.

## §Six source files with §one-purpose-per-file discipline

| File | Lines | Purpose |
| --- | --- | --- |
| `index.js` | 132 | Public API (evadeCensor + evadeCensorSync); three JSDoc overloads each |
| `parse-ast.js` | 43 | parseAst wrapper around Babel parser |
| `transform-ast.js` | 82 | transformAst: orchestrate the six strategies via Babel traverse |
| `transform-code.js` | 247 | evadeStrings + evadeTemplates + evadeRegexpLiteral + evadeMethod + evadeDecrementGreater + adoptStartFrom + addStringToExpressions |
| `transform-comment.js` | 81 | evadeComment + elideComment + markedForPreservation |
| `generate.js` | 112 | generate: wrap Babel generator with source-map handling |

§Sibling-pattern to cycle 195 cli/src cluster's §one-purpose-per-file + §no-internal-dependencies. §Cycle-205-evasive-transform has §inter-file-dependencies (transform-ast imports from transform-code + transform-comment), so it's §a-layered-module-pattern-not-flat-utility-cluster — but the §file-by-purpose discipline is the same.

§Borrowable-pattern: §one-purpose-per-file-with-named-dependencies for §multi-file-packages where §each-file's-purpose-is-its-name.

## §Vestigial useLocationUnmap option marked deprecated

```js
/**
 * @property {boolean | undefined} [useLocationUnmap] - deprecated, vestigial
 */
```

§Honest-deprecation-marker in the typedef. §The-option-is-still-accepted (for backward compatibility) but §named-deprecated-and-vestigial. §Future-removal-implied.

§Borrowable-pattern: §inline-typedef-deprecation-marker as §a-zero-friction-deprecation-signal.

## §Borrowable patterns (tier-1)

1. **§SES-censorship-evasion** as §a-named-design-purpose for §source-transforms-that-make-otherwise-rejected-code-loadable.
2. **§Six-evasion-strategies** as §a-toolkit (evadeStrings + evadeTemplates + evadeRegexpLiteral + evadeMethod + evadeDecrementGreater + evadeComment/elideComment).
3. **§Three-problematic-sequences** detected via §a-single-shared-evadeRegexp with §three-context-specific-transforms.
4. **§Comment-defanging-with-three-patterns** (`<!--` → `<!=-`, `-->` → `-=>`, `import` → `IMPORT`) + §end-of-comment-marker-defense (`*/` → `*X/`).
5. **§HTML-comment-in-code-edge-case** (`x-->y` → `(0,x--)>y`) — §SequenceExpression-wrap as §a-meaning-preserving-lexical-sequence-breaker.
6. **§adoptStartFrom-with-zero-width-end** — set target.loc.end = target.loc.start so the shorter node doesn't claim too much real estate.
7. **§JSON-roundtrip-to-sever-references** for §deep-clone-of-serializable-data (sibling to cycle 203 cache-map's §deepCopyJsonable).
8. **§Try/catch-purely-opportunistic** for §soft-failure-on-optional-operations — the transform proceeds even if location adoption fails.
9. **§Sync-and-async-API-pair** with §trivial-async-wrapper when §the-underlying-operation-is-synchronous-but-the-caller-might-want-async.
10. **§Three-overloads-with-JSDoc-narrowing** based on §presence-of-option-property — return type depends on whether sourceUrl is provided.
11. **§Babel-traverse-default-import-workaround** (`babelTraverse.default || babelTraverse`) with §named-future-resolutions for §CJS-ESM-interop.
12. **§customVisitor escape-hatch** for §library-extensibility-without-forking.
13. **§Comment-preservation-via-magic-prefix** (`!` prefix) and §JSDoc tags (`@preserve` + `@copyright` + `@license` + `@cc_on`) for §elision-with-explicit-opt-out.
14. **§elideComment-vs-evadeComment two-mode** — defang vs strip with column-stability.
15. **§Coerces-all-comments-to-CommentBlock** as §a-normalization-step that simplifies subsequent rewriting.
16. **§Honest-deferred-work-named-with-PR-discussion-citation** for §TaggedTemplateExpression-excluded.
17. **§Inline-typedef-deprecation-marker** ("deprecated, vestigial") as §a-zero-friction-deprecation-signal.
18. **§One-purpose-per-file** with §named-inter-file-dependencies — §a-layered-module-pattern-not-flat-utility-cluster.
19. **§Source-map-update-discipline** — original source map passed in, transform's mappings composed onto it.
20. **§Meaning-preserving-transform** as §the-load-bearing-discipline named in the README.
21. **§Homoglyph-joke** preserved in source comment ("(featuring homoglyphs for @kriskowal)") — §source-comments-as-affectionate-jokes for project maintainers.

## §Synthesis-target

Slot machine library §game-state-source-transform — if game logic is loaded from user-provided sources and needs to be safe for SES evaluation:

- §SES-censorship-evasion borrowable directly via §evadeCensor pre-evaluation.
- §customVisitor escape-hatch borrowable for §game-specific-AST-transforms (e.g., insert telemetry hooks, enforce game-specific lints).
- §elideComment-with-magic-prefix borrowable for §shrinking-game-bundles while §preserving-license-headers.

§Comment-defanging borrowable for any §source-rewriting that needs to §preserve-textual-meaning-while-breaking-lexical-patterns. §The-three-defanging-replacements pattern (`<!--` → `<!=-`, `-->` → `-=>`, `import` → `IMPORT`) is §the-canonical-shape.

§HTML-comment-in-code-edge-case (`x-->y` → `(0,x--)>y`) borrowable for any §JS-source-rewriting that needs to §preserve-decrement-greater-operator-sequences while §breaking-the-lexical-`-->`.

§adoptStartFrom-with-zero-width-end borrowable for any §AST-rewriting where §the-rewritten-node-is-shorter-than-the-source and §the-source-map-recovery-should-not-be-pessimized.

§JSON-roundtrip-to-sever-references borrowable for §deep-clone-of-AST-fragments (cycle 205 names it; cycle 203 cache-map names it; cycle 199 names neither but uses similar JSON-as-clone-substrate).

§Sync-and-async-API-pair borrowable for §APIs-that-might-be-called-from-both-sync-and-async-contexts.

§Inline-typedef-deprecation-marker borrowable as §a-zero-friction-deprecation-signal for §vestigial-options.

## §Cycle 205 meta-observations

§The-thirty-ninth-consecutive-designs/chat-alternation-cycle 166-205.

§Papers-lane-blocked 99+ consecutive cycles (since cycle ~106).

§Library-reaches-710-sections at cycle 205.

§Twenty-first-member of §small-files-with-large-knowledge-density family.

§Library-protocol-from-cycle-200 applied: §grep-by-source-page-existence with `endo--packages-evasive-transform` full slug — §no-prior-ingest-found.

§Six-evasion-strategies as §a-systematic-toolkit is §a-new-pattern named at this cycle. §Sibling-to cycle 189 marshal-justin's §two-pass-decoder-with-mirror-control-flow at a different layer (marshal-justin defends against SGML-comment-injection-in-rendered-output; evasive-transform defends against SES-censorship-of-sources). §Both-defend-against-HTML-comment-formation.

§SES-defense-family now in the library:
- Cycle 175 harden-selector's §race-to-install-with-pin (pre-lockdown).
- Cycle 183 init+lockdown's §NOTE-TO-REVIEWERS pattern.
- Cycle 197 panic's §three-layer-dispatch-chain (impossible-state).
- Cycle 199 memoize's §contingent-safety framing.
- Cycle 200 hardened-url-shim's §two-specific-hazards-named-with-named-defense.
- Cycle 200 worker-rust-xs's §engine-level-confinement-vs-SES-shim.
- Cycle 201 immutable-arraybuffer's §Purposeful-Violation (concordance-sniff-defense).
- Cycle 203 cache-map's §capable-of-supporting-SES (assert error notes).
- Cycle 205 evasive-transform's §SES-censorship-evasion (this cycle).

§Nine-cycles addressing §SES-related-defenses-or-accommodations across §nine-different-axes. §The-@endo-substrate is §richly-SES-aware throughout.
