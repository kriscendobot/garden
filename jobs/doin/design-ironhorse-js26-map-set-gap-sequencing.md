---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: designer

Sequence the four cross-cutting engine-wide gaps in the js-26 Map/Set-methods work.

Origin: report `ironhorse-js-26-map-methods` identified four cross-cutting gaps,
each of which would close residuals across the WHOLE js-26 Map/Set-methods
proposal rather than one method at a time, and said each warrants its own feature
increment. It asked for a prioritization call on sequencing before queueing them.
Maintainer decision 2026-09-13 (muster): design the sequencing.

Task:
1. Recover the four gaps from the report and restate each precisely: what it is,
   which residuals across the proposal it closes, and its blast radius in the
   engine. Cite file:line.
2. Order them into feature increments. The ordering criteria that matter: which
   gaps unblock others, which close the most residuals per unit of work, and which
   carry the most regression risk (do those when the surrounding surface is
   quietest, not stacked together).
3. For each increment, state its entry condition, its exit condition, and how it
   will be verified — including whether it needs a test262 sweep and roughly what
   delta to expect.
4. Note explicitly any increment that should NOT be queued yet, and why.

Deliverable: a design on main2 that a later producer can turn directly into an
ordered chain of build jobs. If it carries unresolved maintainer-facing open
questions, present it as a review PR per CLAUDE.md's open-questions carve-out.

Skills: skills/design-dependency-walk, skills/pr-dependency-topo-sort,
skills/test262-independent-assertions, skills/regression-evidence.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-13T14:22:46Z
