# endpoint-security

Apple's **EndpointSecurity** (ES) framework: the macOS system-extension API for observing and authorizing security-relevant events (process exec/fork, file operations, signals, and so on). An ES *client* subscribes a handler block to events and receives them as either *auth* events (synchronous; the client may allow or deny before the operation proceeds) or *notify* events (asynchronous observation). Clients require the Apple-issued `com.apple.developer.endpoint-security.client` entitlement. This topic collects the corpus's ES material; the first entry is `es_new_descendants_client`, the constructor for a client scoped to the calling process and its recursively-spawned descendant tree — a lower-privilege variant (client entitlement, but no root and no TCC) suited to supervising a spawned process subtree rather than the whole system.

## Sections

| Section | One-line summary |
|---|---|
| [client creation and signature](../sections/web--apple-es-new-descendants-client--client-creation-and-signature.md) | endpoint-security, process-monitoring | The es_new_descendants_client signature, parameters, and return value; a descendant-scoped ES client constructor (macOS 27+). |
| [descendant-monitoring semantics](../sections/web--apple-es-new-descendants-client--descendant-monitoring-semantics.md) | endpoint-security, process-monitoring | Notify events for the caller, auth+notify for the recursive descendant tree, all other processes invisible. |
| [muting and client requirements](../sections/web--apple-es-new-descendants-client--muting-and-client-requirements.md) | endpoint-security, process-monitoring | Process muting unavailable (ES_RETURN_ERROR), path muting works; client entitlement but no root and no TCC. |

## See also

- process-monitoring — the cross-cutting concept (observing/bounding a process and its descendants); EndpointSecurity is macOS's kernel-adjacent mechanism for it.
- daemon — the Endo daemon's OS-sandbox design lineage (`daemon-os-sandbox-plugin` → `endo-posix-sandbox`) names the EndpointSecurity framework as a candidate macOS backend replacement for the deprecated `sandbox-exec`/SBPL engine.
- capability-security — ES is an ambient-authority observe/authorize mechanism, the architectural complement (and contrast) to Endo's structural object-capability confinement.
