---
id: producer-typed-shape-consumer-rendering
aliases: ["producers own typed shape", "consumers own rendering", "no daemon-side string formatter", "typed-shape-in typed-shape-out", "formatting at the edges", "parser owns AST renderer owns DOM"]
topics: [agent-conventions, patterns, chat-ui]
---

# producer-typed-shape-consumer-rendering

A design principle that appears across the corpus: when a system
produces typed structured values that multiple consumers render
differently (CLI string vs chat markup vs JSON vs DOM), **the
producer owns the typed shape; each consumer owns its rendering**. A
producer-side string-rendering method saves canonical-form effort at
one consumer but forces other consumers to re-parse those strings to
recover segment boundaries they could read straight from the typed
value. The typed shape is the backbone that keeps the renderings from
drifting.

The principle holds at every layer where typed structure meets a
rendering boundary. The corpus carries instances at the daemon API
layer (retention paths), the locator/formula-key boundary, and the
inline-Markdown parser/DOM boundary; the same shape recurs wherever a
producer is tempted to flatten a typed structure into a string for
one consumer's convenience.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [rpn/alternatives-and-decisions](../sections/endo-but-for-bots--llm-designs-rpn--alternatives-and-decisions.md) | The worked example: rejects daemon-side `describeRetentionPaths` because it would force CLI and Chat UI to re-parse strings to recover segment boundaries. |
| [dlt/dehydration-and-hydration](../sections/endo-but-for-bots--llm-designs-dlt--dehydration-and-hydration.md) | The locator/formula-key boundary follows the same discipline: formula key is the typed shape; the URL locator is the rendered form. |
| [chat-markdown-render/package-extraction-and-typed-ast](../sections/endo-but-for-bots--llm-designs-chat-markdown-render--package-extraction-and-typed-ast.md) | Applied at the parser boundary: `@endo/markmdown` owns the typed AST; `@endo/chat` and any future consumer (markdown preview, agent-output renderer) own their rendering. The chip-slot post-process is a consumer concern the parser does not know about. |

The principle is codified in [`conventions.md`](../conventions.md) §
*Structural principles from cycles 41-43*.

## See also

- [[shape-not-content]] — sibling principle for upstream-side meta-tables.
- [[dehydrate-hydrate]] — a worked example at the formula-key / locator boundary.
