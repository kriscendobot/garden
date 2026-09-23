---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr682-review-4631723f
verdict: not-a-miss
category: new-direction
pr: 682
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/682#pullrequestreview-4690774603
identity: endojs/endo-but-for-bots#682:review:4690774603:retro
producing_role: designer
severity: minor
grounds: >
  PR #682 ("design(endo-reminder): @endo/reminder message-scheduler plugin,
  supersedes endoclaw-timer") is a DESIGN-DOC PR authored by kriscendobot — it
  edits designs/endo-reminder.md only, no application code. kriskowal (the repo
  owner and architect) submitted review 4690774603 (CHANGES_REQUESTED,
  2026-07-14T04:09:57Z, body_len=375 confirmed by a read-only gh re-check) with a
  single directive (paraphrased): the design must ADD a discussion of how the
  reminder capability is passed and attenuated from agent to subagent — each
  agent managing its own schedules, delegating only handles it holds, and being
  able to formulate an entirely independent but revocable scheduler for a
  subagent, with formulation permitted to rely on agent.evaluate but required to
  be straightforward to automate. This retro judges whether the garden REVIEW
  PROCESS should have anticipated this feedback and concludes it could not have,
  for the same dispositive structural reason as the two prior #682 dismissals
  (pr682-review-6fca982b, pr682-0d3f916c): the review indicts no work product —
  it is the architect specifying a NEW design requirement (subagent delegation /
  attenuation semantics with a named property set: independent-but-revocable,
  own-store/own-budget/own-recipient, driven by an automatable agent.evaluate
  recipe) that the design had not yet covered. A first-stated requirement on a
  design-doc PR is the intended workflow, not a defect a review surface could
  catch: no panel seat, pre-push gate, or standing instruction encodes (or could
  encode) which ocap-delegation topics a specific architect wants a specific
  design to elaborate, nor the specific shape of the desired attenuation model.
  The severity bypass does not apply: no standing garden rule ("a reminder/ocap
  design must specify agent-to-subagent delegation and revocation") existed and
  failed to bind; there is nothing to have bound. The PR's own history confirms
  the garden handled it correctly — the primary job (pr682-review-4631723f) read
  the review as data, added a new §Delegation and attenuation: agent to subagent
  built entirely on the existing two-facet caretaker split (three modes: share a
  held handle / attenuating forwarder, provision a fresh scheduler bound to the
  subagent with the parent retaining ReminderControl, and a canned parameterized
  provisionSubagentReminder recipe over E(agent).evaluate), recorded design
  decision 17, added the daemon-guest-eval-simplification dependency row, and
  posted an in-thread PR reply (issue-comment 4965340996). A design PR's scope
  being extended by the architect is unanticipatable by any review surface — new
  direction, not a garden review-process miss. Recorded as a durable dismissal so
  the same review is never re-litigated. No cluster minted; no improvement
  dispatched.
---

# Dismissal: endo-but-for-bots #682 review 4690774603 (retro)

PR #682 is a DESIGN-DOC PR (`design(endo-reminder)`, edits designs/endo-reminder.md
only). kriskowal (the repo owner and architect) submitted a CHANGES_REQUESTED
review whose single directive asks the design to ADD a new topic: how the reminder
capability is passed and attenuated from agent to subagent — each agent managing
its own schedules, delegating only handles it holds, and able to formulate an
entirely independent but revocable scheduler for a subagent via an automatable
agent.evaluate recipe.

Not a garden review-process miss. The review indicts no work product — it is the
architect specifying a NEW design requirement (subagent delegation / attenuation
semantics) that the design had not yet covered. A first-stated requirement on a
design-doc PR is the intended workflow, not a defect a panel seat, gate, or
standing instruction could catch: nothing encodes which ocap-delegation topics an
architect will want a given design to elaborate. The single-major severity bypass
does not apply — no standing rule existed and failed to bind.

Third in the same class as the two prior #682 dismissals (review-6fca982b, the
architect answering the doc's Open Questions; and 0d3f916c, the maintainer
ratifying the garden's own commissioned cross-design review). The PR history
confirms the garden acted correctly: the primary job folded the directive into a
new §Delegation and attenuation section built on the existing caretaker split,
recorded design decision 17, added the dependency row, and replied in-thread. New
direction, not a miss. See comment_url for the verbatim review.
