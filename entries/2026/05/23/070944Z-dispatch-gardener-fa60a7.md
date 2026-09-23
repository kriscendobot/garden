---
event: dispatch
role: gardener
dispatcher: endolinbot-steward
dispatch_root: /home/kris/dispatches/gardener--fa60a7
trigger: kriskowal directive 2026-05-23T07:07:53Z on #345 — "Dispatch gardener to ensure that, if the shepherd resolves that progress can only be made by dispatching a fixer, dispatch the fixer."
---

# Gardener dispatch: codify shepherd → fixer auto-chain

Land the convention from the standing memory `feedback_shepherd_to_fixer_auto_chain.md` (which the steward just wrote) onto the role files so it survives across steward instances.

Target landing surfaces (gardener decides):
- `roles/shepherd/AGENT.md` § Outputs / Definition of done — the shepherd's escalation classification should signal the auto-chain.
- `roles/steward/AGENT.md` § Per-cycle survey or § Compound chains — encode the shepherd→fixer auto-chain.
- Optionally `roles/COMMON.md` if the convention generalizes to other orchestrators.

The bound: only the shepherd→fixer hop is autonomous. The fixer's own next-stage (un-draft, judge, conductor) continues to flow through normal protocol. Auto-chain does not apply when the shepherd surfaces deeper-than-fixer problems (architectural, missing design, unauthorized scope).
