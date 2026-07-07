---
title: "Descendant-monitoring semantics: notify for self, auth+notify for the recursive descendant tree"
source_kind: web
source_url: https://developer.apple.com/documentation/endpointsecurity/es_new_descendants_client(_:_:)
source_content_sha256: fc069413cbf9d8cd869042c034b0e7971354419cd6d143fcc15b6b97fcc95233
source_authors: [Apple Inc.]
source_date: 2026
ingested: 2026-07-07
ingested_by: scholar
topics: [endpoint-security, process-monitoring]
status: current
notes: "The 'Discussion' section of the Apple reference. This is the semantic core distinguishing a descendants client from a general ES client."
---

Abstract: A client created with `es_new_descendants_client` observes a strictly scoped process set: it receives *notify* events for the calling (creating) process itself, and both *auth* and *notify* events for every descendant process — any process forked or exec'd after the client is created, recursively down the tree. Every other process on the system is invisible to the client. This is what makes the descendants client a tool for supervising a spawned process tree without pulling the whole machine into scope: the authority to observe (and, via auth events, to allow or deny) is bounded to the subtree the creator is responsible for.

## Discussion (verbatim from source)

> The returned client receives notify events for the calling process and
> auth+notify events for descendant processes (forked or exec'd after
> creation, recursively). All other processes are invisible.

## What the scoping means

- **Calling process → notify only.** The creator sees notify (observe-only, after-the-fact) events about itself. It cannot authorize (allow/deny) its own operations through this client.
- **Descendants → auth + notify.** Every process the creator spawns — and every process *those* spawn, recursively — delivers both auth events (synchronous; the client may allow or deny the operation before it proceeds) and notify events (asynchronous observation). "Descendant" is defined by the fork/exec relationship established *after* the client is created.
- **Everything else → invisible.** Processes outside the creator's descendant tree never appear. The client's field of view is exactly the subtree, which is both the privacy property (no system-wide surveillance) and the confinement property (the subtree can be gated).

Source: [es_new_descendants_client(_:_:) — Apple Developer Documentation](https://developer.apple.com/documentation/endpointsecurity/es_new_descendants_client(_:_:)) retrieved 2026-07-07 (content hash `fc069413` over the `.md` rendering).
