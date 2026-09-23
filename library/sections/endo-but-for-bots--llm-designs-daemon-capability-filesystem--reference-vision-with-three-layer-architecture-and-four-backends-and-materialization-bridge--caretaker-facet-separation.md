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
title: §Caretaker-facet-separation
parent: endo-but-for-bots--llm-designs-daemon-capability-filesystem--reference-vision-with-three-layer-architecture-and-four-backends-and-materialization-bridge
---

> *The host holds control facets that are structurally
> separate from the capabilities granted to the guest.*

§Two-paired-facets-per-capability:

- `Dir` (granted to guest) / `DirControl` (held by host).
- `File` (granted to guest) / `FileControl` (held by host).

§DirControl.setWritable(false) — locks writes without the
guest's cooperation.
§DirControl.revoke() — invalidates the corresponding Dir.

§The-guest-cannot-discover-access-or-influence-the-control-
facet. §Structural-separation-not-policy.

§Caretaker-pattern from Miller-1973 cited in cycle 84
(Miller-Van-Cutsem-Tulloh's *Concurrency Among Strangers*)
applied here. §Canonical-ocap-pattern.
