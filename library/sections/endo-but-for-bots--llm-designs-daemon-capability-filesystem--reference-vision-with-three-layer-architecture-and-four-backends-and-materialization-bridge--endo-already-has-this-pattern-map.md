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
title: §Endo-already-has-this-pattern map
parent: endo-but-for-bots--llm-designs-daemon-capability-filesystem--reference-vision-with-three-layer-architecture-and-four-backends-and-materialization-bridge
---

> *Any concrete design should build on these existing
> pieces rather than introducing parallel abstractions.*

§Six-named-relationships:

1. **§Pet-name-directory** (`packages/daemon/src/directory.
   js`): same structural pattern; different purpose.
2. **§VFS-design-sketch** (`docs/virtual-filesystem-design.
   md`): the architectural foundation.
3. **§FilePowers** (daemon types): raw path-based ops;
   this layer §wraps-and-confines.
4. **§OS-sandbox-plugin** (`daemon-os-sandbox-plugin.md`):
   filesystem endowments; materialization bridges.
5. **§EndoDirectory**: pet-name store maps names to
   formula IDs; filesystem Dir maps names to file nodes.
6. **§Existing-`attenuate(opts)`-in-sketch**: this design
   replaces with composable methods.

§Map-to-existing-substrate-not-parallel-abstractions. §The-
new-design-extends-existing-vocabulary.
