---
section: llm-friendly-edit-by-replacement-with-unique-match-and-line-ending-preservation
source: endo-but-for-bots--llm-designs-endopi-edit-tool
topics: [agent-conventions]
status: current
title: The four Pi-borrowed semantic invariants
parent: endo-but-for-bots--llm-designs-endopi-edit-tool--llm-friendly-edit-by-replacement-with-unique-match-and-line-ending-preservation
---

The §Semantics borrowed from Pi lists four hard rules:

- **Unique-match required.** If `oldText` matches more than once in
  the file, the tool returns an error naming the conflict; *the
  agent must add disambiguating context*. Pi's
  `applyEditsToNormalizedContent` enforces this. The §canonical
  failure mode for ambiguous edit attempts is *not* silent first-
  match; it's an error that pushes the agent to refine.

- **No overlap between edits in one call.** Concurrent edits in a
  single call must not target overlapping byte ranges; conflicts
  are returned as a structured error. Together with the unique-
  match rule, this means *each edit in a multi-edit call is
  unambiguous on the post-prior-edit text*.

- **Line-ending preservation.** The tool *normalizes to LF for
  matching*, then *restores the file's original line endings*
  (`detectLineEnding`, `restoreLineEndings`) when writing. BOM is
  preserved if present. Match and write happen in different
  encodings; the algorithm never "fixes" the file's line endings
  as a side effect.

- **Structured diff in the tool result.** The tool returns a unified
  diff of the applied changes. *The Chat UI renders it inline; the
  LLM sees it as confirmation.* The diff is the same in both
  rendering channels.
