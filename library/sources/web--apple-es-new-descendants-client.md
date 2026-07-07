---
source_kind: web
source_url: https://developer.apple.com/documentation/endpointsecurity/es_new_descendants_client(_:_:)
source_snapshot: https://docs.developer.apple.com/tutorials/data/documentation/endpointsecurity/es_new_descendants_client(_:_:).md
source_content_sha256: fc069413cbf9d8cd869042c034b0e7971354419cd6d143fcc15b6b97fcc95233
source_authors: [Apple Inc.]
source_date: 2026
retrieved: 2026-07-07
ingested: 2026-07-07
ingested_by: scholar
section_count: 3
status: current
notes: "Apple EndpointSecurity framework reference for es_new_descendants_client(_:_:), macOS 27.0.0+. The canonical HTML page is JS-rendered; the idempotency anchor (source_content_sha256) is computed over the machine-readable `.md` rendering recorded in source_snapshot. source_date is an era approximation (macOS 27 SDK; 2026 copyright, no explicit publish date). First ingest of the EndpointSecurity / OS-level process-monitoring domain — new topics endpoint-security and process-monitoring."
---

Apple's EndpointSecurity (ES) framework reference for `es_new_descendants_client(_:_:)`, the function that creates an ES client scoped to descendant processes only. The document covers the function signature and parameters, the descendant-monitoring event semantics (notify for the calling process, auth+notify for the recursively-spawned descendant tree, everything else invisible), and the client's muting constraints and reduced deployment requirements (client entitlement but no root and no TCC). It is a compact, single-screen API reference; the corpus's first source in the macOS EndpointSecurity / OS-level process-and-descendant-monitoring domain.

| Section | Topics | Status |
|---------|--------|--------|
| [client creation and signature](../sections/web--apple-es-new-descendants-client--client-creation-and-signature.md) | endpoint-security, process-monitoring | current |
| [descendant-monitoring semantics](../sections/web--apple-es-new-descendants-client--descendant-monitoring-semantics.md) | endpoint-security, process-monitoring | current |
| [muting and client requirements](../sections/web--apple-es-new-descendants-client--muting-and-client-requirements.md) | endpoint-security, process-monitoring | current |
