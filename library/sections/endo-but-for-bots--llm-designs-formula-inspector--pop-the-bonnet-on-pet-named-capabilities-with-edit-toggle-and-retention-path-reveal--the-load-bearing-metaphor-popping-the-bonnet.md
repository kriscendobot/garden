---
section: pop-the-bonnet-on-pet-named-capabilities-with-edit-toggle-and-retention-path-reveal
source: endo-but-for-bots--llm-designs-formula-inspector
topics: [daemon, agent-conventions, tooling]
status: current
title: The §load-bearing-metaphor — *popping the bonnet*
parent: endo-but-for-bots--llm-designs-formula-inspector--pop-the-bonnet-on-pet-named-capabilities-with-edit-toggle-and-retention-path-reveal
---

> *There is no way for a user to "pop the bonnet" and see the
> underlying formula for a pet-named capability.*

The §pet-name-hides-the-formula observation: the chat UI shows
the *rendered value* of each capability (its pet name, its
display), but the daemon's storage holds a *richer formula
structure* — 26 types with fields like `worker`, `source`,
`endowments`, `hub`, `path`. Each pet name resolves to a
formula; the formula resolves to a value. The user normally
sees only the second layer.

The §popping-the-bonnet metaphor (from car mechanics) names
the move: *open the hood; see the engine*. The design surfaces
the formula layer to advanced users.
