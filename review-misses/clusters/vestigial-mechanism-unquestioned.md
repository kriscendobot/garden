---
slug: vestigial-mechanism-unquestioned
category: correctness-bug
status: open
count: 2
members:
  - endojs-endo-but-for-bots-pr1125-3193517b
  - endojs-endo-but-for-bots-pr1125-review-b786506c
prs: [1125]
---



A PR extends or polishes an internal mechanism (a minted object, pin, retention edge) whose consumer an earlier refactor removed or whose job an existing mechanism already does, and review hardens the mechanism instead of asking what still consumes it.

**Threshold rationale:** Held below the dispatch floor (2026-09-27, retro of endojs-endo-but-for-bots-pr1125-review-b786506c).
The cluster now has count=2, but both members come from one PR (prs=[1125]). The
default floor is K>=3 misses across >=2 PRs, and the skill warns explicitly
against letting one messy PR masquerade as a systemic pattern. The severity
bypass does not apply either: both members are minor, and no written standing
rule ("ask what consumes this mechanism" / "minimize formula types") existed
and failed to bind.
Cross-cluster signal worth watching: design-bespoke-mechanism-over-existing-path
(#1226, design panel) has the same root shape, where review patches a mechanism
instead of asking whether an existing primitive already subsumes it. Taken
together, the two clusters span 3 misses across 2 PRs. A future improvement
should route decomplector (f), the minimum-viable-abstraction question, into
the CODE panel as well. A candidate diff signal for a panel-hints probe: a PR
that adds a new daemon formula `type` (a new case in formula-type unions or in
the formula-record.js/manager.js switch). That seat would ask whether
composing existing formulas (eval + an existing attenuator) covers the new
type. If one more instance lands on either cluster from a third PR, consider
merging the two clusters and dispatching.
