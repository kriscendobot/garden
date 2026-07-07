---
title: "es_new_descendants_client: creating a descendant-scoped Endpoint Security client"
source_kind: web
source_url: https://developer.apple.com/documentation/endpointsecurity/es_new_descendants_client(_:_:)
source_content_sha256: fc069413cbf9d8cd869042c034b0e7971354419cd6d143fcc15b6b97fcc95233
source_authors: [Apple Inc.]
source_date: 2026
ingested: 2026-07-07
ingested_by: scholar
topics: [endpoint-security, process-monitoring]
status: current
notes: "Apple EndpointSecurity framework reference (macOS 27.0.0+). Idempotency anchor is the content SHA-256 over the machine-readable `.md` rendering at https://docs.developer.apple.com/tutorials/data/documentation/endpointsecurity/es_new_descendants_client(_:_:).md (the HTML page is JS-rendered). source_date is an era approximation (macOS 27 SDK; page carries a 2026 copyright, no explicit publish date)."
---

Abstract: `es_new_descendants_client(_:_:)` is the EndpointSecurity (ES) framework function that creates a new ES client whose observation scope is narrowed to descendant processes only, rather than the whole system. It takes an out-parameter for the created `es_client_t` and an event-handler block, and returns an `es_new_client_result_t` status. It is the descendant-scoped sibling of the general `es_new_client` constructor: a way to stand up a monitoring/authorization client that sees only the calling process and the process tree it spawns.

## Signature

```
func es_new_descendants_client(
  _ client: UnsafeMutablePointer<OpaquePointer?>,
  _ handler: @escaping es_handler_block_t
) -> es_new_client_result_t
```

Available on macOS 27.0.0 and later. Framework: EndpointSecurity (Endpoint Security); the symbol is the C function `es_new_descendants_client`.

## Parameters

- `client` — Out param. On success, set to the newly created `es_client_t`.
- `handler` — The handler block (`es_handler_block_t`) invoked for each event the client receives.

## Return value

`es_new_client_result_t` indicating success or a specific error.

Source: [es_new_descendants_client(_:_:) — Apple Developer Documentation](https://developer.apple.com/documentation/endpointsecurity/es_new_descendants_client(_:_:)) retrieved 2026-07-07 (content hash `fc069413` over the `.md` rendering).
