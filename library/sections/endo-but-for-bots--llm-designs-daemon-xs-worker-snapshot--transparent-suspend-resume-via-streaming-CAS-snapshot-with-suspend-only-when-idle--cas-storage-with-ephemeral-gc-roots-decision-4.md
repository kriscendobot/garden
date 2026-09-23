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
title: §CAS-storage-with-ephemeral-GC-roots (Decision 4)
parent: endo-but-for-bots--llm-designs-daemon-xs-worker-snapshot--transparent-suspend-resume-via-streaming-CAS-snapshot-with-suspend-only-when-idle
---

> *Snapshot blobs are stored in the content-addressable
> store by SHA-256. An ephemeral GC root prevents
> collection while the worker is suspended.*

§Two-references-to-the-blob:
- §The-CAS-itself (content-addressed durable storage).
- §Ephemeral-GC-root-from-supervisor (prevents collection
  during suspended lifetime).

§Released-on-resume-or-cancel. §If-supervisor-crashes-
before-resume: §the-ephemeral-root-is-lost; §the-blob-may-
be-GC'd; §the-worker-cannot-be-resumed. §Acceptable-on-
crash because §suspend-resume-is-an-optimization-not-a-
correctness-feature.

§CAS-GC-not-yet-implemented (named in Phase 3 future
work). §The-bookkeeping-is-set-up-correctly-for-when-it-
arrives.
