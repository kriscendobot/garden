---
aliases: [OpenSandbox, OpenSandbox platform, opensandbox-server, execd, OpenSandbox secure runtime, OpenSandbox isolation session, OpenSandbox MCP, Credential Vault, Secure Access, OpenSandbox multi-tenancy]
---

# OpenSandbox

> Abstract: A general-purpose sandbox control and data plane for AI applications. It creates Docker containers or Kubernetes workloads through a language-neutral lifecycle API, exposes them through SDK, CLI, and MCP adapters, injects `execd` for command/file/code execution, and can layer tenant namespace routing, ingress authentication, egress filtering and credential injection, gVisor or Kata secure runtimes, and nested bubblewrap sessions. Its primary boundary is an operating-system workload that may run arbitrary languages and binaries. It is useful to Endo as an outer deployment sandbox or interoperable execution service, but it does not replace SES's hardened JavaScript realms, object-capability confinement, or XS/xsnap's explicitly mediated JavaScript worker powers.

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
| [opensandbox--readme--mcp-cli-and-sdk-tool-interop](../sections/opensandbox--readme--mcp-cli-and-sdk-tool-interop.md) | Maps SDK, CLI, and MCP authority-bearing adapters. |
| [opensandbox--docs-guides-multi-tenancy--tenant-identity-and-request-scoped-namespace-routing](../sections/opensandbox--docs-guides-multi-tenancy--tenant-identity-and-request-scoped-namespace-routing.md) | Defines tenant key to namespace routing. |
| [opensandbox--docs-guides-multi-tenancy--namespace-rbac-isolation-and-shared-authority](../sections/opensandbox--docs-guides-multi-tenancy--namespace-rbac-isolation-and-shared-authority.md) | Records the server ClusterRole and shared-pool boundary. |
| [opensandbox--docs-guides-credential-vault--outbound-credential-broker-and-trust-boundary](../sections/opensandbox--docs-guides-credential-vault--outbound-credential-broker-and-trust-boundary.md) | Defines the outbound secret-injection boundary. |
| [opensandbox--docs-guides-credential-vault--binding-discipline-residual-trust-and-endo-comparison](../sections/opensandbox--docs-guides-credential-vault--binding-discipline-residual-trust-and-endo-comparison.md) | Compares request mediation with ocap confinement. |
| [opensandbox--docs-guides-secure-access--endpoint-trust-boundaries-and-endo-comparison](../sections/opensandbox--docs-guides-secure-access--endpoint-trust-boundaries-and-endo-comparison.md) | Distinguishes inbound bearer access from Model-4 ocaps. |
| [opensandbox--docs-components-execd--daemon-api-pty-and-access-token-boundary](../sections/opensandbox--docs-components-execd--daemon-api-pty-and-access-token-boundary.md) | Defines execd API and shared-token authority. |
| [opensandbox--docs-components-execd--isolation-session-identity-native-gate-and-namespace-pinning](../sections/opensandbox--docs-components-execd--isolation-session-identity-native-gate-and-namespace-pinning.md) | Grounds the isolation-session implementation boundary. |
| [opensandbox--docs-components-execd--bind-mount-authority-and-path-confinement](../sections/opensandbox--docs-components-execd--bind-mount-authority-and-path-confinement.md) | Maps bind-mount path authority and allowlisting. |
| [opensandbox--docs-components-execd--implementation-boundaries-and-endo-comparison](../sections/opensandbox--docs-components-execd--implementation-boundaries-and-endo-comparison.md) | Compares nested namespaces with SES and XS. |

## Relations

- [[object-capability]]: Endo grants authority as references; OpenSandbox grants and restricts coarse resources through API authentication, images, mounts, environment variables, network policy, Linux identities, and runtime configuration.
- [[vat-and-compartment]]: OpenSandbox sandboxes are coarser operating-system workloads; SES compartments are finer JavaScript execution contexts.
- [[distributed-confinement]]: OpenSandbox egress overlays constrain network destinations, but do not provide object-graph non-discretionarity after access enters the sandbox.
