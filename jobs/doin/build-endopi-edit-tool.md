---
role: builder
---

Build the `endopi-edit-tool` M3 design in endojs/endo-but-for-bots (branch off `llm`): add an `edit` tool to the Lal and Fae agents that operates on a `File` capability with `oldText`/`newText` replacement semantics (optional multi-edit batching), modeled on Pi's `coding-agent/src/core/tools/edit.ts`, complementing the existing `readFile`/`writeFile` tools from the daemon-agent-tools design.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 5
  claimed_at: 2026-07-10T10:16:04Z
