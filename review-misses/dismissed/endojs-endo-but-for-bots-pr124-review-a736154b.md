---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr124-review-a736154b
verdict: not-a-miss
category: new-direction
pr: 124
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/124#pullrequestreview-4680255190
identity: endojs/endo-but-for-bots#124:review:4680255190:retro
producing_role: none-garden-did-not-panel-review
severity: minor
grounds: >
  kriskowal's CHANGES_REQUESTED review on the slot-machine PR #124 carried a
  single forward-looking directive (paraphrased): post a follow-up job to
  refactor the slot-machine CBOR and the ocapn CBOR, since both use the same
  CBOR subset and can likely share utilities. This retro judges whether the
  garden REVIEW PROCESS should have anticipated it, and concludes it could not.
  Two dispositive facts from the PR's actual history. First, PR #124 has NO
  gauntlet, panel, build, fix, or clean job anywhere on the board — it is a
  large re-open-under-bot of #22 (XS-sqlite slot-machine WIP, superseded design
  in flight) that never reached the un-draft/merge stage where the panel runs,
  so the absence of a review surface is intentional pre-gauntlet WIP, not a
  `process` miss (identical structural fact to the prior #124 dismissal,
  review-6332cda5). Second, the request is a cross-package architectural
  CONSOLIDATION — noticing that two independently-authored codecs
  (packages/slots/src/cbor.js and packages/ocapn/src/cbor/*) implement the same
  RFC 8949 minimal-length-head subset and proposing they share a hardened
  utility. That judgment rests on the maintainer's whole-repo architectural
  knowledge; no juror seat brief, skill, or standing instruction encodes "flag
  when two packages independently reimplement the same wire-format subset and
  propose extracting a shared codec," so no review surface demonstrably knew and
  failed to bind. It is first-stated forward direction, not a defect the panel
  overlooked. The primary loop handled it correctly as new direction: it posted
  the follow-up (ebfb-124-cbor-share-utils), which produced a `@endo/cbor`
  design and draft PR #710 plus a #124 cross-link — exactly the requested
  forward action, not a corrective fix. New direction, not a garden
  review-process miss. Recorded as a durable dismissal so the same review is
  never re-litigated. No cluster minted; no improvement dispatched.
---

# Dismissal: endo-but-for-bots #124 review 4680255190 (retro)

kriskowal's CHANGES_REQUESTED review on the slot-machine PR #124 asked (paraphrased)
that a follow-up job be posted to refactor the slot-machine CBOR and the ocapn CBOR
so they share utilities, since both rely on the same CBOR subset. Not a garden
review-process miss: this is a forward-looking cross-package consolidation request
that depends on the maintainer's whole-repo architectural knowledge, and no juror
seat, skill, or standing instruction encodes "notice two packages reimplementing the
same wire-format subset and propose a shared codec." Structurally reinforcing the
verdict, PR #124 ran no gauntlet/panel/build job — it is pre-gauntlet re-opened WIP
from #22, never at the merge stage where a panel runs — so there is no review surface
that knew a convention and failed to bind. The primary loop handled it correctly as
new direction by posting the follow-up (ebfb-124-cbor-share-utils), which delivered a
`@endo/cbor` design and draft PR #710. First-stated forward direction, not a miss.
See comment_url for the verbatim review.
