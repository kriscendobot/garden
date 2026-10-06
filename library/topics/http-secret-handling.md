# http-secret-handling

HTTP request design for minimizing accidental persistence and disclosure of credentials, PII, and other sensitive values across browsers, proxies, caches, application frameworks, logs, traces, and error-reporting systems. This topic covers carrier choice and whole-path controls; `oauth-credentials` covers token models, while `worker-observability` covers telemetry architecture more broadly.

## Sections

| Section | Topics | Abstract |
|---|---|---|
| [request carriers and accidental copying](../sections/web--secret-seal--request-carriers-and-accidental-copying.md) | http-secret-handling, oauth-credentials, worker-observability | Secret Seal compares request carriers by how widely they are copied and how damaging a copied value remains. |
| [URL fragments and split knowledge](../sections/web--secret-seal--url-fragments-and-split-knowledge.md) | http-secret-handling, capability-security | URL fragments stay off ordinary HTTP requests but remain visible to page code, history, extensions, and Performance Timeline entries. |
| [opaque handles and revelation boundaries](../sections/web--secret-seal--opaque-handles-and-revelation-boundaries.md) | http-secret-handling, capability-security, oauth-credentials | Opaque and one-time handles constrain meaning and replay but remain credentials until redemption. |
| [framework controls and leak canaries](../sections/web--secret-seal--framework-controls-and-leak-canaries.md) | http-secret-handling, worker-observability, testing | Whole-path classification, safe request views, automatic policy, and leak-canary scans make leak resistance observable. |

## See also

- [oauth-credentials](oauth-credentials.md)
- [worker-observability](worker-observability.md)
- [capability-security](capability-security.md)
