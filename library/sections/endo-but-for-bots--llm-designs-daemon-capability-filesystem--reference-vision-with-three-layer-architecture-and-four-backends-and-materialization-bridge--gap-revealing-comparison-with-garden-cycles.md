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
title: §Gap-revealing-comparison with garden cycles
parent: endo-but-for-bots--llm-designs-daemon-capability-filesystem--reference-vision-with-three-layer-architecture-and-four-backends-and-materialization-bridge
---

| Cycle | Connection |
|-------|------------|
| 166 (daemon-mount) | §The-concrete-mergeable-slice of this vision; mount = physical-backend slice |
| 168 (daemon-checkin-checkout) | §Snapshot-and-restore complements mount; both within this vision |
| 161 (filesystem-watchers) | §Live-update extension that this vision's Dir interface would need |
| 105 (daemon-capability-bank) | §Sister capability-design (meta-framework); this is one capability in the bank |
| 107 (daemon-agent-tools) | §Agent-tool-shapes; Filesystem via `Dir` mentioned this design |
| 156 (finalize.js) | §WeakValueMap pattern; Dir/File exos would use it |
| 94 (OCPL paper) | §Threat-model-with-citations precedent |
