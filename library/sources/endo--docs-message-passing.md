---
source: docs/message-passing.md
source_repo: endojs/endo
source_commit: 14a0b631832ff516b4cafa3946a4a3c0ccbcf052
source_date: 2026-01-04
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
section_count: 9
status: current
notes: 1340-line tutorial-shaped source covering the Endo message-passing model end-to-end. 9 H2 sections at substantial size (defensive-receive is 257 lines, digital-purse example 197). The digital-purse worked example is the canonical reference for how pass-style + patterns + exo + eventual-send compose.
---

> Abstract: The Endo message-passing tutorial. Walks the reader from "what can be passed" (pass-style classification) through "how to validate" (patterns), "how to receive defensively" (Exo + multi-facet kits), "how to message asynchronously" (eventual-send), to a complete worked example (digital purse) and a final section on idioms and pitfalls. The single canonical document for understanding the application-facing message-passing model.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [introduction](../sections/endo--docs-message-passing--introduction.md) | eventual-send, marshal, capability-security | current |
| [foundation-what-can-be-passed](../sections/endo--docs-message-passing--foundation-what-can-be-passed.md) | pass-style, marshal | current |
| [validation-describing-what-you-accept](../sections/endo--docs-message-passing--validation-describing-what-you-accept.md) | patterns, marshal | current |
| [defensive-receive-protected-objects](../sections/endo--docs-message-passing--defensive-receive-protected-objects.md) | capability-security, exo, patterns | current |
| [eventual-send-async-messaging](../sections/endo--docs-message-passing--eventual-send-async-messaging.md) | eventual-send, captp | current |
| [digital-purse-example](../sections/endo--docs-message-passing--digital-purse-example.md) | exo, capability-security, eventual-send, marshal | current |
| [design-patterns-and-best-practices](../sections/endo--docs-message-passing--design-patterns-and-best-practices.md) | capability-security, exo, patterns | current |
| [common-pitfalls](../sections/endo--docs-message-passing--common-pitfalls.md) | eventual-send, marshal, patterns | current |
| [next-steps](../sections/endo--docs-message-passing--next-steps.md) | eventual-send, getting-started | current |

## Provenance

- File last modified 2026-01-04 by Kris Kowal.
- Captured at endo file-specific commit `14a0b631`.

Source: [docs/message-passing.md](https://github.com/endojs/endo/blob/14a0b631832ff516b4cafa3946a4a3c0ccbcf052/docs/message-passing.md).
