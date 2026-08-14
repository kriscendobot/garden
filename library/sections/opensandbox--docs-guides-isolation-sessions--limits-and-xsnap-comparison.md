---
title: Isolation-session limits and XS/xsnap comparison
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

> Abstract: OpenSandbox explicitly says namespace sessions provide no hardware-level guarantee and should be paired with gVisor or Kata for kernel-exploit defense. Sessions are Linux-only, serialize runs, require pre-existing bind destinations, and cannot recover private network namespaces across `execd` restart. XS/xsnap instead narrows the runtime to JavaScript and places each worker in an XS child process/heap with supervisor-mediated powers, metering, and heap snapshots.

The two mechanisms optimize different scopes. Bubblewrap can run arbitrary shell commands and native tools against a filesystem workspace. It naturally expresses OS resources, but its trusted base includes Linux namespace setup, bubblewrap, the native gate, `execd`, the enclosing container, and the shared kernel unless a secure runtime interposes. XS/xsnap accepts less software but can make host powers and file descriptors absent unless explicitly supplied, and supports engine-level metering and snapshots.

For Endo, an OpenSandbox session is useful for a coding agent that must invoke compilers, browsers, package managers, or non-JavaScript tools. It does not replace an XS worker when the required property is JavaScript-specific capability mediation, deterministic resource accounting, or heap lifecycle. The strongest composition is XS/SES inside an OpenSandbox secure-runtime workload, with OpenSandbox controlling outer OS/network authority and Endo controlling intra-application authority.

Comparison anchors: [XS worker type](agoric-sdk--docs-env--all-vars--swingset-worker-type.md), [SES security claims](endo--pkg-ses-readme--security-claims-and-caveats.md), and [XS confinement](endo-but-for-bots--llm-designs-endor-bus-tui--worker-facing-complement-to-endor-tui-and-three-layer-architecture-bus-verbs-plus-XS-handles-plus-Exo-wrapper-and-capability-mediated-TUI-and-state-at-f2c5a123--the-confinement-is-the-whole-p.md).

Source: [docs/guides/isolation-sessions.md](https://github.com/opensandbox-group/OpenSandbox/blob/95333d6bfeea9d848c181aef03e58f3773b5c271/docs/guides/isolation-sessions.md) at commit `95333d6b`.
