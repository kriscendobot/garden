---
arc: moonshots
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Build step for endojs/endo-but-for-bots, design daemon-xs-worker-snapshot, Phase 2 "Remaining": add the full supervisor round-trip integration test (suspend via control verb, snapshot streamed to CAS, worker exits, a message triggers resume, restored worker has the correct JS state). Also add ephemeral GC-root bookkeeping for CAS-stored snapshots, and update the design's phase status.
