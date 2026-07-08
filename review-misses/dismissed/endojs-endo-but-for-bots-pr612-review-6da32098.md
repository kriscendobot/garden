---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr612-review-6da32098
verdict: not-a-miss
category: new-direction
pr: 612
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/612#pullrequestreview-4640595076
identity: endojs/endo-but-for-bots#612:review:4640595076:retro
producing_role: designer
producing_job: endojs-endo-but-for-bots-pr612-review-6da32098
severity: minor
grounds: >
  kriskowal's review 4640595076 on PR #612 (anchoring inline comment
  discussion_r3532739438, on the new design document
  designs/exo-google-sheets.md) is, in paraphrase, a maintainer SCOPE-EXPANSION
  directive on a design proposal: "let's do the whole thing" — build the full
  Principle-of-Least-Authority attenuation lattice from coarse (a group of
  sheets) to fine (a single sheet, and range attenuations within a sheet), add
  appendOnly()/writeOnly() attenuations so two parties can read and write
  without either holding both authorities, note that a sheet can serve as a
  queue, and open a follow-up on Google Sheet pubsub. This retro judges whether
  the garden REVIEW PROCESS should have anticipated the ask and concludes it
  could not have, on four grounds drawn from #612's actual history.
  (a) #612 is a DESIGN-DOCUMENT PR — a designer artifact ("Author: Kris Kowal
  (prompted)", Status: Proposed) that adds one new design doc and whose whole
  purpose is to open exactly this design dialogue. The document deliberately
  proposed a phased v1 with an explicit Open Questions section that surfaced the
  very axes the maintainer answers: group-of-sheets was Open Question 3 (a wider
  SheetsService that mints per-spreadsheet exos), structural batchUpdate was
  Open Question 1, and push/pubsub was Open Question 2. A maintainer replying
  "un-defer the deferrals — do the whole lattice now" is the design-review loop
  working as intended, not a review failure.
  (b) The specific additions are a novel invention first stated in the comment.
  The design already embodied PoLA (three facets SpreadsheetControl /
  SpreadsheetWriter / Spreadsheet, readOnly() narrowing, a hidden writer sibling
  facet, tab attenuation via sheet(title), and range confinement by
  validation), but appendOnly()/writeOnly() permission-axis attenuators and the
  sheet-as-queue blind-producer/blind-consumer use case are new design content
  the maintainer contributes, not an omission a reviewer had a standing basis to
  flag.
  (c) It is not a bug, type error, spec/style/convention violation, missed edge
  case, test gap, or any other review-catchable defect in the taxonomy — it is
  PoLA-completeness taste and architectural direction on a proposal. A grep
  across every juror seat brief and every skill for appendOnly / writeOnly /
  "attenuation lattice" / "least authority" / PoLA returns nothing: NO encoded
  review element knows a convention "a capability design must offer the maximal
  coarse-to-fine attenuation lattice with an appendOnly/writeOnly permission
  split" and failed to bind. The nearest lens, the locksmith seat, is a CODE
  seat — it checks that a delivered attenuator narrows the surface it claims to
  (proxy traps, property descriptors, new grants), engaging only on the eventual
  @endo/exo-google-sheets IMPLEMENTATION PR, not on the completeness of a design
  doc's proposed capability surface. Design-doc completeness is in no panel
  seat's remit.
  (d) NO gauntlet/panel ran on #612 — the journal's tada set for #612 holds only
  the design-directive review job and the conductor job, no cleaner/panel/fixer
  gauntlet chain, and the conductor un-drafted the PR only at merge time. There
  is therefore no skipped-panel process miss either; a maintainer steering a
  proposed design is normal early direction. The primary loop
  (review-6da32098) already handled this correctly as DESIGNER work: it built
  the two-axis attenuation lattice (scope: SheetsService group -> spreadsheet ->
  sheet(title) -> range(a1); permission: readOnly()/appendOnly()/writeOnly()),
  reframed Open Questions as resolved layering, replied on all five threads, and
  posted the two directed designer follow-ups (design-google-sheet-pubsub,
  design-refine-endoclaw-oauth-foundation). Recorded as a durable dismissal so
  the same review is never re-litigated. GUARDRAIL OBSERVED: minting any
  "offer-the-full-PoLA-lattice" cluster off this single design proposal would be
  the one-PR-masquerading-as-systemic pitfall the skill warns against; the same
  discriminator dismissed the structurally identical #602 and #592 maintainer
  design-direction asks on the same grounds. No cluster minted; no improvement
  dispatched.
---

# Dismissal: endo-but-for-bots #612 review 4640595076 (retro)

kriskowal's review on the new `designs/exo-google-sheets.md` design document
asks the designer to "do the whole thing": build the full coarse-to-fine
Principle-of-Least-Authority attenuation lattice (a group of sheets, a single
sheet, ranges within a sheet), add `appendOnly()`/`writeOnly()` attenuations so
two parties can share a sheet as a queue without either holding both
authorities, and open a follow-up on Google Sheet pubsub.

Not a garden review-process miss. #612 is a design-document PR whose Open
Questions section deliberately surfaced these very axes (group-of-sheets,
structural ops, pubsub) as deferrals for the maintainer to decide; a maintainer
answering "un-defer them and do the whole lattice" is the design-review loop
working as intended. The design already embodied PoLA (three attenuating
facets, `readOnly()`, hidden writer facet, tab and range confinement); the
`appendOnly()`/`writeOnly()` permission split and the sheet-as-queue use case
are novel design content the maintainer contributes, first stated in the
comment. It is PoLA-completeness taste and architectural direction on a
proposal, not a bug, spec/style violation, missed edge case, or any other
review-catchable defect: a grep across all juror seats and skills for
appendOnly / writeOnly / attenuation-lattice / least-authority / PoLA is empty,
and the nearest seat (locksmith) reviews delivered *code* attenuators, not the
completeness of a design doc. No gauntlet/panel ran on #612 (nor should have on
a design proposal) — the tada set holds only the review and conductor jobs. The
primary loop already handled it correctly as designer work: it built the
two-axis lattice, reframed the Open Questions as resolved layering, and posted
the two directed follow-ups. New direction, not a miss; structurally identical
to the already-dismissed #602 and #592 maintainer design-direction asks. See
comment_url for the verbatim review.
