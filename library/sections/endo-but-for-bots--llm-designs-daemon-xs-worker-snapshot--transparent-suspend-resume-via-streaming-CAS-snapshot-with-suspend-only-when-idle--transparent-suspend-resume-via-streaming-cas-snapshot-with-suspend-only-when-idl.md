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
title: Transparent suspend resume via streaming CAS snapshot with suspend only when idle
parent: endo-but-for-bots--llm-designs-daemon-xs-worker-snapshot--transparent-suspend-resume-via-streaming-CAS-snapshot-with-suspend-only-when-idle
---

> §Endo-but-for-bots-design genre (designs-lane). Status:
> **In Progress** (Phase 1 complete; Phase 2 mostly done;
> Phase 3 future). §Sibling-design-pair to cycle 176
> daemon-endor-architecture (which references this as §the-
> suspend/resume-feature-design).

`designs/daemon-xs-worker-snapshot.md` (395 lines) defines
the **§worker-heap-snapshot suspend/resume** mechanism for
the Rust supervisor. The single most structurally
interesting move is the **§snapshot-as-internal-
implementation-detail-not-user-visible-formula** posture:
the manager sees a continuous CapTP session; the worker
may be Live or Suspended transparently.
