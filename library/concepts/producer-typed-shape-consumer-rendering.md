---
id: producer-typed-shape-consumer-rendering
aliases: ["producers own typed shape", "consumers own rendering", "no daemon-side string formatter", "typed-shape-in typed-shape-out", "formatting at the edges"]
topics: [agent-conventions, patterns]
---

# producer-typed-shape-consumer-rendering

A daemon-wide API design principle: when a system produces typed
structured values that multiple consumers render differently (CLI
string vs chat markup vs JSON), **the producer owns the typed shape;
each consumer owns its rendering**. A producer-side string-rendering
method saves canonical-form effort at one consumer but forces other
consumers to re-parse those strings to recover segment boundaries
they could read straight from the typed value. The typed shape is the
backbone that keeps the renderings from drifting.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [rpn/alternatives-and-decisions](../sections/endo-but-for-bots--llm-designs-rpn--alternatives-and-decisions.md) | The worked example: rejects daemon-side `describeRetentionPaths` because it would force CLI and Chat UI to re-parse strings to recover segment boundaries. |
| [dlt/dehydration-and-hydration](../sections/endo-but-for-bots--llm-designs-dlt--dehydration-and-hydration.md) | The locator/formula-key boundary follows the same discipline: formula key is the typed shape; the URL locator is the rendered form. |

The principle is codified in [`conventions.md`](../conventions.md) §
*Structural principles from cycles 41-43*.

## See also

- [[shape-not-content]] — sibling principle for upstream-side meta-tables.
- [[dehydrate-hydrate]] — a worked example at the formula-key / locator boundary.
