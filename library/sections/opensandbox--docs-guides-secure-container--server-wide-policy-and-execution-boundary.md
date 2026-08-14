---
title: Server-wide policy and execution boundary
source: docs/guides/secure-container.md
source_repo: opensandbox-group/OpenSandbox
source_commit: 9cc17361ddbd1c38ac19c3267f44b49d78c85a48
source_date: 2026-06-18
source_authors: [Gao Ran]
ingested: 2026-08-14
ingested_by: scholar
topics: [sandbox-platforms, capability-security]
status: current
---

> Abstract: Secure-runtime selection is a server-wide administrator policy, not a caller capability. At startup the server validates the configured Docker OCI runtime or Kubernetes RuntimeClass and refuses to start if it is unavailable. Every later sandbox transparently receives that runtime, so SDK callers cannot downgrade individual workloads and need no code changes.

The `secure_runtime` configuration selects `gvisor`, `kata`, `firecracker`, or an empty value for standard runc. Docker creation injects the configured OCI runtime into HostConfig; Kubernetes creation injects `runtimeClassName` into the Pod specification. Operators can verify the actual boundary through Docker inspection, the Kubernetes RuntimeClass, or by comparing a Kata guest kernel with the host.

This is non-discretionary at the deployment-policy level: a guest API caller does not receive the option to weaken the server's runtime. It is not object-capability confinement, because it does not express separate powers within the guest. Once code runs inside its sandbox, its authority still follows the container's filesystem, credentials, environment, network, Linux capabilities, and exposed services.

Source: [docs/guides/secure-container.md](https://github.com/opensandbox-group/OpenSandbox/blob/9cc17361ddbd1c38ac19c3267f44b49d78c85a48/docs/guides/secure-container.md) at commit `9cc17361`.
