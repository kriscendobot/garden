---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr595-review-dc9b727f
verdict: not-a-miss
category: new-direction
pr: 595
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/595#discussion_r3556670632
identity: endojs/endo-but-for-bots#595:review:4668891669:retro
producing_role: designer-garden-authored-design-pr
severity: minor
grounds: >
  kriskowal's CHANGES_REQUESTED review 4668891669 on PR #595 has an empty
  top-level body; its content is a single threaded inline reply
  (in_reply_to 3522720512 — the SAME thread as the two prior dismissals on this
  PR) on designs/unredacted-stack-sanctioned-ses-api.md. Paraphrased, it asks
  the designer to update the SPEC DOC to reflect the gaps the exploratory probe
  surfaced (particularly the name), and supplies fresh design direction: prefer
  a STRUCTURED diagnostic result over coupling rendering to access (a plain
  unredacted-stack string is an acceptable convenience layer); place these
  diagnostic APIs on the INITIAL REALM's globalThis and keep them OUT of the SES
  permits (noting the start-compartment Error-object alternative would entail
  adding permits); and anticipate MORE THAN ONE unredaction method — original
  stack string, assert.note annotations, rendered causal-stack string, and
  serial/parallel causes (the last not currently redacted). This retro judges
  whether the garden REVIEW PROCESS should have anticipated the comment and
  concludes it could not have. Dispositive facts from the PR's actual history:
  #595 is an exploratory DRAFT design-only PR (base branch llm; adds
  designs/unredacted-stack-sanctioned-ses-api.md and
  designs/captp-error-identification.md) whose own Open Questions leave the SES
  API shape to @erights — it explicitly invites this iteration. No gauntlet or
  panel ran or was expected (design-only draft; jobs/tada shows a probe and a
  report-back, no panel/gauntlet job for #595). The ask is NEW design work first
  stated in the comment itself — an API-shape decision (structured vs. string),
  a placement rule (initial-realm globalThis, no permits), a method inventory,
  and a naming steer on a proposed-but-unbuilt API — none of which is a bug, a
  spec or convention violation, a missed edge case, or a defect in what the PR
  actually contains. No review surface (gate, seat brief, or standing
  instruction) knew a rule and failed to bind, because "the maintainer will
  specify the structured-vs-string diagnostic API shape, its globalThis
  placement, and its method set" is a taste-and-direction call on an unbuilt
  proposal, not an anticipatable review check. The primary job (dc9b727f, in
  tada/) confirmed the framing by CORRECTLY treating the ask as forward design
  work: it reworked §2 to structured-over-rendering-coupled, added §3 placement
  (initial-realm globalThis, outside permits, start-compartment Error flagged
  with its permit cost), enumerated the four unredaction methods exactly as
  listed, retired the single-accessor name for a namespaced set left to @erights,
  and posted an inline report-back (discussion_r3556688286). That is the natural
  continuation of a design conversation, not a corrected miss. This is the THIRD
  comment of the SAME directive class on this exact thread — the earlier retros
  endojs-endo-but-for-bots-pr595-review-0a6137f6 and
  endojs-endo-but-for-bots-pr595-review-b3285075 both dismissed
  not-a-miss/new-direction — which reinforces rather than undermines the
  dismissal: a repeated maintainer design nudge on an exploratory draft is
  forward direction by definition. Recorded as a durable dismissal so the same
  comment is never re-litigated. No cluster minted; no improvement dispatched.
---

kriskowal's review 4668891669 (empty body; one threaded inline reply on
designs/unredacted-stack-sanctioned-ses-api.md) asks the designer to update the
spec to reflect the probe's findings — preferring a structured diagnostic result
over rendering-coupled access, placing the APIs on the initial realm's globalThis
and outside SES permits, and anticipating several unredaction methods (original
stack string, assert.note annotations, rendered causal stack, serial/parallel
causes), with a naming steer. This is maintainer-driven forward design direction
on an exploratory DRAFT design PR whose Open Questions explicitly leave the SES
API shape to @erights — new work first stated in the comment, not a defect any
gate, seat, or standing instruction could have anticipated. Verbatim (untrusted)
text at the comment_url; this body is a bot-authored paraphrase. Sibling
dismissals on the same thread: dismissed/endojs-endo-but-for-bots-pr595-review-0a6137f6.md
and dismissed/endojs-endo-but-for-bots-pr595-review-b3285075.md.
