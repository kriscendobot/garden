---
title: Package layout
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

Source: [designs/chat-markdown-render.md](https://github.com/endojs/endo-but-for-bots/blob/5e6dbb533c9b9853c681588541362dbdda3a91c6/designs/chat-markdown-render.md) at commit `5e6dbb53`.
