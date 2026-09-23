---
title: §Composable-capabilities
source-slug: endo-but-for-bots--llm-designs-endoclaw-six-design-cluster
section-id: two-facet-control-pair-and-structural-confinement-and-help-method-and-composable-capabilities-and-cycle-196-parent
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endoclaw-{network-fetch,notifications,proactive-messages,webhooks,voice,browser}.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/endoclaw-{network-fetch,notifications,proactive-messages,webhooks,voice,browser}.md
total-lines: 439 (69 + 55 + 74 + 79 + 69 + 93)
status: Not Started (all six; created and updated 2026-03-03; Parent: endoclaw)
ingest-cycle: 226
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-endoclaw-six-design-cluster--two-facet-control-pair-and-structural-confinement-and-help-method-and-composable-capabilities-and-cycle-196-parent
---

§Capabilities-compose-without-special-glue:

- **network-fetch** composes with **OAuth** (endoclaw-oauth wraps HttpClient with token injection).
- **proactive-messages** composes Timer + data-capabilities + messaging (no new mechanism).
- **webhooks** delivers payloads as §normal-inbox-messages — §the-agent-processes-them-with-the-same-follow-mechanism-it-uses-for-human-messages.
- **proactive-messages** can pair with **notifications** for desktop alert + inbox message.

§Borrowable-pattern: §designs-name-their-composability-partners — §the-capability-IS-composable-with-X-Y-Z. §The-design-document-makes-the-composition-graph-visible.

§Sibling to cycle 222 endoclaw-skill-registry's §federation-by-reference — both designs use §existing-primitives-compose-without-new-glue. §Three-cycles-on-no-new-abstractions discipline (cycles 211 + 214 + 222) → §now-four-cycles (cycle 226 cluster's proactive-messages says §No-new-mechanism-is-needed-this-composes-three-existing-Endo-primitives).
