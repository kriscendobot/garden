---
source: MANUAL.md
source_repo: kriskowal/kni
source_commit: 120fd885f15c2b0d9b2def4faa113b1a0a4e87ca
source_date: 2025-12-29
source_authors: [Kris Kowal]
ingested: 2026-07-21
ingested_by: scholar
section_count: 10
status: current
notes: Reference-shape language manual; overlaps HOWTO.md (tutorial-shape) at a different abstraction level — soft cross-reference, not a contradiction.
---

The kni Language Reference Manual: the exhaustive surface-syntax reference for authoring decision graphs (the gentler graduated on-ramp is HOWTO.md). It establishes that `kni` is simultaneously parser, compiler, and runtime, and documents each authoring construct the parser lowers into the flat instruction graph — the whitespace/text model, indentation-defined threads, the option/question/keyword choice primitive, free-form input capture into variables, flow directives (labels, gotos, loops, procedures), and the brace-block families (sequences, alternation, random/weighted/hypergeometric selection, variable switches, ternary conditions, variable loops, and in-place modifiers), plus the 32-bit expression algebra and the condition-and-consequence option operators. The input-prompt and condition-and-consequence sections are the ones most relevant to this ingest's deterministic-elicitation lens.

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/kni--manual--overview.md) | decision-graph-authoring | current |
| [text-space-and-symbols](../sections/kni--manual--text-space-and-symbols.md) | decision-graph-authoring | current |
| [indentation-and-threads](../sections/kni--manual--indentation-and-threads.md) | decision-graph-authoring | current |
| [options-and-questions](../sections/kni--manual--options-and-questions.md) | decision-graph-authoring, automatic-agentic-loop | current |
| [input-prompts](../sections/kni--manual--input-prompts.md) | decision-graph-authoring, automatic-agentic-loop | current |
| [flow-directives](../sections/kni--manual--flow-directives.md) | decision-graph-authoring | current |
| [procedures](../sections/kni--manual--procedures.md) | decision-graph-authoring | current |
| [blocks-sequences-and-alternation](../sections/kni--manual--blocks-sequences-and-alternation.md) | decision-graph-authoring | current |
| [blocks-switch-conditions-and-modifiers](../sections/kni--manual--blocks-switch-conditions-and-modifiers.md) | decision-graph-authoring | current |
| [expressions-conditions-consequences](../sections/kni--manual--expressions-conditions-consequences.md) | decision-graph-authoring, automatic-agentic-loop | current |
