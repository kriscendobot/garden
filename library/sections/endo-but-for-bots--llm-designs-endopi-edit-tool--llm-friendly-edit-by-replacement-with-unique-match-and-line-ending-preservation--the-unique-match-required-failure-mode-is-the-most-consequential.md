---
section: llm-friendly-edit-by-replacement-with-unique-match-and-line-ending-preservation
source: endo-but-for-bots--llm-designs-endopi-edit-tool
topics: [agent-conventions]
status: current
title: The unique-match-required failure mode is the most consequential
parent: endo-but-for-bots--llm-designs-endopi-edit-tool--llm-friendly-edit-by-replacement-with-unique-match-and-line-ending-preservation
---

discipline

*Unique-match required* is the design's central capability-shape
choice. Modern LLM agents are good at finding *almost*-unique
snippets; the failure mode where an `oldText` matches twice and
the tool silently edits the first match is the source of most
LLM-edit bugs. Pi's approach (and now Endo's) is to *fail loudly*
and force the agent to add context. The contract is *contract not
heuristic* — the same discipline cycle 116's `daemon-form-request`
applied to fields: *patterns are a contract, not a hint*.
