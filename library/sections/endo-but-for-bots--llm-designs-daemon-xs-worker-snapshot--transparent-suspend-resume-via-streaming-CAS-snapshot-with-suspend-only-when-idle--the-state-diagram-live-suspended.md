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
title: §The-state-diagram (Live ↔ Suspended)
parent: endo-but-for-bots--llm-designs-daemon-xs-worker-snapshot--transparent-suspend-resume-via-streaming-CAS-snapshot-with-suspend-only-when-idle
---

```
                    ┌─────────┐
     suspend()      │         │  message arrives
  ┌────────────────►│Suspended├──────────────────┐
  │  snapshot→CAS   │         │  CAS→restore      ▼
┌─┴──┐               └─────────┘               ┌─────┐
│Live│◄─────────────────────────────────────────│Live │
└────┘         resumed, message delivered       └─────┘
```

§Two-states; §two-transitions. §The-state-machine-is-
simple-because-the-discipline-was-strict.

§Cycle-173-promise-executor-kit's §three-state-internal-
reference-lifecycle had three states; this has two.
§Different-purpose, §different-state-count.
