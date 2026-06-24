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
title: §Why-this-design-matters (the bigger picture)
parent: endo-but-for-bots--llm-designs-daemon-xs-worker-snapshot--transparent-suspend-resume-via-streaming-CAS-snapshot-with-suspend-only-when-idle
---

§Memory-pressure-on-the-Endo-daemon is the load-bearing
problem: §long-running-agents-consume-supervisor-slots-
even-when-idle.

§The-solution-isn't-cleverer-allocators; §it's-let-idle-
workers-be-actually-zero-cost via snapshot+drop.

§Cycle-162-ken-protocol's §atomic-checkpoint property is
implemented here for the worker layer: §the-snapshot-is-
the-atomic-checkpoint of the JS heap.

§Future-extension: §auto-suspend-heuristics could make
this transparent to operators too. §The-mechanism-is-here;
§the-policy-is-future-work.
