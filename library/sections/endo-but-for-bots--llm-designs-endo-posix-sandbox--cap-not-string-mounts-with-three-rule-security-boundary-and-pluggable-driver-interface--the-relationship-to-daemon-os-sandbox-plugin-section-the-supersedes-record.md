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
title: §The-§Relationship-to-daemon-os-sandbox-plugin section (the supersedes record)
parent: endo-but-for-bots--llm-designs-endo-posix-sandbox--cap-not-string-mounts-with-three-rule-security-boundary-and-pluggable-driver-interface
---

§The-design-names-three-ways-it-supersedes-the-prior:

```
1. The capability surface is split across `SandboxFactory` /
   `SandboxHandle` / `ProcessHandle` / `MountHandle` so a
   slice's lifetime, mounts, and processes are individually
   addressable (and individually GC-pinnable).
2. Mounts are `Mount` capabilities, never string host paths;
   the plugin does not receive the daemon's host-paths power.
3. The phase plan stages bwrap → podman → fork() → macOS →
   Windows, with macOS and Windows using the in-guest backend
   + host-side proxy pattern that lima establishes, rather
   than maintaining a parallel SBPL backend.
```

§Three-improvements-named-explicitly. §This-is-§the-§supersedes-
record-pattern (sibling to cycle 174-gateway-package's
§supersedes-with-named-prior-as-citable-reference).

§The-older-design "remains in the index as the historical
proposal" — §preserve-the-prior-as-citable-reference, even
though new implementation tracks against the successor.

§Compare-to-cycle-174-gateway-package's §three-design-
lifecycle-statuses-now-distinguished (Supersedes / Deprecates
/ Replaces). §Cycle-190-shows-the-§Supersedes-record-shape in
detail.
