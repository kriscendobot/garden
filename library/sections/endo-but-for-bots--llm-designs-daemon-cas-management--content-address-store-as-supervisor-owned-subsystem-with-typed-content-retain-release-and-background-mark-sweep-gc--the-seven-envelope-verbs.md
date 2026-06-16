---
section: content-address-store-as-supervisor-owned-subsystem-with-typed-content-retain-release-and-background-mark-sweep-gc
source: endo-but-for-bots--llm-designs-daemon-cas-management
topics: [daemon]
status: current
title: The §seven envelope verbs
parent: endo-but-for-bots--llm-designs-daemon-cas-management--content-address-store-as-supervisor-owned-subsystem-with-typed-content-retain-release-and-background-mark-sweep-gc
---

All CAS verbs are control messages (to handle 0) handled by the
supervisor:

| Verb | Payload | Response |
|------|---------|----------|
| `cas-store` | `{data, type}` | `cas-stored` with `{hash}` |
| `cas-fetch` | `{hash}` | `cas-content` with bytes |
| `cas-has` | `{hash}` | `cas-exists` with `{exists}` |
| `cas-retain` | `{hash}` (nonce: 0, fire-and-forget) | — |
| `cas-release` | `{hash}` (nonce: 0, fire-and-forget) | — |
| `cas-store-tree` | tree entries (inline or by hash) | `cas-stored` with root hash |
| `cas-gc` | — | mark/sweep results |

The §streaming-variants `cas-store-stream` and
`cas-content-stream` use the existing frame protocol for chunked
transfer. *This avoids buffering large blobs in a single
envelope*.

The §fire-and-forget retain/release (nonce: 0) means workers
don't await acknowledgement. The §worker-lifecycle integration:
*The supervisor automatically retains hashes for suspended
workers and releases them on resume or cancellation*. Workers
don't have to clean up their own retains across suspension.
