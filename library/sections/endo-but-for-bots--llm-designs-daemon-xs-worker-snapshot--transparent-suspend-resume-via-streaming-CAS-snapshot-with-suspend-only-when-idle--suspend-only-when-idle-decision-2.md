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
title: §Suspend-only-when-idle (Decision 2)
parent: endo-but-for-bots--llm-designs-daemon-xs-worker-snapshot--transparent-suspend-resume-via-streaming-CAS-snapshot-with-suspend-only-when-idle
---

> *The worker must have no pending CapTP calls or
> outstanding promises. This avoids the CapTP reconnection
> problem entirely.*

§Avoidance-not-resolution: §the-CapTP-reconnection-problem
is hard; §sidestep-it-by-requiring-idle-state-at-suspend-
time.

§If-worker-is-not-idle: §suspend-fails-with-error. §No-
silent-degradation.

§What-counts-as-idle:
- No pending CapTP calls.
- No outstanding promises from remote objects.
- Machine quiescent (no running JS, no pending host
  entries).

§The-prompt's-original-concern (from §revised-scope-
discussion-2026-04-15) was §obligating-the-worker-to-
sense-and-recover-from-loss-of-ephemeral-connectivity.
§The-revised-scope-narrowed-this: §don't-try-to-recover;
§refuse-to-suspend-when-state-would-need-recovery.

§Honest-narrowing-of-scope during design. §The-§revised-
scope-section records the conversation.
