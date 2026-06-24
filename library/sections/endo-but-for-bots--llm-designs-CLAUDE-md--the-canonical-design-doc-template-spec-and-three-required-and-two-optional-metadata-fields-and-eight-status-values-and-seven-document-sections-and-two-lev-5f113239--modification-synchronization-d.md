---
title: §Modification-synchronization discipline — bold-faced policy
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

Lines 105-108:
> **Any modification to a design document — especially its metadata — must be synchronized with `designs/README.md`.**

§Named-synchronization-discipline — §when-a-design-doc-is-modified, §the-README-summary-must-be-updated; §the-discipline-IS-bolded-in-the-CLAUDE.md-to-emphasize-its-importance; §sibling-pattern to git's two-step commit-and-push discipline (the design-doc IS the commit; the README IS the index).

§First-explicit-observation in library: **§the-modification-synchronization-discipline-IS-bold-faced-in-the-CLAUDE.md — §when-the-template-bolds-a-rule, §the-rule-IS-the-most-important-discipline-in-the-policy**.

§The-rule-encodes-a-data-flow: design-doc → README. §the-data-flow-IS-one-way: §the-design-doc-IS-authoritative + §the-README-IS-derived; §the-README-IS-a-summary-projection-of-the-design-docs.
