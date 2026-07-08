---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-08T02:48:04Z
---
---
role: gardener
prs:
  - https://github.com/endojs/endo-but-for-bots/issues/632
---
# @-mention #632 (erights): text-reuse permission recorded and acknowledged

erights (@erights) filed endojs/endo-but-for-bots#632 granting @kriscendobot
standing permission to reuse and adapt/derive-from any of his public texts
(thesis, erights.org, published papers, public GitHub postings), on the sole
condition that the garden keep making clear an adaptation is *derived from* the
original but *is not* the original ("You have been doing a great job of that.
Please continue.").

Routing (attention directive):
- Recorded the permission as a dated maintainer directive in
  `roles/COMMON.md` § External-repo etiquette → *Text-reuse permission:
  erights' public texts*, and pointed `roles/scholar/AGENT.md` (the primary
  consumer that ingests erights' work into the library) at the
  derived-from-not-the-original provenance condition. Landed on main2
  (commit 7aa0b6b21).
- Acknowledged on the issue: heart reactji + reply comment
  https://github.com/endojs/endo-but-for-bots/issues/632#issuecomment-4910925271
  confirming the garden will keep adaptations marked derived-from and will ask
  before proceeding in any case where that framing is awkward.

Preflight `pr-feedback-preflight.sh` returned proceed (no prior peer
resolution). Comment authorized under the repo's standing authorizations
(`journal/projects/endo-but-for-bots/README.md` § Standing authorizations).
