---
kind: dispatch
role: designer
host: endolinbot
posture: liaison
short_id: ec20aa
dispatch_root: dispatches/designer--ec20aa
repo: endojs/endo-but-for-bots
branch: design/notifier-pubsub-migration
pr_number: 507
model: opus
---

RSVP kriskowal's CHANGES_REQUESTED review on PR #507 (review id
4550444549, 2026-06-23T06:02:10Z). Three inline asks on
`designs/notifier-pubsub-migration.md`:

1. Line 533 (comment 3457385924): subscribe-method convention is
   non-conventional. The maintainer's suggested shape:
   ```
   const topic = E(hub).subscribe('topic-name');
   const localReader = iterateLatest(topic, cancelled);
   ```
   Topic is a reference implementing `sinkLatest` (or similar);
   `iterateLatest` adapts subscription to async iterator. Move
   away from named-`subscribe`-method shape toward exo methods
   returning topic objects.

2. Line 615 (comment 3457388996): "We do not need a migration
   plan. We are not retiring Agoric's notifier and Endo has no
   current pubsub consumers." Remove the migration plan section.

3. Line 696 (comment 3457394053): "Please move resolved
   questions out of the open questions, either by integrating
   the answers into the design prose or a section on alternative
   designs considered."

Designer brief: revise the design accordingly, post revision 3,
reply inline on each comment.
