---
title: Implications for Endo
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

This is the third package in the **vetted-shim-or-pure-parser family** under `packages/`, after `@endo/hurl` (URL parsing) and `@endo/hardened-text-codecs-shim` (TextEncoder/TextDecoder). The family shares a discipline: factor parsing or shimming behavior out of the consumer that needs it, into a standalone DOM-free package that any other consumer can re-use. The chat client is the first consumer; the design names future consumers (markdown preview, agent-output rendering) as the second-order motivation.

The DI-for-highlighter pattern recurs across the Endo design corpus. `endo-but-for-bots--llm-designs-chat-color-schemes` injects a `set-theme` postMessage into the Monaco iframe rather than embedding theme awareness in the renderer; `endo-but-for-bots--llm-designs-dlt` keeps locator formatting at the CLI rather than the daemon. The pattern is consistent: *the producer offers a hook; the consumer decides what to plug in*. Calling out the producer-typed-shape / consumer-rendering discipline at the parser boundary makes the same point a third time, which is the level at which the pattern becomes a design *style* rather than three coincident decisions.

Source: [designs/chat-markdown-render.md](https://github.com/endojs/endo-but-for-bots/blob/5e6dbb533c9b9853c681588541362dbdda3a91c6/designs/chat-markdown-render.md) at commit `5e6dbb53`.
