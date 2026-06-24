---
section: pop-the-bonnet-on-pet-named-capabilities-with-edit-toggle-and-retention-path-reveal
source: endo-but-for-bots--llm-designs-formula-inspector
topics: [daemon, agent-conventions, tooling]
status: current
title: The §three-affected-packages partition
parent: endo-but-for-bots--llm-designs-formula-inspector--pop-the-bonnet-on-pet-named-capabilities-with-edit-toggle-and-retention-path-reveal
---

§Affected Packages:

> - **`packages/daemon`** — surface inspector data, add
>   `revise` API for editing
> - **`packages/chat`** — new inspector panel UI
> - **`packages/cli`** — new `endo inspect <name>` command

The §three-layer-symmetry: daemon (data + revise API) → chat
UI (visual inspection) + CLI (JSON output). The split honors
the §thin-API-thick-UI principle — the daemon adds *one*
method (`revise`); the UI carries most of the work.
