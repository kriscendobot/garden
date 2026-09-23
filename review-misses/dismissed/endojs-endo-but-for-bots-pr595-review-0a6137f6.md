---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr595-review-0a6137f6
verdict: not-a-miss
category: new-direction
pr: 595
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/595#pullrequestreview-4629038402
identity: endojs/endo-but-for-bots#595:review:4629038402:retro
producing_role: designer-garden-authored-design-pr
severity: minor
grounds: >
  kriskowal's CHANGES_REQUESTED review on PR #595 carried exactly one inline
  comment (paraphrased): dispatch a builder to perform an EXPLORATORY
  IMPLEMENTATION of the proposed sanctioned-SES unredacted-diagnostics API to
  surface its real constraints; keep it exposed only in the initial
  realm/compartment (never passed implicitly to child compartments); map how it
  couples with assert, @endo/errors, the causal console, ava, and distributed
  traces; consider the name unredactError; and report back. This retro judges
  whether the garden REVIEW PROCESS should have anticipated this, and concludes
  it could not have. The dispositive facts from the PR's actual history: #595 is
  an exploratory DRAFT design-only PR (adds designs/unredacted-stack-sanctioned-
  ses-api.md and designs/captp-error-identification.md, base branch llm) whose
  own framing invites iteration — the design doc's Open Questions leave the ses
  API shape to @erights. The single ask is a request for NEW WORK first stated
  in the comment itself (spin up an exploratory probe implementation) plus a
  naming SUGGESTION on a proposed-but-unbuilt API; neither is a bug, a spec or
  convention violation, a missed edge case, or a defect in what the PR actually
  contains. There is no review surface — no gate, seat brief, or standing
  instruction — that demonstrably knew a rule and failed to bind, because "the
  maintainer will want an exploratory build of this proposal" and "unredactError
  reads better than the doc's placeholder name" are taste-and-direction calls,
  not anticipatable review checks. The primary review job confirmed exactly this
  by correctly routing the ask as a gap-revealing probe (posted
  endojs-endo-but-for-bots-pr595-probe-unredact-error, since claimed) rather than
  a fix — the natural next step of a design conversation, not a corrected miss.
  This is maintainer-driven forward direction on an exploratory design PR, i.e.
  new direction. Recorded as a durable dismissal so the same comment is never
  re-litigated. No cluster minted; no improvement dispatched.
---

kriskowal's review on the exploratory DRAFT design PR #595 asked for an
exploratory builder probe of the proposed sanctioned-SES unredacted-diagnostics
API (start-compartment-only exposure, a coupling map across the error/diagnostic
stack, a naming suggestion, and a report-back). This is a request for new work
and a taste-level naming suggestion first stated in the comment — forward
direction on a design proposal, not a defect the panel or a gate could have
caught. Verbatim text at the comment_url; this body is a bot-authored paraphrase.
