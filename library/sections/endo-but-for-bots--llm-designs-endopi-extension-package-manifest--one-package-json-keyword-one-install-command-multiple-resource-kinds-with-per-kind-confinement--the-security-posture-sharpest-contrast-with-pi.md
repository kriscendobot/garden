---
section: one-package-json-keyword-one-install-command-multiple-resource-kinds-with-per-kind-confinement
source: endo-but-for-bots--llm-designs-endopi-extension-package-manifest
topics: [agent-conventions]
status: current
title: The §Security posture — *sharpest contrast with Pi*
parent: endo-but-for-bots--llm-designs-endopi-extension-package-manifest--one-package-json-keyword-one-install-command-multiple-resource-kinds-with-per-kind-confinement
---

The §Security posture subsection is the design's *most
structurally interesting paragraph*:

> *This is the sharpest contrast with Pi. Pi packages run with
> full system authority on first run; Pi's response is "review the
> source before installing". Endo's response: each resource kind
> has its own confinement.*

The §per-kind-confinement table:

- **Guests** run under SES with only the capabilities the user
  grants at provisioning time. *Package authors do not get to ask
  for new capabilities silently.*
- **Skills** are markdown files. *Their power is to *instruct*
  the agent, not to *do* anything directly; the agent's own
  capabilities bound what skill instructions can effect.*
- **Prompts** are pure text expansion. *No capability surface at
  all.*
- **Providers** ship code that talks to an LLM endpoint. The
  provider module *runs confined*; its network access is gated by
  the daemon's outbound HTTP capability per
  `endoclaw-network-fetch`.

The §conclusion:

> *A package install is therefore *safer than `endo install` is
> today* because the new resource kinds (skill, prompt) carry no
> execution authority, and the existing one (guest) is unchanged.*

The §safer-than-today claim is the design's bottom line. The
*expanding-the-surface-without-expanding-the-attack-surface*
discipline: by adding resource kinds with strictly *less*
authority than existing guest plugins, the design *strictly
improves* the install posture. Each new resource kind is *more
confined* than the existing one.
