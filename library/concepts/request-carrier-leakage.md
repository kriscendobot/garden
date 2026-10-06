---
id: request-carrier-leakage
aliases: [HTTP request carrier, request carrier leakage, URL secret leakage, sensitive request data]
topics: [http-secret-handling, worker-observability]
---

# request-carrier-leakage

The accidental-copying surface created by placing a sensitive value in an HTTP URL, standard or custom header, cookie, body, fragment, or tracing field. Carrier choice changes which histories, caches, logs, proxies, page scripts, and telemetry stores commonly receive the value, but no carrier is intrinsically leak-proof.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [request carriers and accidental copying](../sections/web--secret-seal--request-carriers-and-accidental-copying.md) | Compares URL, header, cookie, body, fragment, and tracing copies. |

## See also

- [[fragment-held-credential]] — the browser-fragment instance.
- [[leak-canary-testing]] — how to observe unintended copies.
