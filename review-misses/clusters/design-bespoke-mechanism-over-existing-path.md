---
slug: design-bespoke-mechanism-over-existing-path
category: process
status: improvement-dispatched
count: 3
members:
  - endojs-endo-but-for-bots-pr1226-review-2fc247cc
  - endojs-endo-but-for-bots-pr1226-review-179ff5ab
  - endojs-endo-but-for-bots-pr1407-review-1d8c37a5
prs: [1226, 1407]
improvement_job: review-improve-design-bespoke-mechanism-over-existing-path
---






A design invents a bespoke per-entity channel or mechanism where the repository's existing client/connection path already provides the access, and successive design-panel rounds patch that mechanism's recurring must-fix findings instead of asking whether it is needed at all.

**Threshold rationale:** Held below the dispatch floor. The newly minted
`design-bespoke-mechanism-over-existing-path` cluster has one moderate miss
from one PR (`count=1`, `prs=[1226]`), below the default threshold of at least
three misses across at least two distinct PRs. The severity bypass does not
apply. The decomplector's existing "minimum viable abstraction" category did not
bind, but the miss was confined to a design, caught before the builder step, and
already fixed on llm. Candidate sensing for a future improvement: when a design
panel re-raises must-fix findings on the same mechanism across two or more
rounds, the decomplector or critic asks whether an existing repository path
would make that mechanism unnecessary.

**Threshold rationale:** Still held below the dispatch floor after the second member
(endojs-endo-but-for-bots-pr1226-review-179ff5ab, 2026-09-29). The cluster has
count=2, but both members come from one PR (prs=[1226]), and the floor requires
misses on at least two distinct PRs. The severity bypass does not apply because
the new miss is minor and already fixed on llm. The second member sharpens the
candidate sensing check: a design that cites an existing repository surface
(here the static Lal tool set) and then builds a derivation or brokering
mechanism on top of it should get a decomplector category (f) question on
whether the cited surface already suffices. The trigger remains repeated
must-fix findings on one mechanism across panel rounds. Dispatch
review-improve-design-bespoke-mechanism-over-existing-path when a miss from a
second PR joins this cluster.

**Threshold rationale:** **Threshold rationale (2026-10-07, retro of endojs-endo-but-for-bots-pr1407-review-1d8c37a5):**
Dispatched. The floor is met: count=3 across two distinct PRs (#1226, #1407),
and the prior rationale pre-committed to dispatch when a second PR joined. The
third member is the sharpest: a build re-introduced the per-guest socket the
maintainer had already rejected on #1226 for the same design, and six
code-panel rounds hardened it, because the decomplector's minimum-viable-
abstraction lens is seated only on the design panel. Improvement job
review-improve-design-bespoke-mechanism-over-existing-path carries prevention
(builder/designer briefs, follow-up-build guard) and sensing (code-panel
decomplector probe + seat amendment + repeat-finding signal), with the
re-litigation test. The held sibling cluster vestigial-mechanism-unquestioned
is named as related evidence but left open.
