---
source: designs/daemon-capability-filesystem.md
source_repo: endojs/endo-but-for-bots
source_url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/daemon-capability-filesystem.md
source_path: designs/daemon-capability-filesystem.md
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - capability-security
  - patterns
genre: §endo-but-for-bots-design
cycle: 170
lane: designs
status: current
title: §Single-dimension-attenuation-via-method-chaining
parent: endo-but-for-bots--llm-designs-daemon-capability-filesystem--reference-vision-with-three-layer-architecture-and-four-backends-and-materialization-bridge
---

> *Attenuation happens by calling methods that each narrow
> in a single dimension. These methods return new
> capabilities and compose by chaining.*

§Each-method-narrows-one-dimension:

- **`readOnly()`** — removes write authority.
- **`subDir(path)`** — scopes to a subtree.

§Composable-by-chaining: `readOnly().subDir('src')` gives a
read-only Dir scoped to src/.

§Replaces-the-sketch's-`attenuate(opts)`-with-composable-
chainable-calls. §General-options-bag → §single-purpose-
methods. §Reading-the-chain-tells-you-the-attenuations.

§Attenuation-is-irreversible: §the-guest-cannot-recover-
authority-that-was-removed. The host can also revoke via
the caretaker facet.

§Cycle-166's-mount.readOnly() honors the same pattern.
§This-document-is-the-conceptual-parent of mount's
attenuation API.
