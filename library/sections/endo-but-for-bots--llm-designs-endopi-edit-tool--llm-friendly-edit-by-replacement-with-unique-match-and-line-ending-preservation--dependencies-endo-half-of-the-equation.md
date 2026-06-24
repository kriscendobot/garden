---
section: llm-friendly-edit-by-replacement-with-unique-match-and-line-ending-preservation
source: endo-but-for-bots--llm-designs-endopi-edit-tool
topics: [agent-conventions]
status: current
title: Dependencies — Endo half of the equation
parent: endo-but-for-bots--llm-designs-endopi-edit-tool--llm-friendly-edit-by-replacement-with-unique-match-and-line-ending-preservation
---

The §Dependencies table names three related Endo designs:

| Design | Relationship |
|--------|--------------|
| `daemon-capability-filesystem` | Provides `File` capability |
| `daemon-agent-tools` (cycle 107) | Sibling tool surface (read, write, exec) |
| `cli-edit-verb` | Different consumer (human, hashlines), shares helper code |

The implementation note adds:

- *Reuse the byte-level helpers from `packages/daemon` rather than
  importing Pi's TS verbatim; the algorithm is small and
  well-defined.*
- *Pi's edit tool exposes a render-side preview (`renderDiff`) in
  its TUI; Endo's equivalent lives in the Chat UI, on the existing
  diff-rendering path.*

The reuse-don't-import-Pi-TS choice is consistent with cycle 121's
*adopt Pi's developer-velocity moves without giving up Endo's
multi-agent-system shape*: the *algorithm* migrates, the *code* is
re-implemented for the Endo substrate.
