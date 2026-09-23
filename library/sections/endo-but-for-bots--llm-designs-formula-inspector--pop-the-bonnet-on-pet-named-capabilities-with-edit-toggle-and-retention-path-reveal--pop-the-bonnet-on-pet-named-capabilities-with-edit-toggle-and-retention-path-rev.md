---
section: pop-the-bonnet-on-pet-named-capabilities-with-edit-toggle-and-retention-path-reveal
source: endo-but-for-bots--llm-designs-formula-inspector
topics: [daemon, agent-conventions, tooling]
status: current
title: Pop the bonnet on pet-named capabilities with edit-toggle and retention-path reveal
parent: endo-but-for-bots--llm-designs-formula-inspector--pop-the-bonnet-on-pet-named-capabilities-with-edit-toggle-and-retention-path-reveal
---

> *Power users and developers need to inspect — and
> potentially edit — the formula graph to understand and debug
> the system.*
>
> — `designs/formula-inspector.md` §What is the Problem Being Solved

`formula-inspector.md` (110 lines, *Not Started* status,
created 2026-02-14 / updated 2026-02-24) is a small,
structurally clear "popping-the-bonnet" debug-tool design
sitting between daemon internals and the chat UI. Surfaces
the daemon's 26-formula-type structure to the user so they
can *see* what's behind each pet-named capability — and,
optionally, edit it.
