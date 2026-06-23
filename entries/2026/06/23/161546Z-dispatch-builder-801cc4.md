---
kind: dispatch
role: builder
host: endolinbot
posture: liaison
short_id: 801cc4
dispatch_root: dispatches/builder--801cc4
repo: endojs/endo-but-for-bots
branch: llm
pr_number: null
model: opus
---

RSVP kriskowal's PR #507 inline ask (comment 3460676479, line 98)
+ explicit ask on line 320 to base on the `llm` branch:

> Please dispatch a builder to construct a pull request based on
> the llm branch that recreates the `@endo/pubsub` package from
> the material previously proposed for `@endo/stream` pubsub
> protocols using the Sink and Spring async promise linked list
> convention with the same two variations for lossless changes
> and lossy updates.

Builder brief: construct `@endo/pubsub` package on the `llm`
branch.
- Recreate the previously-proposed `@endo/stream` pubsub
  material as `@endo/pubsub`.
- Use the Sink + Spring async promise linked list convention
  (per https://kriskowal.com/gtor vocabulary).
- Two variations: lossless changes + lossy updates (per the
  parallel design in PR #507).
- The new `makeChangesTopicKit` (per the designer's revision 4
  ask) is the primary factory name; the lossy-updates variant
  needs a parallel factory (likely `makeLatestTopicKit` or
  similar — see the design).
- Open DRAFT PR against `llm` per the project's
  designs-on-llm-implementations-on-master rule (this is the
  incubation phase per the maintainer's "incubate here and later
  get projected out to a change on the master branch").
