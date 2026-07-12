---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr682-0d3f916c
verdict: not-a-miss
category: new-direction
pr: 682
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/682#issuecomment-4951968957
identity: endojs/endo-but-for-bots#682:comment:4951968957:retro
producing_role: designer
producing_job: endojs-endo-but-for-bots-pr682 (design of endo-reminder.md)
missed_by: n/a (no standing check bound)
severity: minor
grounds: >
  kriskowal's directive comment on PR #682 (paraphrased): "I agree to the
  conclusions of review 4680373156; dispatch a fixer and follow up with the
  gauntlet." This retro judges whether the garden REVIEW PROCESS should have
  anticipated the substance — the six recommendations in review 4680373156 — and
  concludes it could not have. Two facts decide it. FIRST, review 4680373156 was
  itself the GARDEN's OWN automated comparative design review (authored by
  kriscendobot at the maintainer's explicit request, per the sibling directive
  already dismissed as endojs-endo-but-for-bots-pr165-d00cbc0d): the maintainer
  did not originate fresh insight the panel missed, he agreed to a review the
  garden fleet produced. The double-loop signal is "maintainer feedback the
  review process failed to anticipate"; here the review process itself produced
  the feedback. SECOND, the six recommendations are a cross-design SYNTHESIS
  salvaging operational richness from a SIBLING design (#165, cli-scheduled-send)
  that is being closed, into #682 (endo-reminder) before #165's ideas are lost —
  named catch-up policies, jittered/parameterized backoff, coalesced-message
  annotation, an eventual CLI surface, a persistence-scale note, and decoupling
  the delivery path from the SturdyRef gate. Deciding which of a retiring
  sibling's ideas should survive into its replacement is taste and product
  direction, commissioned by a one-off maintainer-directed comparison; a design
  panel reviewing #682 in isolation has neither the mandate nor the knowledge of
  #165 to port them, so it cannot "catch" them. The single item nearest a general
  principle — recommendation 1, do not gate the design's critical path on unmerged
  draft PRs (the SturdyRef modelling PRs) — was itself contingent on knowing that
  #165's endowed-reactor delivery offered an ungated alternative, and no standing
  garden rule (seat brief, skill, or COMMON.md norm) encodes "a design must not
  gate its critical path on unmerged dependencies," so the severity bypass does
  not apply (no standing rule existed and failed to bind). The garden's own
  loop worked as designed: the commissioned review surfaced the ports, the
  maintainer agreed, the fixer applied all six (journal/jobs/tada/endojs-endo-but-for-bots-pr682-0d3f916c.md),
  and the design panel gauntlet THEN ran and passed 7/7 before un-drafting. This
  is new direction, not a review-process miss. Recorded as a durable dismissal so
  the same comment is never re-litigated. No cluster minted; no improvement
  dispatched.
---

# Dismissal: endo-but-for-bots #682 comment 4951968957 (retro)

The maintainer directive ("I agree to the conclusions of review 4680373156;
dispatch a fixer and follow up with the gauntlet") is not a garden
review-process miss. The review it agrees to (4680373156) was the garden's own
automated comparative design review — kriscendobot, at the maintainer's request
— salvaging ideas from a closing sibling design (#165, cli-scheduled-send) into
its replacement (#682, endo-reminder) before they are lost. The maintainer
originated no fresh gap the panel missed; he ratified a review the fleet
produced.

The six recommendations (named catch-up policies, parameterized+jittered
backoff, coalesced-message annotation, eventual CLI surface, persistence-scale
note, and decoupling delivery from the SturdyRef gate) are a cross-design
synthesis: which of a retiring sibling's ideas should survive into its
replacement. That is maintainer-directed taste and product direction,
unanticipatable by a design panel that reviews #682 in isolation with no mandate
to cross-reference or port from #165. Even recommendation 1 (do not gate the
critical path on unmerged draft PRs) hinged on knowing #165's ungated
endowed-reactor alternative, and no standing garden rule encodes that principle,
so the single-major severity bypass does not apply.

The loop worked: the commissioned review surfaced the ports, the maintainer
agreed, the fixer applied all six, and the design-panel gauntlet then ran and
passed 7/7 before un-drafting #682. Mirror of the already-recorded sibling
dismissal endojs-endo-but-for-bots-pr165-d00cbc0d, which dismissed the comment
that commissioned this very review. New direction, not a miss. See comment_url
for the verbatim comment.
