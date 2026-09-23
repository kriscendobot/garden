---
title: §Synthesis target — slot machine library
source-slug: garden--designs-driver-md
section-slug: the-garden's-own-script-orchestrated-PR-creation-flow-design-and-claude-on-top-vs-claude-under-script-as-named-orchestration-shape-and-multi-author-attribution-and-Update-section-at-top
source-url: https://github.com/kriskowal/garden/blob/main/designs/driver.md
source-repo: kriskowal/garden
source-path: designs/driver.md
source-author: gardener + fixer + designer
total-lines: 691
ingest-cycle: 281
ingest-date: 2026-06-10
lane: designs
scope: structural-pattern-observations
parent: garden--designs-driver-md--the-garden's-own-script-orchestrated-PR-creation-flow-design-and-claude-on-top-vs-claude-under-script-as-named-orchestration-shape-and-multi-author-attribution-and-Update-section-at-top
---

§The-garden's-claude-under-script-architecture applies to the §game-engine-cluster:

- §**`game-driver.sh` script** that drives a state machine and delegates judgment to LLM only when needed (e.g., interpret an ambiguous game-state).
- §**§named categorical distinction** — the game-driver IS a script, not a game-rule (sibling to §the-driver-IS-a-script-not-a-role).
- §**§scripts/ top-level directory** for game-engine executable shell scripts.
- §**§two named daemon shapes** for game-engine — persistent game-driver pool + one watcher per game-event-feed.
- §**§seven named job kinds** for game-engine workflows (game-creation + observed-error + issue-response + build-request + design-request + retcon-rebase + ci-recovery).
- §**§the prompt-on-failure capture pattern** for game-engine failure logs via git object store.
- §**§the `## Update — YYYY-MM-DD <topic>` section at top** for time-stamped amendments to game-engine design docs.
- §**§multi-author attribution by role name** (game-designer + game-implementer + game-tester) for game-engine design docs.
