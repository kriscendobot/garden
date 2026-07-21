---
kind: review-miss-dismissed
primary_job: kriscendobot-agoric-sdk-pr10-review-18cff77a
verdict: not-a-miss
category: new-direction
pr: 10
repo: kriscendobot/agoric-sdk
surface: pr-review-body
author: michaelfig
comment_url: https://github.com/kriscendobot/agoric-sdk/pull/10#pullrequestreview-4740841697
identity: kriscendobot/agoric-sdk#10:review:4740841697:retro
producing_role: designer
producing_job: agoric-beans-v2-deflation-design
missed_by: none-design-stage-no-panel
severity: minor
grounds: >
  michaelfig — the author of the originating community proposal that PR #10's
  design expands — submitted review 4740841697 (state COMMENTED, empty top-level
  body) with a single inline comment on designs/beans-v2-deflation.md, the sole
  file of this DRAFT, DESIGN-STAGE PR: a `suggestion`-block edit asking the author
  to correct bugs in the design's proposed SettleBeansOwing algorithm, make it more
  abstract pseudocode where clearer, and preserve the intended API, supplying a
  detailed fee-settlement algorithm (fee-unit computation from beansOwing, iteration
  over fee_unit_price taking min(feeUnits × price, availableFee) per denom, an
  insufficient-funds error when unsatisfied, a dispose(beanGas, beanFees) callback,
  atomic reduction of beansOwing via a max(..., 0) clamp, and gas derived by
  dividing taken value by min_gas_price) (verbatim untrusted text at comment_url;
  paraphrased here). This retro judges whether the garden REVIEW PROCESS should have
  anticipated this feedback and concludes it could not have — the FIFTH PR #10
  dismissal on the same structural ground already applied in 9acf0d53, b17025f7,
  e3ccce0c, and 498316a6, plus a content ground specific to this comment.
  Structurally: PR #10 is a docs-only, DRAFT, DESIGN-STAGE product (one design
  file), and design PRs do NOT run the code gauntlet/panel by design — the panel is
  for mergeable-feature builds, while a design stays draft and iterates under the
  maintainer's/originator's DIRECT EDITORIAL REVIEW (roles/designer/AGENT.md;
  CLAUDE.md Orchestrator vocabulary; the #592/#127 draft-no-panel precedent).
  Journal history confirms no gauntlet or panel job for PR #10 — only shepherd and
  review primaries exist — so no juror seat, gate, or standing instruction
  "demonstrably had a turn and missed it." On content: this is DOMAIN-EXPERT
  ARCHITECTURAL direction by the proposal's own originator, specifying the exact
  fee-settlement algorithm for his own proposed SettleBeansOwing function and
  directly continuing the SettleBeansOwing API he introduced in review 4739691767
  (dismissed as 498316a6). Which pseudocode expresses his intended API — the
  per-denom fee-taking order, the atomic debt clamp, the gas-from-price division —
  is first-stated design specification, not derivable from any spec, seat brief, or
  convention: no seat knows the economics of an Agoric-specific beans deflation
  mechanism its own author is still designing. The design doc did its job precisely
  by carrying a first-pass algorithm the originator then corrected; the review
  process FUNCTIONED as designed (a design surfaces a mechanism; its originator
  refines the semantics), rather than a defect a review surface let slip. This is
  DISTINCT from the b17025f7 trip-wire (a future post-editorial-pass recurrence of
  provenance-stripping design-leanness taste from kriskowal): an algorithm-correction
  suggestion is not a provenance strip, so the trip-wire does not fire and no cluster
  is minted. The recurring shape across all five PR #10 reviews is one draft design
  under healthy, active iterative review by its maintainer and originating economist,
  not a review surface repeatedly letting a defect slip. Recorded as a durable
  dismissal so the same review is never re-litigated; no cluster minted, no
  improvement dispatched.
---

# Dismissal: kriscendobot/agoric-sdk #10 review 4740841697 (retro)

michaelfig — author of the community proposal PR #10's design expands — left a
COMMENTED review (empty body) with a single inline `suggestion` comment on
`designs/beans-v2-deflation.md`, the sole file of this draft, design-stage PR:
correct the bugs in the design's `SettleBeansOwing` algorithm, make it more
abstract pseudocode where clearer, and preserve the intended API — supplying a
detailed per-denom fee-settlement algorithm (fee-unit computation, iterate
`fee_unit_price` taking `min(feeUnits × price, availableFee)`, insufficient-funds
error, a `dispose(beanGas, beanFees)` callback, an atomic `beansOwing` reduction
clamped at zero, and gas derived by dividing taken value by `min_gas_price`)
(paraphrase; verbatim untrusted text at comment_url).

Not a garden review-process miss — the **fifth** PR #10 dismissal on the same
structural ground (after 9acf0d53, b17025f7, e3ccce0c, 498316a6). PR #10 is a
docs-only, **draft, design-stage** PR that by design runs no code panel; a design
iterates under the maintainer's/originator's direct editorial review, so no seat,
gate, or standing instruction had a turn to miss (journal history shows no
gauntlet/panel job for PR #10). On content, the ask is **domain-expert
architectural direction** by the proposal's own originator, specifying the exact
fee-settlement algorithm for his own `SettleBeansOwing` function and continuing the
API he introduced in the 498316a6 review. Which pseudocode expresses his intended
economics — the per-denom fee-taking order, the atomic debt clamp, the
gas-from-price division — is first-stated design specification, not derivable from
any spec, seat brief, or convention.

Distinct from the b17025f7 trip-wire (a post-editorial-pass recurrence of
provenance-stripping design-leanness taste from kriskowal): an algorithm-correction
suggestion is not a provenance strip, so the trip-wire does not fire. No cluster
minted, no improvement dispatched. See comment_url for the verbatim review.
