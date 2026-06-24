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
title: §Transparent-resume-on-message (Decision 3)
parent: endo-but-for-bots--llm-designs-daemon-xs-worker-snapshot--transparent-suspend-resume-via-streaming-CAS-snapshot-with-suspend-only-when-idle
---

> *The supervisor adapter detects messages to suspended
> handles and restores the worker before delivery. The
> manager doesn't need to know about suspension.*

§The-supervisor-is-the-resume-trigger. §Manager-just-sends-
a-message; §latency-spikes-during-restore; §nothing-else-
changes.

§Six-step-resume-flow:
1. Message arrives for suspended handle.
2. Supervisor detects (parent-of-cycle-176's `on_resume`
   callback).
3. Spawn worker thread with `"restore"` init envelope.
4. Worker streams snapshot from CAS file.
5. Buffered message delivered.
6. Supervisor releases ephemeral GC root.

§First-message-after-suspend-pays-the-restore-latency;
§subsequent-messages-are-Live-speed.
