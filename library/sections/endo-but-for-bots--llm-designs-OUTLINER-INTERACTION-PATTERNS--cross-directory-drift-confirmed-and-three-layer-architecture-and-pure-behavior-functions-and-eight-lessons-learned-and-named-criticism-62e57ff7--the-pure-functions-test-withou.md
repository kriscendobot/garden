---
title: §The pure-functions-test-without-browser discipline
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

Line 48: *"This makes the interaction logic trivially testable without a browser."*

§First-explicit-observation in library: **§the-pure-functions-test-without-browser-discipline-as-named-testability-driver — §when-the-component-and-data-layers-IS-removed-from-the-test, §the-behavior-layer-tests-IS-fast + §reliable + §browser-independent**.

§Sibling-pattern to many functional-architecture conventions; §the-discipline-IS-NOT-novel + §the-design-NAMES-it-as-load-bearing.

§Three-named-test-axes in the design (lines 850-980):
1. **Unit Tests for Behavior Functions** (line 852).
2. **E2E Tests for Browser Integration** (line 906).
3. **What Unit Tests Catch vs. E2E** (line 966).

§First-explicit-observation in library: **§three-named-test-axes-with-explicit-comparative-section ("What Unit Tests Catch vs. E2E") — §sibling-pattern to cycle 267's two-named-update-disciplines but applied to testing rather than to documentation maintenance**.
