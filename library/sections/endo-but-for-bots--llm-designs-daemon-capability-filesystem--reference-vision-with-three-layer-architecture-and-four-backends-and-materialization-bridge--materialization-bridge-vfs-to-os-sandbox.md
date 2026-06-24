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
title: §Materialization-bridge-VFS-to-OS-sandbox
parent: endo-but-for-bots--llm-designs-daemon-capability-filesystem--reference-vision-with-three-layer-architecture-and-four-backends-and-materialization-bridge
---

> *Materialization would bridge this gap: the VFS (or a
> subtree of it) is checked out to temporary physical
> storage, the sandboxed process runs against that
> checkout, and changes are read back into the VFS.*

§Two-staged-confinement: the §VFS-confines-what-can-be-
mounted; the §materialized-path-confines-what-the-
sandbox-can-see. §Defense-in-depth via §two-different-
confinement-mechanisms.

§Why-not-pass-non-physical-backends-directly-to-sandbox:
sandboxed native processes need *real* filesystem paths.
§Git-tree-and-memory-backends-aren't-filesystem-paths.
§Materialize-first-then-sandbox.

§syncBack-validates-changes-are-within-scope before
writing them back. §Materialization-is-a-controlled-
rights-expansion (named in Security Considerations).

§Connects-to-daemon-os-sandbox-plugin design (named in
the doc's dependency list). §Cross-design-coordination
encoded.
