---
ts: 2026-05-14T20:03:20Z
kind: result
role: gardener
project: garden
to: liaison
refs:
  - entries/2026/05/14/195432Z-dispatch-liaison-3159ab.md
---

# Result: designer policy encoded — draft PRs against llm; design / implementation split

Dispatch `3159ab` landed. The designer's default behavior is now to open a draft PR against the project's bot-fork roadmap branch (today `llm` on `endojs/endo-but-for-bots`); design PRs are not in the build → cleaner → judge → fixer chain; implementations of those designs are separate builder dispatches that land on the project's natural implementation base (today `master`), mirrored from the corresponding llm work.

## Files revised

- `roles/designer/AGENT.md` (commit `2b8c67b`): new default in *Operating norms* (draft PR against bot-fork roadmap branch); project carve-out for projects without such a branch; design-vs-implementation split bullet; updated *External-repo etiquette*; updated *Definition of done*; *Notes from the field* entry citing the maintainer directive and the Node-18-drop reference shape.
- `roles/builder/AGENT.md` (commit `5314685`): new *Operating norms* bullet on reading a roadmap-branch design and implementing master-base; cites the Node-18-drop pattern.
- `skills/pr-creation-flow/SKILL.md` (commit `df46501`): added *Design-only PR* variant under *Flow ordering*; new *Designs versus implementations* section; added step 2 to the next-stage-owed heuristic (skip design-only PRs entirely); renumbered subsequent heuristic steps; *Notes from the field* row.
- `roles/steward/AGENT.md` (commit `fdd3618`): per-cycle PR-flow scan picked up the design-PR skip step; renumbered subsequent steps.
- `journal/projects/endo-but-for-bots/README.md` (journal commit `ee69605`): added explicit roadmap-branch (`llm`) vs implementation-base (`master`) rule with reference shape.

## Confirmation

The next designer dispatch against `endojs/endo-but-for-bots` (or any project whose `journal/projects/<slug>/README.md` names a bot-fork roadmap branch) opens a draft PR on `design/<slug>` against the roadmap branch by default. The next builder dispatch implementing such a design branches off `master` (or the project's named implementation base), not off the roadmap branch, and lands a separate PR. The steward's per-cycle scan skips design-only draft PRs.

## Cross-engagement note

Parallel dispatch `gardener--fbb472` (running concurrently) is adding a 5-seat design-review jury and revising `skills/pr-creation-flow/SKILL.md` § Jury composition + the judge's panel-kind discrimination. Both engagements touch `skills/pr-creation-flow/SKILL.md`; this dispatch's commit landed first on `origin/main` (`df46501`), so the `fbb472` gardener will rebase its own edits onto this change. The two engagements are complementary: this one carves out design-only PRs from the standard flow chain, and `fbb472` defines the design-review panel that runs against them in place of the code panel. No content collision is expected; the relevant section bodies are disjoint.

Self-improvement: when a maintainer directive and a same-day clarification both arrive before a gardener dispatch, the dispatch entry should quote both verbatim so the gardener does not have to backfill the clarification from a system-reminder. The dispatch prompt the liaison wrote for `3159ab` carried only the directive; the clarification arrived as a post-dispatch maintainer note in the agent prompt. Capturing both upstream of the dispatch entry tightens the loop.
