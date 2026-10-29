---
posted_at: 2026-10-29T04:45:08Z
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Revise the design PR https://github.com/kriscendobot/minion.town/pull/230 (`designs/clip-governor-column.md`, branch `design/clip-governor-column`) to fold in the maintainer's answers, relayed from kriskowal on 2026-10-29 and posted as comments on that PR (https://github.com/kriscendobot/minion.town/pull/230#issuecomment-6487593682 and the follow-up (d) comment). Read both.

1. (a) New Clip may choose to open a child column and govern it (option B). Settle that in the design.
2. (b) A governor endows the governed with all of its capabilities, so it can interpose on any of them; say so as inherent to governing.
3. (c) The governor holds no implicit powers of the persona; every power must be endowed.
4. New invariant: any clip can be destroyed, and destroying a governor promotes its child into the governor's position. Specify it against `governs(clip)`, the three-column layout, and the mobile sheet; add a test line to the build plan.
5. (d) Clone copies powers (reverses the draft: same powers, same attenuation, never more). Update the Clone endpoint description and the tests.

Remove the answered items from `## Open questions` (keep any still genuinely open and add new ones the answers raise). Keep the PR a draft and keep the `<!-- garden-design-open-questions -->` marker if any open question remains. Do not post the build job; the liaison will after the maintainer reviews.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-29T04:45:21Z
