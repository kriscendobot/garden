---
title: "Notifier pubsub migration: asymmetric passability"
source: designs/notifier-pubsub-migration.md
source_repo: endojs/endo-but-for-bots
source_branch: design/notifier-pubsub-migration
source_commit: 8c2a46bed3fb072b25d10e96cae16859e63b6812
source_pr: endojs/endo-but-for-bots#507
source_pr_state: draft
source_date: 2026-06-24
source_authors: [Kris Kowal (prompted)]
ingested: 2026-06-25
ingested_by: scholar
topics: [change-propagation, streams, captp]
status: current
notes: Unmerged draft PR #507, revision 5; see the source-index file for the lifecycle caveat.
---

> Abstract: The structural principle that shapes the whole `@endo/exo-pubsub` adapter set. A pubsub kit has two facets: the **publisher** (producer end) and the **topic** (consumer fan-out end). In practice **one of the two facets is the wire-crossing facet, the other stays local; rarely both** (the maintainer's observation). A daemon that publishes status locally and exposes the topic to remote subscribers wants a **passable topic and a local publisher** (it owns the producer; consumers ride the wire). A peer that emits events to a remote daemon that fans them out wants a **passable publisher and a local topic** (it owns the consumer side; the producer rides the wire). Handing both facets across the wire is rare: the holder is then neither producer nor consumer, unusual outside pure routing. This is why each adapter returns **one facet at a time** ("given a local thing, give me a passable facet" or the inverse) rather than a passable pair; a caller who genuinely needs both-passable composes a topic-passable adapter with a publisher-passable adapter, two separate acknowledged decisions.

Revision 4 takes seriously the maintainer's observation:

> it occurs to me that there is an asymmetry where it may be sensible for either the topic or the publisher to be passable, but rarely both.

A pubsub kit has two facets, the publisher (producer end) and the topic (consumer-fan-out end). In practice, **one of the two facets is the wire-crossing facet, the other stays local.**

- A daemon-side process that publishes status updates locally and exposes the topic to remote subscribers wants a **passable topic** and a **local publisher** (it owns the producer; consumers ride the wire).
- A peer that emits events to a remote daemon and lets the daemon fan them out wants a **passable publisher** and a **local topic** (it owns the consumer side; the producer rides the wire).
- A topology that hands both facets across the wire is rare: it means the process that holds the references is neither producer nor consumer, which is unusual outside of pure routing.

This shape steers the adapter set. Each adapter answers "given a local thing, give me a passable facet" or "given a passable facet, give me a local thing" for one facet at a time. A kit factory whose product is "both facets passable" is not in the adapter set; a caller who needs that composes a topic-passable adapter with a publisher-passable adapter, two separate decisions.

The framing also borrows the gtor distinction between **plural / asynchronous / push** (the observable-pubsub axis) and **plural / asynchronous / bidirectional** (the stream axis) to motivate why the adapter set decides per-facet rather than per-pair.

Source: [designs/notifier-pubsub-migration.md](https://github.com/endojs/endo-but-for-bots/blob/8c2a46bed3fb072b25d10e96cae16859e63b6812/designs/notifier-pubsub-migration.md) at commit `8c2a46be` (unmerged draft PR #507, branch `design/notifier-pubsub-migration`).
