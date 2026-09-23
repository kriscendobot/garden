---
kind: review-miss-dismissed
primary_job: kriscendobot-minion.town-pr56-review-7fde9428
verdict: not-a-miss
category: new-direction
pr: 56
repo: kriscendobot/minion.town
surface: pr-review-body
author: kriskowal
comment_url: https://github.com/kriscendobot/minion.town/pull/56#pullrequestreview-5084244742
identity: kriscendobot/minion.town#56:review:5084244742:retro
producing_role: designer
producing_job: unknown
missed_by: none-design-direction
severity: minor
review_at: 2026-09-01T23:52:14Z
grounds: >
  PR #56 is a design PR ("Design: invitation-only guest onboarding, superseding
  open self-signup") and review 5084244742 is a CHANGES_REQUESTED review by the
  maintainer that shapes the design forward. Paraphrased, its parts are: (a) a
  request to clarify the URL/WebSocket routes the workflow will use; (b) a
  preference for the `#v=` version-fragment shorthand over `#version=`; (c) a
  general prose-polish nudge ("grab a thesaurus"); (d) an informational note that
  the tool names are being actively renamed and may change by build time; and
  (e) a requirement that Endo guests expose an `accept` method used directly for
  guest-native invite/accept, and if that Endo gap is open, to post a design job
  against Endo. Every part is either first-stated forward design direction (routes,
  guest-native accept requirement) or taste/polish on a design document (the
  version-shorthand preference, the thesaurus nudge) — none is a defect, spec
  violation, missed edge case, or violated convention that a panel seat, gate, or
  standing instruction demonstrably already knows and should have flagged. The
  board confirms this reads as design elaboration, not an omitted review finding:
  #56 ran a full design gauntlet (panel jobs 1-4, fix jobs 1-3, clean, undraft,
  conduct all in journal/jobs/tada/), and a design panel judges the design's
  internal quality, never whether it pre-specifies the maintainer's not-yet-stated
  route layout, naming shorthand, or Endo-capability requirements. Grounded in the
  world, not the primary report: the primary loop materially delivered — commits
  74be927 ("specify invitation routes (#56)") and 20707bb ("require guest-native
  invitations (#56)") are on the merged PR head, the `#v=1` shorthand was adopted,
  and the Endo gap was carried to an actually-existing designer job
  (endo-guest-invite-accept-design, in journal/jobs/tada/). PR #56 is now MERGED.
  This mirrors the sibling dismissal kriscendobot-minion.town-pr56-ebea2826
  (the earlier design-direction review on the same PR). New direction; no cluster
  or improvement job is warranted.
---

# Dismissal: minion.town #56 review 5084244742 (retro)

The maintainer's CHANGES_REQUESTED review on this design PR shapes the design
forward: clarify the URL/WebSocket routes, prefer the `#v=` version shorthand,
polish the prose, note that tool names are being renamed, and require a
guest-native Endo `accept` method (posting a design job against Endo if that
capability gap is open). This is paraphrased here; the linked review remains the
source for the untrusted verbatim text.

Each part is forward design direction or taste on a design document, not
criticism of a work product a review should have caught. A design gauntlet did
run on #56 (panels 1-4, fixes 1-3, clean, undraft, conduct), but the panel judges
a design's internal quality, not whether it anticipates route layouts, naming
shorthands, or Endo capabilities the maintainer had not yet stated. Direct
inspection confirms the primary loop delivered against the review (route and
guest-native-invitation commits on the merged head; the `#v=1` adoption; a real
endo-guest-invite-accept-design job). Consistent with the sibling dismissal
kriscendobot-minion.town-pr56-ebea2826. Dismissed as new direction; no cluster or
improvement job created.
