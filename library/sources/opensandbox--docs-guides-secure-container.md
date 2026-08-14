---
source: docs/guides/secure-container.md
source_repo: opensandbox-group/OpenSandbox
source_commit: 9cc17361ddbd1c38ac19c3267f44b49d78c85a48
source_date: 2026-06-18
source_authors: [Gao Ran]
ingested: 2026-08-14
ingested_by: scholar
section_count: 3
status: current
---

> Abstract: OpenSandbox's secure-runtime guide distinguishes ordinary runc containers from gVisor's intercepted-syscall user-space kernel and Kata's QEMU, Firecracker, or Cloud Hypervisor virtual machines. The runtime is an operator-selected, server-wide policy automatically applied to every sandbox. This is OpenSandbox's principal defense against container escape by untrusted multi-language workloads, while runc remains the default and nested namespace sessions explicitly do not provide a hardware-level boundary.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [runtime-isolation-options](../sections/opensandbox--docs-guides-secure-container--runtime-isolation-options.md) | sandbox-platforms | current |
| [server-wide-policy-and-execution-boundary](../sections/opensandbox--docs-guides-secure-container--server-wide-policy-and-execution-boundary.md) | sandbox-platforms, capability-security | current |
| [threat-model-and-layering-consequences](../sections/opensandbox--docs-guides-secure-container--threat-model-and-layering-consequences.md) | sandbox-platforms, capability-security | current |

## Provenance

Source: [docs/guides/secure-container.md](https://github.com/opensandbox-group/OpenSandbox/blob/9cc17361ddbd1c38ac19c3267f44b49d78c85a48/docs/guides/secure-container.md) at file-specific commit `9cc17361`.
