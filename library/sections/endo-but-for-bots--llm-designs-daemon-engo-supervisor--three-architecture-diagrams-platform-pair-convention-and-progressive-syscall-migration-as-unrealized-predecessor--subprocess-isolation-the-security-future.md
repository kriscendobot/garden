---
source: designs/daemon-engo-supervisor.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/daemon-engo-supervisor.md
section_kind: design
ingested: 2026-06-05
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - capability-security
status_at_ingest: Not Started
genre: §endo-but-for-bots-design §unrealized-predecessor-of-cycle-176
cycle: 192
lane: designs
status: current
title: §Subprocess-isolation (the security-future)
parent: endo-but-for-bots--llm-designs-daemon-engo-supervisor--three-architecture-diagrams-platform-pair-convention-and-progressive-syscall-migration-as-unrealized-predecessor
---

```
Engo's value proposition includes the ability to apply OS-
level sandboxing to workers it spawns directly.  This is out
of scope for the initial phases but the architecture supports
it:

- Engo controls the `exec.Cmd` configuration for each
  subprocess.
- On macOS, `sandbox-exec` profiles can restrict file and
  network access.
- On Linux, namespaces and seccomp filters can confine
  workers.
- Workers that obtain all I/O through supervisor syscalls can
  be fully confined — they need no direct access to the
  filesystem or network.
```

§Four-named-sandboxing-mechanisms (Cmd config + macOS
sandbox-exec + Linux namespaces+seccomp + supervisor-syscall-
confinement). §Out-of-scope-for-initial-phases but §the-
architecture-supports-it.

§Compare-to-cycle-190-endo-posix-sandbox which §made-the-out-
of-scope-into-its-scope. §Cycle-192's-engo-supervisor names
sandboxing as a future-direction; cycle-190's posix-sandbox
delivers it as a separate plugin under a different supervisor
(the actually-shipping Rust endor).

§The-§supervisor-syscalls-enable-full-confinement: workers
that get all I/O through supervisor messages need no direct
filesystem-or-network access. §This-is-the-§capability-
discipline-at-the-process-layer.

§Compare-to-cycle-190's §cap-not-string-mounts. §Both-are-
§capability-discipline-applied-to-OS-syscall-surface; cycle
192 routes through envelopes, cycle 190 routes through Mount
capabilities.
