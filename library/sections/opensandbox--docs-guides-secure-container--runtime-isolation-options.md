---
title: Secure runtime isolation options
source: docs/guides/secure-container.md
source_repo: opensandbox-group/OpenSandbox
source_commit: 9cc17361ddbd1c38ac19c3267f44b49d78c85a48
source_date: 2026-06-18
source_authors: [Gao Ran]
ingested: 2026-08-14
ingested_by: scholar
topics: [sandbox-platforms]
status: current
---

> Abstract: OpenSandbox supports a spectrum from ordinary runc process/cgroup isolation through gVisor's user-space kernel to Kata virtual machines backed by QEMU, Firecracker, or Cloud Hypervisor. The guide frames runc for trusted/local workloads, gVisor for low-overhead syscall isolation, Kata/QEMU for compatibility and isolation, and Firecracker for denser microVM deployment. Only the latter mechanisms are intended to strengthen resistance to container escape.

The source's comparison makes the mechanism explicit: runc uses process-level cgroups and has minimal overhead; gVisor interposes a user-space kernel at roughly tens of milliseconds startup and tens of megabytes memory; Kata launches a separate guest kernel through a hypervisor, trading more startup and memory for a VM boundary. Firecracker and Cloud Hypervisor are Kata backends with different density/performance points.

OpenSandbox applies these mechanisms underneath the same lifecycle API and sandbox image. This makes runtime choice operational rather than part of guest code, but it also means a “sandbox” alone does not identify its kernel trust boundary: deployment configuration must say whether the workload uses runc, gVisor, or a Kata variant.

Source: [docs/guides/secure-container.md](https://github.com/opensandbox-group/OpenSandbox/blob/9cc17361ddbd1c38ac19c3267f44b49d78c85a48/docs/guides/secure-container.md) at commit `9cc17361`.
