---
source: designs/endo-posix-sandbox.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/endo-posix-sandbox.md
section_kind: design
ingested: 2026-06-04
ingested_by: scholar
contributors:
  - Joshua T Corbin (PLAN)
  - kriscendobot (prompted by kriskowal)
topics:
  - daemon
  - capability-security
  - hardened-javascript
status_at_ingest: In Progress (Phase 3)
genre: §endo-but-for-bots-design §supersedes-prior-with-relationship-section
cycle: 190
lane: designs
status: current
title: §GC-pinning-with-pre-defined-disposal
parent: endo-but-for-bots--llm-designs-endo-posix-sandbox--cap-not-string-mounts-with-three-rule-security-boundary-and-pluggable-driver-interface
---

```
A SandboxHandle formula pins, by reference:
- the rootfs source (Mount capability or marker for host-bind),
- every granted Mount cap,
- a ScratchMount for the writable upper layer.

When the handle is unpinned, dispose() runs.
Every live ProcessHandle is killed (SIGTERM, then SIGKILL
after a grace).
Every MountHandle unmounts.
The driver's teardown cleans up the namespace / container.
ScratchMount removal piggy-backs on the daemon's existing
scratch GC.
```

§GC-pinning-and-disposal-protocol-explicit. §Three-things-
pinned: rootfs + granted-mounts + scratch-mount.

§On-unpin: dispose runs § SIGTERM-grace-SIGKILL on processes +
unmount + driver teardown + scratch GC.

§Piggy-backs-on-existing-scratch-GC = §reuse-existing-
discipline-not-build-parallel. §Compare-to-cycle-167-where/
index.js' §reuse-@endo/where-rather-than-reinventing pattern.
