---
title: Isolation-session identity, native gate, and namespace pinning
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

> Abstract: An isolation session launches a shell in a bubblewrap namespace and establishes identity through either `setpriv` in the existing user namespace or a newly mapped user namespace. Startup probes the real execution paths, and a root-owned native session gate plus fail-closed checks prevent session creation when the selected mechanism is unavailable.

The native helper is installed at `/opt/opensandbox/opensandbox-session-gate` with mode `0555`; both it and its parent directory must remain root-owned and non-writable by group or world. Other daemon APIs remain usable without it, but isolation capability probing and creation fail closed. `setpriv` and `userns` availability are reported independently, and identity-switch failure is detected before session side effects.

For sessions with private networking, execd fixes the authenticated network namespace and its owning user namespace before releasing the native workload gate. Namespace handles live in an execd-owned unpredictable directory beneath `/run/execd/namespaces` until synchronous teardown. The implementation makes namespace ownership and release ordering part of the security boundary rather than relying only on a `bwrap` command line.

Source: [docs/components/execd.md](https://github.com/opensandbox-group/OpenSandbox/blob/7b969bd64935682895e077342b42007b68490585/docs/components/execd.md) at commit `7b969bd6`.
