---
title: `@endo/markmdown` extraction, typed AST shape, and dependency-injected highlighter
source: designs/chat-markdown-render.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 5e6dbb533c9b9853c681588541362dbdda3a91c6
source_date: 2026-03-27
source_authors: [Kris Kowal]
ingested: 2026-05-15
ingested_by: scholar
topics: [chat-ui, patterns]
status: current
---

> Abstract: The Markdown parser and renderer factor out of `packages/chat/markdown-render.js` into a new standalone package, `@endo/markmdown` (`packages/markmdown`). The package owns the parser (inline state-machine scanner + block parser) and produces a typed AST; it also provides a DOM renderer, but the parser can be consumed independently. Test fixtures live as paired `.md` / `.html` files under `packages/markmdown/test/fixtures/`, making the corpus reviewable in any editor and reusable to validate alternative implementations. The DOM renderer accepts an optional `highlightCode` callback via an options bag; `@endo/markmdown` carries no dependency on Monaco or any editor library. `@endo/chat` becomes a consumer that imports from `@endo/markmdown`, injects a Monaco-backed `highlightCode`, and post-processes the rendered DOM to replace Private-Use-Area placeholder characters with `md-chip-slot` spans. This is the producer-typed-shape / consumer-rendering discipline applied at the parser boundary.

## Package layout

```
packages/markmdown/
├── package.json
├── tsconfig.json
├── tsconfig.build.json
├── index.js
├── src/
│   ├── parse-inline.js    — state-machine inline scanner
│   ├── parse-blocks.js    — block-level parser
│   ├── render-dom.js      — AST → DOM fragment renderer
│   └── types.js           — Token, Block, RenderResult typedefs
├── test/
│   ├── render.test.js     — fixture-driven: md → DOM → HTML
│   └── fixtures/
│       ├── md/            — input Markdown files
│       └── html/          — expected HTML output (same basenames)
└── README.md
```

Exports from `packages/markmdown/index.js`:

```js
export { parseInline } from './src/parse-inline.js';
export { parseBlocks } from './src/parse-blocks.js';
export { renderBlocks, renderInlineTokens } from './src/render-dom.js';
```

The package does **not** depend on `@endo/chat` or any chat-specific code. It has no dependency on `document` at the module level; the DOM renderer accepts a `document` parameter or uses `globalThis.document` as a default. Tests use `happy-dom` (already in the monorepo).

## Test fixture convention

Each fixture is a pair sharing a basename: `test/fixtures/md/<name>.md` and `test/fixtures/html/<name>.html`. The test runner reads every `.md` file in `fixtures/md/`, parses it with `parseBlocks`, renders the resulting AST to a DOM fragment via `renderBlocks` (using `happy-dom`), serializes the fragment to HTML with `fragment.innerHTML` (or equivalent), and compares the result against the corresponding `.html` file.

This produces a **language-agnostic fixture set**: the `.md` and `.html` files are plain text, trivially reviewable in any editor or diff tool, and could be reused to validate an alternative implementation. The `.html` files contain the expected output exactly as produced by `happy-dom` serialization (including attribute order and whitespace), so they can be regenerated with a `--update` flag when the renderer changes intentionally.

The initial fixture set covers `emphasis`, `bold`, `code-spans`, `code-fences`, `headings`, `lists`, `nested-lists`, `tables`, `links`, `blockquotes`, `horizontal-rules`, `escapes`, `nesting`, `boundaries`, and `mixed` — fifteen pairs that together exercise the full grammar.

## Dependency injection for the code highlighter

The DOM renderer accepts an optional `highlightCode` function via an options bag:

```js
/**
 * @callback HighlightCode
 * @param {string} code - Raw source text
 * @param {string} language - Language tag from the fence (may be '')
 * @param {Document} document - DOM document for element creation
 * @returns {DocumentFragment} - Highlighted DOM fragment
 */

/**
 * @typedef {object} RenderOptions
 * @property {Document} [document] - DOM document
 *   (defaults to globalThis.document)
 * @property {HighlightCode} [highlightCode] - Code fence highlighter
 *   (defaults to built-in regex-based highlighter)
 */

renderBlocks(blocks, insertionPoints, options);
```

By default (no `highlightCode` supplied), code fences render as plain unhighlighted `<code>` blocks — correct and readable, just unstyled.

`@endo/chat` injects a Monaco-backed highlighter:

```js
import { renderBlocks } from '@endo/markmdown';
import * as monaco from 'monaco-editor';

const highlightCode = (code, language, doc) => {
  // Use Monaco's tokenizer for rich multi-language highlighting
  // Return a DocumentFragment with Monaco-styled spans
};

renderBlocks(blocks, insertionPoints, { highlightCode });
```

