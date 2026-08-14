---
source: docs/components/execd.md
source_repo: opensandbox-group/OpenSandbox
source_commit: 7b969bd64935682895e077342b42007b68490585
source_date: 2026-08-11
source_authors: [ruirui6946, yutian.taoyt, epha, Baichao He]
ingested: 2026-08-14
ingested_by: scholar
section_count: 4
status: current
---

> Abstract: `execd` is OpenSandbox's in-workload HTTP daemon for code, command, filesystem, PTY, metrics, and bubblewrap isolation-session APIs. Its optional shared access token protects the whole API coarsely. Isolated sessions add per-execution namespaces, selectable UID establishment, a root-owned native gate, namespace pinning, and symlink-resolved bind allowlists, but remain inside the parent sandbox and depend on execd's broad process and filesystem authority.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [daemon-api-pty-and-access-token-boundary](../sections/opensandbox--docs-components-execd--daemon-api-pty-and-access-token-boundary.md) | sandbox-platforms, tooling, capability-security | current |
| [isolation-session-identity-native-gate-and-namespace-pinning](../sections/opensandbox--docs-components-execd--isolation-session-identity-native-gate-and-namespace-pinning.md) | sandbox-platforms, capability-security | current |
| [bind-mount-authority-and-path-confinement](../sections/opensandbox--docs-components-execd--bind-mount-authority-and-path-confinement.md) | sandbox-platforms, capability-security | current |
| [implementation-boundaries-and-endo-comparison](../sections/opensandbox--docs-components-execd--implementation-boundaries-and-endo-comparison.md) | sandbox-platforms, capability-security, compartments | current |

## Provenance

Source: [docs/components/execd.md](https://github.com/opensandbox-group/OpenSandbox/blob/7b969bd64935682895e077342b42007b68490585/docs/components/execd.md) at file-specific commit `7b969bd6`.
