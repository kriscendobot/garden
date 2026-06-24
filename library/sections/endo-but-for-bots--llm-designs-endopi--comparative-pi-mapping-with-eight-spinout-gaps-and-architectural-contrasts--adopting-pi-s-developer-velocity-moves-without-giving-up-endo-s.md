---
section: comparative-pi-mapping-with-eight-spinout-gaps-and-architectural-contrasts
source: endo-but-for-bots--llm-designs-endopi
topics: [agent-conventions, capability-security]
status: current
title: "*Adopting Pi's developer-velocity moves without giving up Endo's"
parent: endo-but-for-bots--llm-designs-endopi--comparative-pi-mapping-with-eight-spinout-gaps-and-architectural-contrasts
---

multi-agent-system shape*

The §Agent-orchestration shape architectural contrast is the
clearest summary of *what each project optimizes for*:

> *Pi's default is *one agent, one session, one cwd*. Sub-agents
> are a deliberate non-feature, pushed to extensions ("there's many
> ways to do this; tmux is one"). The harness assumes the human
> stays in the loop.*
>
> *Endo's default is *many guests, many spaces, many capabilities*.
> The multi-guest formula model is the orchestration layer; the
> human can delegate one guest to another (`send`, `request`,
> `form`) without the human being on the message path. This is the
> shape that matters for the Endo bot fleet's eventual
> self-organization.*
>
> *Pi and Endo are pointed at different problems. Pi optimizes for
> a single developer's coding velocity; Endo optimizes for a
> multi-agent system in which the human is one of N participants.
> The gap-closing designs in this document are about adopting Pi's
> developer-velocity moves (edit tool, JSONL transcripts, OAuth
> providers, skills format, RPC) without giving up Endo's
> multi-agent-system shape.*
