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
title: §Cohesion notes
parent: endo-but-for-bots--llm-designs-endo-posix-sandbox--cap-not-string-mounts-with-three-rule-security-boundary-and-pluggable-driver-interface
---

- §Cap-not-string-mounts is §the-load-bearing-constraint.
  Mounts are `Mount` capabilities or nothing.
- §Three-rules-of-security-boundary-clarity: §never-string-
  host-paths + §plugin-does-not-receive-daemon's-host-paths-
  power + §misconfig-is-error-not-relaxation.
- §Pluggable-backend-driver-interface with §capability-blind-
  drivers (drivers see only resolved-path triples; the plugin
  is the single cap-to-path mediator).
- §Three-named-network-profiles + §three-explicit-host-opt-
  ins = six-position-confinement-ladder.
- §Four-rootfs-modes (host-bind / mount / minimal / oci) with
  §five-forbidden-PATH-prefixes for survivor mining.
- §Anti-shadowing-rule: caller-granted mounts land after
  rootfs-derived $PATH so they extend but can't override.
- §Caller-supplied-env.PATH-always-wins over synthesis
  heuristic.
- §Living-phase-list-records-its-own-renumbering (Phase 5
  intentionally absent; Phase 3/4/6 each note their prior
  numbering).
- §Supersedes-record-pattern (§three-improvements over the
  prior daemon-os-sandbox-plugin).
- §Source-mirror-to-PLAN with §named-update-protocol. The
  PLAN is authoritative; this design is the roadmap-aligned
  mirror for milestone-tracking.
- §Four-handle-capability-surface (SandboxFactory /
  SandboxHandle / ProcessHandle / MountHandle) with §each-
  individually-GC-pinnable.
- §GC-pinning-and-disposal-protocol with §SIGTERM-grace-
  SIGKILL on processes + driver teardown + scratch-GC
  piggy-back.
- §Five-cross-phase-invariants as the §test-side-discipline.
- §Plugin-needs-four-powers + §explicitly-refuses-host-paths-
  power.
- §Six-non-goals-explicitly-named.
- §Genie-integration-as-workspace-not-tool-surface: existing
  tools unchanged externally; spawn channel swapped daemon-
  side.
