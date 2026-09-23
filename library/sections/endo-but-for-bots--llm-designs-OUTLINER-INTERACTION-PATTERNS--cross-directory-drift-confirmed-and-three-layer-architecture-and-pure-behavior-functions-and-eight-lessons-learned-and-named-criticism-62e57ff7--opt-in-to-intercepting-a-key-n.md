---
title: §"opt-in to intercepting a key, never opt-out" — the load-bearing discipline
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

Lesson 8 (line 997):
> *Most keystrokes should fall through to browser defaults. The behavior layer must explicitly opt-in to intercepting a key, never opt-out. Get this wrong and you break basic typing.*

§First-explicit-observation in library: **§the-opt-in-not-opt-out-discipline-for-event-interception — §the-default-IS-fall-through + §interception-IS-explicit + §"get-this-wrong-and-you-break-basic-typing"-IS-the-failure-mode-named-explicitly**.

§Sibling-pattern to capability-systems' principle-of-least-authority (the worker doesn't need to control everything; default IS no-authority); §the-discipline-applied-to-keyboard-event-handling.

§the-`{ type: 'default' }`-action-shape — §the-named-action-IS-the-fall-through; §the-shape-IS-explicit-in-the-action-descriptor-not-implicit-in-the-absence-of-action; §sibling-pattern to many state-machine conventions.

§First-explicit-observation in library: **§the-`{ type: 'default' }`-action-as-named-fall-through-shape**.
