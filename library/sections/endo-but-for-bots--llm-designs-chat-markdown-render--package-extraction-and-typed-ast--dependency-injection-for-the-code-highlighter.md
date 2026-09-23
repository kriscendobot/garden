---
title: Dependency injection for the code highlighter
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
parent: endo-but-for-bots--llm-designs-chat-markdown-render--package-extraction-and-typed-ast
---

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

Source: [designs/chat-markdown-render.md](https://github.com/endojs/endo-but-for-bots/blob/5e6dbb533c9b9853c681588541362dbdda3a91c6/designs/chat-markdown-render.md) at commit `5e6dbb53`.
