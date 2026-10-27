---
id: inference-provider-broker
aliases: [inference provider broker, AgentInference, brokered Messages, inference reservation accounting]
topics: [ai-usage-billing, capability-security, daemon]
---

# Inference provider broker

A host-owned capability boundary that retains a provider credential and exposes only a model-scoped inference endpoint to an agent harness. The broker validates provider-wire requests before reading the secret, atomically reserves concurrency/rate/budget across agent, provider, and owner scopes, injects authentication only at dispatch, and settles durable usage afterward. A credential-free harness adapter translates its native message/tool stream to the endpoint; cancellation closes only that stream, while provider retirement or grant revocation fences every later call.

The accounting distinction is load-bearing: admission reserves a conservative worst case; reported usage replaces that reservation, while cancellation, timeout, or unknown usage charges the full reservation as estimated. Dollar budgets refuse models without a pinned price instead of treating unknown cost as zero. Live model discovery may populate a picker, but a well-shaped typed fallback remains unverified until a successful turn and must use a token budget when it has no pinned price.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [AI usage billing](../topics/ai-usage-billing.md) | Places provider-funded inference quotas and usage ledgers in the wider AI billing taxonomy. |
| [capability security](../topics/capability-security.md) | Supplies the least-authority rationale for retaining credentials in the host and handing agents only attenuated inference capabilities. |
| [daemon](../topics/daemon.md) | Covers the durable host substrate in which provider, grant, and accounting records survive restart. |

## See also

- [[ambient-authority]]
- [[ai-gateway-credit-routing]]
- [[object-capability]]
