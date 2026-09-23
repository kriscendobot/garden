---
title: §Status values — eight named members with synonyms acknowledged
source-slug: endo-but-for-bots--llm-designs-CLAUDE-md
section-slug: the-canonical-design-doc-template-spec-and-three-required-and-two-optional-metadata-fields-and-eight-status-values-and-seven-document-sections-and-two-level-progress-tracking
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/CLAUDE.md
source-repo: endojs/endo-but-for-bots
source-path: designs/CLAUDE.md
source-author: Endo project (collective)
total-lines: 115
ingest-cycle: 265
ingest-date: 2026-06-10
lane: designs
parent: endo-but-for-bots--llm-designs-CLAUDE-md--the-canonical-design-doc-template-spec-and-three-required-and-two-optional-metadata-fields-and-eight-status-values-and-seven-document-sections-and-two-level-progress-tracking
---

Lines 36-50 specify the Status taxonomy:

| Status        | Meaning                                              | Notes                                          |
|---------------|------------------------------------------------------|------------------------------------------------|
| Not Started   | Design written, no implementation work begun         | Default for new designs                        |
| Proposed      | Design under discussion, not yet accepted            | Pre-acceptance                                 |
| In Progress   | Implementation underway                              | Active build phase                             |
| **Complete**  | Fully implemented (bolded)                           | §bolding-convention-for-visual-emphasis        |
| Implemented   | Synonym for Complete                                 | §synonym-explicitly-acknowledged-not-hidden    |
| Active        | Living document, continuously maintained             | Not implementation-bound                       |
| Reference     | Informational; not an implementation target          | Read-only documentation                        |
| Deprecated    | Superseded by another design                         | Replaced via `Supersedes` link                 |

§Eight-named-Status-values + §the-synonym-is-explicitly-acknowledged-not-hidden — *"Implemented | Synonym for Complete (some docs use this)"*; §the-template-acknowledges-its-own-historical-drift; §first-explicit-observation in library of §the-template-acknowledges-its-own-historical-drift-via-named-synonym-rows.

§The-bolding-convention (`**Complete**`) — §named-emphasis-for-the-success-state; §when-a-state-IS-the-goal, §the-template-allows-bolding-for-visual-emphasis; §the-emphasis-IS-instance-level-not-template-level — *"sometimes bolded"* gives the document author the choice; §first-explicit-observation in library of §the-bolding-convention-for-the-success-state-as-author-choice-not-template-mandate.

§Eight-status-values-suggest-a-state-machine — but the spec doesn't draw transitions. §the-states-ARE-named + §the-transitions-ARE-implicit + §the-template-doesn't-force-a-state-machine-shape; §the-flexibility-IS-the-point; §first-explicit-observation in library of §the-Status-values-are-eight-named-states-without-an-explicit-state-machine-transition-graph.
