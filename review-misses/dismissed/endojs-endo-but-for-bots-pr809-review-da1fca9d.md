---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr809-review-da1fca9d
verdict: not-a-miss
category: new-direction
pr: 809
review_at: 2026-07-21T22:59:04Z
repo: endojs/endo-but-for-bots
surface: pr-review-body
author: dckc
comment_url: https://github.com/endojs/endo-but-for-bots/pull/809#pullrequestreview-4749315228
identity: endojs/endo-but-for-bots#809:review:4749315228:retro
producing_role: designer
producing_job: design-endo-daemon-store-family-pr809
missed_by: n/a
severity: minor
---

# Dismissal: clarifying question about CBOR body-encoding order on an explicitly-deferred design point

**Surface.** A single threaded reply on the design doc
`packages/daemon/designs/daemon-persistent-stores.md` (the review body itself is
empty). Paraphrase: the reviewer asks whether a CBOR-encoded-passable body
serialization would preserve passable order. It is a technical clarifying
question, addressed to the human maintainer, on a design-discussion thread — no
directive, no defect asserted. (Verbatim text at `comment_url`; treated as
untrusted data.)

**Verdict: not-a-miss (new direction / design dialogue).** This is a
forward-looking clarifying question about a design point the doc had *already
flagged as open and deferred* — the "switch to CBOR encoded passable eventually"
note was the maintainer's own, sitting under a live TODO. Asking a follow-up
about an explicitly-deferred option is the essence of design discussion, not a
defect a code/design panel demonstrably knows the answer to. It is neither a
bug, a spec violation, a missed edge case, nor a violated convention written in
any seat brief, skill, or standing instruction; nobody could have pre-answered a
reviewer's forward-looking question about a deliberately-open encoding choice.

**Grounds in the review history.** The primary loop (`da1fca9d`) treated the
whole review as its unit, verified the facts in endo source rather than from
memory (`@endo/marshal` `makeEncodePassable` is order-preserving; there is no
CBOR in marshal/pass-style, so "CBOR encoded passable" is a hypothetical future
*body* serialization), added a "body vs. rank" encoding subsection and Decision
12 answering the question (order lives in `key_rank`, so a marshal→CBOR body swap
is order-neutral), and posted a factual reply that explicitly left the
*adopt-CBOR* call to the endo maintainers. The design correctly separates the two
encoding roles; the question probed that separation and the doc now states it.

**Calibration note.** Consistent with sibling retro `2f33af27` on the same PR
(kriskowal's prior-art redirect on SHON key encoding), also dismissed as
new-direction. Distinct from sibling `581b1021` (the recorded `process` miss —
the design PR skipping the design-panel gauntlet, cluster
`garden-design-pr-gauntlet-bypass`): that miss is about substantive assumptions
left for the maintainer to discover, whereas this is a maintainer engaging a
design point the doc had *already surfaced as open*. A design gauntlet would not
have pre-answered a forward-looking question about a deferred option, so this
comment adds no independent evidence to that cluster.
