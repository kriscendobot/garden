---
title: Implementation boundaries and Endo comparison
source: docs/components/execd.md
source_repo: opensandbox-group/OpenSandbox
source_commit: 7b969bd64935682895e077342b42007b68490585
source_date: 2026-08-11
source_authors: [ruirui6946, yutian.taoyt, epha, Baichao He]
ingested: 2026-08-14
ingested_by: scholar
topics: [sandbox-platforms, capability-security, compartments]
status: current
---

> Abstract: Bubblewrap sessions are nested operating-system boundaries inside an already privileged sandbox daemon. Their guarantees depend on Linux namespace support, a trusted native gate, execd-owned namespace pins, UID switching, mount policy, and parent-sandbox configuration; clone3 compatibility and shell fallback also vary by environment.

The daemon probes supported UID modes and returns `503 NOT_SUPPORTED` before creating a session when the selected path cannot work. A compatibility setting can force a seccomp fallback on hosts where `clone3(2)` fails. Metrics expose daemon and host state through snapshot and streaming endpoints. These operational surfaces are useful, but they also place execd and its configuration in the trusted computing base.

An isolation session can reduce filesystem, identity, and network reach for a subprocess. It does not create SES semantics: language intrinsics are not hardened, arbitrary binaries remain available according to the image, and authority is expressed through UIDs, paths, mounts, namespaces, and bearer access to execd. Endo compartments and XS/xsnap workers mediate JavaScript powers as references and messages. A robust composition can use OpenSandbox as the outer process boundary and Endo as the inner authority boundary.

Source: [docs/components/execd.md](https://github.com/opensandbox-group/OpenSandbox/blob/7b969bd64935682895e077342b42007b68490585/docs/components/execd.md) at commit `7b969bd6`.
