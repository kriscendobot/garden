---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr1477-review-071f4f54
verdict: not-a-miss
category: new-direction
pr: 1477
repo: endojs/endo-but-for-bots
surface: pr-review-body
author: kriskowal
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1477#pullrequestreview-5609794016
identity: endojs/endo-but-for-bots#1477:review:5609794016
review_at: 2026-10-22T05:50:51Z
producing_role: builder
producing_job: endo-but-for-bots-ocapn-network-transport-separation-build
severity: minor
---

# Dismissal: question the `designator` vocabulary and propose a reshaped location record

On the `.np` location-ID PR, the maintainer left a CHANGES_REQUESTED review asking
the bot to reply and correct him if mistaken, with one inline comment on
`packages/ocapn/test/location-id.test.js`. Paraphrase: he read `designator` as the
referent's swissnum/identifier, believed OCapN uses `designator` for the network
(`np`), argued `np` is a network rather than a transport, and proposed an in-memory
location shape keyed by network, peer, value, and a list of transport/address hints.
Verbatim text lives at `comment_url` and is untrusted input.

## Grounds (dismissal — new direction / maintainer-invited terminology question)

**1. The PR's usage matched both the spec and the base design.** In the OCapN draft
Locators spec, the peer locator's `designator` is the peer's key-derived identifier
and `transport` carries `np`. The base design
`designs/ocapn-network-transport-separation.md` (on `llm-61cd656`) uses
`designator` the same way (the 32-byte Ed25519 key) and states the `.np` identity
is `(network, designator)`. The PR implemented exactly that. No seat brief, skill,
or spec text was violated; the premise of the comment was the reviewer's own
reading, and he explicitly invited correction. The primary loop corrected it with a
spec citation (reply 4351412270, 2026-10-22T17:24Z).

**2. The proposed reshape is a requirement first stated in this comment.** The
network/transport distinction is, by the maintainer's own account, not yet agreed
by the OCapN community, and the `{network, peer, value, at}` shape appears nowhere
in the design or spec. Nobody could have anticipated it; the primary parked it as
`endojs-endo-but-for-bots-pr1477-location-reshape` (gate awaiting-maintainer) for
his decision on scope and placement.

**3. The gauntlet ran.** `jobs/tada/2026/10/16/` holds the full #1477 gauntlet
(viability, clean, panel-1..3, fix-1..2, undraft) and panel round comments are on
the PR. No avoidance; no seat was gamed. Severity bypass inapplicable (no rule
failed to bind).

## Boundary note

Mints no cluster; no threshold; no improvement job. Clusters conceptually with
maintainer design-steering dismissals, not with the `naming` clusters
(`semantic-name-matches-value-kind` et al.), because the name here was correct per
the governing spec.
