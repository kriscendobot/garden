---
kind: review-miss-dismissed
primary_job: kriscendobot-minion.town-pr56-review-7d4dc95d
verdict: not-a-miss
category: new-direction
pr: 56
repo: kriscendobot/minion.town
surface: pr-review-body
author: kriskowal
comment_url: https://github.com/kriscendobot/minion.town/pull/56#pullrequestreview-5084135034
identity: kriscendobot/minion.town#56:review:5084135034:retro
producing_role: designer
producing_job: unknown
missed_by: none-design-taste
severity: minor
review_at: 2026-09-01T23:34:23Z
grounds: >
  PR #56 is a design PR ("Design: invitation-only guest onboarding, superseding
  open self-signup"). The maintainer review carries one substantive inline
  comment on designs/invitation-only-guest-onboarding.md plus three workflow
  verbs in the body (retcon, conduct, dispatch a builder). Paraphrased, the
  inline comment is a soft "consider" suggestion: parse the invitation URL
  anchor/hash with URLSearchParams as a query string rather than bespoke
  specialized parsing. This is first-stated engineering taste on an
  implementation-primitive choice, expressed as an optional refinement, not a
  defect, spec violation, missed edge case, or a convention any panel seat,
  gate, or standing instruction already binds. No seat brief, skill, or
  COMMON.md norm establishes "prefer URLSearchParams / platform primitives over
  hand-rolled parsing"; the nearest lens is the decomplector's "simpler
  primitive" axis, whose own taxonomy grades exactly this shape ("the simpler
  primitive is a taste call within the chosen approach") as comment-only, never
  a must-fix — i.e. a non-blocking refinement the design gauntlet is not
  obligated to surface. The board history confirms this is design elaboration,
  not an omitted finding: #56 ran a full design gauntlet (gauntlet panel jobs
  1-4, fix jobs 1-3, clean, undraft, conduct all in journal/jobs/tada/), and
  that panel judges the design's internal quality, never whether it pre-picks
  the maintainer's preferred web-platform primitive. Grounded in the world (not
  the primary report): the feedback was in fact adopted — the merged design
  (commit 74be9274f, "specify invitation routes (#56)") § 2 now states the shell
  "constructs and parses this envelope with URLSearchParams, using
  window.location.hash.slice(1) as the encoded input", and PR #56 merged to main
  at 2026-09-02T00:34:32Z. Note a machinery discrepancy worth recording but not
  a review-miss: the primary directive job kriscendobot-minion.town-pr56-review-7d4dc95d
  never completed — it was requeue-exhausted and reaper-doomed
  (failure_classification: transient, 2026-09-02T01:05:05Z, during the Anthropic
  weekly-quota outage) and now sits parked in jobs/plan/; the design change and
  merge landed anyway via the sibling ebea2826 loop's commits and the maintainer
  merge. This is new direction / taste; no cluster or improvement job is
  warranted.
---

# Dismissal: minion.town #56 review 5084135034 (retro)

The maintainer's review on this design PR asked, in one inline comment, to
consider parsing the invitation URL fragment with `URLSearchParams` as a query
string instead of specialized parsing, and in the body directed the workflow
verbs retcon → conduct → dispatch a builder. The substance is paraphrased here;
the linked review remains the source for the untrusted verbatim text.

The inline comment is a soft, optional refinement about which primitive to use
for fragment parsing — first-stated engineering taste at design altitude, not
criticism of a work product the review should have caught. #56 ran a full design
gauntlet; the panel judges the design's internal coherence, not whether it
pre-selects the maintainer's preferred platform primitive, and the nearest seat
lens (decomplector) explicitly treats a "simpler primitive" preference within an
otherwise-sound approach as comment-only, not must-fix. Direct inspection of the
world confirms the suggestion was adopted (merged design § 2 now uses
`URLSearchParams` over `window.location.hash.slice(1)`; PR merged 2026-09-02).

Recorded separately, not as a miss: the primary directive job never completed —
it was reaper-doomed as a transient requeue-exhaustion on 2026-09-02 (the weekly
quota outage) and is parked in `jobs/plan/`; the design landed regardless. That
is a machinery/execution gap, the mentor loop's domain, not a review-process
miss. Dismissed as new direction; no cluster or improvement job created.
