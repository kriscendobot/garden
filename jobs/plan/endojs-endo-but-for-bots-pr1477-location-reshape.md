---
gate: awaiting-maintainer
maintainer_question: 'Now that OCapN designator = peer key (not swissnum/network), should the in-memory OcapnLocation still be reshaped to {network, peer, at:[{transport,address}]} (value/swiss-num on sturdyref only), and in #1477 or a follow-up?'
asked_at: https://github.com/endojs/endo-but-for-bots/pull/1477#discussion_r4344979384
priority: normal
posted_by: producer
posted_at: 2026-10-22T06:00:34Z
---

---
role: fixer
tier: mentor
fallback-tier: minion
requires: host=endolin-garden-ece02cb4
dispatch: automatic
---

# Reshape in-memory OcapnLocation to {network, peer, at} (endojs/endo-but-for-bots PR #1477) — AWAITING MAINTAINER

Repo: endojs/endo-but-for-bots. PR: https://github.com/endojs/endo-but-for-bots/pull/1477
Asked at: https://github.com/endojs/endo-but-for-bots/pull/1477#discussion_r4344979384
(review https://github.com/endojs/endo-but-for-bots/pull/1477#pullrequestreview-5609794016)

kriskowal proposed (inline on packages/ocapn/test/location-id.test.js:20) that the
location be `{network: 'np', peer: string, value: string, at: Array<{transport, address}>}`.
His premise was that `designator` meant the swissnum. Per OCapN Locators.md,
`designator` is actually the peer key, and the network is OCapN's `transport` field.
The bot replied with that correction and asked:
(1) does he still want the in-memory reshape, mapping
`designator`→`peer`, `hints`→`at`, `network`/`transport`→`network`, with `value`/swiss-num
staying on the sturdyref type rather than the peer location;
(2) if so, should it land in #1477 or in a follow-up PR.

Do NOT start until the maintainer answers. When he does, follow his answer. If the
reshape is wanted: keep the wire record `<ocapn-peer transport designator hints>`
unchanged, project it in the codec, migrate every netlayer and the
designs/ocapn-network-transport-separation.md vocabulary, and add a changeset.
