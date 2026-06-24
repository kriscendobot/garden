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
kind: index
section_count: 21
---

Sections:

- [Transparent suspend resume via streaming CAS snapshot with suspend only when idle](endo-but-for-bots--llm-designs-daemon-xs-worker-snapshot--transparent-suspend-resume-via-streaming-CAS-snapshot-with-suspend-only-when-idle--transparent-suspend-resume-via-streaming-cas-snapshot-with-suspend-only-when-idl.md)
- [§The-problem (motivation)](endo-but-for-bots--llm-designs-daemon-xs-worker-snapshot--transparent-suspend-resume-via-streaming-CAS-snapshot-with-suspend-only-when-idle--the-problem-motivation.md)
- [§Background: §what-XS-snapshots-capture](endo-but-for-bots--llm-designs-daemon-xs-worker-snapshot--transparent-suspend-resume-via-streaming-CAS-snapshot-with-suspend-only-when-idle--background-what-xs-snapshots-capture.md)
- [§Snapshot-as-internal-implementation-detail (Decision 1)](endo-but-for-bots--llm-designs-daemon-xs-worker-snapshot--transparent-suspend-resume-via-streaming-CAS-snapshot-with-suspend-only-when-idle--snapshot-as-internal-implementation-detail-decision-1.md)
- [§Suspend-only-when-idle (Decision 2)](endo-but-for-bots--llm-designs-daemon-xs-worker-snapshot--transparent-suspend-resume-via-streaming-CAS-snapshot-with-suspend-only-when-idle--suspend-only-when-idle-decision-2.md)
- [§Transparent-resume-on-message (Decision 3)](endo-but-for-bots--llm-designs-daemon-xs-worker-snapshot--transparent-suspend-resume-via-streaming-CAS-snapshot-with-suspend-only-when-idle--transparent-resume-on-message-decision-3.md)
- [§Streaming-snapshot-to-CAS (Decision 5)](endo-but-for-bots--llm-designs-daemon-xs-worker-snapshot--transparent-suspend-resume-via-streaming-CAS-snapshot-with-suspend-only-when-idle--streaming-snapshot-to-cas-decision-5.md)
- [§CAS-storage-with-ephemeral-GC-roots (Decision 4)](endo-but-for-bots--llm-designs-daemon-xs-worker-snapshot--transparent-suspend-resume-via-streaming-CAS-snapshot-with-suspend-only-when-idle--cas-storage-with-ephemeral-gc-roots-decision-4.md)
- [§Append-only-callback-table (Decision 6)](endo-but-for-bots--llm-designs-daemon-xs-worker-snapshot--transparent-suspend-resume-via-streaming-CAS-snapshot-with-suspend-only-when-idle--append-only-callback-table-decision-6.md)
- [§Two-init-paths (the bootstrap branch)](endo-but-for-bots--llm-designs-daemon-xs-worker-snapshot--transparent-suspend-resume-via-streaming-CAS-snapshot-with-suspend-only-when-idle--two-init-paths-the-bootstrap-branch.md)
- [§The-state-diagram (Live ↔ Suspended)](endo-but-for-bots--llm-designs-daemon-xs-worker-snapshot--transparent-suspend-resume-via-streaming-CAS-snapshot-with-suspend-only-when-idle--the-state-diagram-live-suspended.md)
- [§Envelope-protocol (four verbs)](endo-but-for-bots--llm-designs-daemon-xs-worker-snapshot--transparent-suspend-resume-via-streaming-CAS-snapshot-with-suspend-only-when-idle--envelope-protocol-four-verbs.md)
- [§Six-Design-Decisions enumerated](endo-but-for-bots--llm-designs-daemon-xs-worker-snapshot--transparent-suspend-resume-via-streaming-CAS-snapshot-with-suspend-only-when-idle--six-design-decisions-enumerated.md)
- [§Phased-implementation with named state](endo-but-for-bots--llm-designs-daemon-xs-worker-snapshot--transparent-suspend-resume-via-streaming-CAS-snapshot-with-suspend-only-when-idle--phased-implementation-with-named-state.md)
- [§The §revised-scope discussion (honest design evolution)](endo-but-for-bots--llm-designs-daemon-xs-worker-snapshot--transparent-suspend-resume-via-streaming-CAS-snapshot-with-suspend-only-when-idle--the-revised-scope-discussion-honest-design-evolution.md)
- [§The §sibling-design-pair with cycle 176](endo-but-for-bots--llm-designs-daemon-xs-worker-snapshot--transparent-suspend-resume-via-streaming-CAS-snapshot-with-suspend-only-when-idle--the-sibling-design-pair-with-cycle-176.md)
- [§Why-this-design-matters (the bigger picture)](endo-but-for-bots--llm-designs-daemon-xs-worker-snapshot--transparent-suspend-resume-via-streaming-CAS-snapshot-with-suspend-only-when-idle--why-this-design-matters-the-bigger-picture.md)
- [§Gap-revealing-comparison with garden cycles](endo-but-for-bots--llm-designs-daemon-xs-worker-snapshot--transparent-suspend-resume-via-streaming-CAS-snapshot-with-suspend-only-when-idle--gap-revealing-comparison-with-garden-cycles.md)
- [§Tier-1 vocabulary borrowing candidates](endo-but-for-bots--llm-designs-daemon-xs-worker-snapshot--transparent-suspend-resume-via-streaming-CAS-snapshot-with-suspend-only-when-idle--tier-1-vocabulary-borrowing-candidates.md)
- [§Synthesis-target](endo-but-for-bots--llm-designs-daemon-xs-worker-snapshot--transparent-suspend-resume-via-streaming-CAS-snapshot-with-suspend-only-when-idle--synthesis-target.md)
- [§A-mid-flight-design (Status: In Progress)](endo-but-for-bots--llm-designs-daemon-xs-worker-snapshot--transparent-suspend-resume-via-streaming-CAS-snapshot-with-suspend-only-when-idle--a-mid-flight-design-status-in-progress.md)
