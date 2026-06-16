---
title: Attenuation by extension, not contraction
source: designs/daemon-capability-persona.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: bcb6c379325b0f66d211d759ce7d3031fbf94e5b
source_date: 2026-02-24
source_authors: [Kris Kowal]
topics: [daemon, capability-security, patterns]
status: current
parent: endo-but-for-bots--llm-designs-dcp--recursive-chains-and-enforcement
---

This is the same **attenuation pattern** as Dir/File in the daemon: a
Dir can create a sub-Dir (narrowing scope) but cannot widen it. A
delegate can create sub-delegates (adding epithets) but cannot remove
inherited ones. Authority over identity narrows as you go deeper in
the delegation tree.
