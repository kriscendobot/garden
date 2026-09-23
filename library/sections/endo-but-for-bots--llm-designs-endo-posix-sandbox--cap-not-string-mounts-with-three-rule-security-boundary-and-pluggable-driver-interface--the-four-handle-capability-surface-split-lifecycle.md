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
title: §The §four-handle-capability-surface (split lifecycle)
parent: endo-but-for-bots--llm-designs-endo-posix-sandbox--cap-not-string-mounts-with-three-rule-security-boundary-and-pluggable-driver-interface
---

```
make-unconfined entry → SandboxFactory ──┐
                                         │ make({...})
                                         ▼
                                   SandboxHandle ──┐
                                         │         │ spawn(argv, opts)
                                         │         ▼
                                         │   ProcessHandle
                                         │
                                         │ mount(mountCap, innerPath, opts)
                                         ▼
                                   MountHandle
```

§Four-handle-types. §Each-individually-addressable + §each-
individually-GC-pinnable. §The-split makes "release just the
process" or "release just one mount" possible without
affecting the rest of the slice.

§Compare-to-cycle-170-daemon-capability-filesystem's §three-
layer-architecture (Guest / VFS-Namespace / Backends). §Both-
are-§deliberately-decomposed-capability-surfaces; cycle 190's
four-handle split is §lifecycle-decomposition rather than
architectural-decomposition.

§Compare-to-cycle-182-daemon-xs-worker-debugger's §natural-
debugger-trio-attenuation (DebuggerView / DebuggerControl /
DebuggerAdmin). §Cycle-190's four-handle split is §similar-
attenuation but at the §sandbox-layer instead of §debugger-
layer.