This keeps `@endo/markmdown` free of any Monaco or editor dependency while letting consumers inject whatever highlighter they have available. Other consumers (a future markdown preview, an agent-output renderer) can inject a different highlighter, fall back to none, or use a CommonMark-grade language-agnostic highlighter.

## Placeholder handling

The `` Private-Use-Area placeholder character is not special to `@endo/markmdown`. The inline parser treats it as a regular non-whitespace non-punctuation character, which means it passes through the parse tree as literal text. This is correct: the chat layer is responsible for placeholder *semantics*, and it post-processes the rendered DOM to find placeholder runs and replace them with `md-chip-slot` spans.

The clean separation is the parser equivalent of *consumers own rendering, producers own typed shape* (the [`producer-typed-shape-consumer-rendering`](../concepts/producer-typed-shape-consumer-rendering.md) concept): the parser owns the typed AST (and the rendered DOM is a faithful image of that AST), and the chat layer's chip semantics are a separate consumer concern that the parser never knows about. A future consumer that renders Markdown to terminal text, JSON, or a different DOM dialect inherits the same AST and renders its own way.

## The `@endo/chat` integration layer

`packages/chat` becomes a thin consumer of `@endo/markmdown`:

- `markdown-render.js` shrinks to a wrapper that calls `parseBlocks` and `renderBlocks` from `@endo/markmdown`, then walks the resulting DOM to find placeholder characters and replace them with `md-chip-slot` spans.
- It injects a Monaco-backed `highlightCode` into `renderBlocks` for rich syntax highlighting across all languages Monaco supports.
- `prepareTextWithPlaceholders` stays in `@endo/chat` (chat-specific).
- `renderPlainText` stays in `@endo/chat` but delegates inline parsing to `@endo/markmdown`.

`@endo/chat` adds `"@endo/markmdown": "workspace:^"` to its dependencies.

## Translation

| Paper / CommonMark term | Endo-side surface |
|---|---|
| AST | `Token` / `Block` / `RenderResult` typedefs in `packages/markmdown/src/types.js` |
| renderer | `renderBlocks`, `renderInlineTokens` — DOM-fragment producers in `render-dom.js` |
| highlighter | a `HighlightCode` callback the renderer calls per code fence |
| fixture | a paired `.md` + `.html` file under `packages/markmdown/test/fixtures/{md,html}/` |

## Implications for Endo

This is the third package in the **vetted-shim-or-pure-parser family** under `packages/`, after `@endo/hurl` (URL parsing) and `@endo/hardened-text-codecs-shim` (TextEncoder/TextDecoder). The family shares a discipline: factor parsing or shimming behavior out of the consumer that needs it, into a standalone DOM-free package that any other consumer can re-use. The chat client is the first consumer; the design names future consumers (markdown preview, agent-output rendering) as the second-order motivation.

The DI-for-highlighter pattern recurs across the Endo design corpus. `endo-but-for-bots--llm-designs-chat-color-schemes` injects a `set-theme` postMessage into the Monaco iframe rather than embedding theme awareness in the renderer; `endo-but-for-bots--llm-designs-dlt` keeps locator formatting at the CLI rather than the daemon. The pattern is consistent: *the producer offers a hook; the consumer decides what to plug in*. Calling out the producer-typed-shape / consumer-rendering discipline at the parser boundary makes the same point a third time, which is the level at which the pattern becomes a design *style* rather than three coincident decisions.

## See also

- [endo-but-for-bots--llm-designs-chat-markdown-render--motivation-and-gap-analysis](endo-but-for-bots--llm-designs-chat-markdown-render--motivation-and-gap-analysis.md) — the gaps the new package addresses.
- [endo-but-for-bots--llm-designs-chat-markdown-render--delimiter-realignment-and-flanking-rules](endo-but-for-bots--llm-designs-chat-markdown-render--delimiter-realignment-and-flanking-rules.md) — what the inline scanner inside `parse-inline.js` actually implements.
- [endo-but-for-bots--llm-designs-rpn--alternatives-and-decisions](endo-but-for-bots--llm-designs-rpn--alternatives-and-decisions.md) — the canonical example of the same producer-typed-shape discipline at a different layer (retention paths).
- [[producer-typed-shape-consumer-rendering]] — the cross-cutting concept page.

Source: [designs/chat-markdown-render.md](https://github.com/endojs/endo-but-for-bots/blob/5e6dbb533c9b9853c681588541362dbdda3a91c6/designs/chat-markdown-render.md) at commit `5e6dbb53`.
