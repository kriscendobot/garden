---
kind: dispatch
role: builder
host: endolinbot
posture: liaison
short_id: 73e7c9
dispatch_root: dispatches/builder--73e7c9
repo: endojs/endo-but-for-bots
branch: llm
pr_number: null
slot: 1
---

Slot 1 eighth pick: `designs/cbors.md` (`@endo/cbors`). Contractor
substrate audit clean: no packages/cbors exists; no `@endo/cbors` or
cbor-frame references in packages/. Design dated 2026-05-04. Fresh.

Scope: new package `@endo/cbors` modeled on `@endo/netstring`. Reader
and writer share `@endo/netstring`'s API shape. CBOR byte-string head
as the length encoding. **Not a CBOR codec** — only the byte-string
head grammar.

Base: llm. PR opens DRAFT.
