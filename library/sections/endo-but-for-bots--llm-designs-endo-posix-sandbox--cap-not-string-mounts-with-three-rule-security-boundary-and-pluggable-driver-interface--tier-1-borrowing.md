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
title: §Tier-1 borrowing
parent: endo-but-for-bots--llm-designs-endo-posix-sandbox--cap-not-string-mounts-with-three-rule-security-boundary-and-pluggable-driver-interface
---

- §cap-not-string-mounts (the load-bearing-constraint for any
  capability-boundary-around-syscalls)
- §three-rules-of-security-boundary-clarity (never-string-
  inputs + don't-receive-the-power-you-could-have + misconfig-
  is-error)
- §pluggable-backend-driver-interface with §capability-blind-
  drivers (cap-resolution in the mediator only)
- §three-named-profiles + §explicit-opt-ins (no auto-upgrade)
- §anti-shadowing-rule: extend-but-can't-override (caller-
  mounts land after rootfs-derived)
- §living-phase-list-records-its-own-renumbering
- §supersedes-record-pattern with §three-improvements-named-
  explicitly
- §source-mirror-to-PLAN with §named-update-protocol (two
  documents with named authoritative-source)
- §four-handle-capability-surface for §lifecycle-decomposition
- §GC-pinning-and-disposal-protocol with §SIGTERM-grace-
  SIGKILL
- §five-cross-phase-invariants as test-side-discipline
- §plugin-explicitly-refuses-power-it-could-have
- §non-goals-discipline (six explicit scope-limits)
