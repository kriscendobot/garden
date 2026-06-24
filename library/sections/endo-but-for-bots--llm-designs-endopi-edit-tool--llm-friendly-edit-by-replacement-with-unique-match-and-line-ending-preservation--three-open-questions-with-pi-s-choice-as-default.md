---
section: llm-friendly-edit-by-replacement-with-unique-match-and-line-ending-preservation
source: endo-but-for-bots--llm-designs-endopi-edit-tool
topics: [agent-conventions]
status: current
title: Three open questions, with Pi's choice as default
parent: endo-but-for-bots--llm-designs-endopi-edit-tool--llm-friendly-edit-by-replacement-with-unique-match-and-line-ending-preservation
---

The §Open questions section names three:

1. *Single (`oldText`, `newText`) vs array of pairs?* Pi accepts
   both; follow Pi to reduce migration friction for prompts.

2. *Where does the diff land in the agent transcript? As a
   `toolResult` text block (consistent with Pi) vs. a structured
   value-message attachment?* The §value-message reference points
   back to cycle 103's `daemon-value-message` — the design hasn't
   chosen yet but the alternatives are well-defined.

3. *Does `oldText` need to support regex?* The §design answer:
   *Pi declines; Endo should match Pi's choice (regex multiplies
   the prompt-injection surface).* The same *minimal-surface-for-
   prompt-injection-resistance* discipline that cycle 107's
   daemon-agent-tools applied to shell-command argument arrays
   (no shell expansion).
