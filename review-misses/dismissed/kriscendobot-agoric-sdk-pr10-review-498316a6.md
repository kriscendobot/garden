---
kind: review-miss-dismissed
primary_job: kriscendobot-agoric-sdk-pr10-review-498316a6
verdict: not-a-miss
category: new-direction
pr: 10
repo: kriscendobot/agoric-sdk
surface: pr-review-body
author: michaelfig
comment_url: https://github.com/kriscendobot/agoric-sdk/pull/10#pullrequestreview-4739691767
identity: kriscendobot/agoric-sdk#10:review:4739691767:retro
producing_role: designer
producing_job: agoric-beans-v2-deflation-design
missed_by: none-design-stage-no-panel
severity: minor
grounds: >
  michaelfig — author of the originating community proposal that PR #10's design
  expands — submitted review 4739691767 (COMMENTED, no substantive top-level body;
  the primary recorded the body as the [INLINE-REVIEW] marker) with three inline
  comments, all on designs/beans-v2-deflation.md, the single docs-only file of this
  DRAFT, DESIGN-STAGE PR (verbatim untrusted text at comment_url; paraphrased here).
  The three asks: (1) complete a truncated sentence about an entry that names a type
  with no default charge; (2) replace an obsolete IST/Inter-Protocol supply example
  with a currently-accurate one (a native denom like BLD can burn while an
  IBC-transferred external asset does not); (3) rename the design's ChargeBeansNow
  entry point to SettleBeansOwing and refine its semantics so it settles the owing
  record and computes fee/gas rather than moving coins. This retro judges whether
  the garden REVIEW PROCESS should have anticipated this feedback and concludes it
  could not have, on the SAME structural ground the garden already applied three
  times to this very PR (dismissals 9acf0d53, b17025f7, e3ccce0c) plus a content
  ground per item. Structurally: PR #10 is a docs-only, DRAFT, DESIGN-STAGE product
  (one design file), and design PRs do NOT run the code gauntlet/panel by design —
  the panel is for mergeable-feature builds, while a design stays draft and iterates
  under the maintainer's/originator's DIRECT EDITORIAL REVIEW (roles/designer/AGENT.md;
  CLAUDE.md Orchestrator vocabulary; the #592/#127 draft-no-panel precedent). Journal
  history confirms no gauntlet or panel job for PR #10; only shepherd/review primaries
  exist. So no juror seat, gate, or standing instruction "demonstrably had a turn and
  missed it." On content, each item is first-stated direction on the draft: (1) is a
  truncated-prose polish on a draft the author is still writing — no design-doc
  prose-completeness gate exists, and no panel runs to enforce one; (2) is a
  DOMAIN-EXPERT freshness correction that only the proposal's own economist-author
  would know (that the IST/Inter-Protocol supply framing is now the wrong example and
  an IBC-external-asset contrast is the right one) — not derivable from any spec,
  seat brief, or convention; (3) is an ARCHITECTURAL NAMING/semantics call by the
  proposal originator steering his own mechanism, continuing the same accrue-owing
  direction he opened in review 4739631968 (dismissed as e3ccce0c) — which enumerated
  option the originator prefers, and what to name it, is first-stated design taste.
  The design functioned exactly as intended: it enumerated the alternatives and
  carried the prose/examples the maintainer then refined. This is DISTINCT from the
  b17025f7 trip-wire (a future post-editorial-pass recurrence of provenance-stripping
  leanness taste): none of these three is a requirements-provenance strip — they are a
  sentence completion, a domain-example refresh, and a function rename — so the
  trip-wire does not fire and no cluster is minted. The recurring shape across all four
  PR #10 reviews is simply one draft design under healthy, active iterative review by
  its maintainer and originator, not a review surface repeatedly letting a defect slip.
  Recorded as a durable dismissal so the same review is never re-litigated; no cluster
  minted, no improvement dispatched.
---

# Dismissal: kriscendobot/agoric-sdk #10 review 4739691767 (retro)

michaelfig — author of the community proposal PR #10's design expands — left a
COMMENTED review (no substantive body) with three inline comments on
`designs/beans-v2-deflation.md`, the sole file of this draft, design-stage PR:
complete a truncated sentence, replace an obsolete IST/Inter-Protocol supply
example with a currently-accurate IBC-external-asset contrast, and rename the
design's `ChargeBeansNow` entry point to `SettleBeansOwing` with settle-the-owing
semantics (paraphrase; verbatim untrusted text at comment_url).

Not a garden review-process miss — the fourth PR #10 dismissal on the same
structural ground (after 9acf0d53, b17025f7, e3ccce0c). PR #10 is a docs-only,
**draft, design-stage** PR that by design runs no code panel; a design iterates
under the maintainer's/originator's direct editorial review, so no seat, gate, or
standing instruction had a turn to miss (journal history shows no gauntlet/panel
job for PR #10). On content, each ask is first-stated direction on the draft: a
prose-completion polish (no design-doc completeness gate exists or could have run),
a **domain-expert freshness correction** only the proposal's economist-author would
know, and an **architectural naming/semantics** call by the originator steering his
own mechanism (continuing the accrue-owing direction of the e3ccce0c comment). None
is derivable from any spec, seat brief, or convention.

Distinct from the b17025f7 trip-wire (a post-editorial-pass recurrence of
provenance-stripping leanness taste): a sentence completion, a domain-example
refresh, and a function rename are none of them a provenance strip, so the
trip-wire does not fire. No cluster minted, no improvement dispatched. See
comment_url for the verbatim review.
