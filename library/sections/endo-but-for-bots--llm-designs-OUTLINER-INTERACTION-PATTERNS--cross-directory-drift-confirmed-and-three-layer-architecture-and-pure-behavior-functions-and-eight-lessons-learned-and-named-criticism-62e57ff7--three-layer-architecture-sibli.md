---
title: §Three-layer architecture — sibling to cycle 271's three-layers-not-one
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

Lines 30-46 carry an ASCII-art architecture diagram with three named layers:

```
┌──────────────────────────────────────────────────────┐
│  Behavior Layer (pure functions)                     │
│  editing.ts, navigation.ts, selection.ts, dragDrop.ts│
│  Input: context object → Output: action descriptor   │
├──────────────────────────────────────────────────────┤
│  Component Layer (React)                             │
│  BlockContent, Block, BlockTree, BoundingBoxSelection│
│  Translates DOM events → contexts, actions → effects │
├──────────────────────────────────────────────────────┤
│  Data Layer (Automerge CRDT)                         │
│  BlockHandle, BlockTreeContext                       │
│  Tree mutations, content updates, sync               │
└──────────────────────────────────────────────────────┘
```

§Three named layers:
1. **Behavior Layer** (pure functions) — context object → action descriptor.
2. **Component Layer** (React) — DOM events → contexts; actions → effects.
3. **Data Layer** (Automerge CRDT) — tree mutations + content updates + sync.

§Two-cycles-with-three-layer-architectures-as-named-design-rationale (271 endor-bus-tui's bus-verbs + XS-handles + Exo-wrapper; 273 outliner's Behavior + Component + Data); §the-three-layers-IS-the-canonical-shape-for-decoupling-concerns-in-the-cluster.

§First-explicit-observation in library: **§the-ASCII-art-architecture-diagram-as-named-visual-design-discipline — §the-diagram-IS-NOT-a-Mermaid-graph (cycle 267's README's discipline) + §the-ASCII-art-IS-self-contained-and-readable-in-source + §sibling-pattern-to-RFCs-and-Linux-kernel-documentation**.

§Sibling-pattern to cycle 267's Mermaid graph in README.md; §the-cluster-has-two-named-diagram-conventions (Mermaid + ASCII-art); §first-explicit-observation in library of §the-cluster-has-two-named-diagram-conventions.
