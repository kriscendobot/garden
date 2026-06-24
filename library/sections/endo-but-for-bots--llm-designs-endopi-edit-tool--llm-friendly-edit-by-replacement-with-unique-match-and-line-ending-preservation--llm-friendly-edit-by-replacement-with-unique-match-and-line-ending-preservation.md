---
section: llm-friendly-edit-by-replacement-with-unique-match-and-line-ending-preservation
source: endo-but-for-bots--llm-designs-endopi-edit-tool
topics: [agent-conventions]
status: current
title: LLM-friendly edit-by-replacement with unique-match and line-ending preservation
parent: endo-but-for-bots--llm-designs-endopi-edit-tool--llm-friendly-edit-by-replacement-with-unique-match-and-line-ending-preservation
---

> *LLM-driven coding agents perform most of their file mutations as
> "replace this exact string with this other string" rather than as
> whole-file writes. Whole-file `write` either truncates unintended
> content or forces the model to re-emit the entire file, which is
> token-expensive and error-prone for large files. The dominant
> solution across modern coding harnesses (Claude Code, Codex, Pi,
> Cursor) is an *edit* tool with two arguments: `oldText` (a unique
> snippet to replace) and `newText` (the replacement), with optional
> batching of multiple edits per call.*
>
> — `designs/endopi-edit-tool.md` §Motivation

`endopi-edit-tool.md` (122 lines, *Proposed* status, created
2026-05-15) is the *third endopi-* design ingested and the first of
the six unindexed endopi-* spinouts named by cycle 121's
family-keystone ingest. Parent: `endopi.md`. The design closes the
specific gap surfaced in §Feature-by-Feature Mapping §Built-in tool
core: *Endo's `daemon-agent-tools` design lists `readFile` and
`writeFile` but no edit-by-replacement primitive*, and
*[cli-edit-verb](cli-edit-verb.md) is the human-on-CLI shape
(hashline patches), not the shape LLMs use today*.
