---
ts: 2026-06-23T00:06:26Z
kind: dispatch
role: designer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
dispatch_root: /home/kris/dispatches/designer--372a37
short_id: 372a37
refs:
  - entries/2026/06/22/235825Z-dispatch-researcher-a4a14d.md
  - entries/2026/06/23/000406Z-result-researcher-a4a14d.md
  - https://github.com/endojs/endo/issues/1035
  - https://github.com/endojs/endo/issues/1444
  - https://github.com/endojs/endo/issues/1182
---

# dispatch: designer — notifier-pubsub-migration (researcher-refined)

Researcher a4a14d found strong precedent:
- `@agoric/notifier` fully indexed (6 sections); PublishKit's
  "single publisher serves both forward-lossless and lossy"
  is the direct precedent for the three-topic split.
- `@endo/stream`'s `makeQueue` IS the async-singly-linked-
  list-queue endo#1444 names.
- `@endo/exo-stream` has its own concept page —
  canonical rooting for the "exo-streams discipline".
- IN-TREE PRECEDENTS:
  - daemon-message-streaming.md (closest exo-shaped
    streaming with four-event taxonomy + CapTP-rides-
    method-calls discipline).
  - daemon-cross-peer-gc.md (`formulaChangeTopic` instance
    with subscriber-follower lifecycle + retention-
    accumulator — direct precedent for `makeChangeTopic`).

Researcher added 32 keyword shortcuts. Open library gaps:
no in-tree pubsub design exists (THIS will be the first).

Base llm. DRAFT PR.
