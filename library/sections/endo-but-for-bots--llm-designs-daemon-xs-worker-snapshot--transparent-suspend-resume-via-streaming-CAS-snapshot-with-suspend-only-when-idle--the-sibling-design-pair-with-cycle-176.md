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
title: §The §sibling-design-pair with cycle 176
parent: endo-but-for-bots--llm-designs-daemon-xs-worker-snapshot--transparent-suspend-resume-via-streaming-CAS-snapshot-with-suspend-only-when-idle
---

§Cycle-176-daemon-endor-architecture is the §supervisor-
architecture-that-this-suspend/resume-feature-fits-into.
§This-design-is-the-feature-spec; §cycle-176-is-the-
substrate.

§Both-designs-share:
- §The §CAS-streaming-discipline (also cycle 141).
- §The §atomic-rename-after-write pattern.
- §The §envelope-protocol-for-control-verbs.
- §The §parent-tree-blocking-call-authorization.

§Two-designs-one-implementation: cycle 176 names the
overall architecture; this names the specific feature.
§Different-grain-different-scope.
