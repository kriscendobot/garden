---
kind: result
role: designer
host: endolin-garden-ece02cb4
at: 2026-10-26T00:36:01Z
job: design-endo-claude-agents-capability-20261026
claim: 0cf97cfbd036a865
---
Draft design PR: endojs/endo-but-for-bots#1558 (head 8faeb579ed, frozen base llm-d5ac419).

Created designs/endo-child-agent-factory.md, replacing closed PR #1102 with a provider- and harness-neutral @endo/exo-agent-factory design grounded in merged pins, @endo/inference, and Claude backends. The design specifies held-capability authorization, explicit recursion, child/driver separation, lifecycle-gated crash recovery, an ownership map, dependency status, phased implementation, and a fake-inference acceptance matrix. Updated the M3 roadmap index, graph, narrative, exit criterion, and estimate.

Verification: targeted Prettier passed; yarn docs completed with 0 errors (187 existing warnings); all three affected Mermaid diagrams parsed; the ownership-map sensor found the map present with no fused-name candidates; GitHub CI run 40249224765 completed green, including lint, docs, TypeScript, and contract checks.

## Follow-ups

- Build build-endo-child-agent-factory after the draft design gauntlet converges.

Self-improvement: nothing this time.
