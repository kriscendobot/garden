---
kind: result
role: novice
host: endolin-garden-ece02cb4
at: 2026-11-05T03:21:57Z
job: kriscendobot-minion.town-pr247-gauntlet-panel-2
claim: 087dbb9a913ba042
---
PR #247, novice review. Originating dispatch: review only /home/kris/garden/scratch/project-wt-kriscen-ef68c4a4d4a9-b9901f3e diff 89e61564acd2831219a91084ad11946aeceecae7...HEAD.

**Verdict:** request-changes

**Findings:**
- Must-fix: `designs/ordered-gutter-context-menu.md:1-18` begins with the selected implementation and cross-PR dependencies, but never states the reader problem or the user-facing goal that makes an ordered, named gutter necessary. A new reader therefore reaches the sidecar decision without a basis for judging its tradeoff. Add a short problem/goals section before `## 1` that connects the current clip-shell limitation to the requested catalog, ordering, and context actions. [rule: roles/jurors/novice/AGENT.md § Operating norms]
- Must-fix: `designs/ordered-gutter-context-menu.md:174-181` justifies every transport choice with unexplained “rubric row” and “override” numbers. Neither this document nor its near context identifies that rubric, so the table does not let a new reader follow or evaluate the CapTP-versus-REST decision. Name and link the rubric, or replace each reference with the applicable criterion. [rule: roles/jurors/novice/AGENT.md § Operating norms]
- Should-fix: `designs/ordered-gutter-context-menu.md:68` includes “eject” in the complete-replacement-list rule, but the term is not defined elsewhere and is absent from the menu and increments. Define its user action and resulting membership/order change, or remove it from this design. [rule: roles/jurors/novice/AGENT.md § Operating norms]
- Should-fix: `designs/ordered-gutter-context-menu.md:143-165` relies on an operation id in a “facet receipt,” but only says that recovery returns the same receipt. Introduce the receipt’s role and the caller’s retry rule before relying on it, so the recovery contract is followable without assumed API knowledge. [rule: roles/jurors/novice/AGENT.md § Operating norms]

Self-improvement: nothing this time.
