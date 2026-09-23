---
title: Follower API
source: designs/daemon-cross-peer-gc.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 1570e88926e0fe3146b30458b6148f33c76fe02a
source_date: 2026-04-29
source_authors: [Kris Kowal]
topics: [daemon, async-flow, eventual-send]
status: current
parent: endo-but-for-bots--llm-designs-dcpg--wire-and-batching
---

```typescript
interface EndoGateway {
  // Returns an async iterator of retention deltas for the peer identified
  // by peerNodeNumber. The iterator yields a delta each time the local
  // retention graph changes in a way that affects this peer's view; the
  // delta describes only the change, not a snapshot.
  followRetentionSet(peerNodeNumber: string): AsyncIterable<RetentionDelta>;
}

type RetentionDelta = {
  add: string[];     // formula numbers added to this peer's retention set
  remove: string[];  // formula numbers removed from this peer's retention set
};
```

`followRetentionSet` is the *outbound* side: the local daemon calls it
to enumerate deltas it should send to the peer. The peer's daemon
maintains the mirror of the same set on the inbound side.
