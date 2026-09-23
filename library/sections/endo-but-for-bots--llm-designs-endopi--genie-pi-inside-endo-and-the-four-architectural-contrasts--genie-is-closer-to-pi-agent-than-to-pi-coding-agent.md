---
section: genie-pi-inside-endo-and-the-four-architectural-contrasts
source: endo-but-for-bots--llm-designs-endopi
topics: [agent-conventions, capability-security]
status: current
title: "*Genie is closer to pi-agent than to pi-coding-agent*"
parent: endo-but-for-bots--llm-designs-endopi--genie-pi-inside-endo-and-the-four-architectural-contrasts
---

The §Upstream-Pi cross-reference subsection makes the pi-mono
package-split visible:

- `pi-mono/packages/agent` (`@mariozechner/pi-agent-core`) — the
  *embeddable* agent-loop core. Genie depends on this.
- `pi-mono/packages/ai` (`@mariozechner/pi-ai`) — the
  provider/model abstraction. Genie inherits the registry from this.
- `pi-mono/packages/coding-agent` — the pi-cli surface. *Not what
  Genie depends on.* The §Feature-by-Feature Mapping section maps
  Endo against this pi-cli, but Genie reuses the *embedding-shaped
  agent core, not the cli-shaped one*.

The two pi packages mapped here are different shapes: `coding-agent`
is *Pi the cli*, the one most of the comparative-mapping section
addresses; `agent` is *Pi the SDK*, the one Genie embeds.
