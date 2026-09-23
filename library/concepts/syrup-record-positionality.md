---
id: syrup-record-positionality
aliases: ["Syrup record positionality", "Syrup field names on the wire", "record field rename wire-compat", "makeOcapnRecordCodecFromDefinition", "positional bindings not on the wire", "OcapnLocation field rename", "transport vs network field rename"]
topics: [ocapn, marshal]
---

# syrup-record-positionality

In Endo's Syrup codec for OCapN records, the JS field names supplied
to `makeOcapnRecordCodecFromDefinition('OcapnNode', 'ocapn-peer',
{transport: 'selector', designator: 'string', hints: ...})` are
**positional bindings, not on-the-wire field names**. Only the
record label (`ocapn-peer`) and the field *order* are part of the
canonical wire representation. Renaming `transport` → `network` (or
any other field) in the JS definition is therefore a **source-only,
wire-compatible refactor** across implementations, provided:

1. The field order is preserved.
2. The value type (e.g. `'selector'`) is preserved.
3. Every consumer in the package that reads the field as a JS
   property (`loc.transport`) is updated in lockstep with the
   rename.

`makeRecordCodecFromDefinition` iterates `Object.entries(definition)`
for both read and write, so the field names exist only in the JS
binding map; the serialized record carries values positionally
after the label.

## Common confusions

A library reader scanning the ntsep design's discussion of the
`transport` → `network` rename may conclude that field names are on
the wire (because the spec discussion talks about "the field named
`transport`"). They are not — the spec discussion is about the JS
*API surface* of the codec, not the Syrup serialized form. This
concept page exists specifically so that lookup converges on the
positionality answer rather than the API-surface framing.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [ntsep/compatibility-and-upgrade](../sections/endo-but-for-bots--llm-designs-ntsep--compatibility-and-upgrade.md) | The ntsep design discusses the `transport` → `network` rename at the API-surface level; combine with this concept page for the wire-compat conclusion. |
| [ntsep/problem-statement](../sections/endo-but-for-bots--llm-designs-ntsep--problem-statement.md) | The motivation for the rename; the discussion focuses on conceptual cleanup, not wire format. |

## See also

- [[producer-typed-shape-consumer-rendering]] — the JS field names are the *typed-shape* layer; the wire is one rendering of that shape.
- [[permits-buckets]] — sibling structural fact about an Endo subsystem (SES permits) whose discriminator turns out to be one specific property.

## Provenance note

Concept added in cycle 52 as a library-bug-fix from the round-2 A/B
test's Q5: a treatment agent concluded the rename was wire-breaking
because library sections did not foreground the positionality fact.
This page exists so the next agent's lookup lands here and the
correct answer is on the surface.
