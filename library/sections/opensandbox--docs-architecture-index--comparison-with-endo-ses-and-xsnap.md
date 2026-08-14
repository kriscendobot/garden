---
title: Comparison with Endo SES and XS/xsnap
source: docs/architecture/index.md
source_repo: opensandbox-group/OpenSandbox
source_commit: 02617e27f82409a0293012fe4c9acc2f6a67e262
source_date: 2026-08-14
source_authors: [lihaopeng]
ingested: 2026-08-14
ingested_by: scholar
topics: [sandbox-platforms, hardened-javascript, compartments, capability-security]
status: current
---

> Abstract: OpenSandbox and Endo answer different layers of the sandboxing problem. OpenSandbox runs arbitrary operating-system workloads behind container, virtualized-kernel, VM, network, and authenticated service boundaries. SES confines JavaScript within a realm through frozen intrinsics, separate globals, tamed evaluators, and explicit object endowments. XS/xsnap adds a separate child process and heap for JavaScript workers, with host powers explicitly mediated. OpenSandbox is therefore useful as an outer shell or execution service for Endo agents, not as a substitute for Endo's capability semantics.

| Dimension | OpenSandbox | SES / Hardened JavaScript | Endo XS/xsnap workers |
|---|---|---|---|
| Language/runtime scope | Arbitrary container images, native binaries, browsers, shells, and language runtimes | JavaScript in a host realm | JavaScript on the XS engine in a child process |
| Primary isolation | Docker/Kubernetes workload; optional gVisor user-space kernel or Kata VM; optional bubblewrap nested namespaces | Frozen shared intrinsics plus separate global/module scope in Compartments | Separate process and heap, XS engine, supervisor-mediated messages and host powers |
| Authority model | API keys/tokens, image and entrypoint, environment, mounts, UID/GID, network policy, Linux capabilities, endpoint headers | Object capabilities: no host APIs by default; authority enters as hardened endowments, modules, and references | Capabilities/messages and explicitly provided host functions/file descriptors; no ambient terminal or descriptors |
| Trust boundary | Operator, lifecycle server, runtime provider, container/VM runtime, injected `execd`, ingress/egress components, and host kernel as applicable | Host program, SES shim, engine, and explicitly endowed objects | Supervisor, XS engine/bindings, bootstrap, message protocol, and granted host functions |
| Best fit | Untrusted code that needs an OS, tools, multiple languages, browser/desktop, or native dependencies | Supply-chain/plugin/smart-contract confinement and fine-grained cooperation inside JavaScript | Stronger JavaScript worker separation, determinism-oriented execution, metering, snapshots, and explicit host mediation |

The approaches compose. An OpenSandbox workload can run an Endo daemon or coding agent, limiting the outer process's filesystem, network, and host-kernel reach while SES limits authority among JavaScript components inside it. OpenSandbox's MCP server or language SDK can also serve as an execution tool granted to an Endo agent. Conversely, replacing SES with a container would discard object-granular least authority and safe live-reference cooperation; replacing a secure runtime with SES would not contain native binaries or a JavaScript engine/kernel escape.

Comparison anchors: [SES security claims](endo--pkg-ses-readme--security-claims-and-caveats.md), [XS worker type](agoric-sdk--docs-env--all-vars--swingset-worker-type.md), and [XS confinement](endo-but-for-bots--llm-designs-endor-bus-tui--worker-facing-complement-to-endor-tui-and-three-layer-architecture-bus-verbs-plus-XS-handles-plus-Exo-wrapper-and-capability-mediated-TUI-and-state-at-f2c5a123--the-confinement-is-the-whole-p.md).

Source: [docs/architecture/index.md](https://github.com/opensandbox-group/OpenSandbox/blob/02617e27f82409a0293012fe4c9acc2f6a67e262/docs/architecture/index.md) at commit `02617e27`.
