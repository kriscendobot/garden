---
title: §Six evasion strategies
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
parent: endo--packages-evasive-transform--SES-censorship-evasion-with-six-strategies-and-comment-defanging-and-decrement-greater-edge-case-and-sync-async-API-pair-and-zero-width-end-adopt-start-from
---

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
