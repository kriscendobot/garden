---
title: §"Focus management is a state machine" — named architectural style
source-slug: endo-but-for-bots--llm-designs-OUTLINER-INTERACTION-PATTERNS
section-slug: cross-directory-drift-confirmed-and-three-layer-architecture-and-pure-behavior-functions-and-eight-lessons-learned-and-named-criticism-of-contentEditable
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/OUTLINER_INTERACTION_PATTERNS.md
source-repo: endojs/endo-but-for-bots
source-path: designs/OUTLINER_INTERACTION_PATTERNS.md
source-author: Endo project (with attribution to Muddle project)
total-lines: 997
ingest-cycle: 273
ingest-date: 2026-06-10
lane: designs
scope: structural-pattern-observations
parent: endo-but-for-bots--llm-designs-OUTLINER-INTERACTION-PATTERNS--cross-directory-drift-confirmed-and-three-layer-architecture-and-pure-behavior-functions-and-eight-lessons-learned-and-named-criticism-of-contentEditable
---

Lesson 4 (line 989):
> *The pattern of "queue focus for a block that doesn't exist yet" is essential. Any operation that changes tree structure (Enter, Backspace merge, indent, unindent) will destroy and recreate DOM nodes. The focus manager must handle the gap.*

§First-explicit-observation in library: **§the-pending-focus-queue-pattern — §when-an-operation-changes-tree-structure, §the-DOM-nodes-are-destroyed-and-recreated + §the-focus-target-must-survive-this-gap + §a-queue-of-pending-focus-targets-IS-the-architectural-pattern**.

§Sibling-pattern to many DOM-mutation-and-restore patterns; §the-discipline-IS-the-named-state-machine.
