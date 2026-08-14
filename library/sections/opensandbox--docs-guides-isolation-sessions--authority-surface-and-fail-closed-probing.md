---
title: Session authority surface and fail-closed probing
source: docs/guides/isolation-sessions.md
source_repo: opensandbox-group/OpenSandbox
source_commit: 95333d6bfeea9d848c181aef03e58f3773b5c271
source_date: 2026-08-11
source_authors: [epha]
ingested: 2026-08-14
ingested_by: scholar
topics: [sandbox-platforms, capability-security]
status: current
---

> Abstract: A session's authority is configured through workspace mode, bind mounts, an operator allowlist, environment passthrough, UID/GID mode, and whether it shares the enclosing sandbox network namespace. Execd resolves bind-source symlinks before checking the allowlist and denies environment passthrough by default. Capability probing fails closed when the trusted native workload gate, bubblewrap, or namespace support is unavailable.

Writable paths must fall under `allowed_writable` after symlink resolution. The default allowlist covers `/workspace`, `/mnt`, `/media`, and `/data`; an empty list rejects every extra bind. Environment variables require an explicit allow mode and key list. `setpriv` drops to a requested identity in the existing user namespace; `userns` creates a mapping. `share_net: false` creates and pins a private network namespace, while the legacy omitted/default value shares the sandbox network.

`/capabilities` reports whether the isolator and identity modes are usable. Session creation returns a not-supported error when the selected path is unavailable. The native workload gate must be installed at a fixed, root-owned, non-writable path. These are coarse named-resource grants, not transmissible object capabilities: all code in the shell can generally exercise whatever mounts, environment, and network the session received.

Source: [docs/guides/isolation-sessions.md](https://github.com/opensandbox-group/OpenSandbox/blob/95333d6bfeea9d848c181aef03e58f3773b5c271/docs/guides/isolation-sessions.md) at commit `95333d6b`.
