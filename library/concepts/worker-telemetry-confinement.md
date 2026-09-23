---
id: worker-telemetry-confinement
aliases: [Worker telemetry confinement, service-scoped telemetry, defensive telemetry filtering]
topics: [worker-observability, capability-mediated-integrations, capability-security]
---

# Worker telemetry confinement

Worker telemetry confinement is the defense-in-depth pattern of injecting an immutable service scope, independently filtering provider results, substituting safe query paths for broken discovery endpoints, and withholding unscoped aggregates that cannot be unmixed.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [Defensive Worker query confinement](../sections/cloudflare-os--packages-gatekeeper-cloudflare-readme--defensive-worker-query-confinement.md) | Injects a service filter and independently excludes foreign events. |
| [Safe telemetry discovery](../sections/cloudflare-os--packages-gatekeeper-cloudflare-readme--safe-telemetry-discovery.md) | Replaces discovery endpoints that ignore filters with constrained event samples. |
| [Provider error data minimization](../sections/cloudflare-os--packages-gatekeeper-cloudflare-readme--provider-error-data-minimization.md) | Prevents caller-controlled values from re-entering logs through provider errors. |

## See also

- [[cloudflare-os-gatekeeper]]
- [[observer-verification]]
