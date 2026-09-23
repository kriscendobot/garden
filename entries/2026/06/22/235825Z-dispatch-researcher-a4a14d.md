---
ts: 2026-06-22T23:58:25Z
kind: dispatch
role: researcher
host: endolinbot
project: endo-but-for-bots
to: "*"
dispatch_root: /home/kris/dispatches/researcher--a4a14d
short_id: a4a14d
refs:
  - https://github.com/endojs/endo/issues/1035
  - https://github.com/endojs/endo/issues/1444
  - https://github.com/endojs/endo/issues/1182
---

# dispatch: researcher — refine proposed designer prompt for @agoric/notifier → Endo migration with exo-streams-coherent pubsub redesign

Researcher precedence on designer dispatch.

Subject: a design that migrates `@agoric/notifier` from
Agoric SDK into Endo and proposes the redesigned pubsub
shape per:

- endo#1035 — migration commitment (Parcel/marshal pain
  + Endo private API needs notifier).
- endo#1444 — three-topic split: `makeLatestTopic` (lossy
  snapshot), `makeChangeTopic` (lossless deltas),
  `makeUpdateTopic` (current Agoric shape; recommend
  retiring in favor of the first two).
- endo#1182 — producer side should satisfy `Writer<T>` so
  it composes with `@endo/stream`'s Reader/Writer duality
  without an adapter.

Constraint: the result MUST be coherent and consistent
with the design of exo-streams.

Walk for: @agoric/notifier current shape; @endo/stream
Reader/Writer duality; exo-streams (@endo/exo-stream)
design; the async-singly-linked-list-queue primitive
endo#1444 names; any Endo-side pubsub work that's already
landed.
