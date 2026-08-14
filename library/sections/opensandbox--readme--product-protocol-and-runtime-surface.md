---
title: Product, protocol, and runtime surface
source: README.md
source_repo: opensandbox-group/OpenSandbox
source_commit: 7166129aa7a00c49021fcf8409019ace2b6d1c30
source_date: 2026-08-12
source_authors: [贾岛, 高然, epha]
ingested: 2026-08-14
ingested_by: scholar
topics: [sandbox-platforms, tooling]
status: current
---

> Abstract: OpenSandbox is a general-purpose execution platform for AI workloads. A shared lifecycle and execution protocol fronts Docker or Kubernetes runtimes, and built-in command, filesystem, code-interpreter, ingress, egress, credential, and secure-runtime components supply the common workload surface.

The public product surface separates a language-neutral Sandbox Protocol from runtime and client implementations. The lifecycle API creates, inspects, and destroys sandboxes; the execution API reaches command, file, code, and interactive facilities inside them. Docker supports local use, while Kubernetes supplies distributed scheduling and stronger deployment controls. Optional gVisor, Kata, and Firecracker mechanisms strengthen the workload-to-host boundary. Ingress routing, egress policy, and Credential Vault cover distinct communication and secret-handling boundaries.

Official images are published through several registries, signed with Cosign, and accompanied by provenance attestations. Production operators are directed to pin digests and verify the GitHub Actions publishing identity.

Source: [README.md](https://github.com/opensandbox-group/OpenSandbox/blob/7166129aa7a00c49021fcf8409019ace2b6d1c30/README.md) at commit `7166129a`.
