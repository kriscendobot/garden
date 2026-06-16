---
title: "`SpaceConfig` gains a `scheme` field"
source: designs/chat-per-space-color-scheme.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 0ee0cbb3c7639985c971c30c2fb6f32e1944d55b
source_date: 2026-02-26
source_authors: [Kris Kowal]
topics: [chat-ui, agent-conventions]
status: current
parent: endo-but-for-bots--llm-designs-chat-per-space-color-scheme--spaceconfig-extension-persistence-and-monaco
---

```js
/**
 * @typedef {object} SpaceConfig
 * @property {string} id
 * @property {string} name
 * @property {string} icon
 * @property {string[]} profilePath
 * @property {'inbox'} mode
 * @property {ColorScheme} [scheme] - Color scheme preference (default: 'auto')
 */
```

The `scheme` property is **optional** — `undefined` and `'auto'`
both mean *follow system preference*. Existing persisted configs
without the field are valid.

### Note: SpaceConfig is fragmented across three designs

The current authoritative `SpaceConfig` shape is the union of
fields named across three designs:

| Field | Where introduced |
|---|---|
| `id`, `name`, `icon`, `profilePath`, `mode`, `order` | [[endo-but-for-bots--llm-designs-chat-spaces-gutter--space-model-and-persistence]] |
| (`scheme` *referenced* for home space, not detailed) | [[endo-but-for-bots--llm-designs-chat-spaces-home--indelible-space-zero-and-numbering]] |
| `scheme` (defined with 5 values + default) | This design |

A reader looking at the *gutter* design's typedef alone gets an
incomplete picture. The complete typedef has **seven fields** —
six required, one optional. Future chat-design ingests should
treat the typedef as cumulative across the chat-spaces sub-cluster,
or surface the merged definition in a shared place. The
[[space]] concept page is the natural shared definition; that page
should be the source of truth for the cumulative shape, with each
design contributing the fields its scope introduces.
