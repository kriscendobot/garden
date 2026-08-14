---
source: docs/guides/isolation-sessions.md
source_repo: opensandbox-group/OpenSandbox
source_commit: 95333d6bfeea9d848c181aef03e58f3773b5c271
source_date: 2026-08-11
source_authors: [epha]
ingested: 2026-08-14
ingested_by: scholar
section_count: 3
status: current
---

> Abstract: OpenSandbox isolation sessions are fast, nested bubblewrap environments inside one already-created sandbox. Each persistent shell receives PID, mount, tmpfs, environment, and optional network namespaces, plus an overlay or bind-mounted workspace. They isolate short tasks from one another but share the enclosing sandbox kernel and selected resources, so OpenSandbox explicitly directs hard kernel-exploit boundaries to gVisor or Kata. Compared with XS/xsnap, these sessions accept arbitrary Linux binaries and filesystem trees but expose authority by mounts, environment, UID, and network switches rather than object-capability references.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [nested-bubblewrap-execution-boundary](../sections/opensandbox--docs-guides-isolation-sessions--nested-bubblewrap-execution-boundary.md) | sandbox-platforms | current |
| [authority-surface-and-fail-closed-probing](../sections/opensandbox--docs-guides-isolation-sessions--authority-surface-and-fail-closed-probing.md) | sandbox-platforms, capability-security | current |
| [limits-and-xsnap-comparison](../sections/opensandbox--docs-guides-isolation-sessions--limits-and-xsnap-comparison.md) | sandbox-platforms, capability-security | current |

## Provenance

Source: [docs/guides/isolation-sessions.md](https://github.com/opensandbox-group/OpenSandbox/blob/95333d6bfeea9d848c181aef03e58f3773b5c271/docs/guides/isolation-sessions.md) at file-specific commit `95333d6b`.
