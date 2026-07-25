---
title: Schema references, reasoning tradeoff, and grammar mode
source_kind: web
source_url: https://docs.fireworks.ai/structured-responses/structured-response-formatting.md
source_content_sha256: 618edcfff37257fac189eea3382834a24a18d7e5ca8e8719fa5d30b647775f51
source_authors: [Fireworks AI]
source_date: 2026-07-25
ingested: 2026-07-25
ingested_by: scholar
topics: [fireworks-ai-integration]
status: current
---

The captured reference supports most JSON Schema 2020-12 constructs plus Draft-7 `definitions` aliases: scalar and container types, properties and required fields, item and size constraints, patterns, composition, annotations, `$defs` and `definitions`, and recursive in-document references. External HTTP or file `$ref` URIs are not resolved. Fully qualified RFC 6901 pointers are portable. Fireworks additionally resolves bare `#/$defs/Foo` references from nested definitions by lifting them to a root pool, but that shorthand is provider-specific: a root definition wins collisions, otherwise the first nested definition in document order wins and is warned about. Root-level definitions and strict pointers are the portable choice.

For reasoning-capable models, `response_format` with `json_schema` disables the separate `reasoning_content` output. A caller needing both must prompt for the schema without `response_format`, then parse and validate the content itself. Grammar mode is the alternative for custom BNF constraints, including classifications and non-JSON formats. Regex `pattern` enforcement is best effort: unsupported constructs such as lookahead or lookbehind are ignored safely and fall back to an unconstrained string. These constraints should guide schema design and test coverage rather than being inferred from generic JSON Schema behavior.

Source: [Fireworks Structured Outputs](https://docs.fireworks.ai/structured-responses/structured-response-formatting.md).
