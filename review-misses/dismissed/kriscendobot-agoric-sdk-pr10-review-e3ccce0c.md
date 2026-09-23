---
kind: review-miss-dismissed
primary_job: kriscendobot-agoric-sdk-pr10-review-e3ccce0c
verdict: not-a-miss
category: new-direction
pr: 10
repo: kriscendobot/agoric-sdk
surface: pr-review-body
author: michaelfig
comment_url: https://github.com/kriscendobot/agoric-sdk/pull/10#pullrequestreview-4739631968
identity: kriscendobot/agoric-sdk#10:review:4739631968:retro
producing_role: designer
producing_job: agoric-beans-v2-deflation-design
missed_by: none-design-stage-no-panel
severity: minor
grounds: >
  michaelfig — the author of the originating community proposal that PR #10's
  design expands ("Using Agoric beans v2 as a deflationary mechanism") — submitted
  review 4739631968 (state COMMENTED, empty top-level body) with a single inline
  comment on designs/beans-v2-deflation.md: a preference that the design's
  ChargeForSmartWallet entry point NOT immediately charge beans (not call the
  design's ChargeBeansNow path) but instead only accrue the beans owing (call
  AddBeansOwing) and be renamed to match (verbatim untrusted text at comment_url;
  paraphrased here). This retro judges whether the garden REVIEW PROCESS should
  have anticipated this feedback and concludes it could not have, on the same
  structural ground the garden already applied to this very PR in the b17025f7
  dismissal, plus a content ground specific to this comment. Structurally: PR #10
  is a docs-only, DRAFT, DESIGN-STAGE PR (a designer product, one file, +352/-0),
  and design PRs do NOT run the code gauntlet/panel by design — the panel is for
  mergeable-feature builds, while a design stays draft and iterates under the
  maintainer's DIRECT EDITORIAL REVIEW (roles/designer/AGENT.md; CLAUDE.md
  Orchestrator vocabulary; and the garden's #592/#127 draft-no-panel dismissal
  precedent). So there was no panel seat, gate, or standing instruction that
  "demonstrably had a turn and missed it." On content: this is an architectural
  TASTE call — a choice among the charge-now-versus-accrue-owing alternatives that
  the design document ITSELF enumerated (the design split ChargeBeans and laid out
  both immediate-charge and owing-accrual paths) — expressed by the proposal's own
  originator steering his mechanism toward his preferred semantics and naming.
  Which of the enumerated options michaelfig prefers for his own proposed function
  is not derivable from any spec, seat brief, or convention; it is first-stated
  design direction on a draft under active maintainer review. The design doc did
  its job precisely by enumerating the alternatives so the maintainer could pick;
  the review process FUNCTIONED as designed (a design surfaces options; the
  maintainer directs), rather than a defect a review surface let slip. This is
  DISTINCT from the b17025f7 dismissal's "design-doc-narrative-leanness" trip-wire
  (that was editorial provenance-stripping taste from kriskowal); a semantic choice
  among enumerated design options is a different, non-recurring shape, so it neither
  triggers that trip-wire nor mints a new cluster. Recorded as a durable dismissal
  so the same review is never re-litigated; no cluster minted, no improvement
  dispatched.
---

# Dismissal: kriscendobot/agoric-sdk #10 review 4739631968 (retro)

michaelfig — author of the originating community proposal PR #10's design expands —
left a COMMENTED review (empty body) with one inline comment on
`designs/beans-v2-deflation.md`: he'd prefer the design's `ChargeForSmartWallet`
entry point not charge beans immediately but instead only accrue beans owing, and
be renamed to match (paraphrase; verbatim untrusted text at comment_url).

Not a garden review-process miss. PR #10 is a docs-only, **draft, design-stage** PR
that, by design, runs no code panel — a design iterates under the maintainer's
direct editorial review, so no seat, gate, or standing instruction had a turn to
miss (the same structural ground as this PR's earlier b17025f7 dismissal and the
#592/#127 draft-no-panel precedent). On content, the ask is an **architectural taste
call among alternatives the design document itself enumerated** (the design split
`ChargeBeans` and laid out both the immediate-charge and accrue-owing paths),
voiced by the proposal's own originator picking his preferred semantics and naming.
Which enumerated option he prefers is not derivable from any spec, seat brief, or
convention — it is first-stated design direction on a draft. The design functioned
exactly as intended by surfacing the options for the maintainer to choose.

Distinct from the b17025f7 trip-wire (editorial provenance-leanness taste from
kriskowal): a semantic choice among enumerated design options is a different,
non-recurring shape. No cluster minted, no improvement dispatched. See comment_url
for the verbatim review.
