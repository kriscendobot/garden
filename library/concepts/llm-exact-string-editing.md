---
id: llm-exact-string-editing
aliases: [endopi edit tool, edit-by-replacement, exact-string replacement, oldText/newText, editText, structured diff preview]
topics: [agent-conventions]
status: draft
---

# llm-exact-string-editing

An LLM-oriented file-edit primitive replaces an `oldText` snippet only when it matches uniquely, accepts ordered non-overlapping replacements, preserves line endings and byte-order marks, and returns a unified diff as confirmation; each consumer owns how that structured result is rendered, such as an inline Chat preview with distinct file, hunk, addition, and removal rows.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [LLM-friendly edit-by-replacement with unique-match and line-ending preservation](../sections/endo-but-for-bots--llm-designs-endopi-edit-tool--llm-friendly-edit-by-replacement-with-unique-match-and-line-ending-preservation--llm-friendly-edit-by-replacement-with-unique-match-and-line-ending-preservation.md) | Frames exact replacement as the LLM-facing editing primitive and the unified diff as confirmation. |
| [The four Pi-borrowed semantic invariants](../sections/endo-but-for-bots--llm-designs-endopi-edit-tool--llm-friendly-edit-by-replacement-with-unique-match-and-line-ending-preservation--the-four-pi-borrowed-semantic-invariants.md) | Requires unique matches, non-overlap, line-ending preservation, and structured diff results. |
| [File-mutation queueing](../sections/endo-but-for-bots--llm-designs-endopi-edit-tool--llm-friendly-edit-by-replacement-with-unique-match-and-line-ending-preservation--file-mutation-queueing-eventual-send-semantics-already.md) | Uses per-capability eventual-send ordering instead of a separate mutation queue. |

## See also

- [[pi-agent-loop]] — the agent-loop ecosystem from which the editing behavior is adapted.
- [[code-change-operational-transform]] — a revisioned multi-editor change stream rather than unique exact-string replacement.
