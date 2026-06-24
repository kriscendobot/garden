---
ts: 2026-05-23T07:14:50Z
kind: result
role: gardener
dispatcher: endolinbot-steward
dispatch_root: /home/kris/dispatches/gardener--fa60a7
commit: e38ec4d3
refs:
  - entries/2026/05/23/070944Z-dispatch-gardener-fa60a7.md
---

# Codified shepherd → fixer auto-pickup chain

Landed the convention from `feedback_shepherd_to_fixer_auto_chain.md` onto two role files; the rule now survives across steward instances independent of the memory layer.

## Files edited

- [`roles/shepherd/AGENT.md`](../../../../../garden/roles/shepherd/AGENT.md): updated frontmatter `updated: 2026-05-23` and added a new `## Escalation classification: name the next role` section between *Hard escalation points* and *Watch-only dispatches are wrong dispatches*. The section names a four-value `next:` verdict (`fixer`, `weaver`, `designer`/`liaison`, `none`) that escalating shepherd dispatches must carry in both the journal `result` body and the orchestrator-facing report. Reinforced in *Definition of done*.

- [`roles/steward/AGENT.md`](../../../../../garden/roles/steward/AGENT.md): updated frontmatter `updated: 2026-05-23`. Extended the *Subordinate roles dispatched* shepherd bullet to point at the new chain section. Added a new top-level `## Auto-pickup chains` section between *Operational-flake handling* and *Parked followup revisit*, containing:
  - A general framing paragraph: "When a subordinate's `result` already carries the maintainer's authority to chain to the next role, the steward dispatches without re-asking." Bounds the chain to one hop.
  - `### Shepherd → fixer` sub-section spelling out the trigger (`next: fixer` verdict), the inputs the steward passes through, what the chain does **not** authorize (no auto-dispatch of conductor / un-draft / further roles), and what disqualifies the chain (`next: designer`/`liaison` classifications routing to the bulletin instead).
  - `### Notes from the field` recording the 2026-05-22 precipitating cause on PR #355 and the 2026-05-23 directive on PR #345.

## Summary of new role text

The shepherd codifies a five-valued escalation classification (`fixer`, `weaver`, `designer`, `liaison`, `none`). The steward reads the `next: fixer` verdict as the authorization to chain a fixer dispatch immediately, bypassing the `message: steward → liaison` re-authorization hop. Deeper-than-fixer classifications (architectural, missing design, unauthorized scope) still surface to the maintainer via the bulletin's *Awaits maintainer decision* section; the classification's job is precisely to discriminate "fixer can handle this" from "this needs a human-level decision."

The new section was placed in the steward at the same structural level as *Operational-flake handling* and *Parked followup revisit* (top-level `##`); both of those are also cross-role chain protocols, so *Auto-pickup chains* sits naturally with its peers. Future single-hop chain rules (e.g. weaver → fixer if the weaver surfaces a conflict whose resolution is mechanical) extend the same section with a new `### <upstream> → <downstream>` sub-rule.

## Commit

`e38ec4d3 roles: codify shepherd → fixer auto-pickup chain` on `main`, pushed to origin.

## Meta-evolution observations

- **Memory-then-roles is the right ordering.** The steward wrote `feedback_shepherd_to_fixer_auto_chain.md` first (captured the rule for its own future cycles), then the maintainer asked for the gardener dispatch to land the rule durably on the role files. The memory file already had the maintainer's framing, the precipitating PR numbers, and the bounds explicit; the gardener's job was structural placement rather than re-deriving the rule. This shape (memory captures the lesson immediately; gardener lands it in the next dispatch) keeps the role-file edits high-signal because the lesson has already been sharpened by one pass.

- **The classification-then-chain pattern is generalizable.** The shepherd / steward pair are the first instance, but the same shape (escalating role names the next role in a `next: <role>` verdict; receiving orchestrator chains automatically when the named role is within scope) likely applies to other escalations. The weaver could carry `next: fixer` when a rebase conflict's resolution is mechanical but out of the weaver's lane; the builder could carry `next: assayer` when a draft PR needs a test surface the builder cannot author. Did not pre-land those rules (no precipitating evidence yet per the threshold in `skills/self-improvement/SKILL.md`), but the *Auto-pickup chains* section is named generally enough to accept them without restructure.

- **Cross-references rather than duplication.** The shepherd's classification section names the steward's auto-pickup chain by path; the steward's chain section names the shepherd's classification section by path. Neither restates the other's content. This keeps each file's center of gravity local while letting an agent following one role's trail discover the other naturally.

Self-improvement: noted above (classification-then-chain pattern likely generalizes; revisit when a second precipitating instance accumulates).
