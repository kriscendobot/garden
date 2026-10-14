---
title: Horizontally scalable object delivery and working copies
source_kind: web
source_url: https://www.anthropic.com/engineering/redesigning-source-control
source_content_sha256: b3d054963c3f39d437e21031240970f89ddca379738402fa31c6e6c9f3562a44
source_authors: [Nick G., S.G., R.K., Dan C., Garrett H., Ben L., Colin M., Joe P.]
source_date: 2026-10-13
ingested: 2026-10-14
ingested_by: scholar
topics: [source-control-architecture, content-addressed-storage, networking]
status: current
---

Abstract: Scion serves immutable trees and blobs through coordinated cache tiers rather than negotiating packfiles: clients recursively request only missing objects, node-local daemons share them among jobs, regional caches stream disk-format bytes, and authoritative servers fall back to Spanner or cloud storage.

Any Scion server can answer metadata operations and cache immutable content-addressed data. For working-copy delivery, the `scn` client starts from a root tree, checks its bounded local store, requests missing trees recursively, then does the same for blobs. Requests name particular immutable objects, so they are cacheable, resumable, and naturally compatible with sparse or virtualized checkout.

On each fleet node, clients talk to `scion-daemon`, which shares objects among colocated jobs and starts from a refreshed snapshot. The daemon uses regional in-memory `scion-cache` servers. Cache misses fall through to authoritative `scion-server` instances backed by Spanner or cloud storage. All tiers implement the same RPCs, but enforced tiering prevents a regional-cache failure from overloading the authoritative service.

Anthropic reports cache-hit rates above 99% at every tier, about 200 times lower CPU-and-memory infrastructure than the former Git mirror fleet, checkouts in seconds rather than minutes, and a 25% CPU-capacity gain for CI. No client or cache requires repository maintenance.

Source: [Redesigning source control at Anthropic](https://www.anthropic.com/engineering/redesigning-source-control#scaling-scion), retrieved 2026-10-14; content SHA-256 `b3d05496`.
