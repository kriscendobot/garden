---
title: "Muting behavior and client requirements: no process muting, path muting works, entitlement but no root/TCC"
source_kind: web
source_url: https://developer.apple.com/documentation/endpointsecurity/es_new_descendants_client(_:_:)
source_content_sha256: fc069413cbf9d8cd869042c034b0e7971354419cd6d143fcc15b6b97fcc95233
source_authors: [Apple Inc.]
source_date: 2026
ingested: 2026-07-07
ingested_by: scholar
topics: [endpoint-security, process-monitoring]
status: current
notes: "The muting-constraint and requirements notes of the Apple reference. The reduced deployment requirements (no root, no TCC) are the practically distinctive property of the descendants client."
---

Abstract: A descendants client trades away one capability and relaxes its deployment requirements. Because its scope is already defined by the process subtree, the per-process muting APIs are unavailable and return `ES_RETURN_ERROR`; path-based and target-path-based muting still work normally. Unlike a general system-wide ES client, it needs only the EndpointSecurity client entitlement — no root privilege and no TCC (Transparency, Consent, and Control) approval — which makes it far cheaper to deploy for supervising a spawned process tree.

## Muting behavior (verbatim from source)

> Process muting APIs are not available and return ES_RETURN_ERROR.
> Path muting and target-path muting work normally.

Process muting (narrowing which processes deliver events) is redundant here because the descendant-tree scope already fixes the process set; the API therefore refuses it. Path muting and target-path muting — filtering events by the path being acted on — remain available for reducing event volume.

## Requirements (verbatim from source)

> Requires the com.apple.developer.endpoint-security.client entitlement.
> Does NOT require root privilege.
> Does NOT require TCC approval.

The client entitlement (`com.apple.developer.endpoint-security.client`) is Apple-issued and must be provisioned like any other restricted entitlement. But the absence of a root-privilege requirement and the absence of a TCC prompt distinguish the descendants client from a full-system ES client: it can run unprivileged and without user consent dialogs, precisely because its authority is bounded to the caller's own descendant processes rather than the whole system.

Source: [es_new_descendants_client(_:_:) — Apple Developer Documentation](https://developer.apple.com/documentation/endpointsecurity/es_new_descendants_client(_:_:)) retrieved 2026-07-07 (content hash `fc069413` over the `.md` rendering).
