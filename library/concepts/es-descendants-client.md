---
id: es-descendants-client
aliases: [es_new_descendants_client, descendants client, descendant-scoped ES client, EndpointSecurity, Endpoint Security framework, es_client_t, es_handler_block_t, es_new_client_result_t, com.apple.developer.endpoint-security.client, endpoint security entitlement, ES_RETURN_ERROR, process muting, path muting, target-path muting, descendant process monitoring]
topics: [endpoint-security, process-monitoring]
---

# es-descendants-client

`es_new_descendants_client(_:_:)` is the Apple EndpointSecurity (ES) framework function (macOS 27.0.0+) that creates an ES client scoped to *descendant processes only*. The returned `es_client_t` receives **notify** events for the calling process and **auth+notify** events for every descendant — any process forked or exec'd after client creation, recursively — while all other processes on the system are invisible. Compared with a general system-wide ES client it gives up the per-process muting APIs (they return `ES_RETURN_ERROR`; path and target-path muting still work) and in exchange relaxes deployment: it needs the `com.apple.developer.endpoint-security.client` entitlement but **no root privilege and no TCC approval**. The net effect is a lower-privilege primitive for observing and gating a spawned process subtree — the kind of mechanism an OS-level sandbox backend that supervises a confined process tree would build on.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [client creation and signature](../sections/web--apple-es-new-descendants-client--client-creation-and-signature.md) | The function, its signature and parameters, and the es_client_t out-param. |
| [descendant-monitoring semantics](../sections/web--apple-es-new-descendants-client--descendant-monitoring-semantics.md) | The caller-notify / descendants-auth+notify / others-invisible scoping rule. |
| [muting and client requirements](../sections/web--apple-es-new-descendants-client--muting-and-client-requirements.md) | Process-muting unavailable; entitlement required but no root and no TCC. |

## See also

- [[auth-vs-notify-events]] — the ES event-delivery distinction: descendants deliver both auth (allow/deny) and notify (observe) events, the caller only notify.
