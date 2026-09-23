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
title: §Non-goals (the §scope-limiting discipline)
parent: endo-but-for-bots--llm-designs-endo-posix-sandbox--cap-not-string-mounts-with-three-rule-security-boundary-and-pluggable-driver-interface
---

```
- Replacing Endo's own confinement model.
- Shipping a rootfs with Endo.  Consumers BYO their userland.
- Pulling OCI images directly.
- Cross-platform parity in v1.
- Familiar / Electron renderer access.
- Replacing the existing bash/exec/git genie tools with new
  sandbox.spawn tools.
```

§Six-non-goals-explicitly-named. §Each-disclaims-a-tempting-
scope-creep.

§The-§non-goals discipline is §scope-clarification-via-
negation. §What-this-design-does-not-do is as important as
what it does.

§Compare-to-cycle-180-hex-package's §five-known-gaps and
cycle 184-metering's §six-known-gaps. §Non-goals are §scope-
boundary; known-gaps are §future-work. §Both-are-§honest-
disclosure-discipline patterns.
