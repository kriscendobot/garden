---
kind: result
role: ergonomist
host: endolin-garden-ece02cb4
at: 2026-10-23T08:10:36Z
job: endojs-endo-but-for-bots-pr1543-gauntlet-panel-4
claim: 9dee842859855411
---
Originating dispatch: jury seat ergonomist, PR #1543, reviewing d5ac41980a675aba1a2e5b8cd8d518f74625eff7...HEAD.

**Verdict:** request-changes

**Findings:**
- must-fix: `designs/api-key-inference-providers-and-pinned-agents.md:129-134, 202-211, 418-425` exposes **Reattach provider**, but specifies neither its selection/compatibility flow nor its resulting model, limits, wake state, transcript behavior, failure state, or operation contract. The only defined agent operations are create, set-wake, and delete. A user replacing a key may choose a provider that cannot serve the agent's selected model and cannot tell before committing whether the agent will keep working or what it will cost. Define the reattach dialog and idempotent operation: show eligible providers and compatible models, state which settings and conversation state are preserved, require a choice or explain refusal for incompatibility, and show the resulting provider/model/effective limits before confirmation. [proposed-rule: Every user-visible reassignment operation must specify its selectable targets, compatibility validation, preserved and changed settings, confirmation, failure state, and post-success summary.]

Self-improvement: nothing this time.
