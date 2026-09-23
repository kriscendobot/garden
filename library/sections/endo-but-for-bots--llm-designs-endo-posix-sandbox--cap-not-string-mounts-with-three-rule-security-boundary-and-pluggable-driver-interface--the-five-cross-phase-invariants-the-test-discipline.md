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
title: §The §five-cross-phase-invariants (the test discipline)
parent: endo-but-for-bots--llm-designs-endo-posix-sandbox--cap-not-string-mounts-with-three-rule-security-boundary-and-pluggable-driver-interface
---

```
- The plugin layer never accepts a string host path from a
  caller.
- A SandboxHandle released by GC results in inner processes
  receiving SIGTERM and then SIGKILL after the grace period.
- A slice with network: 'private' cannot reach host loopback,
  RFC 1918, CGNAT, link-local, or fc00::/7.
- An unknown network profile is a hard error at slice
  construction.
- A caller-granted mount cannot shadow rootfs-derived $PATH
  entries.
```

§Five-invariants the test suite preserves across phases.
§Each-invariant maps to a §rule-named-elsewhere in the design.

§Compare-to-cycle-180-hex-package's §audit-drives-scope (32-
row exhaustive table). §This-design's §five-cross-phase-
invariants are the §test-side-equivalent: enumerate what the
test suite guards.
