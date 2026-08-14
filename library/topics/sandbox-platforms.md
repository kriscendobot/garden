# Topic: sandbox-platforms

> Abstract: Operating-system-level platforms for running untrusted or mutually suspicious workloads: their execution boundary, isolation mechanisms, authority surfaces, and trusted compute base. OpenSandbox is the first full platform indexed here. Its Docker/Kubernetes workloads, optional gVisor or Kata runtime, network sidecars, and nested bubblewrap sessions complement Endo's finer-grained JavaScript compartments and XS/xsnap workers rather than implementing the same capability model.

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [opensandbox--docs-architecture-index--control-plane-data-plane-and-execution-boundary](../sections/opensandbox--docs-architecture-index--control-plane-data-plane-and-execution-boundary.md) | OpenSandbox architecture | Lifecycle control plane creates Docker/Kubernetes workloads; clients cross into injected execd over authenticated HTTP, SSE, or WebSocket for execution and files. |
| [opensandbox--docs-architecture-index--layered-isolation-and-trust-boundaries](../sections/opensandbox--docs-architecture-index--layered-isolation-and-trust-boundaries.md) | OpenSandbox architecture | Container/pod, secure runtime, execd, ingress, egress, resource limits, and nested sessions cover different trust boundaries. |
| [opensandbox--docs-architecture-index--comparison-with-endo-ses-and-xsnap](../sections/opensandbox--docs-architecture-index--comparison-with-endo-ses-and-xsnap.md) | OpenSandbox architecture | OpenSandbox is a coarse multi-language OS sandbox; SES is fine-grained JavaScript ocap confinement; XS/xsnap adds a separately mediated JS process and heap. |
| [opensandbox--docs-guides-secure-container--runtime-isolation-options](../sections/opensandbox--docs-guides-secure-container--runtime-isolation-options.md) | OpenSandbox secure-container guide | runc, gVisor, and Kata variants form a spectrum from shared-kernel containers through a user-space kernel to VMs and microVMs. |
| [opensandbox--docs-guides-secure-container--server-wide-policy-and-execution-boundary](../sections/opensandbox--docs-guides-secure-container--server-wide-policy-and-execution-boundary.md) | OpenSandbox secure-container guide | Administrators select and validate one secure runtime server-wide; every sandbox inherits it without caller downgrade. |
| [opensandbox--docs-guides-secure-container--threat-model-and-layering-consequences](../sections/opensandbox--docs-guides-secure-container--threat-model-and-layering-consequences.md) | OpenSandbox secure-container guide | Secure runtimes target malicious-code container escape, while network, resource, credential, and intra-workload authority remain separate layers. |
| [opensandbox--docs-architecture-network-isolation--cross-sandbox-threat-model](../sections/opensandbox--docs-architecture-network-isolation--cross-sandbox-threat-model.md) | OpenSandbox network-isolation architecture | Direct Pod-IP reach lets a sandbox scan, bypass authenticated ingress, and reach other tenants; each sandbox is the desired domain. |
| [opensandbox--docs-architecture-network-isolation--platform-enforced-egress-confinement](../sections/opensandbox--docs-architecture-network-isolation--platform-enforced-egress-confinement.md) | OpenSandbox network-isolation architecture | Non-overridable egress-sidecar deny overlays block cluster CIDRs and force legitimate cross-sandbox access through authenticated ingress. |
| [opensandbox--docs-architecture-network-isolation--compatibility-and-residual-trust](../sections/opensandbox--docs-architecture-network-isolation--compatibility-and-residual-trust.md) | OpenSandbox network-isolation architecture | Sidecar interception works with runc/Kata but not gVisor netstack and can conflict with service meshes, making feature composition deployment-specific. |
| [opensandbox--docs-guides-isolation-sessions--nested-bubblewrap-execution-boundary](../sections/opensandbox--docs-guides-isolation-sessions--nested-bubblewrap-execution-boundary.md) | OpenSandbox isolation-sessions guide | Persistent shells in nested bubblewrap namespaces amortize one sandbox across many isolated task runs. |
| [opensandbox--docs-guides-isolation-sessions--authority-surface-and-fail-closed-probing](../sections/opensandbox--docs-guides-isolation-sessions--authority-surface-and-fail-closed-probing.md) | OpenSandbox isolation-sessions guide | Mounts, allowlists, environment, UID/GID, and network sharing define coarse session authority; capability probes fail closed. |
| [opensandbox--docs-guides-isolation-sessions--limits-and-xsnap-comparison](../sections/opensandbox--docs-guides-isolation-sessions--limits-and-xsnap-comparison.md) | OpenSandbox isolation-sessions guide | Bubblewrap accepts arbitrary Linux tools but shares a kernel; XS/xsnap narrows to JS with supervisor-mediated powers, metering, and snapshots. |

## See also

- [`hardened-javascript`](hardened-javascript.md): SES freezes and tames a JavaScript realm.
- [`compartments`](compartments.md): in-process JavaScript global and module isolation with explicit endowments.
- [`capability-security`](capability-security.md): authority carried by unforgeable references rather than ambient host namespaces.
- [`networking`](networking.md): ingress, egress, and distributed communication mechanisms.
