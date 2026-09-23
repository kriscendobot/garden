---
section: comparative-pi-mapping-with-eight-spinout-gaps-and-architectural-contrasts
source: endo-but-for-bots--llm-designs-endopi
topics: [agent-conventions, capability-security]
status: current
title: "*Designs the Pi-Endo mapping does not need*"
parent: endo-but-for-bots--llm-designs-endopi--comparative-pi-mapping-with-eight-spinout-gaps-and-architectural-contrasts
---

The §Pi-specific moves Endo declines list:

- **Ambient extension authority** — Endo keeps SES + capability
  confinement.
- **No MCP** — Pi's stance (*build CLI tools with READMEs; an
  extension can add MCP if wanted*) is compatible with Endo;
  nothing to do.
- **No built-in sub-agents** — Endo's multi-guest formula model
  already provides confined sub-agents.
- **No permission popups in core** — Endo enforces structurally
  (caretaker revocation, interface guards) rather than runtime-
  prompt.
- **No background bash** — Pi prefers `tmux`; Endo is symmetric.
- **Hugging Face transcript publishing** — out of scope for Endo's
  local-first posture.

The §Endo-specific advantages list (no Pi equivalent):

- Object-capability confinement at the JS module boundary
- Caretaker revocation of any granted capability
- Multi-guest isolation with per-guest network identity
- Formula-store persistence outliving daemon restarts
- Hardened JavaScript (SES) defeating prototype pollution attacks
- OCapN peer-to-peer message-passing primitives

The pair of lists is what makes this design *comparative* rather
than *acquisitive*: it's not *adopt Pi*, it's *adopt Pi's
developer-velocity moves without giving up Endo's multi-agent-
system shape*.
