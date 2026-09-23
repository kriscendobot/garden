---
section: registry-shape-and-subscription-oauth-with-lal-vs-genie-consolidation-question
source: endo-but-for-bots--llm-designs-endopi-provider-registry-and-oauth
topics: [agent-conventions]
status: current
title: §Cross-provider handoff — *the registry above is the substrate*
parent: endo-but-for-bots--llm-designs-endopi-provider-registry-and-oauth--registry-shape-and-subscription-oauth-with-lal-vs-genie-consolidation-question
---

The §Cross-provider handoff subsection is structurally brief:

> *Pi supports mid-session handoff (e.g., start on a fast model
> for exploration, switch to a slow reasoning model for the hard
> part). Lal's in-memory transcript already supports this in shape;
> the daemon-side plumbing is missing. The registry above is the
> substrate.*

The §the-registry-is-the-substrate move: once the
ProviderInterface is in place, mid-session switching is *just
calling `complete(...)` on a different provider exo*. The
transcript already carries the sequence of messages independent
of which provider produced each one. The §missing-plumbing is the
control-plane piece (a `/model <provider>:<name>` slash command,
or a `set_model` RPC command per cycle 126's
endopi-stdio-rpc-bridge).
