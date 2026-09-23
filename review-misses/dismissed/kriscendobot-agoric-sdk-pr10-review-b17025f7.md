---
kind: review-miss-dismissed
primary_job: kriscendobot-agoric-sdk-pr10-review-b17025f7
verdict: not-a-miss
category: new-direction
pr: 10
repo: kriscendobot/agoric-sdk
surface: pr-review-body
author: kriskowal
comment_url: https://github.com/kriscendobot/agoric-sdk/pull/10#pullrequestreview-4675344758
identity: kriscendobot/agoric-sdk#10:review:4675344758:retro
producing_role: designer
producing_job: agoric-beans-v2-deflation-design
missed_by: none-design-stage-no-panel
severity: minor
grounds: >
  kriskowal (the repo owner and maintainer) submitted review 4675344758 on PR #10
  with state CHANGES_REQUESTED and a one-sentence body, no inline comments: a
  request to redraft the design document (designs/beans-v2-deflation.md) to drop
  the narrative of where the requirements came from and keep only the facts and
  the intended effects (verbatim untrusted text at comment_url; paraphrased here).
  PR #10 is a DESIGN-STAGE, docs-only, DRAFT PR (a designer product expanding a
  community proposal into a repo-grounded design). This retro judges whether the
  garden REVIEW PROCESS should have anticipated this feedback and concludes it
  could not have, for a structural reason established by the garden's own
  calibration precedent. First, design PRs do NOT run the code gauntlet/panel —
  the panel is for mergeable-feature builds, while a design stays draft and
  iterates under the maintainer's DIRECT EDITORIAL REVIEW (roles/designer/AGENT.md;
  CLAUDE.md Orchestrator vocabulary). So there was no panel seat, gate, or standing
  instruction that "demonstrably had a turn and missed it." This is the same
  structural dismissal ground the garden already applied to draft, un-panelled PRs
  (the endojs/endo-but-for-bots #592 and #127 dismissals held below the
  avoid-name-abbreviations floor precisely because no panel had run): when a DRAFT
  PR has had no review turn, an ask is new direction, not a review miss. Second,
  the instruction is editorial TASTE first stated for this specific document, and
  it partly CONFLICTS with the designer's own standing norms, which actively
  ENCOURAGE citation ("the PR body citing the originating maintainer comment";
  "Cite the spec section, not just the spec name, when deferring to a spec"). There
  is no proactive standing rule that a design body must OMIT provenance narrative;
  the maintainer is refining, per-doc, how much origin narrative he wants inside
  the design prose. Third, and dispositively, the designer role already ANTICIPATES
  maintainer editorial directives on designs — "Editorial-pass directives mean
  structural cut, not addition ... Keep only normative content" — and the primary
  job (pr10-review-b17025f7) executed exactly that structural cut: it stripped the
  Origin/Revised metadata, the community-thread and HackMD citations, the per-item
  attributions, and reframed the quoting Open-questions items as the design's own
  facts, net -33 lines, preserving every parameter, decorator flow, migration note,
  and open question. The review process therefore FUNCTIONED as designed
  (maintainer editorial directive -> structural cut per the existing norm), rather
  than a defect a review surface let slip. Recorded as a durable dismissal so the
  same review is never re-litigated; no cluster minted, no improvement dispatched.
  Trip-wire for a future prosecutor (mirroring the #592 record's framing): the
  maintainer's design-leanness editorial taste is real and recurring (it is the
  source of the two designer editorial norms), but it is encoded only REACTIVELY
  (fires on an editorial directive) — not as a proactive authoring check. Were a
  SECOND garden-authored design, AFTER it had already received a leanness/editorial
  pass (or once a design-leanness probe/seat exists that demonstrably had a turn),
  to draw the same "strip the requirements-provenance narrative" ask, THAT would be
  the moment to record a design-doc-narrative-leanness miss and consider minting a
  cluster whose improvement makes the designer author facts-and-effects-first
  proactively. Until such a post-review recurrence, this is new direction on a
  draft design under active maintainer editorial review.
---

# Dismissal: kriscendobot/agoric-sdk #10 review 4675344758 (retro)

kriskowal (the repo owner) submitted a CHANGES_REQUESTED review on the draft,
design-stage PR #10, with a one-sentence body and no inline comments, asking that
the design document be redrafted to drop the narrative of where its requirements
came from and keep only the facts and intended effects (paraphrase; verbatim
untrusted text at comment_url).

Not a garden review-process miss. PR #10 is a docs-only DESIGN PR that, by design,
runs no code panel — a design iterates under the maintainer's direct editorial
review, so no seat, gate, or standing instruction had a turn to miss (the same
structural ground under the #592/#127 draft-no-panel dismissals). The instruction
is editorial taste first stated for this document, and it partly conflicts with the
designer's standing norms that *encourage* citation (PR-body origin, spec-section
references). Dispositively, the designer role already anticipates maintainer
editorial directives on designs ("Editorial-pass directives mean structural cut ...
Keep only normative content"), and the primary loop (pr10-review-b17025f7) executed
exactly that cut (-33 lines, all technical content preserved). The review process
functioned as designed rather than letting a defect slip.

Trip-wire (per the #592 precedent's framing): the maintainer's design-leanness taste
is recurring but only reactively encoded. A future design that draws the same
provenance-stripping ask *after* it has already had an editorial/leanness pass — or
once a design-leanness probe/seat demonstrably had a turn — would be the first
post-review recurrence worth recording as a miss and clustering. See comment_url for
the verbatim review.
