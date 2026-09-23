---
section: mustache-placeholder-editor-expansion-not-agent-invocation-with-shared-discovery-walker
source: endo-but-for-bots--llm-designs-endopi-prompt-templates
topics: [agent-conventions]
status: current
title: The §shared-discovery-walker discipline
parent: endo-but-for-bots--llm-designs-endopi-prompt-templates--mustache-placeholder-editor-expansion-not-agent-invocation-with-shared-discovery-walker
---

The §Discovery paragraph names the *same walker that handles
[endopi-skills-markdown-format](endopi-skills-markdown-format.md)
scans a parallel set of paths for `*.md` files*:

- `~/.pi/agent/prompts/*.md`
- `~/.agents/prompts/*.md` (cross-harness)
- `.pi/prompts/*.md`
- `.agents/prompts/*.md` (walk up from cwd)

The §parallel-paths-with-cross-harness-aliasing discipline
mirrors cycle 112's skills-format design exactly. Two
canonical-name paths (`.pi/` for Pi, `.agents/` for cross-harness)
× two scopes (global at `~/`, project at `cwd/`). The walk-up-from-
cwd shape lets a project override global templates.

The §same-walker-as-skills note: cycle 112's skills format design
already implemented the discovery walker; this design *just adds
a parallel set of paths*. No new traversal machinery. The
*one-walker-many-resource-kinds* substrate-reuse discipline visible
across cycles 112 + 129 + this cycle.
