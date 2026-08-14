---
title: Threat model and layering consequences
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

> Abstract: The secure-runtime threat model is malicious AI-generated code attempting container escape or cross-tenant compromise. A stronger runtime narrows reliance on the host kernel, but does not define guest authority or automatically solve network isolation, credentials, resource exhaustion, or application-level cooperation. Those remain separate OpenSandbox layers.

The guide motivates secure runtimes with container-escape protection, distinct kernel contexts, multi-tenant safety, and compliance. This makes the hostile subject arbitrary code inside the workload and the protected objects the host plus other tenants. It differs from SES's hostile JavaScript dependency or plugin model, where protected objects may coexist in one process and safe cooperation through selected references is central.

Runtime compatibility is itself part of the trusted deployment: gVisor syscall compatibility can differ from runc, Kata requires virtualization/KVM, and network sidecars that depend on kernel packet interception may not work under every runtime. A useful deployment therefore layers a secure runtime for kernel escape, resource limits for consumption, egress/ingress controls for network reach, and SES or another language-level authority system when components inside the workload must be mutually suspicious.

Source: [docs/guides/secure-container.md](https://github.com/opensandbox-group/OpenSandbox/blob/9cc17361ddbd1c38ac19c3267f44b49d78c85a48/docs/guides/secure-container.md) at commit `9cc17361`.
