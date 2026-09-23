---
source: designs/daemon-xs-worker-snapshot.md
source_repo: endojs/endo-but-for-bots
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/daemon-xs-worker-snapshot.md
source_path: designs/daemon-xs-worker-snapshot.md
source_branch: llm
section_kind: design
ingested: 2026-06-04
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - persistence
  - patterns
genre: §endo-but-for-bots-design
cycle: 178
lane: designs
status: current
title: §Snapshot-as-internal-implementation-detail (Decision 1)
parent: endo-but-for-bots--llm-designs-daemon-xs-worker-snapshot--transparent-suspend-resume-via-streaming-CAS-snapshot-with-suspend-only-when-idle
---

> *The snapshot is an **internal implementation detail** of
> the worker lifecycle, not a user-visible formula.*

§Manager-sees-continuous-CapTP-session. §The-worker-may-be-
Live-or-Suspended-transparently. §The-transition-is-
transparent.

§No-snapshot-formulas. §No-user-visible-snapshot-objects.
§Snapshots-are-opaque-CAS-blobs.

§Cycle-170-daemon-capability-filesystem named the §single-
interface-multiple-backings pattern; this design has the
§single-CapTP-surface-multiple-worker-states pattern.

§Sibling-to-cycle-168-daemon-checkin-checkout §reference-
not-substrate-stance: §the-manager-doesn't-need-to-know-
about-implementation-mechanics.
