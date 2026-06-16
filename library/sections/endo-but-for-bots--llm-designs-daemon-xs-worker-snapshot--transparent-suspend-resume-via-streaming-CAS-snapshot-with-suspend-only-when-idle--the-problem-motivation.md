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
title: §The-problem (motivation)
parent: endo-but-for-bots--llm-designs-daemon-xs-worker-snapshot--transparent-suspend-resume-via-streaming-CAS-snapshot-with-suspend-only-when-idle
---

§Long-running-workers consume memory and supervisor slots
even when idle. §Today-the-only-way-to-stop-a-worker-is-
to-cancel-it, §losing-all-in-heap-state.

§Restarting-requires-re-evaluating-the-formula and
§replaying-any-setup-the-guest-performed.

§The-solution: §suspend-by-snapshotting-the-heap-and-
dropping-the-machine; §resume-transparently-when-a-
message-arrives.

§Two-named-use-cases:
1. §Suspend-idle-agents (LLM agent running periodically).
2. §Checkpoint-long-computations (multi-step pipeline can
   restart from checkpoint on crash).
