---
title: §No-ambient-X
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

§Repeating-across-the-cluster:

- **network-fetch**: §No-ambient-DNS-or-socket-access — *The agent has no `net.connect` or `dns.resolve` — only the `fetch` method on its granted HttpClient*.
- **browser**: §No-cookie-credential-leakage — *The Page interface does not expose cookies, localStorage, or network requests. The agent interacts with page content through DOM methods only*.
- **notifications**: §the-agent-cannot-discover-or-influence-the-control-facet.

§Borrowable-pattern: §the-Endo-Idiom-section-names-the-ambient-authorities-the-capability-prevents. §The-design-document-anticipates-the-question: §what-can't-the-agent-do-via-this-capability + §answers-it-explicitly.

§Three-cycles-on-the-host-grants-capabilities-application-doesn't-take-them discipline (cycle 208 + cycle 218 + cycle 222) → §now-four-cycles (cycle 226 cluster reinforces it across six designs).
