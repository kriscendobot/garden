---
title: Reconnect on the peer side
source: designs/daemon-cross-peer-gc.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 1570e88926e0fe3146b30458b6148f33c76fe02a
source_date: 2026-04-29
source_authors: [Kris Kowal]
topics: [daemon, capability-security, persistence]
status: current
parent: endo-but-for-bots--llm-designs-dcpg--crash-reconnect-and-revocation
---

When a peer P reconnects after a network partition or restart,
`followRetentionSet(P)` is re-called. The fresh subscription yields a
cold-start delta whose `add` is the full current
`retentionEdges[P]`. P's daemon, on the receiving side, treats this
as a **complete restatement** of P's retention picture rather than an
incremental update — P discards its previous mirror and rebuilds it
from the incoming `add` list. This is the protocol's substitute for
checkpoint-and-replay: every reconnect is a full snapshot expressed as
adds; subsequent deltas are incremental.

Importantly, **no vector clocks or sequence numbers are needed.** The
local side is the authoritative writer of its own retention set, and
the receiver always re-snapshots on reconnect, so there is no question
of stale or out-of-order deltas to reconcile.
