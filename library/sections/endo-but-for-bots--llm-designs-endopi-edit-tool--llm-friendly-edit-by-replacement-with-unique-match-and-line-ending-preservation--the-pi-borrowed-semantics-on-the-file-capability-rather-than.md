---
section: llm-friendly-edit-by-replacement-with-unique-match-and-line-ending-preservation
source: endo-but-for-bots--llm-designs-endopi-edit-tool
topics: [agent-conventions]
status: current
title: The Pi-borrowed semantics, on the `File` capability rather than
parent: endo-but-for-bots--llm-designs-endopi-edit-tool--llm-friendly-edit-by-replacement-with-unique-match-and-line-ending-preservation
---

`Dir`

The §Tool surface shows the `M.interface` guard:

```js
const editSchema = M.interface('EditTool', {
  edit: M.callWhen(
    M.string(),                     // file pet name / path within Dir
    M.arrayOf(
      M.splitRecord({
        oldText: M.string(),        // unique match
        newText: M.string(),
      }),
    ),
  ).returns(M.record()),            // { applied, diff, conflicts }
});
```

Two structurally interesting moves:

1. **`M.arrayOf(M.splitRecord({oldText, newText}))` over the
   parameter type.** Multiple edits per call, each a (oldText,
   newText) pair. The §Open questions section debates *single vs
   array* — *Pi accepts both shapes (`oldText`/`newText` for one,
   `edits[]` for many). Following Pi reduces friction for migrating
   prompts; the alternative is two separate tools (`edit`,
   `multi-edit`).*

2. **The `edit` tool is a method on `File` capability, not on
   `Dir`.** The §Capability shape rationale is consistent with the
   rest of `daemon-agent-tools` (cycle 107): `Dir.lookup(name) →
   File`, then `File.edit(edits)`. The granularity is per-file, not
   per-directory; the cap chain mirrors the data-flow chain.
