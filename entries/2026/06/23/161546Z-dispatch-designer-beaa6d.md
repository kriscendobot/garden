---
kind: dispatch
role: designer
host: endolinbot
posture: liaison
short_id: beaa6d
dispatch_root: dispatches/designer--beaa6d
repo: endojs/endo-but-for-bots
branch: design/notifier-pubsub-migration
pr_number: 507
model: opus
---

RSVP kriskowal's CHANGES_REQUESTED review on PR #507 (review id
4554406302, 2026-06-23T15:08:05Z). Three inline asks:

1. **Comment 3460676479 (line 98)**: dispatch a builder to construct
   a PR creating `@endo/pubsub` from prior `@endo/stream` pubsub
   material using Sink/Spring async promise linked list
   convention with 2 variants (lossless changes + lossy updates).
   (This builder is dispatched in parallel; the designer here
   updates the design to align with that direction.)

2. **Comment 3460690829 (line 320)**: consider `makeCancelKit`;
   base the build on the `llm` branch (incubate, project to
   master later).

3. **Comment 3460790765 (line 318)**: rename to
   `makeChangesTopicKit`. Asymmetric passability: either the
   topic or the publisher may be passable, but rarely both.
   Reorient design: start from local pubsub foundations (async
   promise queues, async iterators) + adapters that lift/drop
   between passable and local pubsub primitives. Examples:
   topic from local reader/writer (drop back-pressure); topic
   from a Spring; topic from exo-stream wire protocol;
   publisher from async iterator / sampler / differential
   sampler with diff function; patcher for local value from
   remote subscription. Read https://kriskowal.com/gtor for
   shared vocabulary; read https://github.com/kriskowal/frb
   for future evolution into collection-change propagation.

Designer brief: revision 4 — re-orient around local pubsub
foundations + adapters; rename `make*TopicKit` → `makeChangesTopicKit`;
note `makeCancelKit`; integrate gtor / frb vocabulary; surface
remaining open questions.
