---
title: §the-content-addressed-cache-served-direct-from-the-relay (first-explicit-observation)
section-slug: endo-but-for-bots--llm-designs-endo-gateway--same-binary-two-configurations-and-host-scope-vs-user-scope-and-outbound-registration-and-pubkey-routing-and-noise-not-tls-and-content-addressed-cache-at-relay
source-slug: endo-but-for-bots--llm-designs-endo-gateway
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endo-gateway.md
authors: [Kris Kowal (prompted)]
status: Proposed
created: 2026-05-10
updated: 2026-05-10
ingest-cycle: 283
ingest-date: 2026-06-10
lane: designs
scope: full
total-lines: 997
parent: endo-but-for-bots--llm-designs-endo-gateway--same-binary-two-configurations-and-host-scope-vs-user-scope-and-outbound-registration-and-pubkey-routing-and-noise-not-tls-and-content-addressed-cache-at-relay
---

**The Gateway's HTTP server is itself the static-asset server.** On a GET, the Gateway looks up the weblet formula in its sqlite store, reads the formula's tree-root content hash, and serves the requested path **directly out of the Gateway's content-addressed store**. **There is no per-request round-trip to the User Daemon for content-addressed (immutable) assets.** The User Daemon's only role in static-asset delivery is to publish the formula in advance and to make sure the Gateway has the underlying CAS objects.

**§the-publish-then-no-round-trip pattern** (first-explicit-observation): a relay that becomes a *content-addressed cache* for immutable assets, with the User Daemon only invoked for dynamic-path fallback. This is **read-path-IS-zero-RTT-to-User-Daemon** when the asset is in CAS; the User Daemon only enters the picture for dynamic fallback.

**§the-fall-through-routing-with-CAS-hit-then-User-Daemon-miss pattern**:

```
6. Resolve the request path against that tree root in the CAS.
   - Hit: serve the bytes directly out of the CAS.
   - Miss (path is dynamic, not in the static tree):
       E(userDaemon).handleHttp(webletId, requestRecord) → response.
```

**§the-three-tier-cache-then-relay-then-CapTP shape**: tier-1 Gateway CAS hit (no User Daemon RTT) + tier-2 dynamic-fallback relay (User Daemon HTTP handler, passable record) + tier-3 CapTP escalation for streaming uploads above the inline-body threshold.
