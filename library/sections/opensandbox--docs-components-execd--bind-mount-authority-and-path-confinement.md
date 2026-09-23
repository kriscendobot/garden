---
title: Bind-mount authority and path confinement
source: docs/components/execd.md
source_repo: opensandbox-group/OpenSandbox
source_commit: 7b969bd64935682895e077342b42007b68490585
source_date: 2026-08-11
source_authors: [ruirui6946, yutian.taoyt, epha, Baichao He]
ingested: 2026-08-14
ingested_by: scholar
topics: [sandbox-platforms, capability-security]
status: current
---

> Abstract: Isolation-session requests may add same-path writable mounts or explicit source-to-destination binds. Every source must already exist and resolve beneath an operator allowlist after following symlinks; an empty allowlist rejects all additions, and read-only binds can reduce mutation authority.

`extra_writable` exposes a host path at the same location inside the namespace. `binds` separates source, destination, and read-only choice, but the destination mount point must already exist because the namespace root is read-only. The built-in allowed roots are `/workspace`, `/mnt`, `/media`, and `/data`; configuration can replace the list.

Canonicalizing the source before the allowlist check closes a symlink-redirection escape. The allowlist still describes broad name-based ambient authority held by execd: any caller admitted to the isolation API may request allowed paths unless a higher layer applies narrower policy. An object-capability design would instead hand each session a preselected directory capability and avoid interpreting arbitrary host path strings as authority requests.

Source: [docs/components/execd.md](https://github.com/opensandbox-group/OpenSandbox/blob/7b969bd64935682895e077342b42007b68490585/docs/components/execd.md) at commit `7b969bd6`.
