---
title: §The driver outer loop — six numbered steps
source-slug: garden--designs-driver-md
section-slug: the-garden's-own-script-orchestrated-PR-creation-flow-design-and-claude-on-top-vs-claude-under-script-as-named-orchestration-shape-and-multi-author-attribution-and-Update-section-at-top
source-url: https://github.com/kriskowal/garden/blob/main/designs/driver.md
source-repo: kriskowal/garden
source-path: designs/driver.md
source-author: gardener + fixer + designer
total-lines: 691
ingest-cycle: 281
ingest-date: 2026-06-10
lane: designs
scope: structural-pattern-observations
parent: garden--designs-driver-md--the-garden's-own-script-orchestrated-PR-creation-flow-design-and-claude-on-top-vs-claude-under-script-as-named-orchestration-shape-and-multi-author-attribution-and-Update-section-at-top
---

Lines 194-202 carry §the-driver's-six-numbered-steps:

1. Poll the generic job inbox at `journal/jobs/open/` and claim one job at a time via the existing claim-via-push race.
2. Read the job's `kind` and look up the corresponding workflow state machine.
3. Run the workflow's state machine.
4. On result, advance the state machine.
5. On a failure the script cannot interpret, capture the log via `git hash-object`, construct the prompt-on-failure brief, invoke claude.
6. On clean completion, return to step 1.

§First-explicit-observation in library: **§the-driver's-outer-loop-IS-six-numbered-steps-with-deterministic-default-and-LLM-fallback — §steps-1-2-3-4-6-IS-deterministic + §step-5-IS-the-LLM-fallback + §the-LLM-IS-called-only-when-the-script-cannot-decide-deterministically + §sibling-pattern to many systems' fast-path-with-LLM-fallback discipline**.
