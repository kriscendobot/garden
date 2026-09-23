---
section: genie-pi-inside-endo-and-the-four-architectural-contrasts
source: endo-but-for-bots--llm-designs-endopi
topics: [agent-conventions, capability-security]
status: current
title: "Genie: Pi inside Endo, and the four architectural contrasts"
parent: endo-but-for-bots--llm-designs-endopi--genie-pi-inside-endo-and-the-four-architectural-contrasts
---

> *Genie is the existence proof that *embedding* Pi inside Endo is
> viable: a single package can depend on `pi-ai` for the
> provider/model registry, wrap `pi-agent-core` for the agent loop,
> and project the result into Endo's event vocabulary without
> rewriting either Pi surface.*
>
> — `designs/endopi.md` §What Genie's existence tells us

The §Genie: Pi inside Endo section + the §Architectural Contrasts
section together cover *the third Endo-side surface* (the one that
embeds Pi directly) and *the four worldview-level disagreements*
the comparative-mapping frame stops short of. This section
documents both.

The two halves are tightly coupled: Genie is the *concrete
existence proof* that the comparative-mapping mode is not the only
move; the architectural-contrasts section is the *abstract
codification* of why each move (mapping vs embedding) might be
right depending on what the user is willing to live with.
