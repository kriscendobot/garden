---
role: designer
arc: minion-town-claude-api
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Fold the maintainer's open-question answers into the #1543 design

PR https://github.com/endojs/endo-but-for-bots/pull/1543, branch `design/claude-api-key-agents`, file `designs/api-key-inference-providers-and-pinned-agents.md` (and any sibling design text the answers touch). The answers are in the PR comment and in the tracker https://github.com/kriscendobot/minion.town/issues/227 (the comment beginning "Maintainer answers to the design's open questions"). Treat them as decided.

- Replace each open question with its decision in the relevant section; remove the Open questions section when empty.
- Q5 has two consequences: state that capabilities (provider use facet, subagent creation) pass only by explicit endowment and that UI defaults are pre-checked boxes, not authority; and add to the build plan that agent creation (phase 4) endows a subagent-creation capability slot, with the spawner itself specified by the workbench design (`design-claude-api-agent-workbench-20261027`). Do not design the spawner here.
- Q4 and Q7 become concrete default values and an owner-wide aggregate cap in the abuse-controls section and in phase 2/3 acceptance tests.
- Keep the in-flight phase 1 (registry) compatible: if a change affects phase 1's scope, say so in the PR comment and on the tracker rather than editing the phase 1 job.
Docs only. Push to the PR branch, keep CI and the panel green, and comment the new head SHA on the tracker.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-27T05:02:58Z
