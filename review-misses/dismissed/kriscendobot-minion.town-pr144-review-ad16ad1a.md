---
kind: review-miss-dismissed
primary_job: kriscendobot-minion.town-pr144-review-ad16ad1a
verdict: not-a-miss
category: new-direction
pr: 144
review_at: 2026-10-21T03:25:42Z
repo: kriscendobot/minion.town
surface: pr-review-body
author: kriskowal
comment_url: https://github.com/kriscendobot/minion.town/pull/144#pullrequestreview-5594504143
identity: kriscendobot/minion.town#144:review:5594504143:retro
producing_role: designer
producing_job: design-minion-town-guest-coupons
grounds: The review mostly answers the design's own section 11 open questions and sets new architectural direction. It asks for the coupon issuer to be a confined caplet, not an unconfined one. It asks for a recursive partition-and-attenuate mechanism for DynamoDB, posted as its own job or follow-up design. It says capabilities in this house are transferable, which agrees with the design. It asks to switch admission to coupons as soon as they are available, which answers open question 4. It asks for a flexible sealed-query guest-selection shape for air-drop, which no standing rule or prior thread required. The design had already deferred the DynamoDB-versus-injected-capability placement as open question 2, and the round 2 panel (decomplector) noted that deferral explicitly and raised the related root-authority/caplet split as a must-fix. So the panel did engage the authority question, and the maintainer's confined-plus-attenuated-DB answer goes further: it is new direction. Two inline asks were minor editorial ones. The "air-drop over airdrop in prose and lexical names" preference is a first-stated house spelling. The reviewed head used air-drop 20 times in prose and airdrop 3 times in identifiers, and no seat brief, skill, or orthographer/thesaurus list covers that word. The "more words on the enclosure hook" ask concerns an optional phase-2 section (section 7) that the design flagged as an open question. The novice seat (comment-only over three rounds) did not flag it, but that is a small clarity call, not a breach of a known convention. The gauntlet ran three design-panel rounds (journal/jobs/tada/2026/09/30/kriscendobot-minion.town-pr144-gauntlet-panel-{1,2,3}) and halted at the review budget, which is the intended handoff for a design that carries open questions. Primary deliverable verified in the world, not taken from the primary report: head 35087cc uses air-drop throughout (no "airdrop" left) and names a confined caplet and a query mechanism. Board jobs design-recursive-dynamodb-capabilities and design-endo-invitation-enclosures exist. The maintainer approved at 2026-10-21T04:28Z, and the PR merged at 05:32Z.
---

# Dismissed: guest-coupons design review answered open questions and set direction

The maintainer's change-request review on the guest-coupons design asked for a
confined issuer caplet with an attenuated, recursively partitioned DynamoDB
capability. It asked for a sealed, operator-opaque guest query to drive the
air-drop, for the hyphenated spelling "air-drop" everywhere, and for more
explanation of the optional invitation-enclosure hook. It also agreed with the
design on transferability and on switching to coupons once they exist. This is
a bot-authored paraphrase; the untrusted review lives only at `comment_url`.

## Grounds

New direction, not a review miss: the substantive asks answer the design's own
open questions or add architecture no standing rule required, and the panel did
engage the authority-placement question. The two editorial asks are a
first-stated spelling preference and a minor clarity request on an optional
phase-2 section. See the frontmatter `grounds` for the evidence.
