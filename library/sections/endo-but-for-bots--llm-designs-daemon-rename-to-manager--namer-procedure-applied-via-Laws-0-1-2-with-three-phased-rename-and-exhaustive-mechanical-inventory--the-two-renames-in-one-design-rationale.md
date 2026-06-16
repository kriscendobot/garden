---
section: namer-procedure-applied-via-Laws-0-1-2-with-three-phased-rename-and-exhaustive-mechanical-inventory
source: endo-but-for-bots--llm-designs-daemon-rename-to-manager
topics: [daemon, agent-conventions, repository-governance]
status: current
title: The §two-renames-in-one-design rationale
parent: endo-but-for-bots--llm-designs-daemon-rename-to-manager--namer-procedure-applied-via-Laws-0-1-2-with-three-phased-rename-and-exhaustive-mechanical-inventory
---

The design bundles **two unrelated renames**:

1. `Daemon → Manager` (the orchestration layer)
2. `MignonicPowers → WorkerPowers` (the worker-side powers
   record)

Both are §forbidden-synonym fixes. Both touch the same
worker-side files (`worker.js`, `worker-node-powers.js`,
`worker-go-powers.js`, `bus-worker-node-powers.js`). The
§coherent-rename-batch observation: bundling them produces
*one* refactor PR rather than two interleaved ones.

The §when-bundling-helps-vs-hurts judgment: bundling is right
when (a) the changes touch overlapping files and (b) reviewer
attention can hold both renames at once. Both criteria hold
here.
