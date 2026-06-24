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
title: §LLM-discoverability via help() + interface guards
parent: endo-but-for-bots--llm-designs-daemon-capability-filesystem--reference-vision-with-three-layer-architecture-and-four-backends-and-materialization-bridge
---

> *An LLM agent receiving a `Dir` or `File` capability can
> discover its interface through two mechanisms:
> 1. `help()` text — comprehensive natural-language
> documentation
> 2. Interface guards — machine-readable method signatures*

§Two-mechanisms-for-LLM-discovery:

- §Help()-as-prose: the help() text for Dir is ~70 lines,
  with method-by-method docs, parameter shapes, return
  types, examples.
- §Interface-guards-as-machine-readable: M.interface
  signatures that LLM tools can inspect.

§Help-as-LLM-onboarding: written for an LLM *that has
never seen this capability before*. §The-LLM-needs-to-
understand-only-the-Dir/File-methods-to-use-the-
filesystem.

§Guest-sees-only-Dir-and-File. Not Vfs, not backend types,
not control facets. §Minimal-LLM-vocabulary.

§Synthesis-target: future capability designs that target
LLM agents should follow the §help()-plus-interface-guards
shape. §Two-channels-for-machine-and-human-understanding.
