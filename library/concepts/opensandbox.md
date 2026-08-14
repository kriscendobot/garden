---
aliases: [OpenSandbox, OpenSandbox platform, opensandbox-server, execd, OpenSandbox secure runtime, OpenSandbox isolation session]
---

# OpenSandbox

> Abstract: A general-purpose sandbox control and data plane for AI applications. It creates Docker containers or Kubernetes workloads through a language-neutral lifecycle API, injects `execd` for command/file/code execution, and can layer ingress authentication, egress filtering, gVisor or Kata secure runtimes, and nested bubblewrap sessions. Its primary boundary is an operating-system workload that may run arbitrary languages and binaries. It is useful to Endo as an outer deployment sandbox or interoperable execution service, but it does not replace SES's hardened JavaScript realms, object-capability confinement, or XS/xsnap's explicitly mediated JavaScript worker powers.

## Sections that touch this concept

| Section | Relevance |
|---------|-----------|
| [opensandbox--docs-architecture-index--control-plane-data-plane-and-execution-boundary](../sections/opensandbox--docs-architecture-index--control-plane-data-plane-and-execution-boundary.md) | Defines the remote OS-workload execution boundary. |
| [opensandbox--docs-architecture-index--layered-isolation-and-trust-boundaries](../sections/opensandbox--docs-architecture-index--layered-isolation-and-trust-boundaries.md) | Places OpenSandbox across its layered trusted computing base. |
| [opensandbox--docs-architecture-index--comparison-with-endo-ses-and-xsnap](../sections/opensandbox--docs-architecture-index--comparison-with-endo-ses-and-xsnap.md) | Explicitly compares OpenSandbox with SES and XS/xsnap. |
| [opensandbox--docs-guides-secure-container--runtime-isolation-options](../sections/opensandbox--docs-guides-secure-container--runtime-isolation-options.md) | Distinguishes runc, gVisor, and Kata mechanisms. |
| [opensandbox--docs-guides-secure-container--server-wide-policy-and-execution-boundary](../sections/opensandbox--docs-guides-secure-container--server-wide-policy-and-execution-boundary.md) | Explains operator-selected secure-runtime policy. |
| [opensandbox--docs-guides-secure-container--threat-model-and-layering-consequences](../sections/opensandbox--docs-guides-secure-container--threat-model-and-layering-consequences.md) | Names container escape as the secure-runtime threat. |
| [opensandbox--docs-architecture-network-isolation--cross-sandbox-threat-model](../sections/opensandbox--docs-architecture-network-isolation--cross-sandbox-threat-model.md) | Names direct cross-sandbox Pod-IP access as a threat. |
| [opensandbox--docs-architecture-network-isolation--platform-enforced-egress-confinement](../sections/opensandbox--docs-architecture-network-isolation--platform-enforced-egress-confinement.md) | Describes non-overridable egress overlays. |
| [opensandbox--docs-architecture-network-isolation--compatibility-and-residual-trust](../sections/opensandbox--docs-architecture-network-isolation--compatibility-and-residual-trust.md) | Records enforcement compatibility limits. |
| [opensandbox--docs-guides-isolation-sessions--nested-bubblewrap-execution-boundary](../sections/opensandbox--docs-guides-isolation-sessions--nested-bubblewrap-execution-boundary.md) | Defines the nested per-task namespace boundary. |
| [opensandbox--docs-guides-isolation-sessions--authority-surface-and-fail-closed-probing](../sections/opensandbox--docs-guides-isolation-sessions--authority-surface-and-fail-closed-probing.md) | Maps the session authority surface. |
| [opensandbox--docs-guides-isolation-sessions--limits-and-xsnap-comparison](../sections/opensandbox--docs-guides-isolation-sessions--limits-and-xsnap-comparison.md) | Contrasts bubblewrap with XS/xsnap. |

## Relations

- [[object-capability]]: Endo grants authority as references; OpenSandbox grants and restricts coarse resources through API authentication, images, mounts, environment variables, network policy, Linux identities, and runtime configuration.
- [[vat-and-compartment]]: OpenSandbox sandboxes are coarser operating-system workloads; SES compartments are finer JavaScript execution contexts.
- [[distributed-confinement]]: OpenSandbox egress overlays constrain network destinations, but do not provide object-graph non-discretionarity after access enters the sandbox.
